/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que obtiene datos de simulación y desarrollos modificados ante cambio en uno de ellos
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 30-04-2020            RJZ                     Creación de la Clase.
1.1 15-12-2020			  RL					  Modificación de código para pegar "factorCalculated" en vez de value para carga de productos.
***********************************************************************************/
public with sharing class AMICAR_ActualizaDesarrollo {

  @InvocableMethod(label='Actualizar desarrollos' description='Obtiene desarrollos nuevos')
  public static List<string> ObtieneDesarrollos (List<string> inputParams) {
    // recibo id desarrollo por parametro se busca la solicitud asociada desde la simulación del desarrollo modificado

    Integer retoma;
    String jsonSolicitud;
    
    System.debug('parametros->'+inputParams);

    List<Desarrollo__c> desarrolloOrigen =  [SELECT Id,Simulacion__c,Numero_de_pago__c,Solicitud__c,Pago__c FROM Desarrollo__c WHERE Id in : inputParams];
    List<String> listaSolicitud = new List<String>();
    List<String> listaSimulacion = new List<String>();
    for(Desarrollo__c obj : desarrolloOrigen){
      listaSimulacion.add(obj.Simulacion__c);
    }

    List<Quote> simulacionSalesforce = [SELECT Id,OpportunityId,Cuotas__c FROM Quote WHERE Id IN : listaSimulacion];
    for(Quote objQuote : simulacionSalesforce){
      listaSolicitud.add(objQuote.OpportunityId);
    }
    List<Opportunity> solicitudSalesforce = [SELECT 
                        Id,
                        OwnerId,
                        Name,
                        AccountId,
                        Tipo_de_Veh_culo__c,
                        Precio_vehiculo__c,
                        toLabel(Marca_vehiculo__c),
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
                        Local__r.Codigo_Local__c,
                        Local__r.Importador__c,
                        Account.RUT__c,
                        Account.Name,
                        Account.PersonEmail,
                        Account.PersonMobilePhone,
						Account.isPersonAccount,
                        Owner.RUT_F_I__c,
                        Vendedor__r.RUT__c,
                        RecordType.DeveloperName
                      FROM Opportunity WHERE Id IN : listaSolicitud];

    List<Desarrollo__c> desarrolloSalesforce = [SELECT Id,Numero_de_pago__c,Pago__c FROM Desarrollo__c WHERE Simulacion__c IN : listaSimulacion AND Modificado__c = true];

    if (solicitudSalesforce[0].Monto_retoma__c != null){
      retoma = Integer.valueOf(solicitudSalesforce[0].Monto_retoma__c);
    }else{
      retoma = 0;
    }

    String desarrollo;
    String auxDesa;
    System.debug('desa sf->'+desarrolloSalesforce);
    for (Desarrollo__c desa:desarrolloSalesforce){
      auxDesa = '{'+
              '"paymentNumber":' + desa.Numero_de_pago__c + ',' + 
              '"payment":' + desa.Pago__c +
            '}';
      desarrollo = desarrollo + ',' + auxDesa;
    }
    for (Desarrollo__c desaOrigen:desarrolloOrigen){
        desarrollo = desarrollo + ',' + '{'+ '"paymentNumber":' + desaOrigen.Numero_de_pago__c + ',' + '"payment":' + desaOrigen.Pago__c + '}';
    }
    
    if (desarrollo.length() != 0){
      desarrollo = desarrollo.remove('null,');
    }
    System.debug('desarrollo->'+desarrollo);

    Integer balance = Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c) - Integer.valueOf(solicitudSalesforce[0].Pie__c);
	Integer isPersona = 0;
	if(solicitudSalesforce[0].Account.isPersonAccount){
		isPersona = 1;
	}else{
		isPersona = 2;
	}
	
	jsonSolicitud = '{'+
              '"transactionId":"'+ solicitudSalesforce[0].Id + '",' +
              '"sellerIdentificationValue":"'+ solicitudSalesforce[0].Vendedor__r.RUT__c + '",' +
              '"amicarExecutiveIdentificationValue":"'+ solicitudSalesforce[0].Owner.RUT_F_I__c + '",' +
              '"customer":{'+
				'"identificationTypeId": '+isPersona+','+
                '"identificationValue":"'+ solicitudSalesforce[0].Account.RUT__c + '",' +
                '"email":"'+ solicitudSalesforce[0].Account.PersonEmail + '",' +
                '"phone":"'+ solicitudSalesforce[0].Account.PersonMobilePhone + '"' +
              '},'+
              '"vehicle":{'+
                '"type":"'+ solicitudSalesforce[0].Tipo_de_Veh_culo__c + '",' +
                '"price":'+ Integer.valueOf(solicitudSalesforce[0].Precio_vehiculo__c) + ',' +
                '"brandName":"'+solicitudSalesforce[0].Marca_vehiculo__c + '"' +
              '},'+
              '"loan":{'+
                '"downPayment":'+ Integer.valueOf(solicitudSalesforce[0].Pie__c) + ',' +
                '"downPaymentPercentage":'+ Integer.valueOf(solicitudSalesforce[0].Pie_formula__c) + ',' +
                '"term":'+ Integer.valueOf(simulacionSalesforce[0].Cuotas__c) + ',' +
                '"balance":'+ balance +',' +
                '"startDate":"'+ String.valueOf(System.today()) + '",' +
                '"firstDueDate":"'+ String.valueOf(System.today()+30) + '",' +
                '"rateType":"'+ solicitudSalesforce[0].Tipo_de_tasa__c + '",' +
                '"saleChannel":"'+ solicitudSalesforce[0].Local__r.Importador__c + '",'+ 
                '"saleChannelType": "IMPORTADOR",'+
                '"salesRoomId":'+ Integer.valueOf(solicitudSalesforce[0].Local__r.Codigo_Local__c) + ',' +
                '"immediateOption":'+ solicitudSalesforce[0].Opcion_inmediata__c + ',' +
                '"tradeInCarValue":'+ retoma + ',' +
                '"accessories": 0,'+
                '"modifyTerm": [' + desarrollo + ']'+
              '}'+
            '}';

    System.debug('json->'+jsonSolicitud);
    
    // llamada a metodo futuro para envio a servicio
    Id id_oportunidad = solicitudSalesforce[0].Id;
    String tipoDeTasa = solicitudSalesforce[0].Tipo_de_tasa__c;

    envioServicio(jsonSolicitud,id_oportunidad,tipoDeTasa,solicitudSalesforce[0].RecordType.DeveloperName);

    List<string> results = new List<string>();
    return results;
  }

  @future(callout=true)
  static void envioServicio(String jsonEnvio,Id ide,String tipoTasa, String tipoDeRegistro){

    String resultadoServcio;
    String tablaDesarrollo;

    List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id, URL__c 
                                                             FROM AMICAR_Integracion__mdt 
                                                             WHERE MasterLabel = 'Simulaciones'];
    System.debug('endpoint->'+endpointSolicitudes[0].URL__c);

    List<API_Keys__mdt> apkey = [SELECT Id,APK__c
                   FROM API_Keys__mdt
                   WHERE MasterLabel = 'Simulaciones'];

    List<Quote> SimulacionesBorrar = [SELECT Id FROM Quote WHERE OpportunityId =: ide];

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
      response.setBody('[{"amortizationSchedule":[{"beginningBalance":17465389,"cumulativeInterest":274207,"daysBetweenExpirationsDates":30,"endingBalance":17639596,"expirationDate":"2020-09-13","interest":274207,"payment":100000,"paymentNumber":1,"principal":-174207,"quotaType":"MODIFIED"},{"beginningBalance":17639596,"cumulativeInterest":551148,"daysBetweenExpirationsDates":30,"endingBalance":17383069,"expirationDate":"2020-10-13","interest":276942,"payment":533468,"paymentNumber":2,"principal":256526,"quotaType":"REGULAR"},{"beginningBalance":17383069,"cumulativeInterest":824062,"daysBetweenExpirationsDates":31,"endingBalance":17122515,"expirationDate":"2020-11-13","interest":272914,"payment":533468,"paymentNumber":3,"principal":260554,"quotaType":"REGULAR"},{"beginningBalance":17122515,"cumulativeInterest":1092886,"daysBetweenExpirationsDates":30,"endingBalance":16857870,"expirationDate":"2020-12-13","interest":268823,"payment":533468,"paymentNumber":4,"principal":264645,"quotaType":"REGULAR"},{"beginningBalance":16857870,"cumulativeInterest":1357554,"daysBetweenExpirationsDates":31,"endingBalance":16589071,"expirationDate":"2021-01-13","interest":264669,"payment":533468,"paymentNumber":5,"principal":268800,"quotaType":"REGULAR"},{"beginningBalance":16589071,"cumulativeInterest":1618003,"daysBetweenExpirationsDates":31,"endingBalance":16316051,"expirationDate":"2021-02-13","interest":260448,"payment":533468,"paymentNumber":6,"principal":273020,"quotaType":"REGULAR"},{"beginningBalance":16316051,"cumulativeInterest":1874165,"daysBetweenExpirationsDates":28,"endingBalance":16038745,"expirationDate":"2021-03-13","interest":256162,"payment":533468,"paymentNumber":7,"principal":277306,"quotaType":"REGULAR"},{"beginningBalance":16038745,"cumulativeInterest":2125973,"daysBetweenExpirationsDates":31,"endingBalance":15757085,"expirationDate":"2021-04-13","interest":251808,"payment":533468,"paymentNumber":8,"principal":281660,"quotaType":"REGULAR"},{"beginningBalance":15757085,"cumulativeInterest":2373359,"daysBetweenExpirationsDates":30,"endingBalance":15471003,"expirationDate":"2021-05-13","interest":247386,"payment":533468,"paymentNumber":9,"principal":286082,"quotaType":"REGULAR"},{"beginningBalance":15471003,"cumulativeInterest":2616254,"daysBetweenExpirationsDates":31,"endingBalance":15180430,"expirationDate":"2021-06-13","interest":242895,"payment":533468,"paymentNumber":10,"principal":290573,"quotaType":"REGULAR"},{"beginningBalance":15180430,"cumulativeInterest":2854587,"daysBetweenExpirationsDates":30,"endingBalance":14885294,"expirationDate":"2021-07-13","interest":238333,"payment":533468,"paymentNumber":11,"principal":295135,"quotaType":"REGULAR"},{"beginningBalance":14885294,"cumulativeInterest":3088286,"daysBetweenExpirationsDates":31,"endingBalance":14585525,"expirationDate":"2021-08-13","interest":233699,"payment":533468,"paymentNumber":12,"principal":299769,"quotaType":"REGULAR"},{"beginningBalance":14585525,"cumulativeInterest":3317279,"daysBetweenExpirationsDates":31,"endingBalance":14281050,"expirationDate":"2021-09-13","interest":228993,"payment":533468,"paymentNumber":13,"principal":304475,"quotaType":"REGULAR"},{"beginningBalance":14281050,"cumulativeInterest":3541491,"daysBetweenExpirationsDates":30,"endingBalance":13971794,"expirationDate":"2021-10-13","interest":224212,"payment":533468,"paymentNumber":14,"principal":309256,"quotaType":"REGULAR"},{"beginningBalance":13971794,"cumulativeInterest":3760848,"daysBetweenExpirationsDates":31,"endingBalance":13657683,"expirationDate":"2021-11-13","interest":219357,"payment":533468,"paymentNumber":15,"principal":314111,"quotaType":"REGULAR"},{"beginningBalance":13657683,"cumulativeInterest":3975274,"daysBetweenExpirationsDates":30,"endingBalance":13338641,"expirationDate":"2021-12-13","interest":214426,"payment":533468,"paymentNumber":16,"principal":319043,"quotaType":"REGULAR"},{"beginningBalance":13338641,"cumulativeInterest":4184691,"daysBetweenExpirationsDates":31,"endingBalance":13014589,"expirationDate":"2022-01-13","interest":209417,"payment":533468,"paymentNumber":17,"principal":324051,"quotaType":"REGULAR"},{"beginningBalance":13014589,"cumulativeInterest":4389020,"daysBetweenExpirationsDates":31,"endingBalance":12685450,"expirationDate":"2022-02-13","interest":204329,"payment":533468,"paymentNumber":18,"principal":329139,"quotaType":"REGULAR"},{"beginningBalance":12685450,"cumulativeInterest":4588181,"daysBetweenExpirationsDates":28,"endingBalance":12351144,"expirationDate":"2022-03-13","interest":199162,"payment":533468,"paymentNumber":19,"principal":334307,"quotaType":"REGULAR"},{"beginningBalance":12351144,"cumulativeInterest":4782094,"daysBetweenExpirationsDates":31,"endingBalance":12011589,"expirationDate":"2022-04-13","interest":193913,"payment":533468,"paymentNumber":20,"principal":339555,"quotaType":"REGULAR"},{"beginningBalance":12011589,"cumulativeInterest":4970676,"daysBetweenExpirationsDates":30,"endingBalance":11666702,"expirationDate":"2022-05-13","interest":188582,"payment":533468,"paymentNumber":21,"principal":344886,"quotaType":"REGULAR"},{"beginningBalance":11666702,"cumulativeInterest":5153844,"daysBetweenExpirationsDates":31,"endingBalance":11316401,"expirationDate":"2022-06-13","interest":183167,"payment":533468,"paymentNumber":22,"principal":350301,"quotaType":"REGULAR"},{"beginningBalance":11316401,"cumulativeInterest":5331511,"daysBetweenExpirationsDates":30,"endingBalance":10960601,"expirationDate":"2022-07-13","interest":177668,"payment":533468,"paymentNumber":23,"principal":355801,"quotaType":"REGULAR"},{"beginningBalance":10960601,"cumulativeInterest":5503592,"daysBetweenExpirationsDates":31,"endingBalance":10599214,"expirationDate":"2022-08-13","interest":172081,"payment":533468,"paymentNumber":24,"principal":361387,"quotaType":"REGULAR"},{"beginningBalance":10599214,"cumulativeInterest":5670000,"daysBetweenExpirationsDates":31,"endingBalance":10232154,"expirationDate":"2022-09-13","interest":166408,"payment":533468,"paymentNumber":25,"principal":367060,"quotaType":"REGULAR"},{"beginningBalance":10232154,"cumulativeInterest":5830645,"daysBetweenExpirationsDates":30,"endingBalance":9859330,"expirationDate":"2022-10-13","interest":160645,"payment":533468,"paymentNumber":26,"principal":372823,"quotaType":"REGULAR"},{"beginningBalance":9859330,"cumulativeInterest":5985436,"daysBetweenExpirationsDates":31,"endingBalance":9480654,"expirationDate":"2022-11-13","interest":154791,"payment":533468,"paymentNumber":27,"principal":378677,"quotaType":"REGULAR"},{"beginningBalance":9480654,"cumulativeInterest":6134283,"daysBetweenExpirationsDates":30,"endingBalance":9096032,"expirationDate":"2022-12-13","interest":148846,"payment":533468,"paymentNumber":28,"principal":384622,"quotaType":"REGULAR"},{"beginningBalance":9096032,"cumulativeInterest":6277090,"daysBetweenExpirationsDates":31,"endingBalance":8705371,"expirationDate":"2023-01-13","interest":142808,"payment":533468,"paymentNumber":29,"principal":390660,"quotaType":"REGULAR"},{"beginningBalance":8705371,"cumulativeInterest":6413765,"daysBetweenExpirationsDates":31,"endingBalance":8308577,"expirationDate":"2023-02-13","interest":136674,"payment":533468,"paymentNumber":30,"principal":396794,"quotaType":"REGULAR"},{"beginningBalance":8308577,"cumulativeInterest":6544209,"daysBetweenExpirationsDates":28,"endingBalance":7905554,"expirationDate":"2023-03-13","interest":130445,"payment":533468,"paymentNumber":31,"principal":403023,"quotaType":"REGULAR"},{"beginningBalance":7905554,"cumulativeInterest":6668327,"daysBetweenExpirationsDates":31,"endingBalance":7496203,"expirationDate":"2023-04-13","interest":124117,"payment":533468,"paymentNumber":32,"principal":409351,"quotaType":"REGULAR"},{"beginningBalance":7496203,"cumulativeInterest":6786017,"daysBetweenExpirationsDates":30,"endingBalance":7080425,"expirationDate":"2023-05-13","interest":117690,"payment":533468,"paymentNumber":33,"principal":415778,"quotaType":"REGULAR"},{"beginningBalance":7080425,"cumulativeInterest":6897180,"daysBetweenExpirationsDates":31,"endingBalance":6658120,"expirationDate":"2023-06-13","interest":111163,"payment":533468,"paymentNumber":34,"principal":422305,"quotaType":"REGULAR"},{"beginningBalance":6658120,"cumulativeInterest":7001712,"daysBetweenExpirationsDates":30,"endingBalance":6229184,"expirationDate":"2023-07-13","interest":104532,"payment":533468,"paymentNumber":35,"principal":428936,"quotaType":"REGULAR"},{"beginningBalance":6229184,"cumulativeInterest":7099510,"daysBetweenExpirationsDates":31,"endingBalance":5793514,"expirationDate":"2023-08-13","interest":97798,"payment":533468,"paymentNumber":36,"principal":435670,"quotaType":"REGULAR"},{"beginningBalance":5793514,"cumulativeInterest":7190468,"daysBetweenExpirationsDates":31,"endingBalance":5351004,"expirationDate":"2023-09-13","interest":90958,"payment":533468,"paymentNumber":37,"principal":442510,"quotaType":"REGULAR"},{"beginningBalance":5351004,"cumulativeInterest":7274479,"daysBetweenExpirationsDates":30,"endingBalance":4901547,"expirationDate":"2023-10-13","interest":84011,"payment":533468,"paymentNumber":38,"principal":449457,"quotaType":"REGULAR"},{"beginningBalance":4901547,"cumulativeInterest":7351434,"daysBetweenExpirationsDates":31,"endingBalance":4445033,"expirationDate":"2023-11-13","interest":76954,"payment":533468,"paymentNumber":39,"principal":456514,"quotaType":"REGULAR"},{"beginningBalance":4445033,"cumulativeInterest":7421221,"daysBetweenExpirationsDates":30,"endingBalance":3981352,"expirationDate":"2023-12-13","interest":69787,"payment":533468,"paymentNumber":40,"principal":463681,"quotaType":"REGULAR"},{"beginningBalance":3981352,"cumulativeInterest":7483728,"daysBetweenExpirationsDates":31,"endingBalance":3510391,"expirationDate":"2024-01-13","interest":62507,"payment":533468,"paymentNumber":41,"principal":470961,"quotaType":"REGULAR"},{"beginningBalance":3510391,"cumulativeInterest":7538841,"daysBetweenExpirationsDates":31,"endingBalance":3032036,"expirationDate":"2024-02-13","interest":55113,"payment":533468,"paymentNumber":42,"principal":478355,"quotaType":"REGULAR"},{"beginningBalance":3032036,"cumulativeInterest":7586444,"daysBetweenExpirationsDates":29,"endingBalance":2546171,"expirationDate":"2024-03-13","interest":47603,"payment":533468,"paymentNumber":43,"principal":485865,"quotaType":"REGULAR"},{"beginningBalance":2546171,"cumulativeInterest":7626419,"daysBetweenExpirationsDates":31,"endingBalance":2052677,"expirationDate":"2024-04-13","interest":39975,"payment":533468,"paymentNumber":44,"principal":493493,"quotaType":"REGULAR"},{"beginningBalance":2052677,"cumulativeInterest":7658646,"daysBetweenExpirationsDates":30,"endingBalance":1551436,"expirationDate":"2024-05-13","interest":32227,"payment":533468,"paymentNumber":45,"principal":501241,"quotaType":"REGULAR"},{"beginningBalance":1551436,"cumulativeInterest":7683003,"daysBetweenExpirationsDates":31,"endingBalance":1042326,"expirationDate":"2024-06-13","interest":24358,"payment":533468,"paymentNumber":46,"principal":509111,"quotaType":"REGULAR"},{"beginningBalance":1042326,"cumulativeInterest":7699368,"daysBetweenExpirationsDates":30,"endingBalance":525222,"expirationDate":"2024-07-13","interest":16365,"payment":533468,"paymentNumber":47,"principal":517104,"quotaType":"REGULAR"},{"beginningBalance":525222,"cumulativeInterest":7707614,"daysBetweenExpirationsDates":31,"endingBalance":0,"expirationDate":"2024-08-13","interest":8246,"payment":533468,"paymentNumber":48,"principal":525222,"quotaType":"REGULAR"}],"equivalentAnnualCharge":{"annualCAE":23.77,"monthlyCAE":1.98,"totalLoanCost":25172996},"finalLoanValues":{"UFValue":28663.73,"amicarCommission":2363332,"balance":16000000,"customerRate":1.57,"daysDelayedFirstDue":30,"dealerCommission":1400946,"dealerRate":1.22,"delayedInterest":0,"downPaymentPercentage":38.46,"factorTotal":0.9390000000000001,"finalCapital":17465389,"loanType":"CONVENTIONAL","monthlyPayment":533468,"promissoryFactor":0,"promissoryValue":0,"rateType":"CONVENTIONAL_NORMAL","term":48,"totalSurchargesToMAF":400000,"totalSurchargesToQuote":0,"totalToFinance":17465389,"totalToFinanceUF":609.32},"surchargesAndInsurances":{"amicarAssistance":[{"currencyType":"CLP","description":"FAMILIA PROTEGIDA","factorCalculated":0,"id":10101,"isEditable":true,"isRequired":false,"selected":false,"value":0}],"dealerInsurance":[],"dealerSurcharges":[{"currencyType":"CLP","description":"IMPUESTO VERDE","factorCalculated":0,"id":1,"isEditable":true,"isRequired":false,"selected":false,"value":0}],"financingEntityInsurance":[{"currencyType":"CLP","description":"DESGRAVAMEN","factorCalculated":1065389,"id":336,"isRequired":true,"selected":true,"value":61}],"financingEntitySurcharges":[{"currencyType":"CLP","description":"G. OPERACIONALES","factorCalculated":400000,"id":10567,"isEditable":false,"isRequired":true,"selected":true,"value":400000}]}}]');
    }

    System.debug('respuesta->'+response);
    System.debug('body respuesta->'+response.getBody());

    System.debug('respuesta->'+response);

    if (response.getStatusCode() == 200 && response.getStatus() != null){
      //
      // servicio responde OK, analizamos la respuesta
      //----------------------------------------------------------------------------------
      String respuestaServicio = response.getBody();
      System.debug('body->'+response.getBody());

      procesoRespuestaServicio(respuestaServicio,ide,tipoTasa,tipoDeRegistro);

      resultadoServcio = 'OK';
    }else{
      //
      // servicio responde NOK, enviamos/guardamos la respuesta a algun lado
      //----------------------------------------------------------------------------------
      System.debug('ERROR-> '+response.getStatus());
      System.debug('Descr->'+response.getBody());

      resultadoServcio = 'Mensaje: '+ response.getBody();
    }

    delete SimulacionesBorrar;

    Opportunity updOportunidad = [SELECT Id,Respuesta_Servicio__c FROM Opportunity WHERE Id =: ide];

    updOportunidad.Respuesta_Servicio__c = resultadoServcio;
    update updOportunidad;
  }


  static void procesoRespuestaServicio(String respuestaMetodo,Id solicitudMetodo,String tasaMetodo,String registroMetodo){

    Id rt;

    List<Desarrollo__c> desarrollosBorrar = [SELECT Id FROM Desarrollo__c WHERE Solicitud__c =: solicitudMetodo];
    if (desarrollosBorrar.size() != 0){
      delete desarrollosBorrar;
    }

    List<AMICAR_Resp_Simulacion_WSJson> respuestaSimulacion = (List<AMICAR_Resp_Simulacion_WSJson>) Json.deserialize(respuestaMetodo, List<AMICAR_Resp_Simulacion_WSJson>.class);
    System.debug('respuesta simulacion->'+respuestaSimulacion);

    List<Desarrollo__c> nuevoDesarrollo = new List<Desarrollo__c>();
    
    if (registroMetodo == 'Simulacion_CORE'){
      rt = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
    }else{
      rt = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Presupuesto Renovaciones').getRecordTypeId();
    }
    //List<Pricebook2> IdListaPrecios = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];

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

      System.debug('respuestaSimulacion->'+respuesta);

      Quote cotizacion = new Quote();

      cotizacion.RecordTypeId = rt;
      cotizacion.Name = 'simulacion ' + respuesta.FinalLoanValues.loanType + ' ' + respuesta.FinalLoanValues.term;
      cotizacion.OpportunityId = solicitudMetodo;

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
	  
	  //Se agrega VFMG
      for(AMICAR_Resp_Simulacion_WSJson.AmortizationSchedule amrtSch : respuesta.amortizationSchedule){
		if(amrtSch.quotaType == 'SMART'){
      		cotizacion.VFMG__c = amrtSch.payment;
      		break;
		}
      }
	  //Fin VFMG

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
        System.debug('tipo cuota->'+desarrollo.quotaType);
        System.debug('Pago__c->'+desarrollo.payment);
        if (desarrollo.quotaType == 'MODIFIED'){
          cuota.Modificado__c = true;
        }else{
          cuota.Modificado__c = false;
        }
        nuevoDesarrollo.add(cuota);
      }
      upsert nuevoDesarrollo;

      //
      //recargos y asistencias
      //----------------------------------------------------------------------------------
      AMICAR_Resp_Simulacion_WSJson.SurchargesAndInsurances recargosyasistencias;
      recargosyasistencias = respuesta.surchargesAndInsurances;

	  //RL - Revisar si existen los Productos y Listas de Precios en Salesforce
	  checkProductsAndPricebookentries(recargosyasistencias);

      System.debug('recargos->'+recargosyasistencias);

      List<QuoteLineItem> asistenciasAmicarSimulacion = new List<QuoteLineItem>();
      List<QuoteLineItem> recargosDealerSimulacion = new List<QuoteLineItem>();
      List<QuoteLineItem> recargosEfSimulacion = new List<QuoteLineItem>();
      List<QuoteLineItem> segurosDealerSimulacion = new List<QuoteLineItem>();
      List<QuoteLineItem> segurosEfSimulacion = new List<QuoteLineItem>();

      //List<Product2> ListaProductos = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND (Family = 'amicarAssistance' OR Family = 'dealerSurcharges' OR Family = 'financingEntityInsurance' OR Family = 'dealerInsurance')];
      List<Product2> ListaProductos = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND (Family = 'amicarAssistance' OR Family = 'dealerSurcharges' OR Family = 'financingEntityInsurance' OR Family = 'dealerInsurance' OR Family ='financingEntitySurcharges')];
	  Map<String,Id> MapaAsistencias = new Map<String,Id>();

      //List<PricebookEntry> ListaEntradas = [SELECT Id,Product2Id FROM PricebookEntry WHERE IsActive = true AND (Product2.Family = 'amicarAssistance' OR Product2.Family = 'dealerSurcharges' OR Product2.Family = 'financingEntityInsurance' OR Product2.Family = 'dealerInsurance')];
       List<PricebookEntry> ListaEntradas = [SELECT Id,Product2Id FROM PricebookEntry WHERE IsActive = true AND (Product2.Family = 'amicarAssistance' OR Product2.Family = 'dealerSurcharges' OR Product2.Family = 'financingEntityInsurance' OR Product2.Family = 'dealerInsurance' OR Product2.Family = 'financingEntitySurcharges')];
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
            //Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
			//nuevoItem.Value__c = asistenciasAmicar.value;
			nuevoItem.Value__c = asistenciasAmicar.factorCalculated;
            nuevoItem.Divisa__c = asistenciasAmicar.currencyType;
            nuevoItem.QuoteId = cotizacion.Id;
            nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

            nuevoItem.Requerido__c = asistenciasAmicar.isRequired;
            nuevoItem.Seleccionado__c = asistenciasAmicar.selected;
            
            asistenciasAmicarSimulacion.add(nuevoItem);
          }
        }

		if(!Test.isRunningTest()){
			System.debug('asistencias amicar->'+asistenciasAmicarSimulacion);
			if (asistenciasAmicarSimulacion.size() != 0){
			  insert asistenciasAmicarSimulacion;
			}
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
            //Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
			//nuevoItem.Value__c = recargosDealer.value;
			nuevoItem.Value__c = recargosDealer.factorCalculated;
            nuevoItem.Divisa__c = recargosDealer.currencyType;
            nuevoItem.QuoteId = cotizacion.Id;
            nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

            nuevoItem.Editable__c = recargosDealer.isEditable;
            nuevoItem.Requerido__c = recargosDealer.isRequired;
            nuevoItem.Seleccionado__c = recargosDealer.selected;
            
            recargosDealerSimulacion.add(nuevoItem);
          }
        }
		if(!Test.isRunningTest()){
			System.debug('recargos dealer->'+recargosDealerSimulacion);
			if (recargosDealerSimulacion.size() != 0){
			  insert recargosDealerSimulacion;
			}
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
          //for (AMICAR_Resp_Simulacion_WSJson.DealerSurcharges recargosEf : recargosyasistencias.DealerSurcharges){
          for (AMICAR_Resp_Simulacion_WSJson.DealerSurcharges recargosEf : recargosyasistencias.financingEntitySurcharges){
		    String clave = recargosEf.description + ' ' + recargosEf.id + ' financingEntitySurcharges';
            System.debug('clave->'+clave);

            QuoteLineItem nuevoItem = new QuoteLineItem();
            nuevoItem.Product2Id = MapaAsistencias.get(clave);
            nuevoItem.Quantity = 1;
            nuevoItem.UnitPrice = recargosEf.factorCalculated;
            //Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
			//nuevoItem.Value__c = recargosEf.value;
			nuevoItem.Value__c = recargosEf.factorCalculated;
            nuevoItem.QuoteId = cotizacion.Id;
            nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

            nuevoItem.Editable__c = recargosEf.IsEditable;
            nuevoItem.Requerido__c = recargosEf.isRequired;
            nuevoItem.Seleccionado__c = recargosEf.selected;
            
            recargosEfSimulacion.add(nuevoItem);
          }
		
			if(!Test.isRunningTest()){
			  System.debug('recargos EF->'+recargosEfSimulacion);
			  if (recargosEfSimulacion.size() != 0){
				insert recargosEfSimulacion;
			  }
			}
        }
        MapaAsistencias.clear();

        //
        //dealerInsurance 
        //----------------------------------------------------------------------------------
        //for (Product2 ProductosEnLista:ListaProductos){
        //  if (ProductosEnLista.Family == 'segurosDealerSimulacion'){
        //    MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
        //  }
        //}
        //System.debug('mapa seguros dealer->'+MapaAsistencias);

        //if (!MapaAsistencias.isEmpty()){
        //for (AMICAR_Resp_Simulacion_WSJson.DealerInsurance segurosDealer:recargosyasistencias.DealerInsurance){
        //}
        //}

        //System.debug('recargos dealer->'+segurosDealerSimulacion);
        //if (segurosDealerSimulacion != 0){
        //  insert segurosDealerSimulacion;
        //}

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
            //Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
			//nuevoItem.Value__c = segurosEF.value;
			nuevoItem.Value__c = segurosEF.factorCalculated;
			nuevoItem.QuoteId = cotizacion.Id;
            nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

            nuevoItem.Editable__c = false;
            nuevoItem.Requerido__c = segurosEF.isRequired;
            nuevoItem.Seleccionado__c = segurosEF.selected;
            
            segurosEfSimulacion.add(nuevoItem);
          }
        }

        System.debug('seguros EF->'+segurosEfSimulacion);
        if(!Test.isRunningTest()){
			if (segurosEfSimulacion.size() != 0){
			  insert segurosEfSimulacion;
			}
		}
        MapaAsistencias.clear();
      }
    }
  }

	public Static void checkProductsAndPricebookentries( AMICAR_Resp_Simulacion_WSJson.SurchargesAndInsurances jsonR){
		try{
			List<Product2> prodToAdd = new List<Product2>();
			List<PricebookEntry> priceToAdd = new List<PricebookEntry>();
			List<String> productosJsonAmicarAssistance = new List<String>();
			List<String> productosJsonFinancingEntityInsurance = new List<String>();
			List<String> productosJsonFinancingEntitySurcharges = new List<String>();
			List<String> productosJsonDealerSurcharges = new List<String>();
			List<String> productosJsonDealerInsurance = new List<String>();
			List<String> familias = new List<String>();
			familias.add('amicarAssistance');
			familias.add('financingEntityInsurance');
			familias.add('dealerSurcharges');
			familias.add('dealerInsurance');
			familias.add('financingEntitySurcharges');
			
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
			for(AMICAR_Resp_Simulacion_WSJson.AmicarAssistance prod : jsonR.amicarAssistance){
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
				}
			}

			//revisar si no existen productos financingEntityInsurance
			for(AMICAR_Resp_Simulacion_WSJson.FinancingEntityInsurance prod : jsonR.financingEntityInsurance){
				String clave = prod.description + ' ' + prod.id + ' financingEntityInsurance';
				productosJsonFinancingEntityInsurance.add(clave);
				String idProductSF = mapProducts.get(clave);
				//Si no existe producto, agregarlo en lista
				if(String.isBlank(idProductSF)){
					System.debug('No existe, crear '+clave);
					Product2 prod2 = new Product2();
					prod2.Name = prod.description;
					prod2.Family = 'financingEntityInsurance';
					prod2.IsActive = true;
					prod2.Identificador__c = clave;
					prod2.ProductCode = String.valueOf(prod.id);
					prodToAdd.add(prod2);
				}
			}

			//revisar si no existen productos financingEntitySurcharges
			for(AMICAR_Resp_Simulacion_WSJson.DealerSurcharges prod : jsonR.financingEntitySurcharges){
				String clave = prod.description + ' ' + prod.id + ' financingEntitySurcharges';
				productosJsonFinancingEntityInsurance.add(clave);
				String idProductSF = mapProducts.get(clave);
				//Si no existe producto, agregarlo en lista
				if(String.isBlank(idProductSF)){
					System.debug('No existe, crear '+clave);
					Product2 prod2 = new Product2();
					prod2.Name = prod.description;
					prod2.Family = 'financingEntitySurcharges';
					prod2.IsActive = true;
					prod2.Identificador__c = clave;
					prod2.ProductCode = String.valueOf(prod.id);
					prodToAdd.add(prod2);
				}
			}

			//revisar si no existen productos dealerSurcharges
			for(AMICAR_Resp_Simulacion_WSJson.DealerSurcharges prod : jsonR.dealerSurcharges){
				String clave = prod.description + ' ' + prod.id + ' dealerSurcharges';
				productosJsonDealerSurcharges.add(clave);
				String idProductSF = mapProducts.get(clave);
				//Si no existe producto, agregarlo en lista
				if(String.isBlank(idProductSF)){
					System.debug('No existe, crear '+clave);
					Product2 prod2 = new Product2();
					prod2.Name = prod.description;
					prod2.Family = 'dealerSurcharges';
					prod2.IsActive = true;
					prod2.Identificador__c = clave;
					prod2.ProductCode = String.valueOf(prod.id);
					prodToAdd.add(prod2);
				}
			}

			//revisar si no existen productos dealerInsurance
			//for(AMICAR_Resp_Simulacion_WSJson.DealerInsurance prod : jsonR.dealerInsurance){
				//String clave = prod.description + ' ' + prod.id + ' dealerInsurance';
				//productosJsonDealerSurcharges.add(clave);
				//String idProductSF = mapProducts.get(clave);
				////Si no existe producto, agregarlo en lista
				//if(String.isBlank(idProductSF)){
					//System.debug('No existe, crear '+clave);
					//Product2 prod2 = new Product2();
					//prod2.Name = prod.description;
					//prod2.Family = 'dealerInsurance';
					//prod2.IsActive = true;
					//prod2.Identificador__c = clave;
					//prod2.ProductCode = String.valueOf(prod.id);
					//prodToAdd.add(prod2);
				//}
			//}

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
			
			
			Pricebook2 pb2 = new PriceBook2();
			try{
				pb2 = [SELECT Id 
									FROM Pricebook2 
									WHERE Name =: 'Standard Price Book'
									AND IsActive = true];
			}catch(Exception ex){
				if(Test.isRunningTest()){
					pb2.Id = Test.getStandardPricebookId();
				}else{
					System.debug('ERROR AL INTENTAR OBTENER PRICEBOOK');
					System.debug(ex.getMessage());
					System.debug(ex.getStackTraceString());
				}
			}
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
				}
			}

			//Revisar si existen o no las listas de precio de los productos del JSON financingEntityInsurance
			for(String clave : productosJsonFinancingEntityInsurance){
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
				}
			}

			//Revisar si existen o no las listas de precio de los productos del JSON financingEntitySurcharges
			for(String clave : productosJsonFinancingEntitySurcharges){
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
				}
			}

			//Revisar si existen o no las listas de precio de los productos del JSON dealerSurcharges
			for(String clave : productosJsonDealerSurcharges){
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
				}
			}

			//Revisar si existen o no las listas de precio de los productos del JSON dealerInsurance
			//for(String clave : productosJsonDealerInsurance){
				//String idProd2 = mapProducts.get(clave);
				//String idPricebookEntrySF = mapPricebooks.get(idProd2);
				//if(String.isEmpty(idPricebookEntrySF)){
					//System.debug('Pricebook Id no encontrado = '+clave);
					//PricebookEntry price = new PricebookEntry();
					//price.UnitPrice = 1;
					//price.Product2Id = mapProducts.get(clave);
					//price.IsActive = true;
					//price.Pricebook2Id = pb2.Id;
					//priceToAdd.add(price);
				//}
			//}

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

}