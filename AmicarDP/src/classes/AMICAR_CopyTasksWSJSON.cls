public class AMICAR_CopyTasksWSJSON{
    public String Id { get; set; }   //asdabsdasd
    public String RecordTypeId { get; set; } //asdabsdasd
    public String WhoId { get; set; }    //asdabsdasd
    public String WhatId { get; set; }   //asdabsdasd
    public String WhoCount { get; set; } //asdabsdasd
    public String WhatCount { get; set; }    //asdabsdasd
    public String Subject { get; set; }  //asdabsdasd
    public String ActivityDate { get; set; } //asdabsdasd
    public String Description { get; set; }  //asdabsdasd
    public String AccountId { get; set; }    //asdabsdasd
    public String OwnerId { get; set; }  //asdabsdasd
    public String Type { get; set; } //asdabsdasd
    public String IsDeleted { get; set; }    //asdabsdasd
    public String CreatedDate { get; set; }  //asdabsdasd
    public String CreatedById { get; set; }  //asdabsdasd
    public String LastModifiedDate { get; set; } //asdabsdasd
    public String LastModifiedById { get; set; } //asdabsdasd
    public String SystemModstamp { get; set; }   //asdabsdasd
    public String IsArchived { get; set; }   //asdabsdasd
    public String RecurrenceActivityId { get; set; } //asdabsdasd
    public String IsRecurrence { get; set; } //asdabsdasd
    public String RecurrenceEndDateOnly { get; set; }    //asdabsdasd
    public String RecurrenceTimeZoneSidKey { get; set; } //asdabsdasd
    public String RecurrenceType { get; set; }   //asdabsdasd
    public String RecurrenceInterval { get; set; }   //asdabsdasd
    public String RecurrenceDayOfWeekMask { get; set; }  //asdabsdasd
    public String RecurrenceDayOfMonth { get; set; } //asdabsdasd
    public String RecurrenceInstance { get; set; }   //asdabsdasd
    public String RecurrenceMonthOfYear { get; set; }    //asdabsdasd
    public String ReminderDateTime { get; set; } //asdabsdasd
    public String IsReminderSet { get; set; }    //asdabsdasd
    public String Estado_de_Actividad { get; set; }   //asdabsdasd
    public String Agenda { get; set; }    //asdabsdasd
    public String Comuna { get; set; }    //asdabsdasd
    public String Direccion_Locales { get; set; } //asdabsdasd
    public String Importado { get; set; }    //asdabsdasd
    public String Ejecutivo_F_I { get; set; } //asdabsdasd
    public String Local_Comuna { get; set; }  //asdabsdasd
    public String Marca { get; set; } //asdabsdasd
    public String Credito { get; set; } //asdabsdasd
    public String OrigenCredito { get; set; } //asdabsdasd
    public String RutCliente { get; set; } //asdabsdasd
    public String OrigenCliente { get; set; } //asdabsdasd
    public String UsuarioNombre { get; set; } //asdabsdasd
    public String UsuarioApellido { get; set; } //asdabsdasd
    public String UsuarioMail { get; set; } //asdabsdasd

    public static AMICAR_CopyTasksWSJSON parse(String json){
        return (AMICAR_CopyTasksWSJSON) System.JSON.deserialize(json, AMICAR_CopyTasksWSJSON.class);
    }
    
    public static String testJSON(){
        String falseJson =      '{'+
        '   "Id": "asdabsdasd",'+
        '   "RecordTypeId": "asdabsdasd",'+
        '   "WhoId": "asdabsdasd",'+
        '   "WhatId": "asdabsdasd",'+
        '   "WhoCount": "asdabsdasd",'+
        '   "WhatCount": "asdabsdasd",'+
        '   "Subject": "asdabsdasd",'+
        '   "ActivityDate": "asdabsdasd",'+
        '   "Description": "asdabsdasd",'+
        '   "AccountId": "asdabsdasd",'+
        '   "OwnerId": "asdabsdasd",'+
        '   "Type": "asdabsdasd",'+
        '   "IsDeleted": "asdabsdasd",'+
        '   "CreatedDate": "asdabsdasd",'+
        '   "CreatedById": "asdabsdasd",'+
        '   "LastModifiedDate": "asdabsdasd",'+
        '   "LastModifiedById": "asdabsdasd",'+
        '   "SystemModstamp": "asdabsdasd",'+
        '   "IsArchived": "asdabsdasd",'+
        '   "RecurrenceActivityId": "asdabsdasd",'+
        '   "IsRecurrence": "asdabsdasd",'+
        '   "RecurrenceEndDateOnly": "asdabsdasd",'+
        '   "RecurrenceTimeZoneSidKey": "asdabsdasd",'+
        '   "RecurrenceType": "asdabsdasd",'+
        '   "RecurrenceInterval": "asdabsdasd",'+
        '   "RecurrenceDayOfWeekMask": "asdabsdasd",'+
        '   "RecurrenceDayOfMonth": "asdabsdasd",'+
        '   "RecurrenceInstance": "asdabsdasd",'+
        '   "RecurrenceMonthOfYear": "asdabsdasd",'+
        '   "ReminderDateTime": "asdabsdasd",'+
        '   "IsReminderSet": "asdabsdasd",'+
        '   "Estado_de_Actividad": "asdabsdasd",'+
        '   "Agenda": "asdabsdasd",'+
        '   "Comuna": "asdabsdasd",'+
        '   "Direccion_Locales": "asdabsdasd",'+
        '   "Importador": "asdabsdasd",'+
        '   "Ejecutivo_F_I": "asdabsdasd",'+
        '   "Local_Comuna": "asdabsdasd",'+
        '   "Marca": "asdabsdasd",'+
        '   "Credito": "asdabsdasd",'+
        '   "OrigenCredito": "asdabsdasd",'+
        '   "RutCliente": "asdabsdasd",'+
        '   "OrigenCliente": "asdabsdasd",'+
        '   "UsuarioNombre": "asdabsdasd",'+
        '   "UsuarioApellido": "asdabsdasd",'+
        '   "UsuarioMail": "asdabsdasd"'+
        '}';
        return falseJson;
    }
/*
    static testMethod void testParse() {
        String json=        '{'+
        '   "Id": "asdabsdasd",'+
        '   "RecordTypeId": "asdabsdasd",'+
        '   "WhoId": "asdabsdasd",'+
        '   "WhatId": "asdabsdasd",'+
        '   "WhoCount": "asdabsdasd",'+
        '   "WhatCount": "asdabsdasd",'+
        '   "Subject": "asdabsdasd",'+
        '   "Location": "asdabsdasd",'+
        '   "IsAllDayEvent": "asdabsdasd",'+
        '   "ActivityDateTime": "asdabsdasd",'+
        '   "ActivityDate": "asdabsdasd",'+
        '   "DurationInMinutes": "asdabsdasd",'+
        '   "StartDateTime": "asdabsdasd",'+
        '   "EndDateTime": "asdabsdasd",'+
        '   "Description": "asdabsdasd",'+
        '   "AccountId": "asdabsdasd",'+
        '   "OwnerId": "asdabsdasd",'+
        '   "Type": "asdabsdasd",'+
        '   "IsPrivate": "asdabsdasd",'+
        '   "ShowAs": "asdabsdasd",'+
        '   "IsDeleted": "asdabsdasd",'+
        '   "IsChild": "asdabsdasd",'+
        '   "IsGroupEvent": "asdabsdasd",'+
        '   "GroupEventType": "asdabsdasd",'+
        '   "CreatedDate": "asdabsdasd",'+
        '   "CreatedById": "asdabsdasd",'+
        '   "LastModifiedDate": "asdabsdasd",'+
        '   "LastModifiedById": "asdabsdasd",'+
        '   "SystemModstamp": "asdabsdasd",'+
        '   "IsArchived": "asdabsdasd",'+
        '   "RecurrenceActivityId": "asdabsdasd",'+
        '   "IsRecurrence": "asdabsdasd",'+
        '   "RecurrenceStartDateTime": "asdabsdasd",'+
        '   "RecurrenceEndDateOnly": "asdabsdasd",'+
        '   "RecurrenceTimeZoneSidKey": "asdabsdasd",'+
        '   "RecurrenceType": "asdabsdasd",'+
        '   "RecurrenceInterval": "asdabsdasd",'+
        '   "RecurrenceDayOfWeekMask": "asdabsdasd",'+
        '   "RecurrenceDayOfMonth": "asdabsdasd",'+
        '   "RecurrenceInstance": "asdabsdasd",'+
        '   "RecurrenceMonthOfYear": "asdabsdasd",'+
        '   "ReminderDateTime": "asdabsdasd",'+
        '   "IsReminderSet": "asdabsdasd",'+
        '   "EventSubtype": "asdabsdasd",'+
        '   "Estado_de_Actividad": "asdabsdasd",'+
        '   "Agenda": "asdabsdasd",'+
        '   "Comuna": "asdabsdasd",'+
        '   "Direccion_Locales": "asdabsdasd",'+
        '   "Importador": "asdabsdasd",'+
        '   "Ejecutivo_F_I": "asdabsdasd",'+
        '   "Local_Comuna": "asdabsdasd",'+
        '   "Marca": "asdabsdasd"'+
        '}';
        AMICAR_CopyEventsWSJSON obj = parse(json);
        System.assert(obj != null);
    }
*/
}