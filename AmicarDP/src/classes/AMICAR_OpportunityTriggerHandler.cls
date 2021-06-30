public class AMICAR_OpportunityTriggerHandler {
	private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public AMICAR_OpportunityTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBefore ( Opportunity [] newOpp ){
        try
        {
            Opportunity OpportunityTmp = new Opportunity();
            for ( Opportunity opp : newOpp ){
                if(opp.isClone()){
                    opp.Solicitud_Origen__c = opp.getCloneSourceId();
                    
                }
            }
        }catch(Exception e){
            system.debug(e);
        }
    }
}