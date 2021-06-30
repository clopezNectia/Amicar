/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que envia información de solicitud formalizada a Core (paso 2.1, simulación formalizada)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 15-04-2020            RJZ                      Creación de la Clase.
1.1 
***********************************************************************************/
public class AMICAR_EnviaSimulacionFormalizada {


    @InvocableMethod(label='Envia simulación formalizada paso 2' description='Envia simulación formalizada')
    public static List<string> EnviaFormalizada (List<string> inputParams) {

        System.debug('parametros->'+inputParams);

        Id rtAval = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Aval').getRecordTypeId();
        Id rtCompraPara = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Compra para').getRecordTypeId();
        Id rtConyuge = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Conyuge').getRecordTypeId();
        Id rtReferencia = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();

        List<Opportunity> solicitudSalesforce = [SELECT 
                                                    Id,
                                                    Name,
                                                    AccountId,
                                                    OwnerId,
                                                    Tipo_de_Veh_culo__c,
                                                    Precio_vehiculo__c,
                                                    toLabel(Marca_vehiculo__c),
                                                    Modelo__c,
                                                    A_o_Veh_culo__c,
                                                    Version__c,
                                                    Pie__c,
                                                    Pie_formula__c,
                                                    Cuotas__c,
                                                    Tipo_de_tasa__c,
                                                    Opcion_inmediata__c,
                                                    Monto_retoma__c,
                                                    Concesionarios__c,
                                                    Locales__c,
                                                    Importadora__c,
                                                    Tipo_de_financiamiento__c,
                                                    CloseDate,
                                                    Estado_civil__c,
                                                    Regimen_matrimonial__c,
                                                    Estudios__c,
                                                    Tipo_de_residencia__c,
                                                    Vendedor__c,
                                                    Id_Solicitud__c,
                                                    Direccion__c,
                                                    Regi_n__c,
                                                    Comuna__c,
                                                    Tipo_de_trabajador__c,
                                                    Tipo_de_contrato__c,
                                                    Renta__c,
                                                    Otros_ingresos__c,
                                                    Arriendo__c,
                                                    Dividendo__c,
                                                    Otros_egresos__c,
                                                    Empleador__c,
                                                    RUT_empleador__c,
                                                    Rubro_de_empleador__c,
                                                    Direccion_empleador__c,
                                                    Region_empleador__c,
                                                    Comuna_empleador__c,
                                                    Telefono_empleador__c,
                                                    Fecha_de_ingreso__c,
                                                    Cargo__c,
                                                    Tipo_de_renta__c,
                                                    Tipo_de_actividad__c,
                                                    Banco_cuenta_1__c,
                                                    Numero_cuenta_1__c,
                                                    Tipo_cuenta_1__c,
                                                    PAC_cuenta_1__c,
                                                    Banco_cuenta_2__c,
                                                    Numero_cuenta_2__c,
                                                    Tipo_de_cuenta_2__c,
                                                    PAC_cuenta_2__c,
                                                    Profesion__c,
                                                    Descripcion_otros_ingresos__c,
                                                    N_de_serie_C_I__c
                                                FROM Opportunity WHERE Id =: inputParams];

        List<Account> clienteSolicitud = [SELECT Id,FirstName,LastName,PersonEmail,PersonMobilePhone,RUT__c,N_de_serie_C_I__pc,Nacionalidad__pc,Genero__pc,PersonBirthdate FROM Account WHERE Id =: solicitudSalesforce[0].AccountId];
        List<Impuesto__c> impuestoSolicitud = [SELECT Id,Fecha__c,Impuesto_compras__c,Impuesto_ventas__C FROM Impuesto__c WHERE Solicitud__c =: solicitudSalesforce[0].Id];

        String tempApellidos = clienteSolicitud[0].LastName;
        list<String> apellidos = tempApellidos.split(' ',2);
        if (apellidos.size() == 1 ){
            apellidos.add(' ');
        }
        String rutsinguion = clienteSolicitud[0].RUT__c;
        rutsinguion = rutsinguion.remove('-');

        List<User> usuarioSolicitud = [SELECT Id,RUT_F_I__c FROM User WHERE Id =: solicitudSalesforce[0].OwnerId];

        List<Vendedor__c> vendedorSolicitud = [SELECT Id,RUT__c FROM Vendedor__c WHERE Id =: solicitudSalesforce[0].Vendedor__c];

        List<Patrimonio__c> patrimonioSolicitud = [SELECT Id,Tipo__c,Descripcion__c,Valor_venta__c,Financiamiento__c,Con_deuda__c FROM Patrimonio__c WHERE Solicitud__c =: solicitudSalesforce[0].Id];

        List<Relacion__c> avalSolicitud = [SELECT Id,Cuenta__r.FirstName,Cuenta__r.LastName,Cuenta__r.PersonBirthdate,Cuenta__r.Nacionalidad__pc,RUT__c,Estado_civil__c,Regimen_matrimonial__c,Direccion__c,Region__c,Comuna__c,Sueldo_liquido__c,Tipo_de_trabajador__c,Tipo_de_actividad__c FROM Relacion__c WHERE Solicitud__c =: solicitudSalesforce[0].Id AND RecordTypeId =: rtAval];
        List<Relacion__c> compraParaSolicitud = [SELECT Id,Es_aval__c,RUT__c,Direccion__c,Region__c,Comuna__c,Estado_civil__c,Regimen_matrimonial__c,Cuenta__r.PersonBirthdate,Cuenta__r.Nacionalidad__pc,Cuenta__r.FirstName,Cuenta__r.LastName FROM Relacion__c WHERE Solicitud__c =: solicitudSalesforce[0].Id AND RecordTypeId =: rtCompraPara];
        List<Relacion__c> conyugeSolicitud = [SELECT Id,Empleador__c,Nombre__c,Apellidos__c,RUT_referencia__c,Telefono_empleador__c,Direccion__c,Tipo_de_trabajador__c,Tipo_de_actividad__c,Sueldo_liquido__c,Complementa_renta__c,Comuna__c FROM Relacion__c WHERE Solicitud__c =: solicitudSalesforce[0].Id AND RecordTypeId =: rtConyuge];
        List<Relacion__c> referenciaSolicitud = [SELECT Id,Nombre__c,Apellidos__c,RUT_referencia__c,Tipo_de_relacion__c,Direccion__c,Telefono__c FROM Relacion__c WHERE Solicitud__c =: solicitudSalesforce[0].Id AND RecordTypeId =: rtReferencia];

        List<Remate__c> remateSolicitud = [SELECT Id,Id_remate__c,Orden__c,Entidad_Financiera__c,Aceptada__c,Estado__c,Ganadora__c,Checklist__c FROM Remate__c WHERE Solicitud__c =: solicitudSalesforce[0].Id];


        //
        //      Arma JSON bancos
        //
        String banco1;
        if (solicitudSalesforce[0].Banco_cuenta_1__c != null){
            banco1 = '{"codeId":"' +  solicitudSalesforce[0].Banco_cuenta_1__c  + '","automaticPayment":' + solicitudSalesforce[0].PAC_cuenta_1__c + ',"accountNumber":"' + solicitudSalesforce[0].Numero_cuenta_1__c + '"}';
        }
        String banco2;
        if (solicitudSalesforce[0].Banco_cuenta_2__c != null){
            banco2 = '{"codeId":"' +  solicitudSalesforce[0].Banco_cuenta_2__c  + '","automaticPayment":' + solicitudSalesforce[0].PAC_cuenta_2__c + ',"accountNumber":"' + solicitudSalesforce[0].Numero_cuenta_2__c + '"}';
        }

        String bancoFinal;
        if (banco2 != null){
            bancoFinal = banco1 + ',' + banco2;
        }else{
            bancoFinal = banco1;
        }

        //
        //      Arma JSON conyuge
        //
        String conyuge;
        if (conyugeSolicitud.size() != 0){

            String tempApellidosConyuge = conyugeSolicitud[0].Apellidos__c;
            list<String> apellidosConyuge = tempApellidosConyuge.split(' ',2);
            if (apellidosConyuge.size() == 1 ){
                apellidosConyuge.add(' ');
            }

            String empleadorConyuge = conyugeSolicitud[0].Empleador__c != null ? conyugeSolicitud[0].Empleador__c : '';
            String telefonoEmpleadorConyuge = conyugeSolicitud[0].Telefono_empleador__c != null ? conyugeSolicitud[0].Telefono_empleador__c : '';
            String tipoTrabajadorConyuge = conyugeSolicitud[0].Tipo_de_trabajador__c != null ? conyugeSolicitud[0].Tipo_de_trabajador__c : '';
            String tipoActividadConyuge = conyugeSolicitud[0].Tipo_de_actividad__c != null ? conyugeSolicitud[0].Tipo_de_actividad__c : '';
            Integer sueldoConyuge = conyugeSolicitud[0].Sueldo_liquido__c != null ? Integer.valueOf(conyugeSolicitud[0].Sueldo_liquido__c) : 0;

            conyuge = '{'+
                '"identificationType":'+ 1 + ',' +
                '"identificationValue":"'+ conyugeSolicitud[0].RUT_referencia__c + '",' +
                '"name":"'+ conyugeSolicitud[0].Nombre__c + '",' +
                '"lastName":"'+ apellidosConyuge[0] +'",' +
                '"motherLastName":"'+ apellidosConyuge [1] +'",' + 
                '"address":"'+ conyugeSolicitud[0].Direccion__c + '",' +
                '"spouseGeographicDataId":"'+ conyugeSolicitud[0].Comuna__c + '",'+ 
                //'"state":"'+ /*region*/ + '",' +
                //'"city":"'+  + '",' +
                //'"province":"'+ /*comuna*/ + '",'+ 
                '"workType":"' + tipoTrabajadorConyuge + '",'+
                '"activityTypeId":"'+ tipoActividadConyuge + '",' +
                '"employerName":"'+ empleadorConyuge + '",' +
                '"workPhone":"'+ telefonoEmpleadorConyuge + '",' +
                '"combinedIncome":'+ conyugeSolicitud[0].Complementa_renta__c + ',' +
                '"salary":' + sueldoConyuge +
            '}';
        }else{
            conyuge = '{}';
        }

        //
        //      Arma JSON referencias
        //
        String referencia;
        if (referenciaSolicitud.size() != 0){
            for (Relacion__c refSolicitud : referenciaSolicitud){
                String referenciaApoyo;
                referenciaApoyo = '{'+
                            '"name":"' + refSolicitud.Nombre__c + '",' +
                            '"type":"' + refSolicitud.Tipo_de_relacion__c + '",' +
                            '"address":"' + refSolicitud.Direccion__c + '",' +
                            //'"address":"Calle 1234",' +
                            '"phone":"' + refSolicitud.Telefono__c + '"' +
                            '}';
                if(referenciaSolicitud.Size() > 1){
                    referencia = referencia + referenciaApoyo;
                
                }else{
                    referencia = referenciaApoyo;
            
                }
                }
                
        }else{
            referencia = '';
        }
        referencia = referencia.remove('null');
        System.debug('referencia->'+referencia);

        //
        //      Arma JSON compra para
        //
        String compraPara;
        if (compraParaSolicitud.size() != 0){

            String tempApellidosCompraPara = compraParaSolicitud[0].Cuenta__r.LastName;
            list<String> apellidosCP = tempApellidosCompraPara.split(' ',2);
            if (apellidosCP.size() == 1 ){
                apellidosCP.add(' ');
            }

            compraPara = '{'+
                    '"identificationTypeId":1,' +
                    '"identificationValue":"' + compraParaSolicitud[0].RUT__c + '",' +
                    '"name":"' + compraParaSolicitud[0].Cuenta__r.FirstName + '",' +
                    '"lastName":"' + apellidosCP[0] + '",' +
                    '"motherLastName":"' + apellidosCP[1] + '",' +
                    '"address":"' + compraParaSolicitud[0].Direccion__c + '",' +
                    '"geographicDataId":"' + compraParaSolicitud[0].Comuna__c + '",' +
                    //'"state":' + compraParaSolicitud[0].Region__c + ',' +
                    //'"city":" ",' +
                    //'"province":' + compraParaSolicitud[0].Comuna__c + ',' +
                    //Datetime.newInstance(d.year(), d.month(), d.day()).format('yyy-MM-dd')
                    '"dob":"' + Datetime.newInstance(compraParaSolicitud[0].Cuenta__r.PersonBirthdate.year(), compraParaSolicitud[0].Cuenta__r.PersonBirthdate.month(), compraParaSolicitud[0].Cuenta__r.PersonBirthdate.day()).format('yyy-MM-dd') + '",' +
                    '"nationalityId":"' + compraParaSolicitud[0].Cuenta__r.Nacionalidad__pc + '",' +
                    '"maritalStatus":"' + compraParaSolicitud[0].Estado_civil__c + '",' +
                    '"maritalRegime":"' + compraParaSolicitud[0].Regimen_matrimonial__c + '"' +
                '}';
        }else{
            compraPara = '{}';
        }

        //
        //      Arma JSON aval
        //
        String aval;
        if (avalSolicitud.size() != 0){

            for (integer avalCont = 0; avalCont < avalSolicitud.size(); avalCont++){

                String apellidosAval = avalSolicitud[avalCont].Cuenta__r.LastName;
                list<String> apellidosAV = apellidosAval.split(' ',2);
                if (apellidosAV.size() == 1 ){
                    apellidosAV.add(' ');
                }

                String avalApoyo;
                avalApoyo = '{'+
                        '"identificationTypeId":1,' +
                        '"identificationValue":"' + avalSolicitud[avalCont].RUT__c + '",' +
                        '"name":"' + avalSolicitud[avalCont].Cuenta__r.FirstName + '",' +
                        '"lastName":"' + apellidosAV[0] + '",' +
                        '"motherLastName":"' + apellidosAV[1] + '",' +
                        '"address":"' + avalSolicitud[avalCont].Direccion__c + '",' +
                        '"geographicDataId":"' + avalSolicitud[avalCont].Comuna__c + '",' +
                        '"dob":"' + Datetime.newInstance(avalSolicitud[avalCont].Cuenta__r.PersonBirthdate.year(), avalSolicitud[avalCont].Cuenta__r.PersonBirthdate.month(), avalSolicitud[avalCont].Cuenta__r.PersonBirthdate.day()).format('yyy-MM-dd') + '",' +
                        '"nationalityId":"' + avalSolicitud[avalCont].Cuenta__r.Nacionalidad__pc + '",' +
                        '"maritalStatus":"' + avalSolicitud[avalCont].Estado_civil__c + '",' +
                        '"maritalRegime":"' + avalSolicitud[avalCont].Regimen_matrimonial__c + '",' +
                        '"workType":"' + avalSolicitud[avalCont].Tipo_de_trabajador__c + '",' +
                        '"activityTypeId":"' + avalSolicitud[avalCont].Tipo_de_actividad__c + '",' +
                        '"salary":' + avalSolicitud[avalCont].Sueldo_liquido__c +
                    '}';
                
                if(avalSolicitud.Size() > 1){
                    
                    if(avalCont == 0){
                        aval = avalApoyo;
                    }else{
                        aval = aval + avalApoyo;
                    }
                }else{
                    aval = avalApoyo;
                }
            }
        }else{
            aval = '';
        }
        aval = aval.remove('null');
        System.debug('aval->'+aval);

        //
        //      Arma JSON patrimonios
        //
        String patrimonio;
        if (patrimonioSolicitud.size() != 0){

            for (integer i = 0; i < patrimonioSolicitud.size(); i++){
                String patrimonioApoyo;
                patrimonioApoyo = '{'+
                    '"type":"' + patrimonioSolicitud[i].Tipo__c + '",' +
                    '"description":"' + patrimonioSolicitud[i].Descripcion__c + '",' +
                    '"saleValue":' + patrimonioSolicitud[i].Valor_venta__c + ',' +
                    '"financing":"' + patrimonioSolicitud[i].Financiamiento__c + '",' +
                    '"stillPaying":' + patrimonioSolicitud[i].Con_deuda__c +
                '}';
                if(patrimonioSolicitud.Size() > 1){
                    if(i == 0){
                        patrimonio = patrimonioApoyo;
                    }else{
                        patrimonio = patrimonio + ',' + patrimonioApoyo;
                    }
                }else{
                    patrimonio = patrimonioApoyo;
                }
                
            }
        }else{
            patrimonio = '';
        }
        patrimonio = patrimonio.remove('null');
        System.debug('patrimonio->'+patrimonio);

        String impuesto;
        if (impuestoSolicitud.size() != 0){
            for (Impuesto__c impuestos : impuestoSolicitud){

                String impuestoApoyo;
                impuestoApoyo = '{'+
                                '"dateTax":"' + impuestos.Fecha__c + '",' +
                                '"purchaseTax":' + impuestos.Impuesto_compras__c + ',' +
                                '"salesTax":' + impuestos.Impuesto_ventas__c +
                                '}';
                
                if(impuestoSolicitud.Size() > 1){
                    impuesto = impuesto + ',' + impuestoApoyo;
                }else{
                    impuesto = impuestoApoyo;
                }
            }
        }else{
            impuesto = '';
        }
        impuesto = impuesto.remove('null');
        impuesto = impuesto.right(impuesto.length()-1);
        System.debug('impuestos->'+impuesto);

        String descripcionOtrosIngresos = solicitudSalesforce[0].Descripcion_otros_ingresos__c != null ? solicitudSalesforce[0].Descripcion_otros_ingresos__c:'';

        String jsonSolicitud = '{'+
                            '"stage": 0,' +
                            '"simulationId":"'+ solicitudSalesforce[0].Id_Solicitud__c + '",' +
                            '"sellerIdentificationValue":"'+ vendedorSolicitud[0].RUT__c + '",' +
                            '"amicarExecutiveIdentificationValue":"'+ usuarioSolicitud[0].RUT_F_I__c + '",' +
                            '"customer":{'+
                                '"identificationTypeId":'+ 1 + ',' + //*
                                '"identificationValue":"'+ rutsinguion + '",' + //*
                                '"documentSerialNumber":"'+ solicitudSalesforce[0].N_de_serie_C_I__c + '",' + //*
                                '"name":"'+ clienteSolicitud[0].FirstName + '",' + //*
                                '"lastName":"'+ apellidos[0] + '",' + //*
                                '"motherLastName":"'+ apellidos[1] + '",' + //*
                                '"email":"'+ clienteSolicitud[0].PersonEmail + '",' + //*
                                '"phone":"'+ clienteSolicitud[0].PersonMobilePhone + '",' + //*
                                '"address":"'+ solicitudSalesforce[0].Direccion__c + '",' + //*
                                '"dob":"'+ Datetime.newInstance(clienteSolicitud[0].PersonBirthdate.year(),clienteSolicitud[0].PersonBirthdate.month(),clienteSolicitud[0].PersonBirthdate.day()).format('yyy-MM-dd') + '",' + //*
                                '"nationality":"'+ clienteSolicitud[0].Nacionalidad__pc + '",' + //*
                                '"geographicDataId":"'+ solicitudSalesforce[0].Comuna__c + '",' +
                                '"gender":"'+ clienteSolicitud[0].Genero__pc + '"' + //*
                            '},'+
                            '"customerRequestData":{'+
                                '"maritalStatus":"'+ solicitudSalesforce[0].Estado_civil__c + '",' + //*
                                '"maritalRegime":"'+ solicitudSalesforce[0].Regimen_matrimonial__c + '",' + //*
                                '"academicLevel":"'+ solicitudSalesforce[0].Estudios__c + '",' + //*
                                '"livingHousehold":"'+ solicitudSalesforce[0].Tipo_de_residencia__c + '",' + //*
                                '"profession": "' + solicitudSalesforce[0].Tipo_de_residencia__c + '",' +
                                '"generalComments":""' +
                            '},'+
                            '"customerActivity":{'+
                                '"workType":"'+ solicitudSalesforce[0].Tipo_de_trabajador__c + '",' + //*
                                '"activityTypeId":"'+ solicitudSalesforce[0].Tipo_de_actividad__c + '",' + //*
                                '"workPosition":"'+ solicitudSalesforce[0].Cargo__c + '",' + //*
                                '"workEntryDate":"'+ Datetime.newInstance(solicitudSalesforce[0].Fecha_de_ingreso__c.year(), solicitudSalesforce[0].Fecha_de_ingreso__c.month(), solicitudSalesforce[0].Fecha_de_ingreso__c.day()).format('yyy-MM-dd') + '",' + //*
                                '"employerName":"'+ solicitudSalesforce[0].Empleador__c + '",' + //* (si tipo=dependiente)
                                '"employerIdentificationTypeId":'+ 1 + ',' +
                                '"employerIdentificationValue":"'+ solicitudSalesforce[0].RUT_empleador__c + '",' +
                                '"businessSectorId":"'+ solicitudSalesforce[0].Rubro_de_empleador__c + '",' + //*
                                '"workAddress":"'+ solicitudSalesforce[0].Direccion_empleador__c + '",' + //* (si tipo=dependiente)
                                '"workGeographicDataId":"'+ solicitudSalesforce[0].Comuna_empleador__c + '",' + //*
                                '"workPhone":"'+ solicitudSalesforce[0].Telefono_empleador__c + '",' + //*
                                '"employmentContractType":"'+ solicitudSalesforce[0].Tipo_de_contrato__c + '",' + //*
                                '"salaryType":"'+ solicitudSalesforce[0].Tipo_de_renta__c + '",' + //*
                                '"salaryPayday":0'+ //*
                            '},'+
                            '"income":{'+
                                '"salary":'+ solicitudSalesforce[0].Renta__c + ',' + //*
                                '"honorarium":0,' +
                                '"retirementSalary":0,' +
                                '"pensionSalary":0,' +
                                '"rentalIncome":0,' +
                                '"otherIncome":'+ solicitudSalesforce[0].Otros_ingresos__c + ',' +
                                '"descriptionForOtherIncome":"'+ descripcionOtrosIngresos + '"' +
                            '},'+
                            '"otherIncome":{'+
                                '"year":'+ 0 + ',' +
                                '"folioNumber":'+ 0 + ',' +
                                '"code18":'+ 0 + ',' +
                                '"code36":'+ 0 + ',' +
                                '"code158":'+ 0 + ',' +
                                '"code305":'+ 0 + ',' +
                                '"code611":'+ 0 + ',' +
                                '"code170":'+ 0 + ',' +
                                '"code25":'+ 0 + ',' +
                                '"code628":'+ 0 + ',' +
                                '"code636":'+ 0 + ',' +
                                '"code461":'+ 0 + ',' +
                                '"code545":'+ 0 + '' +
                            '},'+
                            '"expenses":{'+
                                '"mortgageCost":'+ solicitudSalesforce[0].Dividendo__c + ',' +
                                '"otherFixedExpenses":'+ solicitudSalesforce[0].Otros_egresos__c +
                            '},'+
                            '"taxReturn":[' + impuesto + '],' +
                            '"spouseData":' + conyuge + ','+
                            '"buyForAnother":' + compraPara + ','+
                            '"guarantor":[' + aval + '],'+
                            '"bankInformation":[' + bancoFinal + '],'+
                            '"heritage":[' + patrimonio + '],'+
                            '"personalReferences":[' + referencia + ']'+
                        '}';

        System.debug('json->'+jsonSolicitud);

        Id IdSolicitud = solicitudSalesforce[0].Id;
        envioServicio(jsonSolicitud,IdSolicitud);

        List<string> results = new List<string>();
        return results;
    }

