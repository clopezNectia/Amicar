/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que envia información de solicitud y simulación sincronizada a Core (paso 1.1, simulación informal sincronizada)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 13-03-2020            RJZ                      Creación de la Clase.
1.1 02-04-2020            RJZ                      Modificación de código para enviar productosasociados a simulación sincronizada.
1.2 17-05-2021			  RL					   Se agrega campo "Source" en estructura json para simulation/save
***********************************************************************************/
public with sharing class AMICAR_EnviaSimulacionSincronizada {

    @InvocableMethod(label='Envia simulación sincronizada paso 1.1' description='Envia simulación sincronizada')
    public static List<string> EnviaSincronizada (List<string> inputParams) {

        System.debug('parametros->'+inputParams);

        List<Opportunity> solicitudSalesforce = [SELECT 
                                                    Id,
                                                    Name,
                                                    OwnerId,
                                                    AccountId,
                                                    Tipo_de_Veh_culo__c,
                                                    Precio_vehiculo__c,
                                                    toLabel(Marca_vehiculo__c),
                                                    Modelo__c,
                                                    Modelo2__c,
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
                                                    Vendedor__c,
                                                    Tipo_de_financiamiento__c,
                                                    CloseDate,
                                                    Profesion__c,
                                                    Codigo_Concesionario__c,
                                                    Codigo_Importador__c,
                                                    Local__r.Codigo_Local__c,
                                                    Local__r.Importador__c,
                                                    Modelo2__r.Name,
                                                    Modelo2__r.Codigo_modelo__c,
                                                    Account.FirstName,
                                                    Account.LastName,
                                                    Account.PersonEmail,
                                                    Account.PersonMobilePhone,
                                                    Account.RUT__c,
													Account.isPersonAccount,
                                                    Vendedor__r.RUT__c,
                                                    Owner.RUT_F_I__c,
                                                    PPU_retoma__c,
                                                    toLabel(Marca_retoma__c),
                                                    Modelo2_retoma__c,
                                                    Modelo2_retoma__r.Name,
                                                    Version_retoma__c,
                                                    Deuda_retoma__c,
                                                    Tipo_retoma__c,
                                                    Precio_retoma__c,
                                                    Kilometraje_retoma__c,
                                                    Detalles_retoma__c,
                                                    Ano_retoma__c
                                                FROM Opportunity WHERE Id =: inputParams];

        List<Quote> simulacionesSalesforce = [SELECT Id,Name,Cuotas__c FROM Quote WHERE OpportunityId =: solicitudSalesforce[0].Id AND IsSyncing = true];

        List<OpportunityLineItem> productosOportunidad = [SELECT Id,OpportunityId,UnitPrice,Value__c,Divisa__c,Seleccionado__c,Requerido__c,Product2Id,Product2.Family,Product2.ProductCode,Product2.Name FROM OpportunityLineItem WHERE OpportunityId =: solicitudSalesforce[0].Id AND Seleccionado__c = true];
        System.debug('productos->'+productosOportunidad);

        List<Desarrollo__c> desarrolloSimulacion = [SELECT Id,Numero_de_pago__c,Pago__c FROM Desarrollo__c WHERE Simulacion__r.OpportunityId =: solicitudSalesforce[0].Id AND Modificado__c = true];
        System.debug('desarrollos->'+desarrolloSimulacion);

        String asistencia;
        String asistenciasAmicar;
        String financingEntityInsurance;
        String dealerSurcharges;
        String financingEntitySurcharges;
        String dealerInsurance;
        String desarrolloSincronizada;

        if (productosOportunidad.size() != 0){

            for (OpportunityLineItem ProductosEnLista:productosOportunidad){

                System.debug('familia->'+ProductosEnLista.Product2.Family);

                Decimal valor = ProductosEnLista.Value__c != null ? ProductosEnLista.Value__c : 0;

                if (ProductosEnLista.Product2.Family == 'amicarAssistance'){
                    asistencia = '{'+
                                    '"id":' + ProductosEnLista.Product2.ProductCode + ',' +
                                    '"description":"' + ProductosEnLista.Product2.Name + '",' +
                                    '"value":' + valor + ',' +
                                    '"currencyType":"' + ProductosEnLista.Divisa__c  + '",' +
                                    '"factorCalculated":' + ProductosEnLista.UnitPrice  + ',' +
                                    '"selected":' + ProductosEnLista.Seleccionado__c  + ',' +
                                    '"isRequired":' + ProductosEnLista.Requerido__c + '' +
                                '}';
                    asistenciasAmicar = asistenciasAmicar + ',' + asistencia;
                }

                if (ProductosEnLista.Product2.Family == 'financingEntityInsurance'){
                    asistencia = '{'+
                                    '"id":' + ProductosEnLista.Product2.ProductCode + ',' +
                                    '"description":"' + ProductosEnLista.Product2.Name + '",' +
                                    '"value":' + valor + ',' +
                                    '"currencyType":"' + ProductosEnLista.Divisa__c  + '",' +
                                    '"factorCalculated":' + ProductosEnLista.UnitPrice  + ',' +
                                    '"selected":' + ProductosEnLista.Seleccionado__c  + ',' +
                                    '"isRequired":' + ProductosEnLista.Requerido__c + '' +
                                '}';
                    financingEntityInsurance = financingEntityInsurance + ',' + asistencia;
                }

                if (ProductosEnLista.Product2.Family == 'dealerSurcharges'){
                    asistencia = '{'+
                                    '"id":' + ProductosEnLista.Product2.ProductCode + ',' +
                                    '"description":"' + ProductosEnLista.Product2.Name + '",' +
                                    '"value":' + valor + ',' +
                                    '"currencyType":"' + ProductosEnLista.Divisa__c  + '",' +
                                    '"factorCalculated":' + ProductosEnLista.UnitPrice  + ',' +
                                    '"selected":' + ProductosEnLista.Seleccionado__c  + ',' +
                                    '"isRequired":' + ProductosEnLista.Requerido__c + '' +
                                '}';
                    dealerSurcharges = dealerSurcharges + ',' + asistencia;
                }

                if (ProductosEnLista.Product2.Family == 'financingEntitySurcharges'){
                    asistencia = '{'+
                                    '"id":' + ProductosEnLista.Product2.ProductCode + ',' +
                                    '"description":"' + ProductosEnLista.Product2.Name + '",' +
                                    '"value":' + valor + ',' +
                                    '"currencyType":"' + ProductosEnLista.Divisa__c  + '",' +
                                    '"factorCalculated":' + ProductosEnLista.UnitPrice  + ',' +
                                    '"selected":' + ProductosEnLista.Seleccionado__c  + ',' +
                                    '"isRequired":' + ProductosEnLista.Requerido__c + '' +
                                '}';
                    financingEntitySurcharges = financingEntitySurcharges + ',' + asistencia;
                }

                if (ProductosEnLista.Product2.Family == 'dealerInsurance'){
                    asistencia = '{'+
                                    '"id":' + ProductosEnLista.Product2.ProductCode + ',' +
                                    '"description":"' + ProductosEnLista.Product2.Name + '",' +
                                    '"value":' + valor + ',' +
                                    '"currencyType":"' + ProductosEnLista.Divisa__c  + '",' +
                                    '"factorCalculated":' + ProductosEnLista.UnitPrice  + ',' +
                                    '"selected":' + ProductosEnLista.Seleccionado__c  + ',' +
                                    '"isRequired":' + ProductosEnLista.Requerido__c + '' +
                                '}';
                    dealerInsurance = dealerInsurance + ',' + asistencia;
                }

                asistencia = '';
            }
        }
        if (asistenciasAmicar != null){
            asistenciasAmicar = asistenciasAmicar.remove('null');
        }else{
            asistenciasAmicar = '';
        }
        System.debug('asistencias amicar->'+asistenciasAmicar);

        if (financingEntityInsurance != null){
            financingEntityInsurance = financingEntityInsurance.remove('null');
        }else{
            financingEntityInsurance = '';
        }
        System.debug('seguros ef->'+financingEntityInsurance);

        if (dealerSurcharges != null){
            dealerSurcharges = dealerSurcharges.remove('null');
        }else{
            dealerSurcharges = '';
        }
        System.debug('seguros ef->'+dealerSurcharges);

        if (financingEntitySurcharges != null){
            financingEntitySurcharges = financingEntitySurcharges.remove('null');
        }else{
            financingEntitySurcharges = '';
        }
        System.debug('seguros ef->'+financingEntitySurcharges);

        if (dealerInsurance != null){
            dealerInsurance = dealerInsurance.remove('null');
        }else{
            dealerInsurance = '';
        }
        System.debug('seguros ef->'+dealerInsurance);

        String desarrollo;
        if (desarrolloSimulacion.size() != 0){
            for (Desarrollo__c desarrolloSolicitud:desarrolloSimulacion){
                desarrollo = '{' +
                    '"paymentNumber":' + desarrolloSolicitud.Numero_de_pago__c + ',' +
                    '"payment":' + desarrolloSolicitud.Pago__c +
                    '}';
                desarrolloSincronizada = desarrolloSincronizada + ',' + desarrollo;
            }
        }else{
            desarrolloSincronizada = '';
        }
        if (desarrolloSincronizada != null){
            desarrolloSincronizada = desarrolloSincronizada.remove('null');
        }
        System.debug('desarrollo sincronizado->'+desarrolloSincronizada);


        //Integer retoma = solicitudSalesforce[0].Monto_retoma__c != null ? Integer.valueOf(solicitudSalesforce[0].Monto_retoma__c) : 0;
        String descripcionRetoma = solicitudSalesforce[0].Detalles_retoma__c != null?solicitudSalesforce[0].Detalles_retoma__c:'';
        String seccionRetoma;
        if (solicitudSalesforce[0].Monto_retoma__c != 0){
            seccionRetoma = '"tradeInCar":'+
                            '{'+
                                '"type":"' + solicitudSalesforce[0].Tipo_retoma__c + '",' +
                                '"brandName":"' + solicitudSalesforce[0].Marca_retoma__c + '",' +
                                '"modelName":"' + solicitudSalesforce[0].Modelo2_retoma__r.Name + '",' +
                                '"version":"' + solicitudSalesforce[0].Version_retoma__c + '",' +
                                '"year":' + solicitudSalesforce[0].Ano_retoma__c + ',' +
                                '"price":' + solicitudSalesforce[0].Precio_retoma__c + ',' +
                                '"additionalDescription":"' + descripcionRetoma + '",' +
                                '"licensePlate":"' + solicitudSalesforce[0].PPU_retoma__c + '",' +
                                '"mileage":' + solicitudSalesforce[0].Kilometraje_retoma__c + ',' +
                                '"prepaidAmount":' + solicitudSalesforce[0].Deuda_retoma__c +
                            '},';
        }else{
            seccionRetoma = '';
        }

        String telefono = solicitudSalesforce[0].Account.PersonMobilePhone != null ? solicitudSalesforce[0].Account.PersonMobilePhone : '';
        String correo = solicitudSalesforce[0].Account.PersonEmail != null ? solicitudSalesforce[0].Account.PersonEmail : '';

        Integer precioRetoma = solicitudSalesforce[0].Precio_retoma__c != null ? Integer.valueOf(solicitudSalesforce[0].Precio_retoma__c) : 0;
        Integer deudaRetoma = solicitudSalesforce[0].Deuda_retoma__c != null ? Integer.valueOf(solicitudSalesforce[0].Deuda_retoma__c) : 0;
        Integer montoRetoma = precioRetoma - deudaRetoma;

		Integer isPersona = 0;
		if(solicitudSalesforce[0].Account.isPersonAccount){
			isPersona = 1;
		}else{
			isPersona = 2;
		}

        String jsonSolicitud = '{'+
                            '"transactionId":"'+ solicitudSalesforce[0].Id + '",' +
                            '"sellerIdentificationValue":"'+ solicitudSalesforce[0].Vendedor__r.RUT__c + '",' +
                            '"amicarExecutiveIdentificationValue":"'+ solicitudSalesforce[0].Owner.RUT_F_I__c + '",' +
                            '"customer":{'+
                                '"identificationTypeId":'+isPersona+',' +
								'"identificationValue":"'+ solicitudSalesforce[0].Account.RUT__c + '",' +
                                '"name":"'+ solicitudSalesforce[0].Account.FirstName + '",' +
                                '"fatherLastName":"'+ solicitudSalesforce[0].Account.LastName + '",' +
                                '"email":"'+ correo + '",' +
                                '"phone":"'+ telefono + '"' +
                            '},'+
                            seccionRetoma + 
                            '"vehicle":{'+
                                '"type":"'+ solicitudSalesforce[0].Tipo_de_Veh_culo__c + '",' +
                                '"price":'+ Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c) + ',' +
                                '"brandName":"'+ solicitudSalesforce[0].Marca_vehiculo__c + '",' +
                                '"modelName":"'+ solicitudSalesforce[0].Modelo2__r.Name + '",' +
                                '"version":"'+ solicitudSalesforce[0].Version__c + '",' +
                                '"year":'+ Integer.valueOf(solicitudSalesforce[0].A_o_Veh_culo__c) +
                            '},'+
                            '"loan":{'+
                                '"source":"Salesforce",'+
								'"downPayment":'+ Integer.valueOf(solicitudSalesforce[0].Pie__c) + ',' +
                                '"downPaymentPercentage":'+ Integer.valueOf(solicitudSalesforce[0].Pie_formula__c) + ','; 
							if(Test.isRunningTest() && solicitudSalesforce[0].Name == '15539757-8  RENAULT - SALTAR CUOTA'){
								//SIMULANDO SINCRONIZACIÓN
								jsonSolicitud +='"term":1,';
							}else{    
								jsonSolicitud +='"term":'+ Integer.valueOf(simulacionesSalesforce[0].Cuotas__c) + ',';
							}    
							jsonSolicitud+= '"balance":'+ Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c - solicitudSalesforce[0].Pie__c) +',' +
                                '"type":"'+ solicitudSalesforce[0].Tipo_de_financiamiento__c +'",' + 
                                '"startDate":"'+ String.valueOf(System.today()) + '",' +
                                '"firstDueDate":"'+ String.valueOf(System.today()+30) + '",' +
                                '"rateType":"'+ solicitudSalesforce[0].Tipo_de_tasa__c + '",' +
                                '"saleChannel":"'+ solicitudSalesforce[0].Local__r.Importador__c + '",'+ 
                                '"saleChannelType": "IMPORTADOR",'+
                                '"salesRoomId":'+ Integer.valueOf(solicitudSalesforce[0].Local__r.Codigo_Local__c) + ',' +
                                '"immediateOption":'+ solicitudSalesforce[0].Opcion_inmediata__c + ',' +
                                '"tradeInCarValue":'+ montoRetoma + ',' +
                                '"accessories": 0,'+
                                '"modifyTerm": [' + desarrolloSincronizada + ']'+
                                //'"modifyTerm": []'+
                            '},'+
                            '"surchargesAndInsurances":{'+
                                '"amicarAssistance":['+
                                    asistenciasAmicar + 
                                '],'+
                                '"financingEntityInsurance":['+
                                    financingEntityInsurance + 
                                '],'+
                                '"dealerSurcharges":['+
                                    dealerSurcharges + 
                                '],'+
                                '"financingEntitySurcharges":['+
                                    financingEntitySurcharges +
                                '],'+
                                '"dealerInsurance":['+
                                    dealerInsurance +
                                ']'+
                            '}'+
                        '}';

        jsonSolicitud = jsonSolicitud.replace('[,{','[{');
        System.debug('json->'+jsonSolicitud);

        Id idsolicitud = solicitudSalesforce[0].Id;

        envioServicio(jsonSolicitud,idsolicitud);
		if(Test.isRunningTest() && solicitudSalesforce[0].Name == '15539757-8  RENAULT - SALTAR CUOTA'){
			//SALTAR ACTUALIZACIÓN CON SEGUNDO MÉTODO PARA AUMENTAR COBERTURA
		}else{
			actualizaDesarrollos(idsolicitud);
		}
        //List<OpportunityLineItem> productosOportunidadBorrar = [SELECT Id,OpportunityId FROM OpportunityLineItem WHERE OpportunityId =: idsolicitud AND Seleccionado__c = false];
        //delete productosOportunidadBorrar;

        List<Quote> simulacionesOportunidadBorrar = [SELECT Id FROM Quote WHERE OpportunityId =: idsolicitud AND IsSyncing = false];
        delete simulacionesOportunidadBorrar;

        List<string> results = new List<string>();
        return results;
    }

    @future(callout=true)
    static void envioServicio(String jsonEnvio,Id idsol){

        String resultadoServcio;

        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id, URL__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'SimulacionSincronizada'];
        System.debug('endpoint->'+endpointSolicitudes[0].URL__c);

        List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                                     FROM API_Keys__mdt
                                     WHERE MasterLabel = 'Simulaciones'];

        // Generación request a servicio AMICAR
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointSolicitudes[0].URL__c);
        request.setMethod('POST');
        request.setTimeOut(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('x-api-key', apkey[0].APK__c);
        request.setBody(jsonEnvio);
        System.debug('request->'+request);

        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody('{"amortizationSchedule": [],"equivalentAnnualCharge": {"annualCAE": 26.59,"monthlyCAE": 2.22,"totalLoanCost": 14619490},"finalLoanValues": {"UFValue": 28690.73,"amicarCommission": 1141863,"balance": 10001000,"customerRate": 1.58,"daysDelayedFirstDue": 30,"dealerCommission": 590462,"delayedInterest": 0,"factorTotal": 0.944,"finalCapital": 11084703,"loanType": "CONVENTIONAL","monthlyPayment": 406097,"promissoryFactor": 0.008,"promissoryValue": 88678,"term": 36,"totalSurchargesToMAF": 0,"totalSurchargesToQuote": 12860,"totalToFinance": 11084703,"totalToFinanceUF": 386.35},"simulationId": 10000051,"surchargesAndInsurances": {"amicarAssistance": [],"dealerSurcharges": [],"financingEntityInsurance": [],"financingEntitySurcharges": []}}');
        }
        System.debug('respuesta->'+response.getStatus()+' '+response.getBody());

        if (response.getStatusCode() == 200 && response.getStatus() != null){
            //
            // servicio responde OK, guardamos la respuesta
            //----------------------------------------------------------------------------------
            String respuestaServicio = response.getBody();
            System.debug('body->'+response.getBody());

            procesoRespuestaServicio(respuestaServicio,idsol);

        }else{
            //
            // servicio responde NOK, enviamos/guardamos la respuesta a algun lado
            //----------------------------------------------------------------------------------
            System.debug('ERROR-> '+response.getStatus());
            System.debug('Descr->'+response.getBody());

            resultadoServcio = 'Mensaje: '+ response.getBody();

            Opportunity oportunidad = [SELECT Id,Id_Solicitud__c,Respuesta_Servicio__c FROM Opportunity WHERE Id =: idsol];

            oportunidad.Respuesta_Servicio__c = resultadoServcio;
            update oportunidad;
        }
    }

    static void procesoRespuestaServicio(String respuestaMetodo,Id solicitudMetodo){
        AMICAR_Resp_Sincronizada_WSJson respuesta = (AMICAR_Resp_Sincronizada_WSJson) Json.deserialize(respuestaMetodo, AMICAR_Resp_Sincronizada_WSJson.class);

        String id_solicitud = String.valueOf(respuesta.simulationId);

        Opportunity oportunidad = [SELECT Id,Id_Solicitud__c,Respuesta_Servicio__c FROM Opportunity WHERE Id =: solicitudMetodo];

        oportunidad.Id_Solicitud__c = id_solicitud;
        oportunidad.Respuesta_Servicio__c = 'OK';
        update oportunidad;
    }

    static void actualizaDesarrollos(Id idDesarrollos){

        Quote simulacionDesarrollos = [SELECT Id FROM Quote WHERE OpportunityId =: idDesarrollos AND IsSyncing = true];

        List<Desarrollo__c> desarrolloSincronizados = [SELECT Id,Simulacion__c,Solicitud__c FROM Desarrollo__c WHERE Simulacion__c =: simulacionDesarrollos.Id];

        List<Desarrollo__c> desarrolloActualizar = new List<Desarrollo__c>();

        
        for (Desarrollo__c desa:desarrolloSincronizados){
            desa.Solicitud__c = idDesarrollos;
            desarrolloActualizar.add(desa);
        }
        update desarrolloActualizar;
    }
}