/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase invocable que llama servicio web "PUT" de assistance-insurance con parámetros en BODY
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 21-09-2020            RL                       Creación de la Clase.
1.1 
***********************************************************************************/

public class AMICAR_PutProductosChecklistBody  {
    @InvocableMethod(label='Envia servicio PUT assistance-insurance Body' description='Envia servicio PUT assistance-insurance con parámetros')
    public static void InvocaServicioPutBody(List<FlowInputs> inputParams) {
        String jsonPut = '';
        String idSol = '';
        String idSolicitud = '';    
        String familiaOrigen = inputParams[0].familiaUpd;
        Boolean isSelected = inputParams[0].seleccionado;
        OpportunityLineItem tmpOppli = new OpportunityLineItem();
        tmpOppli = inputParams[0].oppli;
        List<OpportunityLineItem> opl;
        Remate__c remateTmp;
        system.debug(inputParams);
        
        
        if(tmpOppli != null){
            opl= [SELECT Id, OpportunityId
                                        FROM OpportunityLineItem
                                        WHERE Id =: inputParams[0].oppli.id];
        }else{
            remateTmp = [Select Id, Solicitud__c from Remate__c where Id=: inputParams[0].remate.id];
            opl = [SELECT Id, OpportunityId
                                        FROM OpportunityLineItem
                                        WHERE OpportunityId =: remateTmp.Solicitud__c];
        }
        
       //WHERE Id IN: inputParams.oppli.id
        List<Opportunity> solicitud= [SELECT Id, Id_Solicitud__c,
                                    OwnerId, Name
                                    FROM Opportunity
                                    WHERE Id =: opl[0].OpportunityId];
        if(solicitud.size() > 0){
            idSol = solicitud[0].Id;
            idSolicitud = solicitud[0].Id_Solicitud__c;
            String familia = 'amicarAssistance';
            List<OpportunityLineItem> productosAssistance = [SELECT Id, OpportunityId, 
                                                    ProductCode, Seleccionado__c, 
                                                    Value__c 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId =: idSol
                                                    AND Product2.Family =: familia]; 
                                                 
                                                        
            familia = 'financingEntityInsurance';
            system.debug(idSol);
            system.debug(familia);
            //system.debug(inputParams[0].oppli.id);
            List<OpportunityLineItem> productosInsurance = [SELECT Id, OpportunityId, 
                                                    ProductCode, Seleccionado__c, 
                                                    Value__c 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId =: idSol
                                                    AND Product2.Family =: familia];
                                             
            System.debug('PRODUCTOS AMICAR ASSISTANCE');
            System.debug(productosAssistance);

            System.debug('PRODUCTOS AMICAR INSURANCE');
            System.debug(productosInsurance);
          
            if(productosAssistance.size() > 0 || productosInsurance.size() > 0){
                jsonPut = '{';
                if(productosAssistance.size() > 0){
                    String jsonAsistencia = '"amicarAssistance": [';
                    String datosJsonPut = '';
                    for(OpportunityLineItem oli : productosAssistance){
                        datosJsonPut += '{';
                        datosJsonPut += '"id":'+oli.ProductCode+',';
                        datosJsonPut += '"value":'+Integer.valueOf(oli.Value__c) +',';
                        if(oli.Seleccionado__c){
                            datosJsonPut += '"selected":true';
                        }else{
                            datosJsonPut += '"selected":false';
                        }
                        datosJsonPut += '},';
                    }
                    
                    datosJsonPut = datosJsonPut.substring(0, datosJsonPut.length()-1);
                    if(productosInsurance.size() > 0){
                        jsonAsistencia +=datosJsonPut+'],';
                    }else{
                        jsonAsistencia +=datosJsonPut+']';
                    }
                    jsonPut += jsonAsistencia;
                }

                if(productosInsurance.size() > 0){
                    String jsonInsurance = '"financingEntityInsurance": [';
                    String datosJsonPut = '';
                    for(OpportunityLineItem oli : productosInsurance){
                        datosJsonPut += '{';
                        datosJsonPut += '"id":'+oli.ProductCode+',';
                        datosJsonPut += '"value":'+Integer.valueOf(oli.Value__c) +',';
                        if(oli.Seleccionado__c){
                            datosJsonPut += '"selected":true';
                        }else{
                            datosJsonPut += '"selected":false';
                        }
                        datosJsonPut += '},';
                    }
                    
                    datosJsonPut = datosJsonPut.substring(0, datosJsonPut.length()-1);
                    jsonInsurance +=datosJsonPut+']';
                    jsonPut += jsonInsurance;
                }else{
                    if(familiaOrigen == 'financingEntityInsurance'){
                        String jsonInsurance = '"financingEntityInsurance": [';
                        String datosJsonPut = '';
                        datosJsonPut += '{';
                        datosJsonPut += '"id":'+inputParams[0].oppli.ProductCode+',';
                        datosJsonPut += '"value":'+Integer.valueOf(inputParams[0].oppli.Value__c) +',';
                        if(inputParams[0].oppli.Seleccionado__c){
                            datosJsonPut += '"selected":true';
                        }else{
                            datosJsonPut += '"selected":false';
                        }
                        datosJsonPut += '}';
                        jsonInsurance +=datosJsonPut+']';
                        jsonPut += jsonInsurance;

                    }
                }

                jsonPut += '}';
            }
            System.debug('JSON PARA PUT');
            System.debug(jsonPut);
      
      
            if(String.isNotBlank(jsonPut)){
                if (shouldProcessAsync()){
                    llamarServicioAmicarAssistanceInsurancePutBody(jsonPut, idSolicitud, idSol);
                } 
            }
        }   
    }
    
