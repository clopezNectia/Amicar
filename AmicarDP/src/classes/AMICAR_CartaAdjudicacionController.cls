public with sharing class AMICAR_CartaAdjudicacionController {

    private sObject mysObject;

    public List<Opportunity> solicitudCarta {get;set;}
    public List<Quote> solicitudSimulacion {get;set;}
    public List<Remate__c> solicitudRemate {get;set;}
    public List<User> solicitudUsuario {get;set;}
    public List<Relacion__c> solicitudCompraPara {get;set;}
    public String fechaDia {get;set;}

    public String idSolicitud{get;set;}


    public void AMICAR_CartaAdjudicacionController(ApexPages.StandardController controller) {
        
    }

    public PageReference cargaDatos(){

        idSolicitud = ApexPages.currentPage().getParameters().get('id');
        System.debug('id->'+idSolicitud);

        solicitudCarta = [SELECT Id,OwnerId,A_o_Veh_culo__c,toLabel(Marca_vehiculo__c),Modelo__c,Modelo2__r.Name,Version__c,Precio_vehiculo__c,Pie__c,Saldo_precio__c,toLabel(Tipo_de_Veh_culo__c),Tasa__c,Id_Solicitud__c,Account.Name,RUT__c,toLabel(Importadora__c),toLabel(Locales__c),ConteoCarta__c,Cuotas__c, Local__r.Name  FROM Opportunity WHERE Id =: idSolicitud];
        System.debug('carta->'+solicitudCarta);

        solicitudSimulacion = [SELECT Id,Comisi_n_dealer__c FROM Quote WHERE OpportunityId =: idSolicitud AND IsSyncing = true];
        System.debug('escenario->'+solicitudSimulacion);

        solicitudRemate = [SELECT Id,toLabel(Entidad_Financiera__c) FROM Remate__c WHERE Solicitud__c =: idSolicitud AND Ganadora__c = true];
        System.debug('remate->'+solicitudRemate);

        solicitudUsuario = [SELECT Id,Name,Email FROM User WHERE Id =: solicitudCarta[0].OwnerId];
        System.debug('usuario->'+solicitudUsuario);
        
        solicitudCompraPara = [SELECT Id,Cuenta__r.Name,Cuenta__r.RUT__c  FROM Relacion__c WHERE Solicitud__c =: idSolicitud AND RecordType.DeveloperName =: 'Compra_para'];
        System.debug('solicitudCompraPara->'+solicitudCompraPara);
        fechaDia = String.valueOf(Datetime.newInstance(System.today().year(), System.today().month(), System.today().day()).format('dd-MM-yyyy'));

        return null;
    }
}