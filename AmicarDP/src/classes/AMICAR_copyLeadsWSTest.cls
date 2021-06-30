/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Esteban Flores (EF)
Proyecto: Amicar
Descripción: Clase Test para integraciones
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 12-02-2020            EF                   Creación de la Clase.
***********************************************************************************/
@isTest
public class AMICAR_copyLeadsWSTest{
    @testSetup static void setup(){
        Lead leadA = new Lead();
        leadA.transactionId__c = '1010101';
        leadA.channel__c = '0831201';
        leadA.engine__c = '012039123918';
        leadA.evaluationResult__c = '12';
        leadA.transactionDate__c = System.today();
        leadA.transactionTime__c = datetime.now().time();
        leadA.rut__c = '1-9';
        leadA.FirstName = 'Testing A';
        leadA.lastName = 'Prueba A';
        leadA.motherLastName__c = 'Perez';
        leadA.income__c = 1000;
        leadA.Email = 'test@test.cl';
        leadA.Phone = '1239123191';
        leadA.carPrice__c = 1000;
        leadA.downPayment__c = 12;
        leadA.vehicleType__c = 'Usado';
        leadA.workType__c = 'Hot';
        leadA.carBrandId__c = 12;   
        leadA.carBrandDescription__c = 'SUZUKI';
        leadA.carModelId__c = 12;
        leadA.carModelDescription__c = 'Descripcion Modelo';
        leadA.carVersion__c = 'Sport';
        leadA.monthlyPayment__c = 1;
        leadA.tripletId__c = '10';
        leadA.carYear__c = '2014';
        leadA.loanSetting__c = 'Plop';
        leadA.channelId__c = 'Autopia';
        leadA.importer__c = 'DERCO S.A.';
        leadA.salesChannel__c = 'VIRTUAL';
        leadA.Locales__c = '';
        leadA.Company = 'Compañia';
        leadA.monthsWorked__c = 10;
        leadA.termDescription__c = 'Descripcion Terminos';
        leadA.productCode__c = '10001';
        leadA.loanType__c = 'Validacion';
        leadA.downPaymentPercentage__c = 90;
        leadA.terms__c = 'Terminos';
        leadA.status = 'Nuevo';
        leadA.status__c = 'Nuevo';
        insert leadA;
        Lead leadB = new Lead();
        leadB.FirstName = 'Testing B';
        leadB.lastName = 'Prueba 2';
        leadB.status = 'Nuevo';
        leadB.status__c = 'Nuevo';
        insert leadB;
    }
    @isTest static void testCotizadorLoadData() {
        Lead x = [SELECT Id, carYear__c, MobilePhone FROM Lead WHERE rut__c = '1-9'];
        AMICAR_copyLeadsWS y = new AMICAR_copyLeadsWS(x.Id);
        List<Id> ids = new List<Id>();
        ids.add(x.Id);
        AMICAR_copyLeadsWS.CopiaLeads(ids);
        AMICAR_CopyLeadsWSJSON testData = new AMICAR_CopyLeadsWSJSON();
        System.debug(testdata);
        System.debug(AMICAR_CopyLeadsWSJSON.testJSON());
        AMICAR_CopyLeadsWSJSON.parse(AMICAR_CopyLeadsWSJSON.testJSON());
        x.carYear__c = '2020';
        x.MobilePhone = '22223344';
        update x;
        x.Phone = '23123123';
        x.MobilePhone = '';
        update x;
    }
}