    @future(callout=true)
    static void envioServicio(String jsonEnvio,Id ide){

        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id, URL__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'SimulacionFormalizada'];
        System.debug('endpoint->'+endpointSolicitudes[0].URL__c);

        List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                                     FROM API_Keys__mdt
                                     WHERE MasterLabel = 'Simulaciones'];

        // Generación request a servicio AMICAR
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointSolicitudes[0].URL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('x-api-key', apkey[0].APK__c);
        request.setTimeout(120000);
        request.setBody(jsonEnvio);
        System.debug('request setBody->'+request.getBody());
        System.debug('request->'+request);

        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(200);
            response.setStatus('OK');
        }

        System.debug('respuesta->'+response.getStatus()+' '+response.getBody());

        procesoRespuestaServicio(response.getStatusCode(),response.getBody(),ide);

    }

    static void procesoRespuestaServicio(Integer respuestaMetodoCode,String respuestaMetodoBody,Id ide){

        if (respuestaMetodoCode == 200){
            System.debug('ejecución correcta');

            Opportunity solicitud = [SELECT Id,Respuesta_Servicio__c,Formalizacion_OK__c FROM Opportunity WHERE Id =: ide];

            solicitud.Respuesta_Servicio__c = 'Ejecución correcta';
            //solicitud.StageName = 'Remate';
            solicitud.Formalizacion_OK__c = true;

            //Solicitud_Renovaciones_V2
            //Id rt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito V2').getRecordTypeId();
            //solicitud.RecordTypeId = rt;

            update solicitud;
        }else{
            System.debug('ejecución incorrecta');
            System.debug('Volver a etapa formalización');
            try{
                Opportunity solicitud = [SELECT Id,Respuesta_Servicio__c,Formalizacion_OK__c FROM Opportunity WHERE Id =: ide];
    
                solicitud.Respuesta_Servicio__c = 'ERROR'+ respuestaMetodoBody;
                solicitud.Formalizacion_OK__c = false;
                solicitud.StageName = 'Formalización';
                update solicitud;
            }catch(Exception ex){
                System.debug('ERROR AL VOLVER FORMALIZACIÓN');
                System.debug(ex.getMessage());
                System.debug(ex.getStackTraceString());
            }           
        }

    }
}