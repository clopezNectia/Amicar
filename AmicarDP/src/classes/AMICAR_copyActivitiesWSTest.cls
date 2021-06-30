/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Esteban Flores (EF)
Proyecto: Amicar
Descripción: Clase Test para integraciones
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 29-02-2020            EF                   Creación de la Clase.
***********************************************************************************/
@isTest
public class AMICAR_copyActivitiesWSTest{
    @testSetup static void setup(){
        Contact c = new Contact();
        c.Firstname = 'Juan';
        c.Lastname = 'Perez';
        c.Rut__c = '1-9';
        insert c;
        Account a = new Account();
        a.Firstname = 'Juan';
        a.Lastname = 'Perez';
        a.Rut__c = '1-9';
        insert a;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Account = a;
        opp.CloseDate = System.today().addDays(2);
        opp.StageName = 'Pre evaluación';
        insert opp;
        Quote q = new Quote();
        q.Contact = c;
        q.Name = 'holi';
        q.OpportunityId = opp.Id;
        insert q;
        Task t1 = new Task();
        t1.WhoId = c.Id;
        t1.WhatId = q.Id;
        t1.Subject = 'Prueba';
        t1.ActivityDate = System.today();
        t1.Description = 'Description';
        t1.Type = 'Llamada';
        t1.Estado_de_Actividad__c = 'AGENDADO';
        t1.Comuna__c = 'CERRILLOS';
        t1.Direcci_n_Locales__c = 'AV AMERICO VESPUCIO #1501 CERRILLOS AUTOPLAZA MALL PLAZA OESTE';
        t1.Marca__c = 'Mazda';
        insert t1;
        Event e1 = new Event();
        e1.WhoId = c.Id;
        e1.WhatId = q.Id;
        e1.Subject = 'Prueba';
        e1.Location = 'Prueba';
        e1.IsAllDayEvent = false;
        e1.ActivityDateTime = System.now();
        e1.ActivityDate = System.today();
        e1.StartDateTime = System.now();
        e1.EndDateTime = System.now();
        e1.Description = 'Description';
        e1.Type = 'Llamada';
        e1.Estado_de_Actividad__c = 'AGENDADO';
        e1.Comuna__c = 'CERRILLOS';
        e1.Direcci_n_Locales__c = 'AV AMERICO VESPUCIO #1501 CERRILLOS AUTOPLAZA MALL PLAZA OESTE';
        e1.Marca__c = 'Mazda';
        insert e1;
    }
    @isTest static void testTask() {
        List<Task> xs = [SELECT Id FROM Task];
        for(Task x : xs){
            AMICAR_copyTasksWS y = new AMICAR_copyTasksWS(x.Id);
            List<String> ids = new List<Id>();
            ids.add(x.Id);
            AMICAR_copyTasksWS.CopiaTask(ids);
            AMICAR_copyTasksWSJSON testData = new AMICAR_copyTasksWSJSON();
            System.debug(testdata);
            System.debug(AMICAR_copyEventsWSJSON.testJSON());
            AMICAR_copyTasksWSJSON.parse(AMICAR_copyTasksWSJSON.testJSON());
        }
    }
    @isTest static void testEvent() {
        List<Event> xs = [SELECT Id FROM Event];
        for(Event x : xs){
            AMICAR_copyEventsWS y = new AMICAR_copyEventsWS(x.Id);
            List<String> ids = new List<Id>();
            ids.add(x.Id);
            AMICAR_copyEventsWS.CopiaEvent(ids);
            AMICAR_copyEventsWSJSON testData = new AMICAR_copyEventsWSJSON();
            System.debug(testdata);
            System.debug(AMICAR_copyEventsWSJSON.testJSON());
            AMICAR_copyEventsWSJSON.parse(AMICAR_copyEventsWSJSON.testJSON());
        }
    }
}