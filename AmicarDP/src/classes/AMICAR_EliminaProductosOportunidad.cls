/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que elimina información de solicitud formalizada a Core (paso 2.1, simulación formalizada)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 28-05-2020            RJZ	                   Creación de la Clase.
***********************************************************************************/
public class AMICAR_EliminaProductosOportunidad {

	@InvocableMethod(label='Elimina productos no seleccionados' description='Elimina productos')
	public static List<string> AMICAR_EliminaProductosOportunidad(List<string> inputParams) {

		System.debug('parametros->'+inputParams);

		List<OpportunityLineItem> listaEliminar = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: inputParams AND Seleccionado__c = false];
		System.debug('lista a eliminar->'+listaEliminar);

		if (listaEliminar.size() != 0){
			delete listaEliminar;
		}

		List<string> results = new List<string>();
		return results;		
	}
}