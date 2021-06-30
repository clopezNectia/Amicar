/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que envia información de solicitud formalizada para que el Core la envíe a remate
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 27-07-2020            RJZ                      Creación de la Clase.
***********************************************************************************/
public class AMICAR_EnviaSimulacionRemate {


    @InvocableMethod(label='Envia simulación aremate' description='Envia simulación a remate')
    public static List<string> EnviaARemate (List<string> inputParams) {
        List<Opportunity> solicitudSalesforce = [SELECT 
                                                    Id,
                                                    Id_Solicitud__c,
                                                    Owner.RUT_F_I__c,
                                                    Vendedor__r.RUT__c
                                                FROM Opportunity WHERE Id =: inputParams];

        String jsonSolicitud = '{'+
                            '"sellerIdentificationValue":"'+ solicitudSalesforce[0].Vendedor__r.RUT__c + '",' +
                            '"amicarExecutiveIdentificationValue":"'+ solicitudSalesforce[0].Owner.RUT_F_I__c + '"' +
                            '}';
        System.debug('json->'+jsonSolicitud);

        String IdSolicitud = solicitudSalesforce[0].Id_Solicitud__c;
        envioServicio(jsonSolicitud,IdSolicitud);

        List<string> results = new List<string>();
        return results;
    }

    @future(callout=true)
    static void envioServicio(String jsonEnvio,String ide){

        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id, URL__c, Metodo__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'SimulacionARemate'];
        System.debug('endpoint->'+endpointSolicitudes[0].URL__c);

        List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                                     FROM API_Keys__mdt
                                     WHERE MasterLabel = 'Simulaciones'];

        String url = endpointSolicitudes[0].URL__c + ide;

        // Generación request a servicio AMICAR
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setTimeout(120000);
        request.setMethod(endpointSolicitudes[0].Metodo__c);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('x-api-key', apkey[0].APK__c);
        request.setBody(jsonEnvio);
        System.debug('request setBody->'+request.getBody());
        System.debug('request->'+request);

        HttpResponse response = new HttpResponse();

        if (!Test.isRunningTest()){
            response = http.send(request);
        }else{
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody('String body');
        }

        System.debug('respuesta->'+response.getStatus()+' '+response.getBody());

        procesoRespuestaServicio(response.getStatusCode(),response.getBody(),ide);
    }

    static void procesoRespuestaServicio(Integer respuestaMetodoCode,String respuestaMetodoBody,String ide){

        if (respuestaMetodoCode == 200){
            System.debug('ejecución correcta');
            Opportunity solicitud = [SELECT Id,Respuesta_Servicio__c,RecordTypeId FROM Opportunity WHERE Id_Solicitud__c =: ide];

            solicitud.Respuesta_Servicio__c = 'Ejecución correcta';

            //Solicitud_Renovaciones_V2
            Id rt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito V2').getRecordTypeId();
            solicitud.RecordTypeId = rt;

            update solicitud;

        }else{
            System.debug('ejecución incorrecta');

            Opportunity solicitud = [SELECT Id,Respuesta_Servicio__c FROM Opportunity WHERE Id_Solicitud__c =: ide];

            solicitud.Respuesta_Servicio__c = 'ERROR'+ respuestaMetodoBody;
            update solicitud;           
        }

    }
}