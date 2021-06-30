/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto J. Zamorano (RJZ)
Proyecto: Amicar
Descripción: Clase invocable que obtiene datos de solicitud y cliente para envio a servicio de Amicar que retorna simulaciones (paso 1, simulación informal)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 06-02-2020            RJZ                      Creación de la Clase.
1.1 11-03-2020            RJZ                      Escribe simulaciones en Sf y obtiene información de estado de ejecución del servicio en la solicitud 
                                                   (OK o NOK + respuesta servicio). Se agrega parametro api-key a llamada a servicio.
1.2 11-03-2020            RJZ                      Se agrega tabla de desarrollo de crédito (cuotas)
1.3 14-05-2020            RJZ                      Se agrega dealerRate en simulaciones de respuesta del CORE. Se modifica para esto clase 
                                                   AMICAR_Resp_Simulacion_WSJson, se agrega el campo en el objeto y se mapea
1.4 15-12-2020			  RL					   Modificación de código para pegar "factorCalculated" en vez de value para carga de productos.
1.5 14-05-2021			  RL					   Se agrega campo "Source" en estructura json para simulation/save
***********************************************************************************/
global class AMICAR_ObtieneSimulaciones {

    @InvocableMethod(label='Obtener simulaciones paso 1' description='Obtiene simulaciones desde solicitud informal')
    public static List<string> ObtieneSimulaciones (List<string> inputParams) {

        Integer retoma;
        String jsonSolicitud;
        String tipoRegistro;
        
        System.debug('parametros->'+inputParams);

        List<Opportunity> solicitudSalesforce = [SELECT 
                                                Id,
                                                OwnerId,
                                                Name,
                                                AccountId,
                                                CloseDate,
                                                Tipo_de_Veh_culo__c,
                                                Precio_vehiculo__c,
                                                toLabel(Marca_vehiculo__c),
                                                Modelo2__c,
                                                Pie__c,
                                                Pie_formula__c,
                                                Cuotas__c,
                                                Tipo_de_tasa__c,
                                                Opcion_inmediata__c,
                                                Monto_retoma__c,
                                                Vendedor__c,
                                                Codigo_Concesionario__c,
                                                Codigo_Importador__c,
                                                Local__c,
                                                Local__r.Codigo_Local__c,
                                                Local__r.Importador__c,
                                                Modelo2__r.Name,
                                                Modelo2__r.Codigo_modelo__c,
                                                Account.Name,
                                                Account.PersonEmail,
                                                Account.PersonMobilePhone,
                                                Account.RUT__c,
												Account.isPersonAccount,
                                                Owner.RUT_F_I__c,
                                                Vendedor__r.RUT__c,
                                                RecordType.DeveloperName,
                                                Tipo_de_financiamiento__c
                                            FROM Opportunity WHERE Id =: inputParams];

        System.debug('solicitud->'+solicitudSalesforce[0]);

        if (solicitudSalesforce[0].Monto_retoma__c != null){
            retoma = Integer.valueOf(solicitudSalesforce[0].Monto_retoma__c);
        }else{
            retoma = 0;
        }

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
                                '"brandName":"'+solicitudSalesforce[0].Marca_vehiculo__c + '",' +
                                '"modelName":"'+solicitudSalesforce[0].Modelo2__r.Name + '"' +
                            '},'+
                            '"loan":{'+
                                '"source":"Salesforce",'+
								'"downPayment":'+ Integer.valueOf(solicitudSalesforce[0].Pie__c) + ',' +
                                '"downPaymentPercentage":'+ Integer.valueOf(solicitudSalesforce[0].Pie_formula__c) + ',' +
                                '"term":'+ Integer.valueOf(solicitudSalesforce[0].Cuotas__c) + ',' +
                                '"balance":'+ balance +',' +
                                '"startDate":"'+ String.valueOf(System.today()) + '",' +
                                //Datetime.newInstance(d.year(), d.month(), d.day()).format('yyy-MM-dd')
                                '"firstDueDate":"'+ Datetime.newInstance(solicitudSalesforce[0].CloseDate.year(), solicitudSalesforce[0].CloseDate.month(), solicitudSalesforce[0].CloseDate.day()).format('yyy-MM-dd') + '",' +
                                '"rateType":"'+ solicitudSalesforce[0].Tipo_de_tasa__c + '",' +
                                // importador
                                '"saleChannel":"'+ solicitudSalesforce[0].Local__r.Importador__c + '",'+ 
                                '"saleChannelType": "IMPORTADOR",'+
                                // local
                                '"salesRoomId":'+ Integer.valueOf(solicitudSalesforce[0].Local__r.Codigo_Local__c) + ',' +
                                '"immediateOption":'+ solicitudSalesforce[0].Opcion_inmediata__c + ',' +
                                '"tradeInCarValue":'+ retoma + ',' +
                                '"accessories": 0,'+
                                '"type":"'+ solicitudSalesforce[0].Tipo_de_financiamiento__c + '",' +
                                '"modifyTerm": []'+
                            '}'+
                        '}';

        System.debug('json->'+jsonSolicitud);
        
        // llamada a metodo futuro para envio a servicio
        Id id_oportunidad = inputParams[0];
        String tipoDeTasa = solicitudSalesforce[0].Tipo_de_tasa__c;
        
        envioServicio(jsonSolicitud,id_oportunidad,tipoDeTasa,solicitudSalesforce[0].RecordType.DeveloperName);

        List<string> results = new List<string>();
        return results;
    }

    @future(callout=true)
    static void envioServicio(String jsonEnvio,Id solicitudId,String tipoTasa,String tipoDeRegistro){
        String resultadoServcio;
        String tablaDesarrollo;

        List<AMICAR_Integracion__mdt> endpointSolicitudes = [SELECT Id,URL__c,Metodo__c 
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
        string url = endpointSolicitudes[0].URL__c;
        system.debug(url);
        request.setEndpoint(url);

        request.setMethod(endpointSolicitudes[0].Metodo__c);
        request.setTimeOut(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('x-api-key', apkey[0].APK__c);
        request.setBody(jsonEnvio);
        System.debug('request->'+request);

        HttpResponse response = new HttpResponse();

        try{
            if (!Test.isRunningTest()){
                response = http.send(request);
            }else{
                response.setStatusCode(200);
                response.setStatus('OK');
                response.setBody('[{"finalLoanValues":{"loanType":"CONVENTIONAL","rateType":"CONVENTIONAL_3_ZERO_FEES","term":36,"balance":8000000,"downPaymentPercentage":42.86,"UFValue":28708.8,"totalSurchargesToMAF":430000,"totalSurchargesToQuote":0,"totalSurchargesToQuoteMafPercentage":0,"totalSurchargesToQuoteMafValue":0,"factorTotal":0.933,"promissoryFactor":0.008,"promissoryValue":72283,"totalToFinance":9035370,"totalToFinanceUF":314.72,"finalCapital":9059464,"daysDelayedFirstDue":35,"delayedInterest":24094,"monthlyPayment":333001,"customerRate":1.6,"dealerRate":1.27,"dealerCommission":512838,"amicarCommission":963786},"equivalentAnnualCharge":{"annualCAE":28.48,"monthlyCAE":2.37,"totalLoanCost":11988036},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-11-05","daysBetweenExpirationsDates":35,"quotaType":"REGULAR","payment":333001,"beginningBalance":9059464,"principal":188049,"interest":144951,"endingBalance":8871415,"cumulativeInterest":144951,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":2,"expirationDate":"2020-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":8871415,"principal":191058,"interest":141943,"endingBalance":8680357,"cumulativeInterest":286894,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":3,"expirationDate":"2021-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":8680357,"principal":194115,"interest":138886,"endingBalance":8486242,"cumulativeInterest":425780,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":4,"expirationDate":"2021-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":8486242,"principal":197221,"interest":135780,"endingBalance":8289021,"cumulativeInterest":561560,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":5,"expirationDate":"2021-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":333001,"beginningBalance":8289021,"principal":200376,"interest":132624,"endingBalance":8088644,"cumulativeInterest":694184,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":6,"expirationDate":"2021-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":8088644,"principal":203582,"interest":129418,"endingBalance":7885062,"cumulativeInterest":823602,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":7,"expirationDate":"2021-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":7885062,"principal":206840,"interest":126161,"endingBalance":7678222,"cumulativeInterest":949763,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":8,"expirationDate":"2021-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":7678222,"principal":210149,"interest":122852,"endingBalance":7468073,"cumulativeInterest":1072615,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":9,"expirationDate":"2021-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":7468073,"principal":213512,"interest":119489,"endingBalance":7254562,"cumulativeInterest":1192104,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":10,"expirationDate":"2021-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":7254562,"principal":216928,"interest":116073,"endingBalance":7037634,"cumulativeInterest":1308177,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":11,"expirationDate":"2021-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":7037634,"principal":220399,"interest":112602,"endingBalance":6817235,"cumulativeInterest":1420779,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":12,"expirationDate":"2021-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":6817235,"principal":223925,"interest":109076,"endingBalance":6593311,"cumulativeInterest":1529855,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":13,"expirationDate":"2021-11-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":6593311,"principal":227508,"interest":105493,"endingBalance":6365803,"cumulativeInterest":1635348,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":14,"expirationDate":"2021-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":6365803,"principal":231148,"interest":101853,"endingBalance":6134655,"cumulativeInterest":1737201,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":15,"expirationDate":"2022-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":6134655,"principal":234846,"interest":98154,"endingBalance":5899809,"cumulativeInterest":1835355,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":16,"expirationDate":"2022-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":5899809,"principal":238604,"interest":94397,"endingBalance":5661205,"cumulativeInterest":1929752,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":17,"expirationDate":"2022-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":333001,"beginningBalance":5661205,"principal":242421,"interest":90579,"endingBalance":5418784,"cumulativeInterest":2020331,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":18,"expirationDate":"2022-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":5418784,"principal":246300,"interest":86701,"endingBalance":5172483,"cumulativeInterest":2107032,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":19,"expirationDate":"2022-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":5172483,"principal":250241,"interest":82760,"endingBalance":4922242,"cumulativeInterest":2189792,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":20,"expirationDate":"2022-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":4922242,"principal":254245,"interest":78756,"endingBalance":4667998,"cumulativeInterest":2268548,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":21,"expirationDate":"2022-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":4667998,"principal":258313,"interest":74688,"endingBalance":4409685,"cumulativeInterest":2343236,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":22,"expirationDate":"2022-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":4409685,"principal":262446,"interest":70555,"endingBalance":4147239,"cumulativeInterest":2413790,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":23,"expirationDate":"2022-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":4147239,"principal":266645,"interest":66356,"endingBalance":3880594,"cumulativeInterest":2480146,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":24,"expirationDate":"2022-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":3880594,"principal":270911,"interest":62090,"endingBalance":3609683,"cumulativeInterest":2542236,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":25,"expirationDate":"2022-11-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":3609683,"principal":275246,"interest":57755,"endingBalance":3334437,"cumulativeInterest":2599991,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":26,"expirationDate":"2022-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":3334437,"principal":279650,"interest":53351,"endingBalance":3054788,"cumulativeInterest":2653342,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":27,"expirationDate":"2023-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":3054788,"principal":284124,"interest":48877,"endingBalance":2770664,"cumulativeInterest":2702218,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":28,"expirationDate":"2023-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":2770664,"principal":288670,"interest":44331,"endingBalance":2481994,"cumulativeInterest":2746549,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":29,"expirationDate":"2023-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":333001,"beginningBalance":2481994,"principal":293289,"interest":39712,"endingBalance":2188705,"cumulativeInterest":2786261,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":30,"expirationDate":"2023-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":2188705,"principal":297981,"interest":35019,"endingBalance":1890723,"cumulativeInterest":2821280,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":31,"expirationDate":"2023-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":1890723,"principal":302749,"interest":30252,"endingBalance":1587974,"cumulativeInterest":2851532,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":32,"expirationDate":"2023-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":1587974,"principal":307593,"interest":25408,"endingBalance":1280381,"cumulativeInterest":2876939,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":33,"expirationDate":"2023-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":1280381,"principal":312515,"interest":20486,"endingBalance":967866,"cumulativeInterest":2897425,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":34,"expirationDate":"2023-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":967866,"principal":317515,"interest":15486,"endingBalance":650352,"cumulativeInterest":2912911,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":35,"expirationDate":"2023-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":333001,"beginningBalance":650352,"principal":322595,"interest":10406,"endingBalance":327757,"cumulativeInterest":2923317,"totalSurchargesToQuote":0,"finalPayment":333001},{"paymentNumber":36,"expirationDate":"2023-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":333001,"beginningBalance":327757,"principal":327757,"interest":5244,"endingBalance":0,"cumulativeInterest":2928561,"totalSurchargesToQuote":0,"finalPayment":333001}],"surchargesAndInsurances":{"amicarAssistance":[],"dealerSurcharges":[{"id":1,"description":"IMPUESTO VERDE","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":3,"description":"PATENTE","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":9,"description":"MANTENCION PREPAGADA","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":5,"description":"INSCRIPCION","value":0,"isEditable":false,"currencyType":"CLP","factorCalculated":0,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntitySurcharges":[{"id":412,"description":"G. OPERACIONALES","value":430000,"isEditable":false,"currencyType":"CLP","factorCalculated":430000,"selected":true,"isRequired":true}],"financingEntityInsurance":[{"id":335,"description":"DESGRAVAMEN","value":59,"currencyType":"CLP","factorCalculated":533087,"selected":true,"isRequired":true},{"id":338,"description":"VIDA","value":58,"currencyType":"CLP","factorCalculated":524051,"selected":false,"isRequired":false},{"id":339,"description":"CUOTA PROTEGIDA","value":7990,"currencyType":"CLP","factorCalculated":7990,"selected":false,"isRequired":false},{"id":340,"description":"CESANTIA","value":28,"currencyType":"CLP","factorCalculated":252990,"selected":false,"isRequired":false}]}},{"finalLoanValues":{"loanType":"CONVENTIONAL","rateType":"CONVENTIONAL_3_ZERO_FEES","term":48,"balance":8000000,"downPaymentPercentage":42.86,"UFValue":28708.8,"totalSurchargesToMAF":356500,"totalSurchargesToQuote":0,"totalSurchargesToQuoteMafPercentage":0,"totalSurchargesToQuoteMafValue":0,"factorTotal":0.931,"promissoryFactor":0.008,"promissoryValue":71807,"totalToFinance":8975832,"totalToFinanceUF":312.65,"finalCapital":8999768,"daysDelayedFirstDue":35,"delayedInterest":23936,"monthlyPayment":270045,"customerRate":1.6,"dealerRate":1.27,"dealerCommission":659302,"amicarCommission":1251567},"equivalentAnnualCharge":{"annualCAE":26.06,"monthlyCAE":2.17,"totalLoanCost":12962160},"amortizationSchedule":[{"paymentNumber":1,"expirationDate":"2020-11-05","daysBetweenExpirationsDates":35,"quotaType":"REGULAR","payment":270045,"beginningBalance":8999768,"principal":126049,"interest":143996,"endingBalance":8873719,"cumulativeInterest":143996,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":2,"expirationDate":"2020-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":8873719,"principal":128065,"interest":141980,"endingBalance":8745654,"cumulativeInterest":285976,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":3,"expirationDate":"2021-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":8745654,"principal":130114,"interest":139930,"endingBalance":8615540,"cumulativeInterest":425906,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":4,"expirationDate":"2021-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":8615540,"principal":132196,"interest":137849,"endingBalance":8483343,"cumulativeInterest":563755,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":5,"expirationDate":"2021-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":270045,"beginningBalance":8483343,"principal":134311,"interest":135733,"endingBalance":8349032,"cumulativeInterest":699488,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":6,"expirationDate":"2021-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":8349032,"principal":136460,"interest":133585,"endingBalance":8212572,"cumulativeInterest":833073,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":7,"expirationDate":"2021-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":8212572,"principal":138644,"interest":131401,"endingBalance":8073928,"cumulativeInterest":964474,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":8,"expirationDate":"2021-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":8073928,"principal":140862,"interest":129183,"endingBalance":7933066,"cumulativeInterest":1093657,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":9,"expirationDate":"2021-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":7933066,"principal":143116,"interest":126929,"endingBalance":7789950,"cumulativeInterest":1220586,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":10,"expirationDate":"2021-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":7789950,"principal":145406,"interest":124639,"endingBalance":7644545,"cumulativeInterest":1345225,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":11,"expirationDate":"2021-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":7644545,"principal":147732,"interest":122313,"endingBalance":7496812,"cumulativeInterest":1467538,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":12,"expirationDate":"2021-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":7496812,"principal":150096,"interest":119949,"endingBalance":7346717,"cumulativeInterest":1587487,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":13,"expirationDate":"2021-11-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":7346717,"principal":152497,"interest":117547,"endingBalance":7194219,"cumulativeInterest":1705034,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":14,"expirationDate":"2021-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":7194219,"principal":154937,"interest":115108,"endingBalance":7039282,"cumulativeInterest":1820142,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":15,"expirationDate":"2022-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":7039282,"principal":157416,"interest":112629,"endingBalance":6881865,"cumulativeInterest":1932770,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":16,"expirationDate":"2022-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":6881865,"principal":159935,"interest":110110,"endingBalance":6721930,"cumulativeInterest":2042880,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":17,"expirationDate":"2022-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":270045,"beginningBalance":6721930,"principal":162494,"interest":107551,"endingBalance":6559436,"cumulativeInterest":2150431,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":18,"expirationDate":"2022-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":6559436,"principal":165094,"interest":104951,"endingBalance":6394343,"cumulativeInterest":2255382,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":19,"expirationDate":"2022-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":6394343,"principal":167735,"interest":102309,"endingBalance":6226607,"cumulativeInterest":2357692,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":20,"expirationDate":"2022-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":6226607,"principal":170419,"interest":99626,"endingBalance":6056188,"cumulativeInterest":2457317,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":21,"expirationDate":"2022-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":6056188,"principal":173146,"interest":96899,"endingBalance":5883042,"cumulativeInterest":2554216,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":22,"expirationDate":"2022-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":5883042,"principal":175916,"interest":94129,"endingBalance":5707126,"cumulativeInterest":2648345,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":23,"expirationDate":"2022-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":5707126,"principal":178731,"interest":91314,"endingBalance":5528395,"cumulativeInterest":2739659,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":24,"expirationDate":"2022-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":5528395,"principal":181591,"interest":88454,"endingBalance":5346805,"cumulativeInterest":2828113,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":25,"expirationDate":"2022-11-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":5346805,"principal":184496,"interest":85549,"endingBalance":5162309,"cumulativeInterest":2913662,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":26,"expirationDate":"2022-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":5162309,"principal":187448,"interest":82597,"endingBalance":4974861,"cumulativeInterest":2996259,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":27,"expirationDate":"2023-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":4974861,"principal":190447,"interest":79598,"endingBalance":4784414,"cumulativeInterest":3075857,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":28,"expirationDate":"2023-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":4784414,"principal":193494,"interest":76551,"endingBalance":4590919,"cumulativeInterest":3152407,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":29,"expirationDate":"2023-03-05","daysBetweenExpirationsDates":28,"quotaType":"REGULAR","payment":270045,"beginningBalance":4590919,"principal":196590,"interest":73455,"endingBalance":4394329,"cumulativeInterest":3225862,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":30,"expirationDate":"2023-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":4394329,"principal":199736,"interest":70309,"endingBalance":4194594,"cumulativeInterest":3296171,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":31,"expirationDate":"2023-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":4194594,"principal":202931,"interest":67113,"endingBalance":3991662,"cumulativeInterest":3363285,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":32,"expirationDate":"2023-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":3991662,"principal":206178,"interest":63867,"endingBalance":3785484,"cumulativeInterest":3427152,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":33,"expirationDate":"2023-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":3785484,"principal":209477,"interest":60568,"endingBalance":3576007,"cumulativeInterest":3487719,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":34,"expirationDate":"2023-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":3576007,"principal":212829,"interest":57216,"endingBalance":3363178,"cumulativeInterest":3544935,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":35,"expirationDate":"2023-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":3363178,"principal":216234,"interest":53811,"endingBalance":3146944,"cumulativeInterest":3598746,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":36,"expirationDate":"2023-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":3146944,"principal":219694,"interest":50351,"endingBalance":2927250,"cumulativeInterest":3649097,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":37,"expirationDate":"2023-11-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":2927250,"principal":223209,"interest":46836,"endingBalance":2704041,"cumulativeInterest":3695933,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":38,"expirationDate":"2023-12-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":2704041,"principal":226780,"interest":43265,"endingBalance":2477261,"cumulativeInterest":3739198,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":39,"expirationDate":"2024-01-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":2477261,"principal":230409,"interest":39636,"endingBalance":2246853,"cumulativeInterest":3778834,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":40,"expirationDate":"2024-02-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":2246853,"principal":234095,"interest":35950,"endingBalance":2012757,"cumulativeInterest":3814784,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":41,"expirationDate":"2024-03-05","daysBetweenExpirationsDates":29,"quotaType":"REGULAR","payment":270045,"beginningBalance":2012757,"principal":237841,"interest":32204,"endingBalance":1774917,"cumulativeInterest":3846988,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":42,"expirationDate":"2024-04-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":1774917,"principal":241646,"interest":28399,"endingBalance":1533270,"cumulativeInterest":3875387,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":43,"expirationDate":"2024-05-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":1533270,"principal":245513,"interest":24532,"endingBalance":1287758,"cumulativeInterest":3899919,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":44,"expirationDate":"2024-06-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":1287758,"principal":249441,"interest":20604,"endingBalance":1038317,"cumulativeInterest":3920523,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":45,"expirationDate":"2024-07-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":1038317,"principal":253432,"interest":16613,"endingBalance":784885,"cumulativeInterest":3937136,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":46,"expirationDate":"2024-08-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":784885,"principal":257487,"interest":12558,"endingBalance":527399,"cumulativeInterest":3949694,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":47,"expirationDate":"2024-09-05","daysBetweenExpirationsDates":31,"quotaType":"REGULAR","payment":270045,"beginningBalance":527399,"principal":261606,"interest":8438,"endingBalance":265792,"cumulativeInterest":3958133,"totalSurchargesToQuote":0,"finalPayment":270045},{"paymentNumber":48,"expirationDate":"2024-10-05","daysBetweenExpirationsDates":30,"quotaType":"REGULAR","payment":270045,"beginningBalance":265792,"principal":265792,"interest":4253,"endingBalance":0,"cumulativeInterest":3962385,"totalSurchargesToQuote":0,"finalPayment":270045}],"surchargesAndInsurances":{"amicarAssistance":[],"dealerSurcharges":[{"id":1,"description":"IMPUESTO VERDE","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":3,"description":"PATENTE","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":9,"description":"MANTENCION PREPAGADA","value":0,"isEditable":true,"currencyType":"CLP","factorCalculated":0,"selected":false,"isRequired":false},{"id":5,"description":"INSCRIPCION","value":0,"isEditable":false,"currencyType":"CLP","factorCalculated":0,"selected":true,"isRequired":true}],"dealerInsurance":[],"financingEntitySurcharges":[{"id":417,"description":"G. OPERACIONALES","value":356500,"isEditable":false,"currencyType":"CLP","factorCalculated":356500,"selected":true,"isRequired":true}],"financingEntityInsurance":[{"id":336,"description":"DESGRAVAMEN","value":61,"currencyType":"CLP","factorCalculated":547526,"selected":true,"isRequired":true},{"id":338,"description":"VIDA","value":58,"currencyType":"CLP","factorCalculated":520598,"selected":false,"isRequired":false},{"id":339,"description":"CUOTA PROTEGIDA","value":7990,"currencyType":"CLP","factorCalculated":7990,"selected":false,"isRequired":false},{"id":340,"description":"CESANTIA","value":28,"currencyType":"CLP","factorCalculated":251323,"selected":false,"isRequired":false}]}}]');
            }
        }catch(Exception e){
            envioServicio(jsonEnvio,solicitudId,tipoTasa,tipoDeRegistro);
        }

        System.debug('respuesta->'+response);

        if (response.getStatusCode() == 200 && response.getStatus() != null){

            List<Quote> eliminarEscenarios = [SELECT Id FROM Quote WHERE OpportunityId =: solicitudId];
            if (eliminarEscenarios.size() != 0 && !Test.isRunningTest()){
                delete eliminarEscenarios;
            }
            
            //
            // servicio responde OK, analizamos la respuesta
            //----------------------------------------------------------------------------------
            String respuestaServicio = response.getBody();
            System.debug('body->'+response.getBody());

            procesoRespuestaServicio(respuestaServicio,solicitudId,tipoTasa,tipoDeRegistro);

            resultadoServcio = 'OK';

        }else{
            
            //
            // servicio responde NOK, guardamos la respuesta en la solicitud
            //----------------------------------------------------------------------------------
            System.debug('ERROR-> '+response.getStatus());
            System.debug('Descr->'+response.getBody());

            resultadoServcio = 'Mensaje: '+ response.getBody();
        }

        Opportunity updOportunidad = [SELECT Id,Respuesta_Servicio__c FROM Opportunity WHERE Id =: solicitudId];

        updOportunidad.Respuesta_Servicio__c = resultadoServcio;
        update updOportunidad;
    }


    static void procesoRespuestaServicio(String respuestaMetodo,Id solicitudMetodo,String tasaMetodo,String registroMetodo){
        List<AMICAR_Resp_Simulacion_WSJson> respuestaSimulacion = (List<AMICAR_Resp_Simulacion_WSJson>) Json.deserialize(respuestaMetodo, List<AMICAR_Resp_Simulacion_WSJson>.class);
        System.debug('respuesta simulacion->'+respuestaSimulacion);
		System.debug('Cantidad respuesta simulacion->'+respuestaSimulacion.size());
        System.debug('tipo de tasa->'+tasaMetodo);
        System.debug('registro->'+registroMetodo);

        List<Desarrollo__c> nuevoDesarrollo = new List<Desarrollo__c>();
        
        Pricebook2 IdListaPrecios;
        if (!Test.isRunningTest()){
            IdListaPrecios = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        }else{
            Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
            );
            update standardPricebook;
            IdListaPrecios = [SELECT Id FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        }

        Id rt;
        if (registroMetodo == 'Simulacion_CORE'){
            rt = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
        }else{
            rt = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Presupuesto Renovaciones').getRecordTypeId();
        }

        for (AMICAR_Resp_Simulacion_WSJson respuesta:respuestaSimulacion){

            System.debug('respuesta->'+respuesta);

            Quote cotizacion = new Quote();

            cotizacion.RecordTypeId = rt;
            cotizacion.Name = 'simulacion ' + respuesta.FinalLoanValues.loanType + ' ' + respuesta.FinalLoanValues.term;
            cotizacion.OpportunityId = solicitudMetodo;
            cotizacion.Status = 'Borrador';

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
            cotizacion.Tipo_de_Tasa2__c = respuesta.FinalLoanValues.rateType;
            cotizacion.Pricebook2Id = IdListaPrecios.Id;
            cotizacion.Comisi_n_dealer__c = respuesta.FinalLoanValues.dealerCommission;
            cotizacion.Fecha_creacion__c = System.now();
            cotizacion.Tasa_dealer__c = respuesta.FinalLoanValues.dealerRate;
			
			System.debug('CUOTAS = '+respuesta.amortizationSchedule);
			//Se agrega VFMG
			for(AMICAR_Resp_Simulacion_WSJson.AmortizationSchedule amrtSch : respuesta.amortizationSchedule){
				System.debug('TIPO DE CUOTA = '+ amrtSch.quotaType); 
				if(amrtSch.quotaType == 'SMART'){
      				System.debug('ES SMART');
					System.debug('VFMG = '+amrtSch.payment);
					cotizacion.VFMG__c = amrtSch.payment;
      				break;
				}
			}
			//Fin VFMG
            System.debug('quote->'+cotizacion);
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
                if (desarrollo.quotaType == 'MODIFIED'){
                    cuota.Modificado__c = true;
                }else{
                    cuota.Modificado__c = false;
                }
                //cuota.Solicitud__c = solicitudId;
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

            List<Product2> ListaProductos = [SELECT Identificador__c,Id,Family FROM Product2 WHERE IsActive = true AND (Family = 'amicarAssistance' OR Family = 'dealerSurcharges' OR Family = 'financingEntityInsurance' OR Family = 'dealerInsurance' OR Family = 'financingEntitySurcharges')];
            Map<String,Id> MapaAsistencias = new Map<String,Id>();

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
                        //AGREGADO POR MJ PARA QUE NO SE CAIGA SI NO ENCUENTRA EL PRODUCTO
                        if(nuevoItem.Product2Id != null){
                            asistenciasAmicarSimulacion.add(nuevoItem);
                        }
                        
                    }
                }

                System.debug('asistencias amicar->'+asistenciasAmicarSimulacion);
                if (!asistenciasAmicarSimulacion.isEmpty()){
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
						//Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
						//nuevoItem.Value__c = recargosDealer.value;
						nuevoItem.Value__c = recargosDealer.factorCalculated;
                        nuevoItem.Divisa__c = recargosDealer.currencyType;
                        nuevoItem.QuoteId = cotizacion.Id;
                        nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

                        nuevoItem.Editable__c = recargosDealer.isEditable;
                        nuevoItem.Requerido__c = recargosDealer.isRequired;
                        nuevoItem.Seleccionado__c = recargosDealer.selected;
                        //AGREGADO POR MJ PARA QUE NO SE CAIGA SI NO ENCUENTRA EL PRODUCTO
                        if(nuevoItem.Product2Id != null){
                            recargosDealerSimulacion.add(nuevoItem);
                        }
                    }
                }

                System.debug('recargos dealer->'+recargosDealerSimulacion);
                if (!recargosDealerSimulacion.isEmpty()){
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
						//Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
						//nuevoItem.Value__c = recargosEf.value;
						nuevoItem.Value__c = recargosEf.factorCalculated;
                        nuevoItem.QuoteId = cotizacion.Id;
                        nuevoItem.Divisa__c = recargosEf.currencyType;
                        nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

                        nuevoItem.Editable__c = recargosEf.IsEditable;
                        nuevoItem.Requerido__c = recargosEf.isRequired;
                        nuevoItem.Seleccionado__c = recargosEf.selected;
                        //AGREGADO POR MJ PARA QUE NO SE CAIGA SI NO ENCUENTRA EL PRODUCTO
                        if(nuevoItem.Product2Id != null){
                            recargosEfSimulacion.add(nuevoItem);
                        }
                    }

                    System.debug('recargos dealer->'+recargosEfSimulacion);
                    if (!recargosEfSimulacion.isEmpty()){
                        insert recargosEfSimulacion;
                    }

                }
                MapaAsistencias.clear();

                //
                //dealerInsurance 
                //----------------------------------------------------------------------------------
                //for (Product2 ProductosEnLista:ListaProductos){
                //  if (ProductosEnLista.Family == 'segurosDealerSimulacion'){
                //      MapaAsistencias.put(ProductosEnLista.Identificador__c, ProductosEnLista.Id);
                //  }
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
						//Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
						//nuevoItem.Value__c = segurosEF.value;
						nuevoItem.Value__c = segurosEF.factorCalculated;
                        nuevoItem.Divisa__c = segurosEF.currencyType;
                        nuevoItem.QuoteId = cotizacion.Id;
                        nuevoItem.PricebookEntryId = MapaEntradas.get(nuevoItem.Product2Id);

                        nuevoItem.Editable__c = false;
                        nuevoItem.Requerido__c = segurosEF.isRequired;
                        nuevoItem.Seleccionado__c = segurosEF.selected;
                        //AGREGADO POR MJ PARA QUE NO SE CAIGA SI NO ENCUENTRA EL PRODUCTO
                        if(nuevoItem.Product2Id != null){
                            segurosEfSimulacion.add(nuevoItem);
                        }
                    }

                    System.debug('seguros EF->'+segurosEfSimulacion);
                    if (!segurosEfSimulacion.isEmpty()){
                        insert segurosEfSimulacion;
                    }
                }

                MapaAsistencias.clear();
            }
        }

    }

	public Static void checkProductsAndPricebookentries(AMICAR_Resp_Simulacion_WSJson.SurchargesAndInsurances jsonR){
		try{
			List<Product2> prodToAdd = new List<Product2>();
			List<PricebookEntry> priceToAdd = new List<PricebookEntry>();
			List<String> productosJsonAmicarAssistance = new List<String>();
			List<String> productosJsonFinancingEntityInsurance = new List<String>();
			List<String> productosJsonDealerSurcharges = new List<String>();
			List<String> productosJsonDealerInsurance = new List<String>();
			List<String> productosJsonFinancingEntitySurcharges = new List<String>();
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

			//revisar si no existen productos financingEntitySurcharges
			for(AMICAR_Resp_Simulacion_WSJson.DealerSurcharges prod : jsonR.financingEntitySurcharges){
				String clave = prod.description + ' ' + prod.id + ' financingEntitySurcharges';
				productosJsonFinancingEntitySurcharges.add(clave);
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
			if(Test.isRunningTest()){
				pb2.Id = Test.getStandardPricebookId();
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