/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Apex que recibe datos JSON enviados desde fuera
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 21-10-2020            RL                       Creación de la Clase.
1.1 23-01-2021            RL                       Se agrega sección IVA
1.2 25-01-2021            RL                       Ajuste de código
***********************************************************************************/

@RestResource(urlMapping='/Opportunities/*')
global class AMICAR_ServiciosRestOpportunityWS  {
    //Oportunidades
    @HttpGet
    global static Opportunity getOpportunity() {
        try{
            RestRequest request = RestContext.request;
            // grab the caseId from the end of the URL
            String oppId = request.requestURI.substring( request.requestURI.lastIndexOf('/')+1);
            Opportunity result =  [SELECT Id, Name
                            FROM Opportunity
                            WHERE Id_Solicitud__c = :oppId];
            return result;
        }catch(Exception ex){
            return null;
        }
    }

    @HttpPut
    global static void insertOpportunity() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AMICAR_ServicioRestOpportunityWS_SOQL consultasSOQL = new AMICAR_ServicioRestOpportunityWS_SOQL();
        AMICAR_OpportunityJSON2 oppResp = new AMICAR_OpportunityJSON2();
        AMICAR_ServiciosRestOpportunityWS_Class datosOportunidad = new AMICAR_ServiciosRestOpportunityWS_Class();
        Boolean esServicioPj = false;
        String jsonRequest = '';
            
        try{
            jsonRequest = req.requestBody.toString();

            System.debug('JSON');
            System.debug(jsonRequest);

            oppResp = (AMICAR_OpportunityJSON2) System.JSON.deserialize(jsonRequest, AMICAR_OpportunityJSON2.class);
            
            if(oppResp.loanSimulationData.source == 'Salesforce'){
                System.debug('Solicitud rechazada (Origen: Salesforce)');
                jsonRespError respError= new jsonRespError();
                respError.StatusCode = 200;
                respError.Mensaje = 'Solicitud rechazada (Origen: Salesforce).';
                res.responseBody = Blob.valueOf(JSON.serialize(respError));
                res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                res.statusCode = 200;
            }else{
                //Se valida primero que venga el RUT del Propietario, si no es incluido en la estructura JSON
                //Retornar error 400
                if(oppResp.loanSimulationData.amicarExecutive == null || oppResp.loanSimulationData.amicarExecutive.rut == '' || String.isBlank(oppResp.loanSimulationData.amicarExecutive.rut)){
                    jsonRespError respError= new jsonRespError();
                    respError.StatusCode = 400;
                    respError.Mensaje = 'Debe indicar el RUT del Ejecutivo (Propietario) en el campo "rut" de la sección amicarExecutive.';
                    res.responseBody = Blob.valueOf(JSON.serialize(respError));
                    res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                    res.statusCode = 400;
                }else{

                    //Reviso si el cliente a ingresar es Persona Natural o Jurídica
                    //En caso de ser Persona Jurídica cambiar valor a true
                    if(oppResp.customer.identificationTypeId == 2){
                        esServicioPj = true;
                    }

                    //Agrego RUT de todos las cuentas a registrarse en una lista para comparar
                    Set<String> rutCuentas = new Set<String>();
                    rutCuentas.add(formatoRut(oppResp.customer.identificationValue));
                    
                    //Consulto si los avales existen como cuenta, si no, agregarlos en lista de cuentas a crear
                    if(oppResp.guarantor != null && oppResp.guarantor.size() > 0){
                        for(AMICAR_OpportunityJSON2.Guarantor guarantor : oppResp.guarantor){
                            rutCuentas.add(formatoRut(guarantor.identificationValue));
                        }
                    }

                    //Consulto si los representantes legales existen como cuenta, si no, agregarlos en lista de cuentas a crear
                    if(oppResp.legalRepresentative != null && oppResp.legalRepresentative.size() > 0){
                        for(AMICAR_OpportunityJSON2.LegalRepresentative legalRep : oppResp.legalRepresentative){
                            rutCuentas.add(formatoRut(legalRep.identificationValue));
                        }
                    }

                    //Consulto si los socios existen como cuenta, si no, agregarlos en lista de cuentas a crear
                    if(oppResp.majorityPartners != null && oppResp.majorityPartners.size() > 0){
                        for(AMICAR_OpportunityJSON2.MajorityPartners socio : oppResp.majorityPartners){
                            rutCuentas.add(formatoRut(socio.identificationValue));
                        }
                    }

                    //Consulto si los Compra para existen como cuenta, si no, agregarlos en lista de cuentas a crear
                    if(oppResp.BuyForAnother != null && oppResp.buyForAnother.identificationValue != null){
                        rutCuentas.add(formatoRut(oppResp.buyForAnother.identificationValue));
                    }


                    //Agrego en MAP todas las cuentas disponibles
                    List<Account> listaCuentas = consultasSOQL.getCuentas(rutCuentas);
                    Map<String, Account> mapCuentas = new Map<String, Account>();
                    Map<String, String> mapCuentasToAdd = new Map<String, String>();

                    //Agrego en MAP todos los valores disponibles de la Marca de Vehículo y Retoma de vehículo
                    Map<String, String> mapMarcasVehiculo = consultasSOQL.getMapMarcaVehiculo();
                    Map<String, String> mapMarcasRetoma = consultasSOQL.getMapMarcaRetoma();

                    //Agrego en MAP todos los valores disponibles de la Tipo de Vehículo y Tipo Retoma
                    Map<String, String> mapTipoVehiculo = consultasSOQL.getMapTipoVehiculo();
                    Map<String, String> mapTipoVehiculoRetoma = consultasSOQL.getMapTipoVehiculoRetoma();

                    String codigoMarca = mapMarcasVehiculo.get(oppResp.loanSimulationCar.Brand.name);
                
                    String codigoMarcaRetoma = '';

                    String tipoVehiculo = mapTipoVehiculo.get(oppResp.loanSimulationCar.VehicleType.externalCode);
                
                    String tipoVehiculoRetoma = '';

                    //Agrego campo User para ver si existe RUT FI
                    User propietario = new User();
                
                    //Agrego campo Vendedor__c para ver que exista el vendedor
                    Vendedor__c vendedor = new Vendedor__c();

                    //Agrego campo Local__C para ver que exista dicho local en registros de Salesforce
                    Local__c local = new Local__c();

                    //Consulto datos para Modelo2 y Modelo2Retoma
                    Modelo_de_vehiculo__c modelo = consultasSOQL.getVehiculo(String.valueOf(oppResp.loanSimulationCar.Brand.id), String.valueOf(oppResp.loanSimulationCar.Model.id));
                    Modelo_de_vehiculo__c modeloRetoma = new Modelo_de_vehiculo__c();
                    if(oppResp.tradeInCar != null && oppResp.tradeInCar.id > 0){
                        modeloRetoma = consultasSOQL.getVehiculo(String.valueOf(oppResp.tradeInCar.Brand.id), String.valueOf(oppResp.tradeInCar.Model.id));
                        codigoMarcaRetoma = mapMarcasRetoma.get(oppResp.tradeInCar.Brand.name);
                        tipoVehiculoRetoma = mapTipoVehiculo.get(oppResp.tradeInCar.VehicleType.externalCode);
                    }

                    try{
                        propietario = consultasSOQL.getPropietario(oppResp.loanSimulationData.amicarExecutive.rut);
                    }catch(Exception ex){
                        //SOLO PARA QUE VALIDAR SI PROPIETARO EXISTE
                    }

                    try{
                        vendedor = consultasSOQL.getVendedor(oppResp.loanSimulationData.salesRepresentative.rut);
                    }catch(Exception ex){
                        //SOLO PARA VALIDAR SI EXISTE VENDEDOR
                    }

                    try{
                        local = consultasSOQL.getLocal(String.valueOf(oppResp.loanSimulationData.SalesRoom.id));
                    }catch(Exception ex){
                        //SOLO PARA VALIDAR SI EXISTE LOCAL
                    }
                
                    //Si el Propietario no existe en Salesforce, retornar error 400
                    //De lo contrario iniciar proceso de carga de datos
                    if(propietario == null || String.isBlank(propietario.RUT_F_I__c)){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El RUT "'+oppResp.loanSimulationData.amicarExecutive.rut+'" no se encuentra asociado a los Ejecutivos registrados en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        res.statusCode = 400;
                    }else if(local == null){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El Local "'+oppResp.loanSimulationData.SalesRoom.name+' (Cod. '+oppResp.loanSimulationData.SalesRoom.id+')" no se encuentra registrado en el Objeto Local__c de Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        res.statusCode = 400;
                    }else if(vendedor == null){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El RUT "'+oppResp.loanSimulationData.salesRepresentative.rut+'" no se encuentra asociado a los Vendedores registrados en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        res.statusCode = 400;
                    }else if(tipoVehiculo != String.valueOf(oppResp.loanSimulationCar.VehicleType.externalCode)){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El tipo de vehículo "'+oppResp.loanSimulationCar.VehicleType.description+'" (Cod. '+oppResp.loanSimulationCar.VehicleType.externalCode+') no se encuentra registrado como valor API en el campo "Tipo de Vehículo" en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                    }else if(codigoMarca != String.valueOf(oppResp.loanSimulationCar.Brand.id)){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El código de la Marca "'+oppResp.loanSimulationCar.Brand.Name+' (Cod. '+oppResp.loanSimulationCar.Brand.Id+') es distinto al valor API ('+codigoMarca+') para la marca '+oppResp.loanSimulationCar.Brand.Name+' del campo "Marca vehículo" en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                    }else if(modelo == null){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El Vehículo "'+oppResp.loanSimulationCar.Brand.Name+' (Cod. '+oppResp.loanSimulationCar.Brand.Id+') - '+oppResp.loanSimulationCar.Model.name+' (Cod. '+oppResp.loanSimulationCar.Model.id+')" no se encuentra registrado el objeto Modelo_de_vehículo__c en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        res.statusCode = 400;
                    }else if(oppResp.tradeInCar != null && oppResp.tradeInCar.id > 0 && tipoVehiculoRetoma != String.valueOf(oppResp.tradeInCar.VehicleType.externalCode)){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El tipo de vehículo (Retoma) "'+oppResp.tradeInCar.VehicleType.description+'" (Cod. '+oppResp.tradeInCar.VehicleType.externalCode+') no se encuentra registrado como valor API en el campo "Tipo" en la sección Retoma en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                    }else if(oppResp.tradeInCar != null && oppResp.tradeInCar.id > 0 && codigoMarcaRetoma != String.valueOf(oppResp.tradeInCar.Brand.id)){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El código de la Marca (Retoma) "'+oppResp.loanSimulationCar.Brand.Name+' (Cod. '+oppResp.loanSimulationCar.Brand.Id+') es distinto al valor API ('+codigoMarca+') para la marca '+oppResp.loanSimulationCar.Brand.Name+' del campo "Marca" en la sección Retoma en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                    }else if(modeloRetoma == null && oppResp.tradeInCar != null && oppResp.tradeInCar.id > 0){
                        jsonRespError respError= new jsonRespError();
                        respError.StatusCode = 400;
                        respError.Mensaje = 'El Vehículo (retoma) "'+oppResp.tradeInCar.Brand.Name+' (Cod. '+oppResp.tradeInCar.Brand.Id+') - '+oppResp.tradeInCar.Model.name+' (Cod. '+oppResp.tradeInCar.Model.id+')" no se encuentra registrado el objeto Modelo_de_vehículo__c en Salesforce.';
                        res.responseBody = Blob.valueOf(JSON.serialize(respError));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        res.statusCode = 400;
                    }else{
                        if(!listaCuentas.isEmpty()){
                            for(Account acc:listaCuentas){
                                mapCuentas.put(acc.RUT__c, acc);
                            }
                        }

                        //Si dato del cliente no existe, lo agrego en lista de cuentas a crear
                        Set<Account> accToAdd = new Set<Account>();
                        if(mapCuentas.get(formatoRut(oppResp.customer.identificationValue)) == null){
                            Account acc = datosOportunidad.crearCliente(oppResp.customer);
                            accToAdd.add(acc);
                            //Si el servicio es PJ al map asigno RUT y Name, de lo contrario RUT y FirstName
                            if(esServicioPj){
                                mapCuentasToAdd.put(acc.RUT__c, acc.Name);
                            }else{
                                mapCuentasToAdd.put(acc.RUT__c, acc.FirstName);
                            }
                        }

                        //Consulto si los avales existen como cuenta, si no, agregarlos en lista de cuentas a crear
                        if(oppResp.guarantor != null && oppResp.guarantor.size() > 0){
                            for(AMICAR_OpportunityJSON2.Guarantor guarantor : oppResp.guarantor){
                                if(mapCuentas.get(formatoRut(guarantor.identificationValue)) == null && mapCuentasToAdd.get(formatoRut(guarantor.identificationValue)) == null){
                                    Account acc = datosOportunidad.crearAval(guarantor);
                                    accToAdd.add(acc);
                                    if(guarantor.identificationTypeId == null || guarantor.identificationTypeId == 0 || guarantor.identificationTypeId == 1){
                                        mapCuentasToAdd.put(acc.RUT__c, acc.FirstName);
                                    }else{
                                        mapCuentasToAdd.put(acc.RUT__c, acc.Name);
                                    }
                                }
                            }
                        }

                        //Consulto si los representantes legales existen como cuenta, si no, agregarlos en lista de cuentas a crear
                        if(oppResp.legalRepresentative != null && oppResp.legalRepresentative.size() > 0){
                            for(AMICAR_OpportunityJSON2.LegalRepresentative legalRep : oppResp.legalRepresentative){
                                if(mapCuentas.get(formatoRut(legalRep.identificationValue)) == null && mapCuentasToAdd.get(formatoRut(legalRep.identificationValue)) == null){
                                    if(String.isNotBlank(legalRep.name)){
                                        Account acc = datosOportunidad.crearRepLegal(legalRep);
                                        accToAdd.add(acc);
                                        mapCuentasToAdd.put(acc.RUT__c, acc.FirstName);
                                    }
                                }
                            }
                        }

                        //Consulto si los socios existen como cuenta, si no, agregarlos en lista de cuentas a crear
                        if(oppResp.majorityPartners != null && oppResp.majorityPartners.size() > 0){
                            for(AMICAR_OpportunityJSON2.MajorityPartners socio : oppResp.majorityPartners){
                                if(mapCuentas.get(formatoRut(socio.identificationValue)) == null && mapCuentasToAdd.get(formatoRut(socio.identificationValue)) == null){
                                    if(String.isNotBlank(socio.name)){
                                        Account acc = datosOportunidad.crearSocio(socio);
                                        accToAdd.add(acc);
                                        mapCuentasToAdd.put(acc.RUT__c, acc.FirstName);
                                    }
                                }
                            }
                        }

                        //Consulto si los Compra para existen como cuenta, si no, agregarlos en lista de cuentas a crear
                        if(oppResp.BuyForAnother != null && oppResp.buyForAnother.identificationValue != null){
                            System.debug(oppResp.buyForAnother.identificationValue);
                            System.debug(oppResp.buyForAnother);
                            if(mapCuentas.get(formatoRut(oppResp.buyForAnother.identificationValue)) == null && mapCuentasToAdd.get(formatoRut(oppResp.buyForAnother.identificationValue)) == null){
                                Account acc = datosOportunidad.crearCompraPara(oppResp.buyForAnother);
                                accToAdd.add(acc);  
                                mapCuentasToAdd.put(acc.RUT__c, acc.FirstName);
                            }
                        }

                        //Si existen cuentas a crear, proceder con insert Accounts y agregar en map los nuevos registros
                        if(accToAdd.size() > 0){
                            List<Account> accLst = new List<Account>();
                            for(Account accAdd : accToAdd){
                                accLst.add(accAdd);
                                System.debug(accAdd.RUT__c);
                            }
                            accLst = consultasSOQL.insertarCuentas(accLst);
                            for(Account acc : accLst){
                                mapCuentas.put(acc.RUT__c, acc);
                            }
                        }

                        //Traigo los datos del cliente
                        Account acc = mapCuentas.get(formatoRut(oppResp.customer.identificationValue));
                
                        //Creo la Oportunidad
                        Opportunity opp = datosOportunidad.crearOportunidad(oppResp, propietario, acc, local, vendedor, modelo, modeloRetoma);
                    
                        opp.SyncedQuoteId = null;

                        System.debug(opp);

                        //Primer upsert a la Oportunidad
                        opp = consultasSOQL.upsertOpportunity(opp);

                        //Si existen relaciones las elimino para volver a reingresarlas (No hay external ID)
                        List<Impuesto__c> impList = consultasSOQL.getImpuestosOpportunity(opp.Id);
                        if(impList.size() > 0){
                            consultasSOQL.eliminarImpuestos(impList);
                        }

                        //Declaración de IVA
                        if(oppResp.taxReturn.size() > 0 && opp.Id != null){
                            List<Impuesto__c> impToAdd = new List<Impuesto__c>();
                            for(AMICAR_OpportunityJSON2.TaxReturn ivas : oppResp.taxReturn){
                                Impuesto__c iva = datosOportunidad.crearImpuesto(ivas, opp.Id);
                                impToAdd.add(iva);
                            }

                            if(impToAdd.size() > 0){
                                    System.debug('Declaración de Iva');
                                    System.debug(impToAdd);
                                    consultasSOQL.insertarImpuestos(impToAdd);
                            }
                        }
            
                        //Si existen relaciones las elimino para volver a reingresarlas (No hay external ID)
                        List<Relacion__c> relList = consultasSOQL.getRelacionesOportunidad(opp.Id);
                        if(oppResp.guarantor.size() > 0 || oppResp.spouseData != null || oppResp.personalReferences.size() > 0 || oppResp.buyForAnother != null){
                            if(relList.size() > 0){
                                consultasSOQL.eliminarRelacionesOportunidad(relList);
                            }
                        }                   
                    
                        //Cargar Relaciones y referencias
                        if(oppResp.guarantor.size() > 0 || oppResp.spouseData != null || 
                            oppResp.personalReferences.size() > 0 || oppResp.buyForAnother != null ||
                            oppResp.legalRepresentative != null || oppResp.majorityPartners != null || 
                            oppResp.customerSuppliers != null){
                            List<Relacion__c> relToAdd = new List<Relacion__c>();

                            //Compra para
                            if(oppResp.buyForAnother != null && oppResp.buyForAnother.identificationValue != null){
                                Account accRel = new Account();
                                String rutRel = formatoRut(oppResp.buyForAnother.identificationValue);
                                accRel = mapCuentas.get(rutRel);
                                Relacion__c rel = datosOportunidad.crearCompraPara(oppResp.buyForAnother, accRel.Id, opp.id);
                                System.debug('COMPRA PARA');
                                System.debug(rel);
                                relToAdd.add(rel);
                            }

                            //Aval
                            if(oppResp.guarantor != null){
                                for(AMICAR_OpportunityJSON2.Guarantor guarantor : oppResp.guarantor){
                                    Account accRel = new Account();
                                    String rutRel = guarantor.identificationValue.substring(0,guarantor.identificationValue.length()-1)+'-'+guarantor.identificationValue.substring((guarantor.identificationValue.length()-1),guarantor.identificationValue.length());
                                    accRel = mapCuentas.get(rutRel);
                                    Relacion__c rel = datosOportunidad.crearAval(guarantor, accRel.Id, opp.Id);
                                    System.debug('AVAL');
                                    System.debug(rel);
                                    relToAdd.add(rel);
                                }
                            }

                            //Representante Legal
                            if(oppResp.legalRepresentative != null){
                                for(AMICAR_OpportunityJSON2.LegalRepresentative legalRep : oppResp.legalRepresentative){
                                    Account accRel = new Account();
                                    String rutRel = legalRep.identificationValue.substring(0,legalRep.identificationValue.length()-1)+'-'+legalRep.identificationValue.substring((legalRep.identificationValue.length()-1),legalRep.identificationValue.length());
                                    accRel = mapCuentas.get(rutRel);
                                    if(accRel != null){
                                        Relacion__c rel = datosOportunidad.crearRepresentanteLegal(legalRep, accRel.Id, opp.Id);
                                        System.debug('REPRESENTANTE LEGAL');
                                        System.debug(rel);
                                        relToAdd.add(rel);
                                    }
                                }
                            }

                            //Socios
                            if(oppResp.majorityPartners != null){
                                for(AMICAR_OpportunityJSON2.MajorityPartners socio : oppResp.majorityPartners){
                                    Account accRel = new Account();
                                    String rutRel = socio.identificationValue.substring(0,socio.identificationValue.length()-1)+'-'+socio.identificationValue.substring((socio.identificationValue.length()-1),socio.identificationValue.length());
                                    accRel = mapCuentas.get(rutRel);
                                    if(accRel != null){
                                        Relacion__c rel = datosOportunidad.crearSocio(socio, accRel.Id, opp.Id);
                                        System.debug('SOCIO');
                                        System.debug(rel);
                                        relToAdd.add(rel);
                                    }
                                }
                            }

                            //Cónyuge
                            if(oppResp.spouseData.identificationValue != null){
                                Relacion__c rel = datosOportunidad.crearConyuge(oppResp.spouseData, opp.Id);
                                relToAdd.add(rel);
                            }

                            //Referencia
                            if(oppResp.personalReferences.size() > 0){
                                for(AMICAR_OpportunityJSON2.PersonalReferences personalReferences : oppResp.personalReferences){
                                    Relacion__c rel = datosOportunidad.crearReferencia(personalReferences, opp.Id);
                                    relToAdd.add(rel);
                                }
                            }

                            //Proveedores
                            if(oppResp.customerSuppliers != null){
                                if(oppResp.customerSuppliers.size() > 0){
                                    for(AMICAR_OpportunityJSON2.CustomerSuppliers customerSuppliers : oppResp.customerSuppliers){
                                        Relacion__c rel = datosOportunidad.crearReferenciaProveedor(customerSuppliers, opp.Id);
                                        relToAdd.add(rel);
                                    }
                                }
                            }

                            if(relToAdd.size() > 0){
                                System.debug('RELACIONADOS');
                                System.debug(relToAdd);
                                consultasSOQL.insertarRelacionesOportunidad(relToAdd);
                            }
                        }
            
                        //Asigno el estado original de la solicitud y formalizacion OK en true 
                        opp.StageName = TranslateStatusStage(oppResp.loanSimulationData.status);
                        opp.Formalizacion_OK__c = true;
            
                        List<Quote> quoteList = consultasSOQL.getQuotesOportunidad(opp.id);
                        if(quoteList.size() > 0){
                            consultasSOQL.eliminarQuotesOportunidad(quoteList);
                        }

                        //Cargo quote
                        Quote q = new Quote();
                        if(oppResp.loanSimulationData.LoanType != null){
                    
                            Pricebook2 pb2 = consultasSOQL.getListaStandardPrecio();
                            if(Test.isRunningTest()){
                                pb2.Id = Test.getStandardPricebookId();
                            }
                        
                            q = datosOportunidad.crearQuote(oppResp.loanSimulationData, oppResp.amortizationSchedule, opp.Id, pb2.Id);
                
                            q = consultasSOQL.insertarQuoteOportunidad(q);
                        }

                        //Agrego QuoteLineItems, si hay datos después debo sincronizar
                        if(oppResp.surchargesAndInsurances.size() > 0){
                
                            //Revisar si existen los Productos y Listas de Precios en Salesforce
                            consultasSOQL.checkProductsAndPricebookentries(oppResp);

                            List<QuoteLineItem> asistenciasAmicarSimulacion = new List<QuoteLineItem>();
                            List<QuoteLineItem> recargosDealerSimulacion = new List<QuoteLineItem>();
                            List<QuoteLineItem> recargosEfSimulacion = new List<QuoteLineItem>();
                            List<QuoteLineItem> segurosDealerSimulacion = new List<QuoteLineItem>();
                            List<QuoteLineItem> segurosEfSimulacion = new List<QuoteLineItem>();
                    
                            List<Product2> ListaProductos = consultasSOQL.getListaProductos();
                            Map<String,Id> MapaAsistencias = new Map<String,Id>();

                            List<PricebookEntry> ListaEntradas = consultasSOQL.getListaEntradas();
                            Map<Id,Id> MapaEntradas = new Map<Id,Id>();

                            if(!ListaEntradas.isEmpty()){
                                for(PricebookEntry ProductosEntrada:ListaEntradas){
                                    MapaEntradas.put(ProductosEntrada.Product2Id,ProductosEntrada.Id);
                                }
                            }

                            if(!ListaProductos.isEmpty()){
                                //
                                // productos amicarAssistance
                                //----------------------------------------------------------------------------------
                                for(Product2 ProductosEnLista:ListaProductos){
                                    if(ProductosEnLista.Family == 'amicarAssistance'){
                                        MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
                                    }
                                }
                                System.debug('mapa asistencias amicar->'+MapaAsistencias);

                                if(!MapaAsistencias.isEmpty()){
                                    for(AMICAR_OpportunityJSON2.SurchargesAndInsurances asistenciasAmicar : oppResp.surchargesAndInsurances){
                                        if(asistenciasAmicar.type == 'amicarAssistance'){
                                            String clave = asistenciasAmicar.description + ' ' + asistenciasAmicar.id + ' amicarAssistance';
                                            System.debug('clave->'+clave);
                                            System.debug(MapaAsistencias.get(clave));
                                            String idProduct2 = MapaAsistencias.get(clave);
                                            String idPricebookEntry = MapaEntradas.get(idProduct2);
                                            QuoteLineItem nuevoItem = datosOportunidad.crearQuoteLineItem(asistenciasAmicar, idProduct2, idPricebookEntry, q.id);
                                            asistenciasAmicarSimulacion.add(nuevoItem);
                                        }
                                    }
                                }

                                System.debug('asistencias amicar->'+asistenciasAmicarSimulacion);
                                if(asistenciasAmicarSimulacion.size() != 0){
                                    try{
                                        consultasSOQL.insertarQuoteLineItem(asistenciasAmicarSimulacion);
                                    }catch(Exception ex){
                                        System.debug('Error al insertar asistencias amicar');
                                        System.debug(ex.getMessage());
                                        System.debug(ex.getStackTraceString());
                                    }
                                }

                                MapaAsistencias.clear();

                                //
                                //dealerSurcharges
                                //----------------------------------------------------------------------------------
                                for(Product2 ProductosEnLista:ListaProductos){
                                    if(ProductosEnLista.Family == 'dealerSurcharges'){
                                        MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
                                    }
                                }
                                System.debug('mapa recargos dealer->'+MapaAsistencias);

                                if(!MapaAsistencias.isEmpty()){
                                    for(AMICAR_OpportunityJSON2.SurchargesAndInsurances recargosDealer : oppResp.surchargesAndInsurances){
                                        if(recargosDealer.type == 'dealerSurcharges'){
                                            String clave = recargosDealer.description + ' ' + recargosDealer.id + ' dealerSurcharges';
                                            System.debug('clave->'+clave);
                                            String idProduct2 = MapaAsistencias.get(clave);
                                            String idPricebookEntry = MapaEntradas.get(idProduct2);
                                            QuoteLineItem nuevoItem = datosOportunidad.crearQuoteLineItem(recargosDealer, idProduct2, idPricebookEntry, q.id);
                                            recargosDealerSimulacion.add(nuevoItem);
                                        }
                                    }
                                }

                                System.debug('recargos dealer->'+recargosDealerSimulacion);
                                if(recargosDealerSimulacion.size() != 0){
                                    try{
                                        consultasSOQL.insertarQuoteLineItem(recargosDealerSimulacion);
                                    }catch(Exception ex){
                                        System.debug('Error al insertar recargos dealer');
                                        System.debug(ex.getMessage());
                                        System.debug(ex.getStackTraceString());
                                    }
                                }

                                MapaAsistencias.clear();

                                //
                                //financingEntitySurcharges
                                //----------------------------------------------------------------------------------
                                for(Product2 ProductosEnLista:ListaProductos){
                                    if(ProductosEnLista.Family == 'financingEntitySurcharges'){
                                        MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
                                    }
                                }
                                System.debug('mapa recargos EF->'+MapaAsistencias);

                                if(!MapaAsistencias.isEmpty()){
                                    for(AMICAR_OpportunityJSON2.SurchargesAndInsurances recargosEf : oppResp.surchargesAndInsurances){
                                        if(recargosEf.type == 'financingEntitySurcharges'){
                                            String clave = recargosEf.description + ' ' + recargosEf.id + ' financingEntitySurcharges';
                                            System.debug('clave->'+clave);
                                            String idProduct2 = MapaAsistencias.get(clave);
                                            String idPricebookEntry = MapaEntradas.get(idProduct2);
                                            QuoteLineItem nuevoItem = datosOportunidad.crearQuoteLineItem(recargosEf, idProduct2, idPricebookEntry, q.id);
                                            recargosEfSimulacion.add(nuevoItem);
                                        }
                                    }

                                    System.debug('recargos dealer->'+recargosEfSimulacion);
                                    if(recargosEfSimulacion.size() != 0){
                                        try{
                                            consultasSOQL.insertarQuoteLineItem(recargosEfSimulacion);
                                        }catch(Exception ex){
                                            System.debug('Error al insertar entity surcharges');
                                            System.debug(ex.getMessage());
                                            System.debug(ex.getStackTraceString());
                                        }
                                    }
                                }
                                MapaAsistencias.clear();

                                //
                                //financingEntityInsurance
                                //----------------------------------------------------------------------------------
                                for(Product2 ProductosEnLista:ListaProductos){
                                    if(ProductosEnLista.Family == 'financingEntityInsurance'){
                                        MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
                                    }
                                }
                                System.debug('mapa seguros segurosEF->'+MapaAsistencias);

                                if(!MapaAsistencias.isEmpty()){
                                    for(AMICAR_OpportunityJSON2.SurchargesAndInsurances segurosEF : oppResp.surchargesAndInsurances){
                                        if(segurosEF.type == 'financingEntityInsurance'){
                                            String clave = segurosEF.description + ' ' + segurosEF.id + ' financingEntityInsurance';
                                            System.debug('clave->'+clave);
                                            System.debug('ef->'+segurosEF);
                                            String idProduct2 = MapaAsistencias.get(clave);
                                            String idPricebookEntry = MapaEntradas.get(idProduct2);
                                            QuoteLineItem nuevoItem = datosOportunidad.crearQuoteLineItem(segurosEF, idProduct2, idPricebookEntry, q.id);
                                            segurosEfSimulacion.add(nuevoItem);
                                        }
                                    }
                                }

                                System.debug('seguros EF->'+segurosEfSimulacion);

                                if(segurosEfSimulacion.size() != 0){
                                    try{
                                        consultasSOQL.insertarQuoteLineItem(segurosEfSimulacion);
                                    }catch(Exception ex){
                                        System.debug('Error al insertar entity insurance');
                                        System.debug(ex.getMessage());
                                        System.debug(ex.getStackTraceString());
                                    }
                                }
                                MapaAsistencias.clear();
                            }
                            //Sincronizar
                            opp.SyncedQuoteId = q.Id;
                            opp = consultasSOQL.updateOpportunity(opp);
                        
                        }else{
                            //Solo actualizo la oportunidad con los datos de la etapa y formalización OK
                            opp = consultasSOQL.updateOpportunity(opp);
                        }

                        //Carga de patrimonios
                        List<Patrimonio__c> patToDelete = consultasSOQL.getListaPatrimonios(opp.id);
                        if(oppResp.heritage.size() > 0){
                            if(patToDelete.size() > 0){
                                consultasSOQL.eliminarPatrimonios(patToDelete);
                            }
                            List<Patrimonio__c> patToAdd = new List<Patrimonio__c>();
                            for(AMICAR_OpportunityJSON2.Heritage heritage : oppResp.heritage){
                                Patrimonio__c pat = datosOportunidad.crearPatrimonio(heritage, opp.id);
                                patToAdd.add(pat);
                            }
                            if(patToAdd.size() > 0){
                                consultasSOQL.insertarPatrimonios(patToAdd);
                            }
                        }

                        //Carga de referencias
                        List<Desarrollo__c> desarrolloToDelete = consultasSOQL.getListaDesarrollos(opp.Id);
                        if(oppResp.amortizationSchedule.size() > 0){
                            if(desarrolloToDelete.size() > 0){
                                consultasSOQL.eliminarDesarrollos(desarrolloToDelete);
                            }
                            List<Desarrollo__c> desarrolloToAdd = new List<Desarrollo__c>();
                            for(AMICAR_OpportunityJSON2.AmortizationSchedule amortization : oppResp.amortizationSchedule){
                                Desarrollo__c des = datosOportunidad.crearDesarrollo(amortization, opp.Id, q.Id);
                                desarrolloToAdd.add(des);
                            }
                            if(desarrolloToAdd.size() > 0){
                                consultasSOQL.insertarDesarrollos(desarrolloToAdd);
                            }
                        }

                        jsonRespOk respOk = new jsonRespOk();
                        respOk.StatusCode = 200;
                        respOk.OpportunityId = opp.Id;

                        res.responseBody = Blob.valueOf(JSON.serialize(respOk));
                        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
                        //res.setHeader('content-type', 'application/json');
                        res.statusCode = 200;
                    }
                }
            }
        }catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            
            jsonRespError respError= new jsonRespError();
            respError.StatusCode = 400;
            respError.Mensaje = ex.getMessage()+'\n'+ex.getStackTraceString();
            res.responseBody = Blob.valueOf(JSON.serialize(respError));
            res.addHeader('Content-Type', 'application/json;charset=UTF-8');
            res.statusCode = 400;
        }
    }

    public static String nameConcat(String rut, String marca, String modelo){ 
        
        String rutPersona='';
        if(rut.length() > 1){
            if(rut.contains('-')){
                rutPersona = rut;
            }else{
                rutPersona = rut.substring(0,(rut.length()-1))+'-'+rut.subString((rut.length()-1),rut.length());
            }
        }

        return (rutPersona +' ' + marca + ' ' +modelo +' Solicitud AMICORE' );
    }

    public static String formatoRut(String rut){
        String rutPersona='';
        if(rut.length() > 1){
            if(rut.contains('-')){
                rutPersona = rut;
            }else{
                rutPersona = rut.substring(0,rut.length()-1)+'-'+rut.substring((rut.length()-1),rut.length());
                System.debug('rutPersona = '+rutPersona);
            }
        }
        return rutPersona;
    }

    public static String TranslateStatusStage(String status){ 
        String stage = '';
    
        if(status == 'DRAFT_SIMULATION'){
            stage = 'Pre evaluación';
        }else if(status == 'SAVED_SIMULATION'){
            stage = 'Formalización';
        }else if(status == 'FORMALIZED_REQUEST'){
            //stage = 'Remate';
            stage = 'Envío a Evaluar';
        }else if (status == 'FINISHED_AUCTION'){
            stage = 'Remate Finalizado';
        }else if (status == 'GRANTED'){
            stage = 'Checklist';
        }else if (status == 'VALIDATION_STAGE'){
            stage = 'Firma documentación';
        }else if (status == 'AWARDED'){
            stage = 'Cerrada ganada';
        }else if (status == 'CHECKLIST_VALIDATION'){
            stage = 'Checklist';
        }else if (status == 'CHECKLIST_CONFIRMED'){
            stage = 'Firma Documentación';
        }else if (status == 'SIGNING'){
            stage = 'Firma Documentación';
        }else if (status == 'FOLDER_VALIDATION'){
            stage = 'Cerrada ganada';
        }else if (status == 'CANCELED'){
            stage = 'Cerrada perdida';
        }else if (status == 'CLOSED'){
            stage = 'Cerrada ganada';
        }else if (status == 'CLOSED_WITHOUT_APPROVALS'){
            stage = 'Cerrada perdida';
        }else{
            stage = status;
        } 

        return stage;
    }

    global class jsonRespOk {
        public Integer StatusCode{get;set;}
        public String OpportunityId{get;set;}
    }

    global class jsonRespError {
        public Integer StatusCode{get;set;}
        public String Mensaje{get;set;}
    }
}