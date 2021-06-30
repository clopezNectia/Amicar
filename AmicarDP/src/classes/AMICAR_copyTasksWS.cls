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
public class AMICAR_copyTasksWS{
    public AMICAR_copyTasksWS(Id iTask){
        Task myTask = [SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, 
                       ActivityDate, Description, AccountId, OwnerId, Type, IsDeleted,
                       CreatedDate, CreatedById, LastModifiedDate,
                       LastModifiedById, SystemModstamp, IsArchived, RecurrenceActivityId, IsRecurrence,
                       RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType,
                       RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, 
                       RecurrenceMonthOfYear, ReminderDateTime, IsReminderSet, Estado_de_Actividad__c, 
                       Agenda__c, Comuna__c, Direcci_n_Locales__c, Ejecutivo_F_I__c, 
                       Importador__c, Local_Comuna__c, Marca__c
                     FROM Task
                     WHERE Id =: iTask];
    }

    @InvocableMethod(label='Copiar Task' description='Copia Actividades en base de datos replica')
    public static List<String> CopiaTask (List<String> iTask) {
        List<Task> tDatas = [SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, 
                               ActivityDate, Description, AccountId, OwnerId, Type, IsDeleted,
                               CreatedDate, CreatedById, LastModifiedDate,
                               LastModifiedById, SystemModstamp, IsArchived, RecurrenceActivityId, IsRecurrence,
                               RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType,
                               RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, 
                               RecurrenceMonthOfYear, ReminderDateTime, IsReminderSet, Estado_de_Actividad__c, 
                               Agenda__c, Comuna__c, Direcci_n_Locales__c, Ejecutivo_F_I__c, 
                               Importador__c, Local_Comuna__c, Marca__c
                             FROM Task
                             WHERE Id IN: iTask];
        for(Task tData : tDatas){
            String json = AMICAR_CopyTasksWS.loadRequest(tData);
            callService(json, tData.Id);
        }
        return null;
    }

