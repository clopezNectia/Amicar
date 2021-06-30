/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que elimina información de solicitud formalizada a Core (paso 2.1, simulación formalizada)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 15-04-2020            RJZ	                   Creación de la Clase.
1.1 05-05-2020            RJZ	                   Pruebas de funcionamiento.
***********************************************************************************/
public class AMICAR_EliminaSimulaciones {

	@InvocableMethod(label='Elimina simulaciones no usadas' description='Elimia simulación')
	public static List<string> ElmininaSimulaciones (List<string> inputParams) {

		System.debug('parametros->'+inputParams);

		List<Quote> listaEliminar = [SELECT Id FROM Quote WHERE OpportunityId =: inputParams AND IsSyncing = false ];
		System.debug('lista a eliminar->'+listaEliminar);

		if (listaEliminar.size() != 0){
			delete listaEliminar;
		}

		List<string> results = new List<string>();
		return results;
	}
}