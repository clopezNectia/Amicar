public with sharing class AMICAR_AsignacionManualController {
    
    public Remate__c remate {get;set;}
    public Remate__c remates {get;set;}
    
    ApexPages.StandardSetController setCon;
    
    public AMICAR_AsignacionManualController(ApexPages.StandardSetController controller) {
        setCon = controller;
        system.debug('setCon'+setCon);
        try{
            for ( Remate__c remateTmp : (Remate__c[])setCon.getSelected()){
                remate = remateTmp;
                system.debug('remateTmp'+remateTmp);
            }
            remates = [select Id, Entidad_Financiera__c , Estado__c, Solicitud__r.Id_Solicitud__c, Solicitud__c, Solicitud__r.OwnerId, Solicitud__r.Owner.RUT_F_I__c from Remate__c where Id =: remate.Id];
            
        }catch(Exception e){
            
            system.debug(e.getMessage());
            
            
        }    
        //return null;
    }
    public PageReference postGanadora() {
        // system.debug(opportunity);
        if(remates != null){
            if(remates.Estado__c == 'APPROVED'){
                String jsonSolicitud = '{"amicarExecutiveIdentificationValue":"'+ remates.Solicitud__r.Owner.RUT_F_I__c +'","feIdentificationValue":"'+ remates.Entidad_Financiera__c +'"}';
                llamarServicioAsignacionManual(jsonSolicitud, remates.Solicitud__r.Id_Solicitud__c, remates.Solicitud__c);
                PageReference p = new PageReference('/'+remates.Solicitud__r.Id);
                return p;
            }else{
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Solo puede asignar un remate aprobado');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Debe seleccionar un remate aprobado antes de continuar');
            ApexPages.addMessage(myMsg);
            return null; 
        } 
        
    }
    
    
    @future(callout=true)
    static void llamarServicioAsignacionManual(String jsonEnvio, String idSolicitud, String idRegistroSolicitud){
        Transient String responseWs;
        Transient AMICAR_ChecklistPutJSON jsonR;
        String tablaDesarrollo;
        String urlEndpoint;
        String metodo;
        Opportunity oppUpd = [Select Id, StageName from Opportunity Where Id =: idRegistroSolicitud];
        ///chl/v1/loan-application/manual-assignment/{loanApplicationId}
        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id,URL__c,Metodo__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'manual-assignment'];
        //ya que testing aún no está implementada... por ahora va la url de staging
        System.debug('Endpoint = '+endpointSolicitudes[0].URL__c);
        urlEndpoint = endpointSolicitudes[0].URL__c;
        List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                                     FROM API_Keys__mdt
                                     WHERE MasterLabel = 'Simulaciones'];
        
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointSolicitudes[0].URL__c + idSolicitud);
        req.setTimeOut(120000);
        req.setMethod(endpointSolicitudes[0].Metodo__c);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', apkey[0].APK__c);
        req.setBody(jsonEnvio);
        System.debug('Request');
        System.debug(req);
        System.debug('Body');
        System.debug(jsonEnvio);
        
        HttpResponse res = new HttpResponse();
		if(Test.isRunningTest()){
			res.setStatusCode(200);
		}else{
			res = h.send(req);
        }

        try{    
            if (res.getStatusCode() == 200){
                responseWs = res.getBody();
                oppUpd.StageName = 'Checklist';
                update oppUpd;
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