    @future(callout=true)
    static void callService(String json, String idTask){
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
            request.setEndpoint(endP+'?IdSended='+idTask);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/json');
            request.setBody(json);
            System.debug(json);
            if (!Test.IsRunningTest()){
                Http http = new Http();
                response = http.send(request);
            }else{
                String falseJson = AMICAR_CopyTasksWSJSON.testJSON();
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

    public static String loadRequest(Task myTask){
        /* Llenar datos con información de la actividad */
        AMICAR_CopyTasksWSJSON objToJSON = new AMICAR_CopyTasksWSJSON();
        objToJSON.Id = myTask.Id;
        objToJSON.RecordTypeId = myTask.RecordTypeId;
        objToJSON.WhoId = myTask.WhoId;
        objToJSON.WhatId = myTask.WhatId;
        objToJSON.WhoCount = String.valueOf(myTask.WhoCount);
        objToJSON.WhatCount = String.valueOf(myTask.WhatCount);
        objToJSON.Subject = myTask.Subject;
        objToJSON.ActivityDate = String.valueOf(myTask.ActivityDate);
        objToJSON.Description = myTask.Description;
        objToJSON.AccountId = myTask.AccountId;
        objToJSON.OwnerId = myTask.OwnerId;
        objToJSON.Type = myTask.Type;
        objToJSON.IsDeleted = String.valueOf(myTask.IsDeleted);
        objToJSON.CreatedDate = String.valueOf(myTask.CreatedDate);
        objToJSON.CreatedById = myTask.CreatedById;
        objToJSON.LastModifiedDate = String.valueOf(myTask.LastModifiedDate);
        objToJSON.LastModifiedById = myTask.LastModifiedById;
        objToJSON.SystemModstamp = String.valueOf(myTask.SystemModstamp);
        objToJSON.IsArchived = String.valueOf(myTask.IsArchived);
        objToJSON.RecurrenceActivityId = myTask.RecurrenceActivityId;
        objToJSON.IsRecurrence = String.valueOf(myTask.IsRecurrence);
        objToJSON.RecurrenceEndDateOnly = String.valueOf(myTask.RecurrenceEndDateOnly);
        objToJSON.RecurrenceTimeZoneSidKey = String.valueOf(myTask.RecurrenceTimeZoneSidKey);
        objToJSON.RecurrenceType = myTask.RecurrenceType;
        objToJSON.RecurrenceInterval = String.valueOf(myTask.RecurrenceInterval);
        objToJSON.RecurrenceDayOfWeekMask = String.valueOf(myTask.RecurrenceDayOfWeekMask);
        objToJSON.RecurrenceDayOfMonth = String.valueOf(myTask.RecurrenceDayOfMonth);
        objToJSON.RecurrenceInstance = myTask.RecurrenceInstance;
        objToJSON.RecurrenceMonthOfYear = String.valueOf(myTask.RecurrenceMonthOfYear);
        objToJSON.ReminderDateTime = String.valueOf(myTask.ReminderDateTime);
        objToJSON.IsReminderSet = String.valueOf(myTask.IsReminderSet);
        objToJSON.Estado_de_Actividad = myTask.Estado_de_Actividad__c;
        objToJSON.Agenda = String.valueOf(myTask.Agenda__c);
        objToJSON.Comuna = myTask.Comuna__c;
        objToJSON.Direccion_Locales = myTask.Direcci_n_Locales__c;
        objToJSON.Importado = myTask.Importador__c;
        objToJSON.Ejecutivo_F_I = myTask.Ejecutivo_F_I__c;
        objToJSON.Local_Comuna = myTask.Local_Comuna__c;
        objToJSON.Marca = myTask.Marca__c;
        objToJSON.UsuarioNombre = UserInfo.getFirstName();
        objToJSON.UsuarioApellido = UserInfo.getLastName();
        objToJSON.UsuarioMail = UserInfo.getUserEmail();
        if(myTask.WhoId != null){
            Schema.SObjectType tipoObjeto = myTask.WhoId.getSObjectType();
            String nombreObjeto = tipoObjeto.getDescribe().getName();
            objToJSON.OrigenCliente = nombreObjeto;
            if(nombreObjeto == 'Account'){
                String rData = [SELECT RUT__c FROM Account WHERE Id =:myTask.WhoId LIMIT 1].RUT__c;
                objToJSON.RutCliente = rData;
            }else if(nombreObjeto == 'Contact'){
                String rData = [SELECT RUT__c FROM Contact WHERE Id =:myTask.WhoId LIMIT 1].RUT__c;
                objToJSON.RutCliente = rData;
            }else if(nombreObjeto == 'Lead'){
                String rData = [SELECT rut__c FROM Lead WHERE Id =:myTask.WhoId LIMIT 1].rut__c;
                objToJSON.RutCliente = rData;
            }else{
                objToJSON.RutCliente = '';
            }
        }
        if(myTask.WhatId != null){
            Schema.SObjectType tipoObjetoB = myTask.WhatId.getSObjectType();
            String nombreObjetoB = tipoObjetoB.getDescribe().getName();
            objToJSON.OrigenCredito = nombreObjetoB;
            if(nombreObjetoB == 'Asset'){ //Credito
                if(myTask.WhoId == null){
                    //Account
                    Asset cred = [SELECT Id_Credito__c, Account.RUT__c FROM Asset WHERE Id =:myTask.WhatId LIMIT 1];
                    objToJSON.Credito = cred.Id_Credito__c;
                    objToJSON.RutCliente = cred.Account.RUT__c;
                    objToJSON.OrigenCliente = 'Account';
                }else{
                    String numCredito = [SELECT Id_Credito__c FROM Asset WHERE Id =:myTask.WhatId LIMIT 1].Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else if(nombreObjetoB == 'Opportunity'){ //Solicitud
                if(myTask.WhoId == null){
                    //Account
                    Opportunity opp = [SELECT Activo__r.Id_Credito__c, Cuenta__r.RUT__c FROM Opportunity WHERE Id =:myTask.WhatId LIMIT 1];
                    objToJSON.Credito = opp.Activo__r.Id_Credito__c;
                    objToJSON.RutCliente = opp.Cuenta__r.RUT__c;
                    objToJSON.OrigenCliente = 'Account';
                }else{
                    String numCredito = [SELECT Activo__r.Id_Credito__c FROM Opportunity WHERE Id =:myTask.WhatId LIMIT 1].Activo__r.Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else if(nombreObjetoB == 'Quote'){ //Simulacion
                if(myTask.WhoId == null){
                    //Account
                    Quote sim = [SELECT Opportunity.Activo__r.Id_Credito__c, Contact.RUT__c FROM Quote WHERE Id =:myTask.WhatId LIMIT 1];
                    objToJSON.Credito = sim.Opportunity.Activo__r.Id_Credito__c;
                    objToJSON.RutCliente = sim.Contact.RUT__c;
                    objToJSON.OrigenCliente = 'Contact';
                }else{
                    String numCredito = [SELECT Opportunity.Activo__r.Id_Credito__c FROM Quote WHERE Id =:myTask.WhatId LIMIT 1].Opportunity.Activo__r.Id_Credito__c;
                    objToJSON.Credito = numCredito;
                }
            }else{ //Cualquier otro
                objToJSON.Credito = '';
            }
        }
        return JSON.serialize(objToJSON);
    }
}