/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Esteban Flores (EF)
Proyecto: Amicar
Descripción: Clase controladora para copia de Tasks por integracion
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 09-04-2020            EF                   Creación de la Clase.
***********************************************************************************/
public class AMICAR_copyEventsWS{
    public AMICAR_copyEventsWS(Id iEvent){
        Event myEvent = [SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, Location, 
                       IsAllDayEvent, ActivityDateTime, ActivityDate, DurationInMinutes, StartDateTime,
                       EndDateTime, Description, AccountId, OwnerId, Type, IsPrivate, ShowAs, IsDeleted,
                       IsChild, IsGroupEvent, GroupEventType, CreatedDate, CreatedById, LastModifiedDate,
                       LastModifiedById, SystemModstamp, IsArchived, RecurrenceActivityId, IsRecurrence,
                       RecurrenceStartDateTime, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType,
                       RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, 
                       RecurrenceMonthOfYear, ReminderDateTime, IsReminderSet, EventSubtype, Estado_de_Actividad__c, 
                       Agenda__c, Comuna__c, Direcci_n_Locales__c, Ejecutivo_F_I__c, 
                       Importador__c, Local_Comuna__c, Marca__c
                     FROM Event
                     WHERE Id =: iEvent];
    }

    @InvocableMethod(label='Copiar Event' description='Copia Actividades en base de datos replica')
    public static List<String> CopiaEvent (List<String> iEvent) {
        List<Event> events = [SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, Location, 
                               IsAllDayEvent, ActivityDateTime, ActivityDate, DurationInMinutes, StartDateTime,
                               EndDateTime, Description, AccountId, OwnerId, Type, IsPrivate, ShowAs, IsDeleted,
                               IsChild, IsGroupEvent, GroupEventType, CreatedDate, CreatedById, LastModifiedDate,
                               LastModifiedById, SystemModstamp, IsArchived, RecurrenceActivityId, IsRecurrence,
                               RecurrenceStartDateTime, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType,
                               RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, 
                               RecurrenceMonthOfYear, ReminderDateTime, IsReminderSet, EventSubtype, Estado_de_Actividad__c, 
                               Agenda__c, Comuna__c, Direcci_n_Locales__c, Ejecutivo_F_I__c, 
                               Importador__c, Local_Comuna__c, Marca__c
                             FROM Event
                             WHERE Id IN: iEvent];
        for(Event event : events){
            String json = AMICAR_CopyEventsWS.loadRequest(event);
            callService(json, event.Id);
        }
        return null;
    }

    @future(callout=true)
    static void callService(String json, String idEvent){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        //Para chequear si es sandbox o productivo
        Organization ox = [SELECT Id, IsSandbox FROM Organization LIMIT 1];
        String endP = '';
        try{
            //Obtener endpoint de metadata
            endP = [SELECT URL__c
                    FROM AMICAR_Integracion__mdt
                    WHERE MasterLabel = 'Event'].URL__c;
            request.setEndpoint(endP+'?IdSended='+idEvent);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/json');
            request.setBody(json);
            System.debug(json);
            if (!Test.IsRunningTest()){
                Http http = new Http();
                response = http.send(request);
            }else{
                String falseJson = AMICAR_CopyEventsWSJSON.testJSON();
                response.setBody(falseJson);
            }
            System.debug('Body de respuesta: '+response.getBody());
        }catch(Exception e){
            System.debug('Tipo de excepción: ' + e.getTypeName());
            System.debug('Mensaje: ' + e.getMessage());
            System.debug('Causa: ' + e.getCause());
            System.debug('Línea: ' + e.getLineNumber());
            System.debug('Traza: ' + e.getStackTraceString());
        }
    }