    public class FlowInputs{
    
        @InvocableVariable
        public OpportunityLineItem oppli;
        
        @InvocableVariable
        public Remate__c remate;
        
        @InvocableVariable
        public Boolean seleccionado;
        
        @InvocableVariable
        public String familiaUpd;
        
    }
    
    @future(callout=true)
    static void llamarServicioAmicarAssistanceInsurancePutBody(String jsonPut, String idSolicitud, String idRegistroSolicitud){
        Transient String responseWs;
        Transient AMICAR_ChecklistPutJSON jsonR;
        String tablaDesarrollo;
        String urlEndpoint;
        String metodo;
        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id,URL__c,Metodo__c 
                                                            FROM AMICAR_Integracion__mdt 
                                                            WHERE MasterLabel = 'amicarAssistanceInsurance'];
        //ya que testing aún no está implementada... por ahora va la url de staging
        System.debug('Endpoint = '+endpointSolicitudes[0].URL__c);
        urlEndpoint = endpointSolicitudes[0].URL__c;
        List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                                    FROM API_Keys__mdt
                                    WHERE MasterLabel = 'Simulaciones'];


        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointSolicitudes[0].URL__c + idSolicitud);
        req.setMethod(endpointSolicitudes[0].Metodo__c);
        req.setHeader('Content-Type', 'application/json');
        req.setTimeOut(120000);
        req.setHeader('x-api-key', apkey[0].APK__c);
        req.setBody(jsonPut);
        System.debug('Request');
        System.debug(req);
        System.debug('Body');
        System.debug(jsonPut);

        HttpResponse res = new HttpResponse();
        if(Test.isRunningTest()){
			res.setStatusCode(200);
			res.setBody('{\n'						
			+'"simulationId": 10000001,\n'
			+'"finalLoanValues": {\n'
			+'"loanType": "CONVENTIONAL",\n'
			+'"rateType": "CONVENTIONAL_NORMAL",\n'
			+'"term": 24,\n'
			+'"balance": 3000000,\n'
			+'"downPaymentPercentage": 13.23,\n'
			+'"UFValue": 28399.15,\n'
			+'"totalSurchargesToMAF": 360000,\n'
			+'"totalSurchargesToQuote": 0,\n'
			+'"factorTotal": 0.944,\n'
			+'"promissoryFactor": 0.008,\n'
			+'"promissoryValue": 28475,\n'
			+'"totalToFinance": 3559322,\n'
			+'"totalToFinanceUF": 125.33,\n'
			+'"finalCapital": 3638339,\n'
			+'"daysDelayedFirstDue": 60,\n'
			+'"delayedInterest": 79017,\n'
			+'"monthlyPayment": 147834,\n'
			+'"customerRate": 2.22,\n'
			+'"dealerRate": 2.12,\n'
			+'"dealerCommission": 323694,\n'
			+'"amicarCommission": 794932\n'
			+'},\n'
			+'"equivalentAnnualCharge": {\n'
			+'"annualCAE": 41.99,\n'
			+'"monthlyCAE": 3.5,\n'
			+'"totalLoanCost": 5322030\n'
			+'},\n'
			+'"amortizationSchedule": [\n'
			+'{\n'
			+'	"paymentNumber": 1,\n'
			+'	"expirationDate": "2020-03-02",\n'
			+'	"daysBetweenExpirationsDates": 31,\n'
			+'	"payment": 147834,\n'
			+'	"beginningBalance": 3638339,\n'
			+'	"principal": 67063,\n'
			+'	"interest": 80771,\n'
			+'	"endingBalance": 3571276,\n'
			+'	"cumulativeInterest": 80771\n'
			+'}\n'
			+'],\n'
			+'"surchargesAndInsurances": {\n'
			+'"dealerSurcharges": [\n'
			+'	{\n'
			+'	"id": 1,\n'
			+'	"description": "Inscripción",\n'
			+'	"value": 0,\n'
			+'	"isEditable": true,\n'
			+'	"currencyType": "CLP",\n'
			+'	"factorCalculated": 24332,\n'
			+'	"selected": true,\n'
			+'	"isRequired": false\n'
			+'	}\n'
			+'],\n'
			+'"financingEntitySurcharges": [\n'
			+'	{\n'
			+'	"id": 50,\n'
			+'	"description": "GASTOS OPERACIONALES",\n'
			+'	"value": 360000,\n'
			+'	"isEditable": false,\n'
			+'	"currencyType": "CLP",\n'
			+'	"factorCalculated": 360000,\n'
			+'	"selected": true,\n'
			+'	"isRequired": true\n'
			+'	}\n'
			+'],\n'
			+'"dealerInsurance": [\n'
			+'	{\n'
			+'	"id": 41,\n'
			+'	"description": "SEGURO VEHÍCULO",\n'
			+'	"value": 3,\n'
			+'	"isEditable": false,\n'
			+'	"currencyType": "UF",\n'
			+'	"factorCalculated": 85391.01,\n'
			+'	"selected": true,\n'
			+'	"isRequired": true\n'
			+'	}\n'
			+'],\n'
			+'"financingEntityInsurance": [\n'
			+'	{\n'
			+'	"id": 3,\n'
			+'	"description": "DESGRAVAMEN",\n'
			+'	"value": 48,\n'
			+'	"currencyType": "CLP",\n'
			+'	"factorCalculated": 170847,\n'
			+'	"selected": true,\n'
			+'	"isRequired": true\n'
			+'	}\n'
			+'],\n'
			+'"amicarAssistance": [\n'
			+'	{\n'
			+'	"id": 3,\n'
			+'	"description": "Car Assist",\n'
			+'	"value": 3490,\n'
			+'	"currencyType": "CLP",\n'
			+'	"factorCalculated": 3490,\n'
			+'	"selected": false,\n'
			+'	"isRequired": false\n'
			+'	}\n'
			+']\n'
			+'}\n'
			+'}');
		}else{
			res = h.send(req);
		}

        try{        
            if (res.getStatusCode() == 200){
                responseWs = res.getBody();
            }
            else{
                System.debug('ERROR EN LA LLAMADA');
                System.debug('Servicio = '+urlEndpoint+idSolicitud);
                System.debug('Código de Status del Request = '+res.getStatusCode());
                System.debug('Status del Request = '+res.getStatus());
                responseWs = 'ERROR';
            }
        }catch(Exception ex){
            System.debug('ERROR');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            responseWs = 'ERROR';
        }

        try{
            if(responseWs != 'ERROR'){
                jsonR = (AMICAR_ChecklistPutJSON) System.JSON.deserialize(responseWs, AMICAR_ChecklistPutJSON.class);
                System.debug('RESPUESTA');
                System.debug(jsonR);
                System.debug(jsonR.finalLoanValues);
            }
        }catch(Exception ex){
            System.debug('ERROR');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }

        if(responseWs != 'ERROR'){
            updateOportunidad(idRegistroSolicitud, jsonR);
        }
    }

    static void updateOportunidad(String idRegistroSolicitud, AMICAR_ChecklistPutJSON jsonR){
        Opportunity actualizaOportunidad = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE Id =: idRegistroSolicitud];

        actualizaOportunidad.Valor_UF__c = jsonR.finalLoanValues.UFValue;
        actualizaOportunidad.Tasa__c = jsonR.finalLoanValues.customerRate;
        actualizaOportunidad.Valor_Cuota__c = jsonR.finalLoanValues.monthlyPayment;
        actualizaOportunidad.CAE__c = jsonR.equivalentAnnualCharge.annualCAE;
        actualizaOportunidad.Comision_dealer__c = jsonR.finalLoanValues.dealerCommission;
        actualizaOportunidad.Costo_total_credito__c = jsonR.equivalentAnnualCharge.totalLoanCost;
        actualizaOportunidad.Total_a_financiar__c = jsonR.finalLoanValues.totalToFinance;
        actualizaOportunidad.Capital_final__c = jsonR.finalLoanValues.finalCapital;
        //actualizaOportunidad.Respuesta_Servicio__c = 'OK';

        update actualizaOportunidad;
        
        Quote updQuote = [Select id, Valor_cuota__c from Quote where Id =: actualizaOportunidad.SyncedQuoteId];
        updQuote.Valor_cuota__c = jsonR.finalLoanValues.monthlyPayment;
        update updQuote;

     }
    
    static Boolean shouldProcessAsync(){
        return !system.isFuture() && !system.isBatch() && Limits.getLimitFutureCalls() > Limits.getFutureCalls();
    }
}