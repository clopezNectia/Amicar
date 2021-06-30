/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase que deserializa JSON de la clase AMICAR_simulacionWSJSON
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 06-10-2020            RL	                   Creación de la Clase.
1.1 06-10-2020			  
***********************************************************************************/

@isTest 
private class AMICAR_simulacionWSJSON_Test {
	
	@isTest
	private static void test1() {
		Test.startTest();
        String json=        '{'+
        '    "transactionId": "A-10382",'+
        '    "customer": {'+
        '        "rut": "247426507",'+
        '        "name": "Roberto",'+
        '        "fatherLastName": "O Higgins",'+
        '        "motherLastName": "De la Cerda",'+
        '        "email": "email@domain.com.co",'+
        '        "phone": "+56977665544",'+
        '        "address": "Colon 125, San Bernardo, Región Metropolitana",'+
        '        "state": "Metropolitana",'+
        '        "province": "Maipo",'+
        '        "city": "San Bernardo",'+
        '        "gender": "MALE",'+
        '        "nationality": "Chileno",'+
        '        "profession": "Médico",'+
        '        "workType": "HIRED",'+
        '        "companyName": "Saysa Ltda",'+
        '        "companyPosition": "Medico",'+
        '        "income": 3000000,'+
        '        "monthsWorked": 18,'+
        '        "dob": "1983-04-11",'+
        '        "workAddress": "Las condes 11000, Vitacura, Región Metropolitana",'+
        '        "maritalStatus": "SINGLE",'+
        '        "academicLevel": "POST_GRADUATE",'+
        '        "livingHousehold": "OWNER"'+
        '    },'+
        '    "vehicle": {'+
        '        "type": "USED_PERSONAL",'+
        '        "brandName": "KIA",'+
        '        "modelName": "MORNING",'+
        '        "version": "EX 1.2 5MT FULL",'+
        '        "year": 2020,'+
        '        "price": 10000000'+
        '    },'+
        '    "loan": {'+
        '        "downPayment": 3000000,'+
        '        "downPaymentPercentage": 30,'+
        '        "type": "CONVENTIONAL",'+
        '        "term": 24,'+
        '        "balance": 7000000,'+
        '        "startDate": "2020-01-02",'+
        '        "firstDueDate": "2020-02-02",'+
        '        "rateType": "NORMAL",'+
        '        "saleChannel": "829957000",'+
        '        "saleChannelType": "IMPORTADOR",'+
        '        "salesRoomId": 1,'+
        '        "immediateOption": false,'+
        '        "accessories": 0,'+
        '        "tradeInCarValue": 0,'+
        '        "modifyTerm": []'+
        '    }'+
        '}';
        AMICAR_simulacionWSJSON obj = AMICAR_simulacionWSJSON.parse(json);
		Test.stopTest();
	}
}