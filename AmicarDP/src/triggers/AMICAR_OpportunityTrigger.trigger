trigger AMICAR_OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete, after delete) {
	
    AMICAR_OpportunityTriggerHandler handler = new AMICAR_OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    system.debug(Trigger.isBefore);
    system.debug(Trigger.isAfter);   
    if (Trigger.isInsert && Trigger.isBefore) {
        system.debug('Entro?');
        handler.OnBefore(Trigger.new);
    }
}