    public static String loadRequest(Event myEvent){
        /* Llenar datos con información de la actividad */
        AMICAR_CopyEventsWSJSON objToJSON = new AMICAR_CopyEventsWSJSON();
        objToJSON.Id = myEvent.Id;
        objToJSON.RecordTypeId = myEvent.RecordTypeId;
        objToJSON.WhoId = myEvent.WhoId;
        objToJSON.WhatId = myEvent.WhatId;
        objToJSON.WhoCount = String.valueOf(myEvent.WhoCount);
        objToJSON.WhatCount = String.valueOf(myEvent.WhatCount);
        objToJSON.Subject = myEvent.Subject;
        objToJSON.Location = myEvent.Location;
        objToJSON.IsAllDayEvent = String.valueOf(myEvent.IsAllDayEvent);
        objToJSON.ActivityDateTime = String.valueOf(myEvent.ActivityDateTime);
        objToJSON.ActivityDate = String.valueOf(myEvent.ActivityDate);
        objToJSON.DurationInMinutes = String.valueOf(myEvent.DurationInMinutes);
        objToJSON.StartDateTime = String.valueOf(myEvent.StartDateTime);
        objToJSON.EndDateTime = String.valueOf(myEvent.EndDateTime);
        objToJSON.Description = myEvent.Description;
        objToJSON.AccountId = myEvent.AccountId;
        objToJSON.OwnerId = myEvent.OwnerId;
        objToJSON.Type = myEvent.Type;
        objToJSON.IsPrivate = String.valueOf(myEvent.IsPrivate);
        objToJSON.ShowAs = myEvent.ShowAs;
        objToJSON.IsDeleted = String.valueOf(myEvent.IsDeleted);
        objToJSON.IsChild = String.valueOf(myEvent.IsChild);
        objToJSON.IsGroupEvent = String.valueOf(myEvent.IsGroupEvent);
        objToJSON.GroupEventType = myEvent.GroupEventType;
        objToJSON.CreatedDate = String.valueOf(myEvent.CreatedDate);
        objToJSON.CreatedById = myEvent.CreatedById;
        objToJSON.LastModifiedDate = String.valueOf(myEvent.LastModifiedDate);
        objToJSON.LastModifiedById = myEvent.LastModifiedById;
        objToJSON.SystemModstamp = String.valueOf(myEvent.SystemModstamp);
        objToJSON.IsArchived = String.valueOf(myEvent.IsArchived);
        objToJSON.RecurrenceActivityId = myEvent.RecurrenceActivityId;
        objToJSON.IsRecurrence = String.valueOf(myEvent.IsRecurrence);
        objToJSON.RecurrenceStartDateTime = String.valueOf(myEvent.RecurrenceStartDateTime);
        objToJSON.RecurrenceEndDateOnly = String.valueOf(myEvent.RecurrenceEndDateOnly);
        objToJSON.RecurrenceTimeZoneSidKey = String.valueOf(myEvent.RecurrenceTimeZoneSidKey);
        objToJSON.RecurrenceType = myEvent.RecurrenceType;
        objToJSON.RecurrenceInterval = String.valueOf(myEvent.RecurrenceInterval);
        objToJSON.RecurrenceDayOfWeekMask = String.valueOf(myEvent.RecurrenceDayOfWeekMask);
        objToJSON.RecurrenceDayOfMonth = String.valueOf(myEvent.RecurrenceDayOfMonth);
        objToJSON.RecurrenceInstance = myEvent.RecurrenceInstance;
        objToJSON.RecurrenceMonthOfYear = String.valueOf(myEvent.RecurrenceMonthOfYear);
        objToJSON.ReminderDateTime = String.valueOf(myEvent.ReminderDateTime);
        objToJSON.IsReminderSet = String.valueOf(myEvent.IsReminderSet);
        objToJSON.EventSubtype = myEvent.EventSubtype;
        objToJSON.Estado_de_Actividad = myEvent.Estado_de_Actividad__c;
        objToJSON.Agenda = String.valueOf(myEvent.Agenda__c);
        objToJSON.Comuna = myEvent.Comuna__c;
        objToJSON.Direccion_Locales = myEvent.Direcci_n_Locales__c;
        objToJSON.Importado = myEvent.Importador__c;
        objToJSON.Ejecutivo_F_I = myEvent.Ejecutivo_F_I__c;
        objToJSON.Local_Comuna = myEvent.Local_Comuna__c;
        objToJSON.Marca = myEvent.Marca__c;
        objToJSON.UsuarioNombre = UserInfo.getFirstName();
        objToJSON.UsuarioApellido = UserInfo.getLastName();
        objToJSON.UsuarioMail = UserInfo.getUserEmail();
        if(myEvent.WhoId != null){
            Schema.SObjectType tipoObjeto = myEvent.WhoId.getSObjectType();
            String nombreObjeto = tipoObjeto.getDescribe().getName();
            objToJSON.OrigenCliente = nombreObjeto;
            if(nombreObjeto == 'Account'){
                String rData = [SELECT RUT__c FROM Account WHERE Id =:myEvent.WhoId LIMIT 1].RUT__c;
                objToJSON.RutCliente = rData;
            }else if(nombreObjeto == 'Contact'){
                String rData = [SELECT RUT__c FROM Contact WHERE Id =:myEvent.WhoId LIMIT 1].RUT__c;
                objToJSON.RutCliente = rData;
            }else if(nombreObjeto == 'Lead'){
                String rData = [SELECT rut__c FROM Lead WHERE Id =:myEvent.WhoId LIMIT 1].rut__c;
                objToJSON.RutCliente = rData;
            }else{
                objToJSON.RutCliente = '';
            }
        }
        if(myEvent.WhatId != null){
            Schema.SObjectType tipoObjetoB = myEvent.WhatId.getSObjectType();
            String nombreObjetoB = tipoObjetoB.getDescribe().getName();
            objToJSON.OrigenCredito = nombreObjetoB;
            if(nombreObjetoB == 'Asset'){ //Credito
                if(myEvent.WhoId == null){
                    //Account
                    Asset cred = [SELECT Id_Credito__c, Account.RUT__c FROM Asset WHERE Id =:myEvent.WhatId LIMIT 1];
                    objToJSON.Credito = cred.Id_Credito__c;
                    objToJSON.RutCliente = cred.Account.RUT__c;
                    objToJSON.OrigenCliente = 'Account';
                }else{
                    String numCredito = [SELECT Id_Credito__c FROM Asset WHERE Id =:myEvent.WhatId LIMIT 1].Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else if(nombreObjetoB == 'Opportunity'){ //Solicitud
                if(myEvent.WhoId == null){
                    //Account
                    Opportunity opp = [SELECT Activo__r.Id_Credito__c, Cuenta__r.RUT__c FROM Opportunity WHERE Id =:myEvent.WhatId LIMIT 1];
                    objToJSON.Credito = opp.Activo__r.Id_Credito__c;
                    objToJSON.RutCliente = opp.Cuenta__r.RUT__c;
                    objToJSON.OrigenCliente = 'Account';
                }else{
                    String numCredito = [SELECT Activo__r.Id_Credito__c FROM Opportunity WHERE Id =:myEvent.WhatId LIMIT 1].Activo__r.Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else if(nombreObjetoB == 'Quote'){ //Simulacion
                if(myEvent.WhoId == null){
                    //Account
                    Quote sim = [SELECT Opportunity.Activo__r.Id_Credito__c, Contact.RUT__c FROM Quote WHERE Id =:myEvent.WhatId LIMIT 1];
                    objToJSON.Credito = sim.Opportunity.Activo__r.Id_Credito__c;
                    objToJSON.RutCliente = sim.Contact.RUT__c;
                    objToJSON.OrigenCliente = 'Contact';
                }else{
                    String numCredito = [SELECT Opportunity.Activo__r.Id_Credito__c FROM Quote WHERE Id =:myEvent.WhatId LIMIT 1].Opportunity.Activo__r.Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else{ //Cualquier otro
                objToJSON.Credito = '';
            }
        }
        return JSON.serialize(objToJSON);
    }
}