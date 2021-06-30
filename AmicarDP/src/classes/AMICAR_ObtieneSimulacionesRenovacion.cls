/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que obtiene datos de solicitud y cliente para envio a servicio de Amicar que retorna simulaciones (paso 1, simulación informal)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 06-02-2020            RJZ	                   Creación de la Clase.
1.1 11-03-2020            RJZ	                   Escribe simulaciones en Sf y obtiene información de estado de ejecución del servicio en la solicitud 
													(OK o NOK + respuesta servicio). Se agrega parametro api-key a llamada a servicio.
1.2 11-03-2020            RJZ	                   Se agrega tabla de desarrollo de crédito (cuotas)
1.3 14-05-2020            RJZ	                   Se agrega dealerRate en simulaciones de respuesta del CORE. Se modifica para esto clase 
													AMICAR_Resp_Simulacion_WSJson, se agrega el campo en el objeto y se mapea
***********************************************************************************/
global class AMICAR_ObtieneSimulacionesRenovacion {

	@InvocableMethod(label='Obtener simulaciones renovación' description='Obtiene simulaciones')
	public static List<string> ObtieneSimulacionesRenovacion (List<string> inputParams) {

		Integer retoma;
		String jsonSolicitud;
		
		System.debug('parametros->'+inputParams);
		//System.debug('parametros->'+proceso);

		List<Opportunity> solicitudSalesforce = [SELECT 
												Id,
												OwnerId,
												Name,
												AccountId,
												Tipo_de_Veh_culo__c,
												Precio_vehiculo__c,
												toLabel(Marca_vehiculo__c),
												Modelo__c,
												Modelo2__c,
												Pie__c,
												Pie_formula__c,
												Cuotas__c,
												Tipo_de_tasa__c,
												Opcion_inmediata__c,
												Monto_retoma__c,
												Concesionarios__c,
												Locales__c,
												Importadora__c,
												Vendedor__c,
												Codigo_Concesionario__c,
												Codigo_Importador__c,
												Local__r.Codigo_Local__c
											FROM Opportunity WHERE Id =: inputParams];

		List<Account> clienteSolicitud = [SELECT Id,Name,PersonEmail,PersonMobilePhone,RUT__c 
                                          FROM Account 
                                          WHERE Id =: solicitudSalesforce[0].AccountId];

		List<User> usuarioSolicitud = [SELECT Id,RUT_F_I__c FROM User WHERE Id =: solicitudSalesforce[0].OwnerId];

		List<Vendedor__c> vendedorSolicitud = [SELECT Id,RUT__c FROM Vendedor__c WHERE Id =: solicitudSalesforce[0].Vendedor__c];

		List<Modelo_de_vehiculo__c> modeloSolicitud = [SELECT Id,Name,Codigo_modelo__c FROM Modelo_de_vehiculo__c WHERE Id =: solicitudSalesforce[0].Modelo2__c];

		if (solicitudSalesforce[0].Monto_retoma__c != null){
			retoma = Integer.valueOf(solicitudSalesforce[0].Monto_retoma__c);
		}else{
			retoma = 0;
		}

		Integer balance = Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c) - Integer.valueOf(solicitudSalesforce[0].Pie__c);

		jsonSolicitud = '{'+
							'"transactionId":"'+ solicitudSalesforce[0].Id + '",' +
							'"sellerIdentificationValue":"'+ vendedorSolicitud[0].RUT__c + '",' +
							'"amicarExecutiveIdentificationValue":"'+ usuarioSolicitud[0].RUT_F_I__c + '",' +
							'"customer":{'+
								'"rut":"'+ clienteSolicitud[0].RUT__c + '",' +
								'"email":"'+ clienteSolicitud[0].PersonEmail + '",' +
								'"phone":"'+ clienteSolicitud[0].PersonMobilePhone + '"' +
							'},'+
							'"vehicle":{'+
								'"type":"'+ solicitudSalesforce[0].Tipo_de_Veh_culo__c + '",' +
								'"price":'+ Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c) + ',' +
								'"brandName":"'+solicitudSalesforce[0].Marca_vehiculo__c + '",' +
								'"modelName":"'+modeloSolicitud[0].Name + '"' +
							'},'+
							'"loan":{'+
								'"downPayment":'+ Integer.valueOf(solicitudSalesforce[0].Pie__c) + ',' +
								'"downPaymentPercentage":'+ Integer.valueOf(solicitudSalesforce[0].Pie_formula__c) + ',' +
								'"term":'+ Integer.valueOf(solicitudSalesforce[0].Cuotas__c) + ',' +
								'"balance":'+ balance +',' +
								'"startDate":"'+ String.valueOf(System.today()) + '",' +
								'"firstDueDate":"'+ String.valueOf(System.today()+30) + '",' +
								'"rateType":"NORMAL",' +
								'"saleChannel":"'+ solicitudSalesforce[0].Codigo_Importador__c + '",'+ 
								'"saleChannelType": "IMPORTADOR",'+
								'"salesRoomId":'+ Integer.valueOf(solicitudSalesforce[0].Local__r.Codigo_Local__c) + ',' +
								'"immediateOption":'+ solicitudSalesforce[0].Opcion_inmediata__c + ',' +
								'"tradeInCarValue":'+ retoma + ',' +
								'"accessories": 0,'+
								'"modifyTerm": []'+
							'}'+
						'}';

		System.debug('json->'+jsonSolicitud);
		
		// llamada a metodo futuro para envio a servicio
		Id id_oportunidad = inputParams[0];
		String tipoDeTasa = solicitudSalesforce[0].Tipo_de_tasa__c;
		
		envioServicio(jsonSolicitud,id_oportunidad,tipoDeTasa);

		List<string> results = new List<string>();
		return results;
	}

	@future(callout=true)
	static void envioServicio(String jsonEnvio, Id solicitudId, String tipoTasa){

		String resultadoServcio;
		String tablaDesarrollo;

		List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id, URL__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'Simulaciones'];
		System.debug('endpoint->'+endpointSolicitudes[0].URL__c);

		List<API_Keys__mdt> apkey = [SELECT Id,APK__c
									 FROM API_Keys__mdt
									 WHERE MasterLabel = 'Simulaciones'];

		//
		// Generación request a servicio AMICAR
		//----------------------------------------------------------------------------------
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpointSolicitudes[0].URL__c);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('x-api-key', apkey[0].APK__c);
		request.setBody(jsonEnvio);
		System.debug('request->'+request);

		HttpResponse response = new HttpResponse();

		if (!Test.isRunningTest()){
			response = http.send(request);
		}else{
			response.setStatusCode(200);
			response.setStatus('OK');
			//response.setBody('[{"finalLoanValues":{"loanType":"CONVENTIONAL","term":24,"balance":7000000,"UFValue":28341.91,"totalSurchargesToMAF":260000,"totalSurchargesToQuote":0,"factorTotal":0.945,"promissoryFactor":0.008,"promissoryValue":61460,"totalToFinance":7682540,"totalToFinanceUF":271.07,"finalCapital":7686586,"daysDelayedFirstDue":31,"delayedInterest":4046,"monthlyPayment":387321,"costumerRate":1.58,"dealerCommission":301450,"amicarCommission":541135},"equivalentAnnualCharge":{"annualCAE":28.86,"monthlyCAE":2.4,"totalLoanCost":9295699},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-02-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":7686586,"principal":265873,"interest":121448,"endingBalance":7420713,"cumulativeInterest":121448},{"paymentNumber":2,"expirationDate":"2020-03-02","daysBetweenExpirationsDates":29,"payment":387321,"beginningBalance":7420713,"principal":270074,"interest":117247,"endingBalance":7150640,"cumulativeInterest":238695},{"paymentNumber":3,"expirationDate":"2020-04-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":7150640,"principal":274341,"interest":112980,"endingBalance":6876299,"cumulativeInterest":351675},{"paymentNumber":4,"expirationDate":"2020-05-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":6876299,"principal":278675,"interest":108646,"endingBalance":6597624,"cumulativeInterest":460321},{"paymentNumber":5,"expirationDate":"2020-06-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":6597624,"principal":283078,"interest":104242,"endingBalance":6314545,"cumulativeInterest":564563},{"paymentNumber":6,"expirationDate":"2020-07-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":6314545,"principal":287551,"interest":99770,"endingBalance":6026994,"cumulativeInterest":664333},{"paymentNumber":7,"expirationDate":"2020-08-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":6026994,"principal":292094,"interest":95227,"endingBalance":5734900,"cumulativeInterest":759560},{"paymentNumber":8,"expirationDate":"2020-09-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":5734900,"principal":296709,"interest":90611,"endingBalance":5438191,"cumulativeInterest":850171},{"paymentNumber":9,"expirationDate":"2020-10-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":5438191,"principal":301397,"interest":85923,"endingBalance":5136793,"cumulativeInterest":936095},{"paymentNumber":10,"expirationDate":"2020-11-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":5136793,"principal":306159,"interest":81161,"endingBalance":4830634,"cumulativeInterest":1017256},{"paymentNumber":11,"expirationDate":"2020-12-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":4830634,"principal":310997,"interest":76324,"endingBalance":4519637,"cumulativeInterest":1093580},{"paymentNumber":12,"expirationDate":"2021-01-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":4519637,"principal":315911,"interest":71410,"endingBalance":4203727,"cumulativeInterest":1164990},{"paymentNumber":13,"expirationDate":"2021-02-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":4203727,"principal":320902,"interest":66419,"endingBalance":3882825,"cumulativeInterest":1231409},{"paymentNumber":14,"expirationDate":"2021-03-02","daysBetweenExpirationsDates":28,"payment":387321,"beginningBalance":3882825,"principal":325972,"interest":61349,"endingBalance":3556852,"cumulativeInterest":1292758},{"paymentNumber":15,"expirationDate":"2021-04-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":3556852,"principal":331123,"interest":56198,"endingBalance":3225730,"cumulativeInterest":1348956},{"paymentNumber":16,"expirationDate":"2021-05-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":3225730,"principal":336354,"interest":50967,"endingBalance":2889376,"cumulativeInterest":1399923},{"paymentNumber":17,"expirationDate":"2021-06-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":2889376,"principal":341669,"interest":45652,"endingBalance":2547707,"cumulativeInterest":1445575},{"paymentNumber":18,"expirationDate":"2021-07-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":2547707,"principal":347067,"interest":40254,"endingBalance":2200640,"cumulativeInterest":1485828},{"paymentNumber":19,"expirationDate":"2021-08-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":2200640,"principal":352551,"interest":34770,"endingBalance":1848089,"cumulativeInterest":1520599},{"paymentNumber":20,"expirationDate":"2021-09-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":1848089,"principal":358121,"interest":29200,"endingBalance":1489968,"cumulativeInterest":1549798},{"paymentNumber":21,"expirationDate":"2021-10-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":1489968,"principal":363779,"interest":23541,"endingBalance":1126189,"cumulativeInterest":1573340},{"paymentNumber":22,"expirationDate":"2021-11-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":1126189,"principal":369527,"interest":17794,"endingBalance":756662,"cumulativeInterest":1591134},{"paymentNumber":23,"expirationDate":"2021-12-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":756662,"principal":375366,"interest":11955,"endingBalance":381296,"cumulativeInterest":1603089},{"paymentNumber":24,"expirationDate":"2022-01-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":381296,"principal":381296,"interest":6024,"endingBalance":0,"cumulativeInterest":1609113}],"surchargesAndInsurances":{"dealerSurcharges":[{"id":2,"description":"Inscripción","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":8,"description":"Permiso Circulación","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false}],"financingEntitySurcharges":[{"id":11,"description":"GASTOS OPERACIONALES","value":260000,"isEditable":false,"currencyType":"CLP","factorCalculated":260000,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntityInsurance":[{"id":3,"description":"DESGRAVAMEN","value":47,"currencyType":"CLP","valueCalculated":361079,"selected":true,"isRequired":true}],"amicarAssistance":[{"id":1,"description":"Car Assist","value":3490,"currencyType":"CLP","factorCalculated":3490,"selected":false,"isRequired":false},{"id":2,"description":"Proteccion Neumaticos","value":1990,"currencyType":"CLP","factorCalculated":1990,"selected":false,"isRequired":false},{"id":3,"description":"Protecar (Robo Contenido)","value":3790,"currencyType":"CLP","factorCalculated":3790,"selected":false,"isRequired":false},{"id":4,"description":"Garantía Mecánica","value":3590,"currencyType":"CLP","factorCalculated":3590,"selected":false,"isRequired":false}]}},{"finalLoanValues":{"loanType":"CONVENTIONAL","term":36,"balance":7000000,"UFValue":28341.91,"totalSurchargesToMAF":325000,"totalSurchargesToQuote":0,"factorTotal":0.944,"promissoryFactor":0.008,"promissoryValue":62076,"totalToFinance":7759534,"totalToFinanceUF":273.78,"finalCapital":7763621,"daysDelayedFirstDue":31,"delayedInterest":4087,"monthlyPayment":284426,"costumerRate":1.58,"dealerCommission":413336,"amicarCommission":799329},"equivalentAnnualCharge":{"annualCAE":26.64,"monthlyCAE":2.22,"totalLoanCost":10239353},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-02-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":7763621,"principal":161761,"interest":122665,"endingBalance":7601860,"cumulativeInterest":122665},{"paymentNumber":2,"expirationDate":"2020-03-02","daysBetweenExpirationsDates":29,"payment":284426,"beginningBalance":7601860,"principal":164317,"interest":120109,"endingBalance":7437543,"cumulativeInterest":242775},{"paymentNumber":3,"expirationDate":"2020-04-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":7437543,"principal":166913,"interest":117513,"endingBalance":7270629,"cumulativeInterest":360288},{"paymentNumber":4,"expirationDate":"2020-05-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":7270629,"principal":169551,"interest":114876,"endingBalance":7101079,"cumulativeInterest":475164},{"paymentNumber":5,"expirationDate":"2020-06-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":7101079,"principal":172229,"interest":112197,"endingBalance":6928849,"cumulativeInterest":587361},{"paymentNumber":6,"expirationDate":"2020-07-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":6928849,"principal":174951,"interest":109476,"endingBalance":6753899,"cumulativeInterest":696837},{"paymentNumber":7,"expirationDate":"2020-08-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":6753899,"principal":177715,"interest":106712,"endingBalance":6576184,"cumulativeInterest":803548},{"paymentNumber":8,"expirationDate":"2020-09-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":6576184,"principal":180523,"interest":103904,"endingBalance":6395661,"cumulativeInterest":907452},{"paymentNumber":9,"expirationDate":"2020-10-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":6395661,"principal":183375,"interest":101051,"endingBalance":6212286,"cumulativeInterest":1008503},{"paymentNumber":10,"expirationDate":"2020-11-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":6212286,"principal":186272,"interest":98154,"endingBalance":6026014,"cumulativeInterest":1106657},{"paymentNumber":11,"expirationDate":"2020-12-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":6026014,"principal":189215,"interest":95211,"endingBalance":5836798,"cumulativeInterest":1201868},{"paymentNumber":12,"expirationDate":"2021-01-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":5836798,"principal":192205,"interest":92221,"endingBalance":5644593,"cumulativeInterest":1294090},{"paymentNumber":13,"expirationDate":"2021-02-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":5644593,"principal":195242,"interest":89185,"endingBalance":5449351,"cumulativeInterest":1383274},{"paymentNumber":14,"expirationDate":"2021-03-02","daysBetweenExpirationsDates":28,"payment":284426,"beginningBalance":5449351,"principal":198327,"interest":86100,"endingBalance":5251025,"cumulativeInterest":1469374},{"paymentNumber":15,"expirationDate":"2021-04-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":5251025,"principal":201460,"interest":82966,"endingBalance":5049565,"cumulativeInterest":1552340},{"paymentNumber":16,"expirationDate":"2021-05-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":5049565,"principal":204643,"interest":79783,"endingBalance":4844921,"cumulativeInterest":1632124},{"paymentNumber":17,"expirationDate":"2021-06-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":4844921,"principal":207877,"interest":76550,"endingBalance":4637044,"cumulativeInterest":1708673},{"paymentNumber":18,"expirationDate":"2021-07-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":4637044,"principal":211161,"interest":73265,"endingBalance":4425883,"cumulativeInterest":1781939},{"paymentNumber":19,"expirationDate":"2021-08-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":4425883,"principal":214498,"interest":69929,"endingBalance":4211386,"cumulativeInterest":1851868},{"paymentNumber":20,"expirationDate":"2021-09-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":4211386,"principal":217887,"interest":66540,"endingBalance":3993499,"cumulativeInterest":1918407},{"paymentNumber":21,"expirationDate":"2021-10-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":3993499,"principal":221329,"interest":63097,"endingBalance":3772170,"cumulativeInterest":1981505},{"paymentNumber":22,"expirationDate":"2021-11-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":3772170,"principal":224826,"interest":59600,"endingBalance":3547344,"cumulativeInterest":2041105},{"paymentNumber":23,"expirationDate":"2021-12-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":3547344,"principal":228378,"interest":56048,"endingBalance":3318965,"cumulativeInterest":2097153},{"paymentNumber":24,"expirationDate":"2022-01-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":3318965,"principal":231987,"interest":52440,"endingBalance":3086979,"cumulativeInterest":2149593},{"paymentNumber":25,"expirationDate":"2022-02-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":3086979,"principal":235652,"interest":48774,"endingBalance":2851326,"cumulativeInterest":2198367},{"paymentNumber":26,"expirationDate":"2022-03-02","daysBetweenExpirationsDates":28,"payment":284426,"beginningBalance":2851326,"principal":239376,"interest":45051,"endingBalance":2611951,"cumulativeInterest":2243418},{"paymentNumber":27,"expirationDate":"2022-04-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":2611951,"principal":243158,"interest":41269,"endingBalance":2368793,"cumulativeInterest":2284687},{"paymentNumber":28,"expirationDate":"2022-05-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":2368793,"principal":247000,"interest":37427,"endingBalance":2121794,"cumulativeInterest":2322114},{"paymentNumber":29,"expirationDate":"2022-06-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":2121794,"principal":250902,"interest":33524,"endingBalance":1870892,"cumulativeInterest":2355638},{"paymentNumber":30,"expirationDate":"2022-07-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":1870892,"principal":254866,"interest":29560,"endingBalance":1616025,"cumulativeInterest":2385198},{"paymentNumber":31,"expirationDate":"2022-08-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":1616025,"principal":258893,"interest":25533,"endingBalance":1357132,"cumulativeInterest":2410731},{"paymentNumber":32,"expirationDate":"2022-09-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":1357132,"principal":262984,"interest":21443,"endingBalance":1094148,"cumulativeInterest":2432174},{"paymentNumber":33,"expirationDate":"2022-10-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":1094148,"principal":267139,"interest":17288,"endingBalance":827009,"cumulativeInterest":2449462},{"paymentNumber":34,"expirationDate":"2022-11-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":827009,"principal":271360,"interest":13067,"endingBalance":555650,"cumulativeInterest":2462528},{"paymentNumber":35,"expirationDate":"2022-12-02","daysBetweenExpirationsDates":30,"payment":284426,"beginningBalance":555650,"principal":275647,"interest":8779,"endingBalance":280002,"cumulativeInterest":2471308},{"paymentNumber":36,"expirationDate":"2023-01-02","daysBetweenExpirationsDates":31,"payment":284426,"beginningBalance":280002,"principal":280002,"interest":4424,"endingBalance":0,"cumulativeInterest":2475732}],"surchargesAndInsurances":{"dealerSurcharges":[{"id":2,"description":"Inscripción","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":8,"description":"Permiso Circulación","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false}],"financingEntitySurcharges":[{"id":34,"description":"GASTOS OPERACIONALES","value":325000,"isEditable":false,"currencyType":"CLP","factorCalculated":325000,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntityInsurance":[{"id":4,"description":"DESGRAVAMEN","value":48,"currencyType":"CLP","valueCalculated":372458,"selected":true,"isRequired":true}],"amicarAssistance":[{"id":1,"description":"Car Assist","value":3490,"currencyType":"CLP","factorCalculated":3490,"selected":false,"isRequired":false},{"id":2,"description":"Proteccion Neumaticos","value":1990,"currencyType":"CLP","factorCalculated":1990,"selected":false,"isRequired":false},{"id":3,"description":"Protecar (Robo Contenido)","value":3790,"currencyType":"CLP","factorCalculated":3790,"selected":false,"isRequired":false},{"id":4,"description":"Garantía Mecánica","value":3590,"currencyType":"CLP","factorCalculated":3590,"selected":false,"isRequired":false}]}},{"finalLoanValues":{"loanType":"SMART","term":24,"balance":7000000,"UFValue":28341.91,"totalSurchargesToMAF":260000,"totalSurchargesToQuote":0,"factorTotal":0.945,"promissoryFactor":0.008,"promissoryValue":61460,"totalToFinance":7682540,"totalToFinanceUF":271.07,"finalCapital":7686586,"daysDelayedFirstDue":31,"delayedInterest":4046,"monthlyPayment":217065,"costumerRate":1.58,"dealerCommission":271884,"amicarCommission":823165},"equivalentAnnualCharge":{"annualCAE":25.54,"monthlyCAE":2.13,"totalLoanCost":10209558},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-02-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":7686586,"principal":95617,"interest":121448,"endingBalance":7590969,"cumulativeInterest":121448},{"paymentNumber":2,"expirationDate":"2020-03-02","daysBetweenExpirationsDates":29,"payment":217065,"beginningBalance":7590969,"principal":97128,"interest":119937,"endingBalance":7493842,"cumulativeInterest":241385},{"paymentNumber":3,"expirationDate":"2020-04-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":7493842,"principal":98662,"interest":118403,"endingBalance":7395179,"cumulativeInterest":359788},{"paymentNumber":4,"expirationDate":"2020-05-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":7395179,"principal":100221,"interest":116844,"endingBalance":7294958,"cumulativeInterest":476632},{"paymentNumber":5,"expirationDate":"2020-06-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":7294958,"principal":101805,"interest":115260,"endingBalance":7193154,"cumulativeInterest":591892},{"paymentNumber":6,"expirationDate":"2020-07-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":7193154,"principal":103413,"interest":113652,"endingBalance":7089741,"cumulativeInterest":705544},{"paymentNumber":7,"expirationDate":"2020-08-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":7089741,"principal":105047,"interest":112018,"endingBalance":6984694,"cumulativeInterest":817562},{"paymentNumber":8,"expirationDate":"2020-09-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":6984694,"principal":106707,"interest":110358,"endingBalance":6877987,"cumulativeInterest":927920},{"paymentNumber":9,"expirationDate":"2020-10-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":6877987,"principal":108393,"interest":108672,"endingBalance":6769594,"cumulativeInterest":1036592},{"paymentNumber":10,"expirationDate":"2020-11-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":6769594,"principal":110105,"interest":106960,"endingBalance":6659489,"cumulativeInterest":1143552},{"paymentNumber":11,"expirationDate":"2020-12-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":6659489,"principal":111845,"interest":105220,"endingBalance":6547644,"cumulativeInterest":1248772},{"paymentNumber":12,"expirationDate":"2021-01-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":6547644,"principal":113612,"interest":103453,"endingBalance":6434032,"cumulativeInterest":1352225},{"paymentNumber":13,"expirationDate":"2021-02-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":6434032,"principal":115407,"interest":101658,"endingBalance":6318624,"cumulativeInterest":1453882},{"paymentNumber":14,"expirationDate":"2021-03-02","daysBetweenExpirationsDates":28,"payment":217065,"beginningBalance":6318624,"principal":117231,"interest":99834,"endingBalance":6201394,"cumulativeInterest":1553717},{"paymentNumber":15,"expirationDate":"2021-04-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":6201394,"principal":119083,"interest":97982,"endingBalance":6082311,"cumulativeInterest":1651699},{"paymentNumber":16,"expirationDate":"2021-05-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":6082311,"principal":120964,"interest":96101,"endingBalance":5961346,"cumulativeInterest":1747799},{"paymentNumber":17,"expirationDate":"2021-06-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":5961346,"principal":122876,"interest":94189,"endingBalance":5838471,"cumulativeInterest":1841988},{"paymentNumber":18,"expirationDate":"2021-07-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":5838471,"principal":124817,"interest":92248,"endingBalance":5713654,"cumulativeInterest":1934236},{"paymentNumber":19,"expirationDate":"2021-08-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":5713654,"principal":126789,"interest":90276,"endingBalance":5586864,"cumulativeInterest":2024512},{"paymentNumber":20,"expirationDate":"2021-09-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":5586864,"principal":128792,"interest":88272,"endingBalance":5458072,"cumulativeInterest":2112784},{"paymentNumber":21,"expirationDate":"2021-10-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":5458072,"principal":130827,"interest":86238,"endingBalance":5327245,"cumulativeInterest":2199022},{"paymentNumber":22,"expirationDate":"2021-11-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":5327245,"principal":132894,"interest":84170,"endingBalance":5194350,"cumulativeInterest":2283192},{"paymentNumber":23,"expirationDate":"2021-12-02","daysBetweenExpirationsDates":30,"payment":217065,"beginningBalance":5194350,"principal":134994,"interest":82071,"endingBalance":5059356,"cumulativeInterest":2365263},{"paymentNumber":24,"expirationDate":"2022-01-02","daysBetweenExpirationsDates":31,"payment":217065,"beginningBalance":5059356,"principal":137127,"interest":79938,"endingBalance":4922229,"cumulativeInterest":2445201},{"paymentNumber":25,"expirationDate":"2022-02-02","daysBetweenExpirationsDates":31,"payment":5000000,"beginningBalance":4922229,"principal":4922229,"interest":77771,"endingBalance":0,"cumulativeInterest":2522972}],"surchargesAndInsurances":{"dealerSurcharges":[{"id":2,"description":"Inscripción","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":8,"description":"Permiso Circulación","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false}],"financingEntitySurcharges":[{"id":68,"description":"GASTOS OPERACIONALES","value":260000,"isEditable":false,"currencyType":"CLP","factorCalculated":260000,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntityInsurance":[{"id":3,"description":"DESGRAVAMEN","value":47,"currencyType":"CLP","valueCalculated":361079,"selected":true,"isRequired":true}],"amicarAssistance":[{"id":1,"description":"Car Assist","value":3490,"currencyType":"CLP","factorCalculated":3490,"selected":false,"isRequired":false},{"id":2,"description":"Proteccion Neumaticos","value":1990,"currencyType":"CLP","factorCalculated":1990,"selected":false,"isRequired":false},{"id":3,"description":"Protecar (Robo Contenido)","value":3790,"currencyType":"CLP","factorCalculated":3790,"selected":false,"isRequired":false},{"id":4,"description":"Garantía Mecánica","value":3590,"currencyType":"CLP","factorCalculated":3590,"selected":false,"isRequired":false}]}},{"finalLoanValues":{"loanType":"SMART","term":36,"balance":7000000,"UFValue":28341.91,"totalSurchargesToMAF":325000,"totalSurchargesToQuote":0,"factorTotal":0.944,"promissoryFactor":0.008,"promissoryValue":62076,"totalToFinance":7759534,"totalToFinanceUF":273.78,"finalCapital":7763621,"daysDelayedFirstDue":31,"delayedInterest":4087,"monthlyPayment":202380,"costumerRate":1.58,"dealerCommission":411992,"amicarCommission":1097123},"equivalentAnnualCharge":{"annualCAE":24.64,"monthlyCAE":2.05,"totalLoanCost":11285666},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-02-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":7763621,"principal":79714,"interest":122665,"endingBalance":7683907,"cumulativeInterest":122665},{"paymentNumber":2,"expirationDate":"2020-03-02","daysBetweenExpirationsDates":29,"payment":202380,"beginningBalance":7683907,"principal":80974,"interest":121406,"endingBalance":7602933,"cumulativeInterest":244071},{"paymentNumber":3,"expirationDate":"2020-04-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":7602933,"principal":82253,"interest":120126,"endingBalance":7520679,"cumulativeInterest":364197},{"paymentNumber":4,"expirationDate":"2020-05-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":7520679,"principal":83553,"interest":118827,"endingBalance":7437127,"cumulativeInterest":483024},{"paymentNumber":5,"expirationDate":"2020-06-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":7437127,"principal":84873,"interest":117507,"endingBalance":7352254,"cumulativeInterest":600531},{"paymentNumber":6,"expirationDate":"2020-07-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":7352254,"principal":86214,"interest":116166,"endingBalance":7266040,"cumulativeInterest":716696},{"paymentNumber":7,"expirationDate":"2020-08-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":7266040,"principal":87576,"interest":114803,"endingBalance":7178463,"cumulativeInterest":831500},{"paymentNumber":8,"expirationDate":"2020-09-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":7178463,"principal":88960,"interest":113420,"endingBalance":7089504,"cumulativeInterest":944919},{"paymentNumber":9,"expirationDate":"2020-10-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":7089504,"principal":90365,"interest":112014,"endingBalance":6999138,"cumulativeInterest":1056934},{"paymentNumber":10,"expirationDate":"2020-11-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6999138,"principal":91793,"interest":110586,"endingBalance":6907345,"cumulativeInterest":1167520},{"paymentNumber":11,"expirationDate":"2020-12-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":6907345,"principal":93244,"interest":109136,"endingBalance":6814101,"cumulativeInterest":1276656},{"paymentNumber":12,"expirationDate":"2021-01-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6814101,"principal":94717,"interest":107663,"endingBalance":6719385,"cumulativeInterest":1384319},{"paymentNumber":13,"expirationDate":"2021-02-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6719385,"principal":96213,"interest":106166,"endingBalance":6623171,"cumulativeInterest":1490485},{"paymentNumber":14,"expirationDate":"2021-03-02","daysBetweenExpirationsDates":28,"payment":202380,"beginningBalance":6623171,"principal":97733,"interest":104646,"endingBalance":6525438,"cumulativeInterest":1595131},{"paymentNumber":15,"expirationDate":"2021-04-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6525438,"principal":99278,"interest":103102,"endingBalance":6426160,"cumulativeInterest":1698233},{"paymentNumber":16,"expirationDate":"2021-05-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":6426160,"principal":100846,"interest":101533,"endingBalance":6325314,"cumulativeInterest":1799766},{"paymentNumber":17,"expirationDate":"2021-06-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6325314,"principal":102440,"interest":99940,"endingBalance":6222874,"cumulativeInterest":1899706},{"paymentNumber":18,"expirationDate":"2021-07-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":6222874,"principal":104058,"interest":98321,"endingBalance":6118816,"cumulativeInterest":1998028},{"paymentNumber":19,"expirationDate":"2021-08-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6118816,"principal":105702,"interest":96677,"endingBalance":6013114,"cumulativeInterest":2094705},{"paymentNumber":20,"expirationDate":"2021-09-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":6013114,"principal":107372,"interest":95007,"endingBalance":5905741,"cumulativeInterest":2189712},{"paymentNumber":21,"expirationDate":"2021-10-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":5905741,"principal":109069,"interest":93311,"endingBalance":5796672,"cumulativeInterest":2283023},{"paymentNumber":22,"expirationDate":"2021-11-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":5796672,"principal":110792,"interest":91587,"endingBalance":5685880,"cumulativeInterest":2374610},{"paymentNumber":23,"expirationDate":"2021-12-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":5685880,"principal":112543,"interest":89837,"endingBalance":5573337,"cumulativeInterest":2464447},{"paymentNumber":24,"expirationDate":"2022-01-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":5573337,"principal":114321,"interest":88059,"endingBalance":5459016,"cumulativeInterest":2552506},{"paymentNumber":25,"expirationDate":"2022-02-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":5459016,"principal":116127,"interest":86252,"endingBalance":5342889,"cumulativeInterest":2638758},{"paymentNumber":26,"expirationDate":"2022-03-02","daysBetweenExpirationsDates":28,"payment":202380,"beginningBalance":5342889,"principal":117962,"interest":84418,"endingBalance":5224927,"cumulativeInterest":2723176},{"paymentNumber":27,"expirationDate":"2022-04-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":5224927,"principal":119826,"interest":82554,"endingBalance":5105102,"cumulativeInterest":2805730},{"paymentNumber":28,"expirationDate":"2022-05-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":5105102,"principal":121719,"interest":80661,"endingBalance":4983383,"cumulativeInterest":2886391},{"paymentNumber":29,"expirationDate":"2022-06-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":4983383,"principal":123642,"interest":78737,"endingBalance":4859740,"cumulativeInterest":2965128},{"paymentNumber":30,"expirationDate":"2022-07-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":4859740,"principal":125596,"interest":76784,"endingBalance":4734145,"cumulativeInterest":3041912},{"paymentNumber":31,"expirationDate":"2022-08-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":4734145,"principal":127580,"interest":74799,"endingBalance":4606565,"cumulativeInterest":3116711},{"paymentNumber":32,"expirationDate":"2022-09-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":4606565,"principal":129596,"interest":72784,"endingBalance":4476969,"cumulativeInterest":3189495},{"paymentNumber":33,"expirationDate":"2022-10-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":4476969,"principal":131643,"interest":70736,"endingBalance":4345325,"cumulativeInterest":3260231},{"paymentNumber":34,"expirationDate":"2022-11-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":4345325,"principal":133723,"interest":68656,"endingBalance":4211602,"cumulativeInterest":3328887},{"paymentNumber":35,"expirationDate":"2022-12-02","daysBetweenExpirationsDates":30,"payment":202380,"beginningBalance":4211602,"principal":135836,"interest":66543,"endingBalance":4075766,"cumulativeInterest":3395431},{"paymentNumber":36,"expirationDate":"2023-01-02","daysBetweenExpirationsDates":31,"payment":202380,"beginningBalance":4075766,"principal":137983,"interest":64397,"endingBalance":3937783,"cumulativeInterest":3459828},{"paymentNumber":37,"expirationDate":"2023-02-02","daysBetweenExpirationsDates":31,"payment":4000000,"beginningBalance":3937783,"principal":3937783,"interest":62217,"endingBalance":0,"cumulativeInterest":3522045}],"surchargesAndInsurances":{"dealerSurcharges":[{"id":2,"description":"Inscripción","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":8,"description":"Permiso Circulación","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false}],"financingEntitySurcharges":[{"id":91,"description":"GASTOS OPERACIONALES","value":325000,"isEditable":false,"currencyType":"CLP","factorCalculated":325000,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntityInsurance":[{"id":4,"description":"DESGRAVAMEN","value":48,"currencyType":"CLP","valueCalculated":372458,"selected":true,"isRequired":true}],"amicarAssistance":[{"id":1,"description":"Car Assist","value":3490,"currencyType":"CLP","factorCalculated":3490,"selected":false,"isRequired":false},{"id":2,"description":"Proteccion Neumaticos","value":1990,"currencyType":"CLP","factorCalculated":1990,"selected":false,"isRequired":false},{"id":3,"description":"Protecar (Robo Contenido)","value":3790,"currencyType":"CLP","factorCalculated":3790,"selected":false,"isRequired":false},{"id":4,"description":"Garantía Mecánica","value":3590,"currencyType":"CLP","factorCalculated":3590,"selected":false,"isRequired":false}]}}]');
			response.setBody('[{"finalLoanValues":{"loanType":"CONVENTIONAL","term":24,"balance":7000000,"UFValue":28341.91,"totalSurchargesToMAF":260000,"totalSurchargesToQuote":0,"factorTotal":0.945,"promissoryFactor":0.008,"promissoryValue":61460,"totalToFinance":7682540,"totalToFinanceUF":271.07,"rateType":"CONVENTIONAL_COMMERCIAL_NORMAL","finalCapital":7686586,"daysDelayedFirstDue":31,"delayedInterest":4046,"monthlyPayment":387321,"costumerRate":1.58,"dealerCommission":301450,"amicarCommission":541135},"equivalentAnnualCharge":{"annualCAE":28.86,"monthlyCAE":2.4,"totalLoanCost":9295699},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-02-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":7686586,"principal":265873,"interest":121448,"endingBalance":7420713,"cumulativeInterest":121448},{"paymentNumber":2,"expirationDate":"2020-03-02","daysBetweenExpirationsDates":29,"payment":387321,"beginningBalance":7420713,"principal":270074,"interest":117247,"endingBalance":7150640,"cumulativeInterest":238695},{"paymentNumber":3,"expirationDate":"2020-04-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":7150640,"principal":274341,"interest":112980,"endingBalance":6876299,"cumulativeInterest":351675},{"paymentNumber":4,"expirationDate":"2020-05-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":6876299,"principal":278675,"interest":108646,"endingBalance":6597624,"cumulativeInterest":460321},{"paymentNumber":5,"expirationDate":"2020-06-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":6597624,"principal":283078,"interest":104242,"endingBalance":6314545,"cumulativeInterest":564563},{"paymentNumber":6,"expirationDate":"2020-07-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":6314545,"principal":287551,"interest":99770,"endingBalance":6026994,"cumulativeInterest":664333},{"paymentNumber":7,"expirationDate":"2020-08-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":6026994,"principal":292094,"interest":95227,"endingBalance":5734900,"cumulativeInterest":759560},{"paymentNumber":8,"expirationDate":"2020-09-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":5734900,"principal":296709,"interest":90611,"endingBalance":5438191,"cumulativeInterest":850171},{"paymentNumber":9,"expirationDate":"2020-10-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":5438191,"principal":301397,"interest":85923,"endingBalance":5136793,"cumulativeInterest":936095},{"paymentNumber":10,"expirationDate":"2020-11-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":5136793,"principal":306159,"interest":81161,"endingBalance":4830634,"cumulativeInterest":1017256},{"paymentNumber":11,"expirationDate":"2020-12-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":4830634,"principal":310997,"interest":76324,"endingBalance":4519637,"cumulativeInterest":1093580},{"paymentNumber":12,"expirationDate":"2021-01-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":4519637,"principal":315911,"interest":71410,"endingBalance":4203727,"cumulativeInterest":1164990},{"paymentNumber":13,"expirationDate":"2021-02-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":4203727,"principal":320902,"interest":66419,"endingBalance":3882825,"cumulativeInterest":1231409},{"paymentNumber":14,"expirationDate":"2021-03-02","daysBetweenExpirationsDates":28,"payment":387321,"beginningBalance":3882825,"principal":325972,"interest":61349,"endingBalance":3556852,"cumulativeInterest":1292758},{"paymentNumber":15,"expirationDate":"2021-04-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":3556852,"principal":331123,"interest":56198,"endingBalance":3225730,"cumulativeInterest":1348956},{"paymentNumber":16,"expirationDate":"2021-05-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":3225730,"principal":336354,"interest":50967,"endingBalance":2889376,"cumulativeInterest":1399923},{"paymentNumber":17,"expirationDate":"2021-06-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":2889376,"principal":341669,"interest":45652,"endingBalance":2547707,"cumulativeInterest":1445575},{"paymentNumber":18,"expirationDate":"2021-07-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":2547707,"principal":347067,"interest":40254,"endingBalance":2200640,"cumulativeInterest":1485828},{"paymentNumber":19,"expirationDate":"2021-08-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":2200640,"principal":352551,"interest":34770,"endingBalance":1848089,"cumulativeInterest":1520599},{"paymentNumber":20,"expirationDate":"2021-09-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":1848089,"principal":358121,"interest":29200,"endingBalance":1489968,"cumulativeInterest":1549798},{"paymentNumber":21,"expirationDate":"2021-10-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":1489968,"principal":363779,"interest":23541,"endingBalance":1126189,"cumulativeInterest":1573340},{"paymentNumber":22,"expirationDate":"2021-11-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":1126189,"principal":369527,"interest":17794,"endingBalance":756662,"cumulativeInterest":1591134},{"paymentNumber":23,"expirationDate":"2021-12-02","daysBetweenExpirationsDates":30,"payment":387321,"beginningBalance":756662,"principal":375366,"interest":11955,"endingBalance":381296,"cumulativeInterest":1603089},{"paymentNumber":24,"expirationDate":"2022-01-02","daysBetweenExpirationsDates":31,"payment":387321,"beginningBalance":381296,"principal":381296,"interest":6024,"endingBalance":0,"cumulativeInterest":1609113}],"surchargesAndInsurances":{"dealerSurcharges":[{"id":2,"description":"Inscripción","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false}],"financingEntitySurcharges":[],"dealerInsurance":[{"id":11,"description":"GASTOS OPERACIONALES","value":260000,"isEditable":false,"currencyType":"CLP","factorCalculated":260000,"selected":true,"isRequired":true}],"financingEntityInsurance":[{"id":221,"description":"DESGRAVAMEN","value":47,"currencyType":"CLP","valueCalculated":361079,"factorCalculated":260000,"selected":true,"isRequired":true}],"amicarAssistance":[{"id":20,"description":"PROTECAR","value":3490,"currencyType":"CLP","factorCalculated":3490,"selected":false,"isRequired":false},{"id":19,"description":"NEUMATICOS","value":1990,"currencyType":"CLP","factorCalculated":1990,"selected":false,"isRequired":false},{"id":18,"description":"GARANTIA MECANICA","value":3790,"currencyType":"CLP","factorCalculated":3790,"selected":false,"isRequired":false},{"id":17,"description":"GARANTIA MECANICA >5 AÑOS","value":3590,"currencyType":"CLP","factorCalculated":3590,"selected":false,"isRequired":false}]}}]');
		}

		System.debug('respuesta->'+response);

		if (response.getStatusCode() == 200 && response.getStatus() != null){
			
			//
			// servicio responde OK, analizamos la respuesta
			//----------------------------------------------------------------------------------
			String respuestaServicio = response.getBody();
			System.debug('body->'+response.getBody());

			//List<AMICAR_Resp_Simulacion_WSJson> respuestaSimulacion = (List<AMICAR_Resp_Simulacion_WSJson>) Json.deserializeStrict(respuestaServicio, List<AMICAR_Resp_Simulacion_WSJson>.class);
			List<AMICAR_Resp_Simulacion_WSJson> respuestaSimulacion = (List<AMICAR_Resp_Simulacion_WSJson>) Json.deserialize(respuestaServicio, List<AMICAR_Resp_Simulacion_WSJson>.class);
			System.debug('respuesta simulacion->'+respuestaSimulacion);

			List<Desarrollo__c> nuevoDesarrollo = new List<Desarrollo__c>();
			Id rt = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Presupuesto Renovaciones').getRecordTypeId();
			List<Pricebook2> IdListaPrecios = new List<Pricebook2>();
			if(!Test.isRunningTest()){
				IdListaPrecios = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
			}else{
				Pricebook2 pricebook2 = new Pricebook2(
		                                       Name = 'Standard Price Book',
		                                       IsActive = true);
				insert pricebook2;

				IdListaPrecios.add(pricebook2);
			}
			for (AMICAR_Resp_Simulacion_WSJson respuesta:respuestaSimulacion){

				System.debug('respuesta->'+respuesta);

				Quote cotizacion = new Quote();

				cotizacion.RecordTypeId = rt;
				cotizacion.Name = 'simulacion ' + respuesta.FinalLoanValues.loanType + ' ' + respuesta.FinalLoanValues.term;
				cotizacion.OpportunityId = solicitudId;

				cotizacion.CAE__c = respuesta.EquivalentAnnualCharge.annualCae;
				cotizacion.Costo_total_cr_dito__c = respuesta.EquivalentAnnualCharge.totalLoanCost;
				cotizacion.Valor_UF__c = respuesta.FinalLoanValues.UFValue;
				cotizacion.Saldo_precio__c = respuesta.FinalLoanValues.balance;
				cotizacion.Total_a_financiar__c = respuesta.FinalLoanValues.totalToFinance;
				cotizacion.Interes_por_desfase__c = respuesta.FinalLoanValues.delayedInterest;
				cotizacion.Capital_final__c = respuesta.FinalLoanValues.finalCapital;
				cotizacion.Tipo_de_financiamiento__c = respuesta.FinalLoanValues.loanType;
				cotizacion.Cuotas__c = respuesta.FinalLoanValues.term;
				cotizacion.Valor_cuota__c = respuesta.FinalLoanValues.monthlyPayment;
				cotizacion.Tasa__c = respuesta.FinalLoanValues.customerRate;
				cotizacion.Tipo_de_tasa2__c = respuesta.FinalLoanValues.rateType;
				cotizacion.Pricebook2Id = IdListaPrecios[0].Id;
				cotizacion.Comisi_n_dealer__c = respuesta.FinalLoanValues.dealerCommission;
				cotizacion.Fecha_creacion__c = System.now();
				cotizacion.Tasa_dealer__c = respuesta.FinalLoanValues.dealerRate;

				insert cotizacion;

				//
				// tabla de desarrollo
				//----------------------------------------------------------------------------------
				for (AMICAR_Resp_Simulacion_WSJson.AmortizationSchedule desarrollo:respuesta.amortizationSchedule){

					// Generación de registros en tabla "Desarrollo"
					Desarrollo__c cuota = new Desarrollo__c();
					cuota.Numero_de_pago__c = desarrollo.paymentNumber;
					cuota.Simulacion__c = cotizacion.Id;
					cuota.Pago__c = desarrollo.payment;
					cuota.Fecha_vencimiento__c = desarrollo.expirationDate;
					nuevoDesarrollo.add(cuota);
				}
				upsert nuevoDesarrollo;

				//
				//recargos y asistencias
				//----------------------------------------------------------------------------------
				AMICAR_Resp_Simulacion_WSJson.SurchargesAndInsurances recargosyasistencias;
				recargosyasistencias = respuesta.surchargesAndInsurances;
				System.debug('recargos->'+recargosyasistencias);

				List<QuoteLineItem> asistenciasAmicarSimulacion = new List<QuoteLineItem>();
				List<QuoteLineItem> recargosDealerSimulacion = new List<QuoteLineItem>();
				List<QuoteLineItem> recargosEfSimulacion = new List<QuoteLineItem>();
				List<QuoteLineItem> segurosDealerSimulacion = new List<QuoteLineItem>();
				List<QuoteLineItem> segurosEfSimulacion = new List<QuoteLineItem>();
	
				List<Product2> ListaProductos = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND (Family = 'amicarAssistance' OR Family = 'dealerSurcharges' OR Family = 'financingEntityInsurance' OR Family = 'dealerInsurance')];
				Map<String,Id> MapaAsistencias = new Map<String,Id>();

				List<PricebookEntry> ListaEntradas = [SELECT Id,Product2Id FROM PricebookEntry WHERE IsActive = true AND (Product2.Family = 'amicarAssistance' OR Product2.Family = 'dealerSurcharges' OR Product2.Family = 'financingEntityInsurance' OR Product2.Family = 'dealerInsurance')];
				Map<Id,Id> MapaEntradas = new Map<Id,Id>();

				if (!ListaEntradas.isEmpty()){

					for (PricebookEntry ProductosEntrada:ListaEntradas){
							MapaEntradas.put(ProductosEntrada.Product2Id,ProductosEntrada.Id);
					}
				}
				System.debug('mapa entradas->'+MapaEntradas);


				if (!ListaProductos.isEmpty()){

					//
					// productos amicarAssistance
					//----------------------------------------------------------------------------------
					for (Product2 ProductosEnLista:ListaProductos){
						if (ProductosEnLista.Family == 'amicarAssistance'){
							MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
						}
					}
					System.debug('mapa asistencias amicar->'+MapaAsistencias);

					if (!MapaAsistencias.isEmpty()){
						for (AMICAR_Resp_Simulacion_WSJson.AmicarAssistance asistenciasAmicar:recargosyasistencias.amicarAssistance){
							String clave = asistenciasAmicar.description + ' ' + asistenciasAmicar.id + ' amicarAssistance';
							System.debug('clave->'+clave);

							QuoteLineItem nuevoItem = new QuoteLineItem();
							nuevoItem.Product2Id = MapaAsistencias.get(clave);
							nuevoItem.Quantity = 1;
							nuevoItem.UnitPrice = asistenciasAmicar.factorCalculated;
							nuevoItem.Value__c = asistenciasAmicar.value;
							nuevoItem.Divisa__c = asistenciasAmicar.currencyType;
							nuevoItem.QuoteId = cotizacion.Id;
							nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

							nuevoItem.Requerido__c = asistenciasAmicar.isRequired;
							nuevoItem.Seleccionado__c = asistenciasAmicar.selected;
							
							asistenciasAmicarSimulacion.add(nuevoItem);
						}
					}

					System.debug('asistencias amicar->'+asistenciasAmicarSimulacion);
					if(!Test.isRunningTest()){
						insert asistenciasAmicarSimulacion;
					}
					MapaAsistencias.clear();

					//
					//dealerSurcharges
					//----------------------------------------------------------------------------------
					for (Product2 ProductosEnLista:ListaProductos){
						if (ProductosEnLista.Family == 'dealerSurcharges'){
							MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
						}
					}
					System.debug('mapa recargos dealer->'+MapaAsistencias);

					if (!MapaAsistencias.isEmpty()){
						for (AMICAR_Resp_Simulacion_WSJson.DealerSurcharges recargosDealer:recargosyasistencias.dealerSurcharges){
							String clave = recargosDealer.description + ' ' + recargosDealer.id + ' dealerSurcharges';
							System.debug('clave->'+clave);

							QuoteLineItem nuevoItem = new QuoteLineItem();
							nuevoItem.Product2Id = MapaAsistencias.get(clave);
							nuevoItem.Quantity = 1;
							nuevoItem.UnitPrice = recargosDealer.factorCalculated;
							nuevoItem.Value__c = recargosDealer.value;
							nuevoItem.Divisa__c = recargosDealer.currencyType;
							nuevoItem.QuoteId = cotizacion.Id;
							nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

							nuevoItem.Editable__c = recargosDealer.isEditable;
							nuevoItem.Requerido__c = recargosDealer.isRequired;
							nuevoItem.Seleccionado__c = recargosDealer.selected;
							
							recargosDealerSimulacion.add(nuevoItem);
						}
					}

					System.debug('recargos dealer->'+recargosDealerSimulacion);
					if(!Test.isRunningTest()){
						insert recargosDealerSimulacion;
					}
					MapaAsistencias.clear();

					//
					//financingEntitySurcharges
					//----------------------------------------------------------------------------------
					for (Product2 ProductosEnLista:ListaProductos){
						if (ProductosEnLista.Family == 'financingEntitySurcharges'){
							MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
						}
					}
					System.debug('mapa recargos EF->'+MapaAsistencias);

					if (!MapaAsistencias.isEmpty()){
						for (AMICAR_Resp_Simulacion_WSJson.DealerSurcharges recargosEf:recargosyasistencias.DealerSurcharges){
							String clave = recargosEf.description + ' ' + recargosEf.id + ' financingEntitySurcharges';
							System.debug('clave->'+clave);

							QuoteLineItem nuevoItem = new QuoteLineItem();
							nuevoItem.Product2Id = MapaAsistencias.get(clave);
							nuevoItem.Quantity = 1;
							nuevoItem.UnitPrice = recargosEf.factorCalculated;
							nuevoItem.Value__c = recargosEf.value;
							nuevoItem.QuoteId = cotizacion.Id;
							nuevoItem.Divisa__c = recargosEf.currencyType;
							nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

							nuevoItem.Editable__c = recargosEf.IsEditable;
							nuevoItem.Requerido__c = recargosEf.isRequired;
							nuevoItem.Seleccionado__c = recargosEf.selected;
							
							recargosEfSimulacion.add(nuevoItem);
						}

						System.debug('recargos dealer->'+recargosEfSimulacion);
						if(!Test.isRunningTest()){
							insert recargosEfSimulacion;
						}
					}
					MapaAsistencias.clear();

					//
					//dealerInsurance 
					//----------------------------------------------------------------------------------
					//for (Product2 ProductosEnLista:ListaProductos){
					//	if (ProductosEnLista.Family == 'segurosDealerSimulacion'){
					//		MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
					//	}
					//}
					//System.debug('mapa seguros dealer->'+MapaAsistencias);

					//if (!MapaAsistencias.isEmpty()){
					//for (AMICAR_Resp_Simulacion_WSJson.DealerInsurance segurosDealer:recargosyasistencias.DealerInsurance){
					//}
					//}

					//System.debug('recargos dealer->'+segurosDealerSimulacion);
					////insert segurosDealerSimulacion;

					//MapaAsistencias.clear();


					//
					//financingEntityInsurance
					//----------------------------------------------------------------------------------
					for (Product2 ProductosEnLista:ListaProductos){
						if (ProductosEnLista.Family == 'financingEntityInsurance'){
							MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
						}
					}
					System.debug('mapa seguros segurosEF->'+MapaAsistencias);

					if (!MapaAsistencias.isEmpty()){
						for (AMICAR_Resp_Simulacion_WSJson.FinancingEntityInsurance segurosEF:recargosyasistencias.FinancingEntityInsurance){
							String clave = segurosEF.description + ' ' + segurosEF.id + ' financingEntityInsurance';
							System.debug('clave->'+clave);

							System.debug('ef->'+segurosEF);

							QuoteLineItem nuevoItem = new QuoteLineItem();
							nuevoItem.Product2Id = MapaAsistencias.get(clave);
							nuevoItem.Quantity = 1;
							nuevoItem.UnitPrice = segurosEF.factorCalculated;
							nuevoItem.Value__c = segurosEF.value;
							nuevoItem.Divisa__c = segurosEF.currencyType;
							nuevoItem.QuoteId = cotizacion.Id;
							nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

							nuevoItem.Editable__c = false;
							nuevoItem.Requerido__c = segurosEF.isRequired;
							nuevoItem.Seleccionado__c = segurosEF.selected;
							
							segurosEfSimulacion.add(nuevoItem);
						}

						System.debug('seguros EF->'+segurosEfSimulacion);
						if(!Test.isRunningTest()){
							insert segurosEfSimulacion;
						}
					}

					MapaAsistencias.clear();
				}
			}

			resultadoServcio = 'OK';
		}else{
			
			//
			// servicio responde NOK, enviamos/guardamos la respuesta a algun lado
			//----------------------------------------------------------------------------------
			System.debug('ERROR-> '+response.getStatus());
			System.debug('Descr->'+response.getBody());

			resultadoServcio = 'Mensaje: '+ response.getBody();
		}

		Opportunity updOportunidad = [SELECT Id,Respuesta_Servicio__c FROM Opportunity WHERE Id =: solicitudId];

		updOportunidad.Respuesta_Servicio__c = resultadoServcio;
		update updOportunidad;
	}
}