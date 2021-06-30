public class AMICAR_MultipleEditDesarrollosController {
    ApexPages.StandardSetController setCon;
    public integer nuevoMonto{get;set;}
    public Set<Id> idsSeleccionados = new Set<Id>();
    public List<Desarrollo__c> listadoDesarrollos = new List<Desarrollo__c>();
    public AMICAR_MultipleEditDesarrollosController(ApexPages.StandardSetController controller) {
        setCon = controller;
    }


    public AMICAR_MultipleEditDesarrollosController(ApexPages.StandardController controller) {

    }
    
    public pageReference guardaMontoNuevo()
    {

        System.debug('nuevoMonto = ' + nuevoMonto);
        id idSimulacion;
        for ( Desarrollo__c desarrollo : (Desarrollo__c[])setCon.getSelected() )
        {
                System.debug('Desarrollo name = ' + desarrollo);
                idsSeleccionados.add(desarrollo.Id);
        }
        listadoDesarrollos = [select Id, Pago__c, Simulacion__c from Desarrollo__c where Id IN: idsSeleccionados];
        System.debug('listadoDesarrollos = ' + listadoDesarrollos);
        for ( Desarrollo__c desarrollosUpd : listadoDesarrollos )
        {
            desarrollosUpd.Pago__c = nuevoMonto;
            idSimulacion = desarrollosUpd.Simulacion__c;
        } 
        System.debug('listadoDesarrollos modificado = ' + listadoDesarrollos);
        update listadoDesarrollos;
        PageReference p = new PageReference('/'+idSimulacion);
        
        return p;
    }

}