/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase invocable que invoca servicio web "GET" de amicar-assistance
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 01-09-2020            RL	                   Creación de la Clase.
1.1 15-12-2020			  RL					   Modificación de código para pegar "factorCalculated" en vez de value para carga de productos.
***********************************************************************************/

public class AMICAR_GetProductosChecklist  {

	@InvocableMethod(label='amicarAssistanceGET' description='obitene productos relacionados a etapa checklist')
	public static void InvocaServicioGet(List<string> inputParams) {
		String idSol = '';
		String idSolicitud = '';

		List<Opportunity> solicitud= [SELECT Id, Id_Solicitud__c,
									OwnerId, Name
									FROM Opportunity
									WHERE Id =: inputParams];
		 if(solicitud.size() > 0){
			idSol = solicitud[0].Id;
			idSolicitud = solicitud[0].Id_Solicitud__c;
			if (shouldProcessAsync()){
				llamarServicioAmicarAssistanceGet(idSolicitud, idSol);
			}
		 }
  }

	@future(callout=true)
	static void llamarServicioAmicarAssistanceGet(String idSolicitud, String idRegistroSolicitud){
		Transient String responseWs;
		Transient AMICAR_ChecklistGetJSON jsonR;

		String tablaDesarrollo;
		String urlEndpoint;
		String metodo;
		List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id,URL__c,Metodo__c 
															FROM AMICAR_Integracion__mdt 
															WHERE MasterLabel = 'amicarAssistanceStagingGet'];
		//ya que testing aún no está implementada... por ahora va la url de staging
		System.debug('Endpoint = '+endpointSolicitudes[0].URL__c);
		urlEndpoint = endpointSolicitudes[0].URL__c;
		List<API_Keys__mdt> apkey = [SELECT Id,APK__c
									FROM API_Keys__mdt
									WHERE MasterLabel = 'Simulaciones'];


		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpointSolicitudes[0].URL__c + idSolicitud);
		req.setMethod(endpointSolicitudes[0].Metodo__c);
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('x-api-key', apkey[0].APK__c);
		//req.setBody(jsonPut);
		System.debug('Request');
		System.debug(req);
		//System.debug('Body');
		//System.debug(jsonPut);

		HttpResponse res = new HttpResponse();
		if(Test.isRunningTest() && idSolicitud == '10000431'){
			res.setStatusCode(200);
			res.setBody('{"amicarAssistance":['+
			'    {'+
			'        \"id\": 16,'+
			'        \"description\": \"FAMILIA PROTEGIDA\",'+
			'        \"value\": 3490,'+
			'        \"factorCalculated\": 3490,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 17,'+
			'        \"description\": \"GARANTIA MECANICA >5 AÑOS\",'+
			'        \"value\": 6990,'+
			'        \"factorCalculated\": 6990,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 18,'+
			'        \"description\": \"GARANTIA MECANICA\",'+
			'        \"value\": 3590,'+
			'        \"factorCalculated\": 3590,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 19,'+
			'        \"description\": \"NEUMATICOS\",'+
			'        \"value\": 1990,'+
			'        \"factorCalculated\": 1990,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 20,'+
			'        \"description\": \"PROTECAR\",'+
			'        \"value\": 3790,'+
			'        \"factorCalculated\": 3790,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    }'+
			']}');
		}else if(Test.isRunningTest() && idSolicitud=='Test 2'){
			res.setStatusCode(400);
		}else if(Test.isRunningTest() && idSolicitud == 'Test3'){
			res.setStatusCode(200);
			res.setBody('{"amicarAssistance":['+
			'    {'+
			'        \"id\": 16,'+
			'        \"description\": \"FAMILIA PROTEGIDA\",'+
			'        \"value\": 3490,'+
			'        \"factorCalculated\": 3490,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 17,'+
			'        \"description\": \"GARANTIA MECANICA >5 AÑOS\",'+
			'        \"value\": 6990,'+
			'        \"factorCalculated\": 6990,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 18,'+
			'        \"description\": \"GARANTIA MECANICA\",'+
			'        \"value\": 3590,'+
			'        \"factorCalculated\": 3590,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 19,'+
			'        \"description\": \"NEUMATICOS\",'+
			'        \"value\": 1990,'+
			'        \"factorCalculated\": 1990,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    },'+
			'    {'+
			'        \"id\": 20,'+
			'        \"description\": \"PROTECAR\",'+
			'        \"value\": 3790,'+
			'        \"factorCalculated\": 3790,'+
			'        \"isRequired\": false,'+
			'        \"selected\": false'+
			'    }'+
			']}');
		}else{
			res = h.send(req);
		}

		try{		
			if (res.getStatusCode() == 200){
				responseWs = res.getBody();
			}
			else{
				System.debug('ERROR EN LA LLAMADA');
				System.debug('Servicio = '+urlEndpoint+idSolicitud);
				System.debug('Código de Status del Request = '+res.getStatusCode());
				System.debug('Status del Request = '+res.getStatus());
				responseWs = 'ERROR';
			}
		}catch(Exception ex){
			System.debug('ERROR');
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
			responseWs = 'ERROR';
		}

		try{
		if(responseWs != 'ERROR'){
			System.debug(responseWs);
			jsonR = AMICAR_ChecklistGetJSON.parse(responseWs);
			System.debug('RESPUESTA');
			System.debug(jsonR);
		}
		}catch(Exception ex){
			System.debug('ERROR');
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
		}

		if(responseWs != 'ERROR'){
			insertarPrueba(jsonR, idRegistroSolicitud);
		}
	}

	static void insertarPrueba(AMICAR_ChecklistGetJSON jsonR, String idRegistroSolicitud){
		checkProductsAndPricebookentries(jsonR);

		//DAR LOGICA PARA CARGAR PRODUCTOS AMICAR ASSISTANCE EN OPPORTUNITY LINE ITEM
		String familia = 'amicarAssistance';
		List<Product2> prod2List = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND Family =: familia];
		Map<String,Id> mapAmicarAssistance = new Map<String,Id>();
		List<OpportunityLineItem> OppToAdd = new List<OpportunityLineItem>();
		//EJEMPLO CAR ASSIST 5 amicarAssistance
		if(prod2List.size() > 0){
			for (Product2 prod2 : prod2List){
				mapAmicarAssistance.put(prod2.Identificador__c, prod2.Id);
			}

			List<PricebookEntry> ListaEntradas = [SELECT Id,Product2Id FROM PricebookEntry WHERE IsActive = true AND Product2.Family =: familia];
			Map<Id,Id> MapaEntradas = new Map<Id,Id>();

			if (!ListaEntradas.isEmpty()){
				for (PricebookEntry ProductosEntrada:ListaEntradas){
					MapaEntradas.put(ProductosEntrada.Product2Id,ProductosEntrada.Id);
				}
			}

			for(AMICAR_ChecklistGetJSON.AmicarAssistance prod : jsonR.amicarAssistance){
				String clave = prod.description + ' ' + prod.id + ' '+familia;
				OpportunityLineItem OLI = new OpportunityLineItem();
				OLI.Product2Id = mapAmicarAssistance.get(clave);
				OLI.Quantity = 1;
				//Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
				//OLI.Value__c = prod.value;
				OLI.Value__c = prod.factorCalculated;
				//OLI.TotalPrice = prod.value;
				OLI.TotalPrice = prod.factorCalculated;
				//OLI.UnitPrice = prod.factorCalculated;
				OLI.OpportunityId = idRegistroSolicitud;
				OLI.PricebookEntryId = MapaEntradas.get(OLI.Product2Id);
				if(prod.selected){
					OLI.Editable__c = true;
				}else{
					OLI.Editable__c = false;
				}
				OLI.Requerido__c = prod.isRequired;
				OLI.Seleccionado__c = prod.selected;
				OppToAdd.add(OLI);
			}

			if(OppToAdd.size() > 0){
				if(!Test.isRunningTest()){
					insert OppToAdd;
				}
			}
		}
	}

	public Static void checkProductsAndPricebookentries(AMICAR_ChecklistGetJSON jsonR){
		try{
			List<Product2> prodToAdd = new List<Product2>();
			List<PricebookEntry> priceToAdd = new List<PricebookEntry>();
			List<String> productosJsonAmicarAssistance = new List<String>();
			List<String> familias = new List<String>();
			familias.add('amicarAssistance');
        
			List<Product2> prod2List = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND Family IN : familias];
			List<PricebookEntry> pricebookList = [SELECT Id,Product2Id FROM PricebookEntry WHERE IsActive = true AND Product2.Family IN : familias];
		
			Map<String,Id> mapProducts = new Map<String,Id>();
			Map<Id,Id> mapPricebooks = new Map<Id,Id>();

			if(prod2List.size() > 0){
				for(Product2 prod2 : prod2List){
					mapProducts.put(prod2.Identificador__c, prod2.Id);
				}
			}

			if(pricebookList.size() > 0){
				for(PricebookEntry ProductosEntrada:pricebookList){
					mapPricebooks.put(ProductosEntrada.Product2Id,ProductosEntrada.Id);
				}
			}

			//revisar si no existen productos amicarAssistance
			for(AMICAR_ChecklistGetJSON.AmicarAssistance prod : jsonR.amicarAssistance){
				String clave = prod.description + ' ' + prod.id + ' amicarAssistance';
				productosJsonAmicarAssistance.add(clave);
				String idProductSF = mapProducts.get(clave);
				//Si no existe producto, agregarlo en lista
				if(String.isBlank(idProductSF)){
					System.debug('No existe, crear '+clave);
					Product2 prod2 = new Product2();
					prod2.Name = prod.description;
					prod2.Family = 'amicarAssistance';
					prod2.Identificador__c = clave;
					prod2.IsActive = true;
					prod2.ProductCode = String.valueOf(prod.id);
					prodToAdd.add(prod2);
				}else{
					System.debug('Producto '+ clave +' si existe en SF');
				}
			}

			if(prodToAdd.size() > 0){
				if(!Test.isRunningTest()){
					System.debug(prodToAdd);
					insert prodToAdd;
					//for(Product2 prod2 : prodToAdd){
						//String clave = prod2.Name + ' ' + prod2.ProductCode + ' ' + prod2.Family;
						//mapProducts.put(clave, prod2.Id);
					//}
					prod2List = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND Family IN : familias];
					for(Product2 prod2 : prod2List){
						mapProducts.put(prod2.Identificador__c, prod2.Id);
					}
				}
			}
			
			Pricebook2 pb2 = [SELECT Id 
							  FROM Pricebook2 
							  WHERE Name =: 'Standard Price Book'
							  AND IsActive = true];

			//Revisar si existen o no las listas de precio de los productos del JSON amicarAssistanceInsurance
			for(String clave : productosJsonAmicarAssistance){
				String idProd2 = mapProducts.get(clave);
				String idPricebookEntrySF = mapPricebooks.get(idProd2);
				if(String.isEmpty(idPricebookEntrySF)){
					System.debug('Pricebook Id no encontrado = '+clave);
					PricebookEntry price = new PricebookEntry();
					price.UnitPrice = 1;
					price.Product2Id = mapProducts.get(clave);
					price.IsActive = true;
					price.Pricebook2Id = pb2.Id;
					priceToAdd.add(price);
				}else{
					System.debug('Pricebook '+ clave +' si existe en SF');
				}
			}

			if(priceToAdd.size() > 0){
				if(!Test.isRunningTest()){
					insert priceToAdd;
				}
			}
		}catch(Exception ex){
			System.debug('ERROR INSERT PRODUCTOS/PRICEBOOK');
			System.debug(ex.getMessage());
			System.debug(ex.getStackTraceString());
		}
	}
	
	static Boolean shouldProcessAsync(){
		return !system.isFuture() && !system.isBatch() && Limits.getLimitFutureCalls() > Limits.getFutureCalls();
	} 
}