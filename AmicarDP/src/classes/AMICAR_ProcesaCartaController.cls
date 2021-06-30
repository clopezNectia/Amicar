public class AMICAR_ProcesaCartaController{

    private sObject mysObject;
	public String tmpId{get;set;}
	
	public AMICAR_ProcesaCartaController(ApexPages.StandardController controller){
		tmpId = Apexpages.currentPage().getParameters().get('Id');
        System.debug('id->'+tmpId);
	}
    
	public pageReference procesaCarta(){
	
        try{
			Opportunity solicitudActualizar = [SELECT Id,ConteoCarta__c FROM Opportunity WHERE Id =: tmpId];

			if (solicitudActualizar.ConteoCarta__c == null){
				solicitudActualizar.ConteoCarta__c = '001';
			}else{
				solicitudActualizar.ConteoCarta__c = String.valueOf( Integer.valueOf(solicitudActualizar.ConteoCarta__c) + 1);
			}
			System.debug('conteo->'+solicitudActualizar.ConteoCarta__c);

			update solicitudActualizar;

			String url = '/apex/AMICAR_CartaAdjudicacion?Id='+solicitudActualizar.Id;
			System.debug('url->'+url);
        
			PageReference pr = new PageReference(url);
			pr.setRedirect(true);
			return pr;
		}catch(Exception ex){
			System.debug('Se ha detectado un error');
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
			return null;
		}
    }
}