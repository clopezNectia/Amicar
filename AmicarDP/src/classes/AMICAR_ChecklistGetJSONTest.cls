/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
       Marcelo Pinto (MPI)
Proyecto: Amicar
Descripción: Clase que deserializa JSON de servicio web "GET" de amicar-assistance
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 01-09-2020            RL	                   Creación de la Clase.
1.1 29-09-2020			  MPI					   Modificación de clase Test.
***********************************************************************************/

@isTest 
private class AMICAR_ChecklistGetJSONTest {

	static testMethod void testParse() {
        String json = '{ \"FinancingEntityInsurance\": [{'+
		'        \"id\": 16,'+
		'        \"description\": \"FAMILIA PROTEGIDA\",'+
		'        \"value\": 3490,'+
		'        \"isRequired\": false,'+
		'        \"selected\": false'+
		'    }],'+
		'    \"AmicarAssistance\": [{'+
		'        \"id\": 17,'+
		'        \"description\": \"GARANTIA MECANICA >5 AÑOS\",'+
		'        \"value\": 6990,'+
		'        \"isRequired\": false,'+
		'        \"selected\": false'+
        '    } ] }';
		AMICAR_ChecklistGetJSON obj = AMICAR_ChecklistGetJSON.parse(json);
		
		Integer id         = obj.FinancingEntityInsurance.get(0).id;
		String description = obj.FinancingEntityInsurance.get(0).description;
		Decimal value      = obj.FinancingEntityInsurance.get(0).value;
		Boolean isRequired = obj.FinancingEntityInsurance.get(0).isRequired;
		Boolean selected   = obj.FinancingEntityInsurance.get(0).selected;
        
        id          = obj.AmicarAssistance.get(0).id;
		description = obj.AmicarAssistance.get(0).description;
		value       = obj.AmicarAssistance.get(0).value;
		isRequired  = obj.AmicarAssistance.get(0).isRequired;
		selected    = obj.AmicarAssistance.get(0).selected;
		
		Rodrigo prueba = new Rodrigo();
		prueba.a = new Account();

		System.assert(obj != null);

	}
}