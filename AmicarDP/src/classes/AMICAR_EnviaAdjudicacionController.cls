public class AMICAR_EnviaAdjudicacionController {
    public Opportunity opp {get;set;}
    public Opportunity opps {get;set;}
    public AMICAR_EnviaAdjudicacionController(ApexPages.StandardController controller) {
        opp = (Opportunity)controller.getRecord();
        system.debug(opp.Id);
        opps = [select Id, Id_Solicitud__c, OwnerId, Owner.RUT_F_I__c from Opportunity where Id =: opp.Id];
        //return null;
    }


    public PageReference putAdjudicacion() {
       // system.debug(opportunity);
       String jsonSolicitud = '{ "amicarExecutiveIdentificationValue":"'+ opps.Owner.RUT_F_I__c +'"}';
       llamarServicioAdjudicacion(jsonSolicitud, opps.Id_Solicitud__c, opps.id);
       PageReference p = new PageReference('/'+opps.id);
       return p;
       
    }
    
    
     @future(callout=true)
 static void llamarServicioAdjudicacion(String jsonEnvio, String idSolicitud, String idRegistroSolicitud){
     Transient String responseWs;
   Transient AMICAR_ChecklistPutJSON jsonR;
     String tablaDesarrollo;
     String urlEndpoint;
     String metodo;
     List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id,URL__c,Metodo__c 
                                                         FROM AMICAR_Integracion__mdt 
                                                         WHERE MasterLabel = 'award'];
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
  req.setHeader('x-api-key', apkey[0].APK__c);
  req.setTimeout(120000);
  req.setBody(jsonEnvio);
  System.debug('Request');
  System.debug(req);
  System.debug('Body');
  System.debug(jsonEnvio);

  HttpResponse res = new HttpResponse();
  if(Test.isRunningTest()){
    res.setStatusCode(0);
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

}
}