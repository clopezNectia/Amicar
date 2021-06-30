/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Test para AMICAR_ServicioRestOpportunityWS y AMICAR_OpportunityJSON2
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 21-10-2020            RL                       Creación de la Clase.
***********************************************************************************/

@isTest 
private class AMICAR_ServicioRestOpportunityWS_Test {
    @testSetup 
    static void setup(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Ejecutivo Simulaciones']; 
        
        User ejecutivoAmicar = new User(
            Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='usuariotest@testorg.com',                                                                          // Usuario de Marketing Cloud válido
            RUT_F_I__c = '194391811'
        );
        insert ejecutivoAmicar;
        
        Local__c local = new Local__c(
          Name = '10 CARRERA',// Nombre de Local
          Codigo_Local__c = '1',             // Código Local
          Importador__c = '829957000',       // Importador
          Concesionario__c = '69'  // Concesionario
        );
        insert local;
        
        Vendedor__c vendedor = new Vendedor__c(
          Name = 'Vendedor Dummy',              // Nombre
          RUT__c = '112223339',                   // RUT
          Local__c = '153 DERCOUSADOS VITACURA'  // Local
        );
        insert vendedor;

        //Marca__c marcaVeh = new Marca__c(
          //Name = 'MAZDA',         // Nombre de Marca
          //Codigo_Marca__c = '831'  // Codigo_Marca
        //);
        //insert marcaVeh;

        
        Modelo_de_vehiculo__c modVeh = new Modelo_de_vehiculo__c(
          Modelo__c = 'CX-5',    // Modelo
          //Marca__c = '831',      // Marca
          Marca__c = '831',      // Marca
          //Marca_Busqueda__c = marcaVeh.Id,
          Codigo_modelo__c = '1146'  // Código modelo
        );
        insert modVeh;

        //marcaVeh = new Marca__c(
            //Name = 'HYUNDAI',
            //Codigo_Marca__c = '824'
        //);
        //insert marcaVeh;

        modVeh = new Modelo_de_vehiculo__c(
          Modelo__c = 'ELANTRA',    // Modelo
          Marca__c = '824',      // Marca
          //Marca_Busqueda__c = marcaVeh.Id,
          Codigo_modelo__c = '1147'  // Código modelo
        );
        insert modVeh;

        Account cliente = new Account(
          RUT__c = '1-9',                      // RUT
          PersonBirthdate = Date.valueOf('1983-12-19'),  // Birthdate
          FirstName = 'Roberto',                 // Account Name
          LastName = 'Runge De la Barra',
          //Genero__pc = 'Masculino',                      // Género
          //Nacionalidad__pc = 'Chileno',                  // Nacionalidad
          PersonEmail = 'ee@gmail.com',                  // Email
          PersonHasOptedOutOfEmail = false,              // Email Opt Out
          PersonMobilePhone = '999999999',               // Mobile
          PersonDoNotCall = false,                       // Do Not Call
          RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId()                    // Account Record Type
        );
        insert cliente;

        Pricebook2 pb2 = new Pricebook2(
            Name = 'Standard Price Book',
            IsActive = true);
        insert pb2;
    }
    
    //Test Persona Natural - Camino Feliz
    static testmethod void test1(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de función
    static testmethod void test2(){
        Test.startTest();
        String stage = '';      
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('DRAFT_SIMULATION');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('SAVED_SIMULATION');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('FORMALIZED_REQUEST');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('FINISHED_AUCTION');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('GRANTED');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('VALIDATION_STAGE');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('AWARDED');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('CHECKLIST_VALIDATION');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('CHECKLIST_CONFIRMED');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('SIGNING');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('FOLDER_VALIDATION');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('CANCELED');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('CLOSED');
        stage = AMICAR_ServiciosRestOpportunityWS.TranslateStatusStage('CLOSED_WITHOUT_APPROVALS');

        Test.stopTest();
    }

    //Test de método GET
    static testmethod void test3(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Opportunities/getOpportunity/123456';  
        req.httpMethod = 'GET';  
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.getOpportunity();
        Test.stopTest();
    }

    //Test para deserializar JSON Persona Natural
    static testmethod void test4(){
        Test.startTest();
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        AMICAR_OpportunityJSON2 oppResp = new AMICAR_OpportunityJSON2();
        oppResp = (AMICAR_OpportunityJSON2) System.JSON.deserialize(jsonString, AMICAR_OpportunityJSON2.class);

        decimal eacannualCAE = oppResp.equivalentAnnualCharge.annualCAE;
        decimal eacmonthlyCAE = oppResp.equivalentAnnualCharge.monthlyCAE;
        decimal eactotalLoanCost = oppResp.equivalentAnnualCharge.totalLoanCost;

        Integer flvloanTypeId   = oppResp.finalLoanValues.loanTypeId;
        Integer flvterm = oppResp.finalLoanValues.term; 
        Integer flvbalance  = oppResp.finalLoanValues.balance;
        Decimal flvUFValue  = oppResp.finalLoanValues.UFValue;
        Integer flvtotalSurchargesToMAF = oppResp.finalLoanValues.totalSurchargesToMAF;
        Integer flvtotalSurchargesToQuote   = oppResp.finalLoanValues.totalSurchargesToQuote;
        Decimal flvfactorTotal = oppResp.finalLoanValues.factorTotal; 
        Decimal flvpromissoryFactor = oppResp.finalLoanValues.promissoryFactor; 
        Integer flvpromissoryValue= oppResp.finalLoanValues.promissoryValue;
        Integer flvtotalToFinance = oppResp.finalLoanValues.totalToFinance;
        Decimal flvtotalToFinanceUF = oppResp.finalLoanValues.totalToFinanceUF; 
        Integer flvfinalCapital = oppResp.finalLoanValues.finalCapital; 
        Integer flvdaysDelayedFirstDue  = oppResp.finalLoanValues.daysDelayedFirstDue;
        Integer flvdelayedInterest = oppResp.finalLoanValues.delayedInterest;
        Integer flvmonthlyPayment = oppResp.finalLoanValues.monthlyPayment; 
        Decimal flvcustomerRate = oppResp.finalLoanValues.customerRate; 
        Integer flvdealerCommission = oppResp.finalLoanValues.dealerCommission;
        Integer flvamicarCommission = oppResp.finalLoanValues.amicarCommission; 

        Integer Indexid = oppResp.IndexaProductsConversion.id;
        Integer IndexrateTypeId = oppResp.IndexaProductsConversion.rateTypeId;
        Integer IndexvehicleTypeId = oppResp.IndexaProductsConversion.vehicleTypeId;
        Integer IndexloanTypeId = oppResp.IndexaProductsConversion.loanTypeId;
        Integer IndexsalesChannelId = oppResp.IndexaProductsConversion.salesChannelId;
        Boolean IndeximmediateOption = oppResp.IndexaProductsConversion.immediateOption;
        Integer IndexindexaId = oppResp.IndexaProductsConversion.indexaId;
        String IndexindexaName = oppResp.IndexaProductsConversion.indexaName;
        String IndexcreatedAt = oppResp.IndexaProductsConversion.createdAt;
        String IndexupdatedAt = oppResp.IndexaProductsConversion.updatedAt;
        String IndexdeletedAt = oppResp.IndexaProductsConversion.deletedAt;

        Integer LSMid = oppResp.LoanSimulationData.id;
        Integer LSMcustomerDataId = oppResp.LoanSimulationData.customerDataId; 
        Integer LSMsalesRoomId = oppResp.LoanSimulationData.salesRoomId; 
        Integer LSMratesId = oppResp.LoanSimulationData.ratesId; 
        Integer LSMloanTypeId = oppResp.LoanSimulationData.loanTypeId; 
        Integer LSMsalesRepresentativeId = oppResp.LoanSimulationData.salesRepresentativeId; 
        Integer LSMamicarExecutiveId = oppResp.LoanSimulationData.amicarExecutiveId; 
        String  LSMstatus = oppResp.LoanSimulationData.status; 
        String  LSMdateOfLoanStart = oppResp.LoanSimulationData.dateOfLoanStart; 
        String  LSMdateOfFirstDue = oppResp.LoanSimulationData.dateOfFirstDue; 
        Integer LSMdaysDelayedFirstDue = oppResp.LoanSimulationData.daysDelayedFirstDue; 
        Integer LSMterm = oppResp.LoanSimulationData.term; 
        Integer LSMtotalToFinance = oppResp.LoanSimulationData.totalToFinance; 
        Integer LSMdownPayment = oppResp.LoanSimulationData.downPayment; 
        Integer LSMbalance = oppResp.LoanSimulationData.balance; 
        Integer LSMmonthlyPayment = oppResp.LoanSimulationData.monthlyPayment; 
        Integer LSMfinalCapital = oppResp.LoanSimulationData.finalCapital; 
        Decimal LSMannualCAE = oppResp.LoanSimulationData.annualCAE; 
        String  LSMexternalId = oppResp.LoanSimulationData.externalId; 
        String  LSMsalesForceSourceId = oppResp.LoanSimulationData.salesForceSourceId; 
        Integer LSMtotalSurchargesToMAF = oppResp.LoanSimulationData.totalSurchargesToMAF; 
        String  LSMcampaign = oppResp.LoanSimulationData.campaign; 
        String  LSMcurrencyType = oppResp.LoanSimulationData.currencyType; 
        Integer LSMaccessories = oppResp.LoanSimulationData.accessories; 
        Integer LSMtradeInCarValue = oppResp.LoanSimulationData.tradeInCarValue; 
        Decimal LSMdealerRate = oppResp.LoanSimulationData.dealerRate; 
        Decimal LSMUFValue = oppResp.LoanSimulationData.UFValue; 
        Integer LSMtotalSurchargesToQuote = oppResp.LoanSimulationData.totalSurchargesToQuote; 
        Decimal LSMfactorTotal = oppResp.LoanSimulationData.factorTotal; 
        Decimal LSMpromissoryFactor = oppResp.LoanSimulationData.promissoryFactor; 
        Integer LSMpromissoryValue = oppResp.LoanSimulationData.promissoryValue; 
        Decimal LSMtotalToFinanceUF = oppResp.LoanSimulationData.totalToFinanceUF; 
        Integer LSMdelayedInterest = oppResp.LoanSimulationData.delayedInterest; 
        Integer LSMdealerCommission = oppResp.LoanSimulationData.dealerCommission; 
        Integer LSMamicarCommission = oppResp.LoanSimulationData.amicarCommission; 
        Decimal LSMcustomerRate = oppResp.LoanSimulationData.customerRate; 
        Integer LSMtotalLoanCost = oppResp.LoanSimulationData.totalLoanCost; 
        Decimal LSMmonthlyCAE = oppResp.LoanSimulationData.monthlyCAE; 
        Boolean LSMauctionTimeEnded = oppResp.LoanSimulationData.auctionTimeEnded; 
        String  LSMauctionTime = oppResp.LoanSimulationData.auctionTime; 
        String  LSMcreatedAt = oppResp.LoanSimulationData.createdAt; 
        String  LSMupdatedAt = oppResp.LoanSimulationData.updatedAt; 
        String  LSMdeletedAt = oppResp.LoanSimulationData.deletedAt; 

        Integer LTid = oppResp.LoanSimulationData.loanType.id; 
        String LTdescription = oppResp.LoanSimulationData.loanType.description; 
        String LTcod = oppResp.LoanSimulationData.loanType.cod; 
        String LTcreatedAt = oppResp.LoanSimulationData.loanType.createdAt; 
        String LTupdatedAt = oppResp.LoanSimulationData.loanType.updatedAt; 
        
        Integer Rid = oppResp.LoanSimulationData.Rate.id; 
        Integer RfinancingEntityId = oppResp.LoanSimulationData.Rate.financingEntityId; 
        Integer RrateTypeId = oppResp.LoanSimulationData.Rate.rateTypeId; 
        Integer RvehicleTypeId = oppResp.LoanSimulationData.Rate.vehicleTypeId; 
        Integer RloanTypeId = oppResp.LoanSimulationData.Rate.loanTypeId; 
        Integer RsalesChannelId = oppResp.LoanSimulationData.Rate.salesChannelId; 
        Decimal RcustomerRate = oppResp.LoanSimulationData.Rate.customerRate; 
        Decimal RbaseRate = oppResp.LoanSimulationData.Rate.baseRate; 
        Decimal RdealerRate = oppResp.LoanSimulationData.Rate.dealerRate; 
        Integer RtermsFrom = oppResp.LoanSimulationData.Rate.termsFrom; 
        Integer RtermsTo = oppResp.LoanSimulationData.Rate.termsTo; 
        Decimal RamountFinancedFrom = oppResp.LoanSimulationData.Rate.amountFinancedFrom; 
        Decimal RamountFinancedTo = oppResp.LoanSimulationData.Rate.amountFinancedTo; 
        Integer Rfee = oppResp.LoanSimulationData.Rate.fee; 
        Integer Rhighlight = oppResp.LoanSimulationData.Rate.highlight; 
        Boolean RimmediateOption = oppResp.LoanSimulationData.Rate.immediateOption; 
        String RcreatedAt = oppResp.LoanSimulationData.Rate.createdAt; 
        String RupdatedAt = oppResp.LoanSimulationData.Rate.updatedAt; 
        String RdeletedAt = oppResp.LoanSimulationData.Rate.deletedAt; 
        
        Integer RTid = oppResp.LoanSimulationData.Rate.RateType.id; 
        String RTdescription = oppResp.LoanSimulationData.Rate.RateType.description; 
        String RTcod = oppResp.LoanSimulationData.Rate.RateType.cod; 

        Integer SRid = oppResp.LoanSimulationData.SalesRoom.id; 
        Integer SRsalesChannelId = oppResp.LoanSimulationData.SalesRoom.salesChannelId; 
        String SRname = oppResp.LoanSimulationData.SalesRoom.name; 
        String SRaddress = oppResp.LoanSimulationData.SalesRoom.address; 
        List<Decimal> SRlatLong = oppResp.LoanSimulationData.SalesRoom.latLong; 
        String SRtype = oppResp.LoanSimulationData.SalesRoom.type; 
        Integer SRlegacyId = oppResp.LoanSimulationData.SalesRoom.legacyId; 
        Integer SRSRsupervisorId = oppResp.LoanSimulationData.SalesRoom.supervisorId; 
        String SRsupervisorName = oppResp.LoanSimulationData.SalesRoom.supervisorName; 
        String SRzone = oppResp.LoanSimulationData.SalesRoom.zone; 
        String SRcreatedAt = oppResp.LoanSimulationData.SalesRoom.createdAt; 
        String SRupdatedAt = oppResp.LoanSimulationData.SalesRoom.updatedAt; 
        String SRdeletedAt = oppResp.LoanSimulationData.SalesRoom.deletedAt; 

        Integer SCid = oppResp.LoanSimulationData.SalesRoom.SalesChannel.id; 
        Integer SCidentificationTypeId = oppResp.LoanSimulationData.SalesRoom.SalesChannel.identificationTypeId; 
        Integer SCsalesChannelTypeId = oppResp.LoanSimulationData.SalesRoom.SalesChannel.salesChannelTypeId; 
        String SCidentificationValue = oppResp.LoanSimulationData.SalesRoom.SalesChannel.identificationValue; 
        String SCdescription = oppResp.LoanSimulationData.SalesRoom.SalesChannel.description; 
        String SCapiKey = oppResp.LoanSimulationData.SalesRoom.SalesChannel.apiKey; 
        String SCcreatedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.createdAt; 
        String SCupdatedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.updatedAt; 
        String SCdeletedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.deletedAt; 
        
        Integer SCTid = oppResp.LoanSimulationData.SalesRoom.SalesChannel.SalesChannelType.id; 
        String SCTdescription = oppResp.LoanSimulationData.SalesRoom.SalesChannel.SalesChannelType.description; 
        String SCTcreatedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.SalesChannelType.createdAt; 
        String SCTupdatedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.SalesChannelType.updatedAt; 
        String SCTdeletedAt = oppResp.LoanSimulationData.SalesRoom.SalesChannel.SalesChannelType.deletedAt; 


        Integer SREPid = oppResp.LoanSimulationData.SalesRepresentative.id; 
        String SREPfullName = oppResp.LoanSimulationData.SalesRepresentative.fullName; 
        String SREPrut = oppResp.LoanSimulationData.SalesRepresentative.rut; 
        String SREPgender = oppResp.LoanSimulationData.SalesRepresentative.gender; 
        String SREPphone = oppResp.LoanSimulationData.SalesRepresentative.phone; 
        String SREPposition = oppResp.LoanSimulationData.SalesRepresentative.position; 
        Boolean SREPstatus = oppResp.LoanSimulationData.SalesRepresentative.status; 
        String SREPbirthdate = oppResp.LoanSimulationData.SalesRepresentative.birthdate; 
        String SREPcreatedAt = oppResp.LoanSimulationData.SalesRepresentative.createdAt; 
        String SREPupdatedAt = oppResp.LoanSimulationData.SalesRepresentative.updatedAt; 
        String SREPdeletedAt = oppResp.LoanSimulationData.SalesRepresentative.deletedAt;

        Integer AEid = oppResp.LoanSimulationData.amicarExecutive.id; 
        String AEfullName = oppResp.LoanSimulationData.amicarExecutive.fullName; 
        String AErut = oppResp.LoanSimulationData.amicarExecutive.rut; 
        String AEgender = oppResp.LoanSimulationData.amicarExecutive.gender; 
        String AEphone = oppResp.LoanSimulationData.amicarExecutive.phone; 
        String AEposition = oppResp.LoanSimulationData.amicarExecutive.position; 
        Boolean AEstatus = oppResp.LoanSimulationData.amicarExecutive.status; 
        String AEbirthdate = oppResp.LoanSimulationData.amicarExecutive.birthdate; 
        String AEcreatedAt = oppResp.LoanSimulationData.amicarExecutive.createdAt; 
        String AEupdatedAt = oppResp.LoanSimulationData.amicarExecutive.updatedAt; 
        String AEdeletedAt = oppResp.LoanSimulationData.amicarExecutive.deletedAt;
        
        if(oppResp.ManualAssignmentLogs.size()>0){
            Integer MALyear= oppResp.ManualAssignmentLogs.get(0).year;
            Integer MALfolioNumber= oppResp.ManualAssignmentLogs.get(0).folioNumber;
            Decimal MALcode18= oppResp.ManualAssignmentLogs.get(0).code18;
            Decimal MALcode36= oppResp.ManualAssignmentLogs.get(0).code36;
            Decimal MALcode158= oppResp.ManualAssignmentLogs.get(0).code158;
            Decimal MALcode305= oppResp.ManualAssignmentLogs.get(0).code305;
            Decimal MALcode611= oppResp.ManualAssignmentLogs.get(0).code611;
            Decimal MALcode170= oppResp.ManualAssignmentLogs.get(0).code611;
            Decimal MALcode25= oppResp.ManualAssignmentLogs.get(0).code170;
            Decimal MALcode628= oppResp.ManualAssignmentLogs.get(0).code25;
            Decimal MALcode636= oppResp.ManualAssignmentLogs.get(0).code628;
            Decimal MALcode461= oppResp.ManualAssignmentLogs.get(0).code636;
            Decimal MALcode545= oppResp.ManualAssignmentLogs.get(0).code545;
        }
        String TRdateTax = oppResp.taxReturn.get(0).dateTax;
        Integer TRpurchaseTax = oppResp.taxReturn.get(0).purchaseTax;
        Integer TRsalesTax = oppResp.taxReturn.get(0).salesTax;

        Integer ASid = oppResp.AmortizationSchedule.get(0).id; 
        Integer ASloanSimulationDataId = oppResp.AmortizationSchedule.get(0).loanSimulationDataId; 
        Integer ASpaymentNumber = oppResp.AmortizationSchedule.get(0).paymentNumber; 
        String ASexpirationDate = oppResp.AmortizationSchedule.get(0).expirationDate; 
        Integer ASdaysBetweenExpirationsDates = oppResp.AmortizationSchedule.get(0).daysBetweenExpirationsDates; 
        Integer ASpayment = oppResp.AmortizationSchedule.get(0).payment; 
        Integer ASbeginningBalance = oppResp.AmortizationSchedule.get(0).beginningBalance; 
        Integer ASprincipal = oppResp.AmortizationSchedule.get(0).principal; 
        Integer ASinterest = oppResp.AmortizationSchedule.get(0).interest; 
        Integer ASendingBalance = oppResp.AmortizationSchedule.get(0).endingBalance; 
        Integer AScumulativeInterest = oppResp.AmortizationSchedule.get(0).cumulativeInterest; 
        String ASquotaType = oppResp.AmortizationSchedule.get(0).quotaType; 
        Integer AStotalSurchargesToQuote = oppResp.AmortizationSchedule.get(0).totalSurchargesToQuote; 
        Integer ASfinalPayment = oppResp.AmortizationSchedule.get(0).finalPayment; 

        Integer Isalary = oppResp.Income.salary; 
        Integer Ihonorarium = oppResp.Income.honorarium; 
        Integer IretirementSalary = oppResp.Income.retirementSalary; 
        Integer IpensionSalary = oppResp.Income.pensionSalary; 
        Integer IrentalIncome = oppResp.Income.rentalIncome; 
        Integer IotherIncome = oppResp.Income.otherIncome; 
        String IdescriptionForOtherIncome = oppResp.Income.descriptionForOtherIncome;

        Integer id = oppResp.Customer.id; 
        String identificationValue = oppResp.Customer.identificationValue; 
        Integer identificationTypeId = oppResp.Customer.identificationTypeId; 
        String documentSerialNumber = oppResp.Customer.documentSerialNumber; 
        String name = oppResp.Customer.name; 
        String lastName = oppResp.Customer.lastName; 
        String motherLastName = oppResp.Customer.motherLastName; 
        String email = oppResp.Customer.email; 
        String phone = oppResp.Customer.phone; 
        String address = oppResp.Customer.address; 
        String latLong = oppResp.Customer.latLong; 
        String dob = oppResp.Customer.dob; 
        String nationality = oppResp.Customer.nationality; 
        Integer geographicDataId = oppResp.Customer.geographicDataId; 
        String gender = oppResp.Customer.gender; 
        String createdAt = oppResp.Customer.createdAt; 
        String updatedAt = oppResp.Customer.updatedAt; 
        String deletedAt = oppResp.Customer.deletedAt; 
        
        Integer CGCid = oppResp.Customer.geographicData.Commune.id; 
        String CGCname = oppResp.Customer.geographicData.Commune.name; 
        Integer CGCparentId = oppResp.Customer.geographicData.Commune.parentId; 
        String CGCinternalCode = oppResp.Customer.geographicData.Commune.internalCode; 
        String CGCexternalCode = oppResp.Customer.geographicData.Commune.externalCode; 
        String CGCtype = oppResp.Customer.geographicData.Commune.type; // in json: type
        String CGCcreatedAt = oppResp.Customer.geographicData.Commune.createdAt; 
        String CGCupdatedAt = oppResp.Customer.geographicData.Commune.updatedAt; 
        String CGCdeletedAt = oppResp.Customer.geographicData.Commune.deletedAt; 
        
        CGCid = oppResp.Customer.geographicData.REGION.id; 
        CGCname = oppResp.Customer.geographicData.REGION.name; 
        CGCparentId = oppResp.Customer.geographicData.REGION.parentId; 
        CGCinternalCode = oppResp.Customer.geographicData.REGION.internalCode; 
        CGCexternalCode = oppResp.Customer.geographicData.REGION.externalCode; 
        CGCtype = oppResp.Customer.geographicData.REGION.type; // in json: type
        CGCcreatedAt = oppResp.Customer.geographicData.REGION.createdAt; 
        CGCupdatedAt = oppResp.Customer.geographicData.REGION.updatedAt; 
        CGCdeletedAt = oppResp.Customer.geographicData.REGION.deletedAt; 
        
        CGCid = oppResp.Customer.geographicData.COUNTRY.id; 
        CGCname = oppResp.Customer.geographicData.COUNTRY.name; 
        CGCparentId = oppResp.Customer.geographicData.COUNTRY.parentId; 
        CGCinternalCode = oppResp.Customer.geographicData.COUNTRY.internalCode; 
        CGCexternalCode = oppResp.Customer.geographicData.COUNTRY.externalCode; 
        CGCtype = oppResp.Customer.geographicData.COUNTRY.type; // in json: type
        CGCcreatedAt = oppResp.Customer.geographicData.COUNTRY.createdAt; 
        CGCupdatedAt = oppResp.Customer.geographicData.COUNTRY.updatedAt; 
        CGCdeletedAt = oppResp.Customer.geographicData.COUNTRY.deletedAt; 

        CGCid = oppResp.Customer.nationalityData.id; 
        CGCname = oppResp.Customer.nationalityData.name; 
        CGCparentId = oppResp.Customer.nationalityData.parentId; 
        CGCinternalCode = oppResp.Customer.nationalityData.internalCode; 
        CGCexternalCode = oppResp.Customer.nationalityData.externalCode; 
        CGCtype = oppResp.Customer.nationalityData.type; // in json: type
        CGCcreatedAt = oppResp.Customer.nationalityData.createdAt; 
        CGCupdatedAt = oppResp.Customer.nationalityData.updatedAt; 
        CGCdeletedAt = oppResp.Customer.nationalityData.deletedAt; 

        CGCid = oppResp.Customer.genderData.id; 
        CGCname = oppResp.Customer.genderData.name; 
        CGCparentId = oppResp.Customer.genderData.parentId; 
        CGCinternalCode = oppResp.Customer.genderData.internalCode; 
        CGCexternalCode = oppResp.Customer.genderData.externalCode; 
        CGCtype = oppResp.Customer.genderData.type; // in json: type
        CGCcreatedAt = oppResp.Customer.genderData.createdAt; 
        CGCupdatedAt = oppResp.Customer.genderData.updatedAt; 
        CGCdeletedAt = oppResp.Customer.genderData.deletedAt; 

        Integer SIid = oppResp.SurchargesAndInsurances.get(0).id; 
        String SIdescription = oppResp.SurchargesAndInsurances.get(0).description; 
        Decimal SIvalue = oppResp.SurchargesAndInsurances.get(0).value; 
        Boolean SIvalueToMAF = oppResp.SurchargesAndInsurances.get(0).valueToMAF; 
        String SIcalculateFormulae = oppResp.SurchargesAndInsurances.get(0).calculateFormulae; 
        Boolean SIcalculateCommissionFinancialEntity = oppResp.SurchargesAndInsurances.get(0).calculateCommissionFinancialEntity; 
        Boolean SIisEditable = oppResp.SurchargesAndInsurances.get(0).isEditable; 
        Boolean SIcalculateCommissionDealer = oppResp.SurchargesAndInsurances.get(0).calculateCommissionDealer; 
        Boolean SIcalculateCommissionFnI = oppResp.SurchargesAndInsurances.get(0).calculateCommissionFnI; 
        String SIcurrencyType = oppResp.SurchargesAndInsurances.get(0).currencyType; 
        Boolean SIisRequired = oppResp.SurchargesAndInsurances.get(0).isRequired; 
        Boolean SIselected = oppResp.SurchargesAndInsurances.get(0).selected; 
        String SItype = oppResp.SurchargesAndInsurances.get(0).type;
        Integer SIidRef = oppResp.SurchargesAndInsurances.get(0).idRef; 
        String SIinsuranceType = oppResp.SurchargesAndInsurances.get(0).insuranceType; 
        Decimal SIfactorCalculated = oppResp.SurchargesAndInsurances.get(0).factorCalculated; 

        Integer PRid = oppResp.PersonalReferences.get(0).id; 
        String PRtype = oppResp.PersonalReferences.get(0).type; 

        Integer BIcodeId = oppResp.BankInformation.get(0).codeId; 
        Boolean BIautomaticPayment = oppResp.BankInformation.get(0).automaticPayment; 
        String BIaccountNumber = oppResp.BankInformation.get(0).accountNumber; 
        String BIexternalCode = oppResp.BankInformation.get(0).externalCode; 
        String BIname = oppResp.BankInformation.get(0).name;

        String generalComments = oppResp.CustomerRequestData.generalComments; 
        String yearsOfResidence = oppResp.CustomerRequestData.yearsOfResidence; 
        String monthsOfResidence = oppResp.CustomerRequestData.monthsOfResidence; 
        String numberOfChildren = oppResp.CustomerRequestData.numberOfChildren; 

        Integer LSCid = oppResp.LoanSimulationcar.id; 
        Integer LSCloanSimulationDataId = oppResp.LoanSimulationcar.loanSimulationDataId; 
        Integer LSCvehicleTypeId = oppResp.LoanSimulationcar.vehicleTypeId; 
        Integer LSCcarBrandId = oppResp.LoanSimulationcar.carBrandId; 
        String LSCcarBrandDescription = oppResp.LoanSimulationcar.carBrandDescription; 
        Integer LSCcarModelId = oppResp.LoanSimulationcar.carModelId; 
        String LSCcarModelDescription = oppResp.LoanSimulationcar.carModelDescription; 
        String LSCcarVersion = oppResp.LoanSimulationcar.carVersion; 
        Integer LSCyear = oppResp.LoanSimulationcar.year; 
        Integer LSCprice = oppResp.LoanSimulationcar.price; 
        String LSCadditionalDescription = oppResp.LoanSimulationcar.additionalDescription; 
        String LSClicensePlate = oppResp.LoanSimulationcar.licensePlate; 
        String LSCcreatedAt = oppResp.LoanSimulationcar.createdAt; 
        String LSCupdatedAt = oppResp.LoanSimulationcar.updatedAt; 
        String LSCdeletedAt = oppResp.LoanSimulationcar.deletedAt; 

        Integer LSCparentId = oppResp.LoanSimulationCar.Brand.parentId; 
        String LSCinternalCode = oppResp.LoanSimulationCar.Brand.internalCode; 
        String LSCexternalCode = oppResp.LoanSimulationCar.Brand.externalCode;
        String LSCtype = oppResp.LoanSimulationCar.Brand.type;
        LSCcreatedAt = oppResp.LoanSimulationCar.Brand.createdAt; 
        LSCupdatedAt = oppResp.LoanSimulationCar.Brand.updatedAt; 
        LSCdeletedAt = oppResp.LoanSimulationCar.Brand.deletedAt;

        String Hertype = oppResp.Heritage.get(0).type; // in json: type
        String Herdescription = oppResp.Heritage.get(0).description; 
        Integer HersaleValue = oppResp.Heritage.get(0).saleValue; 
        String Herfinancing = oppResp.Heritage.get(0).financing; 
        Boolean HerstillPaying = oppResp.Heritage.get(0).stillPaying; 
         
        String HertypeDescription = oppResp.Heritage.get(0).typeDescription; 
        String HertypeExternalCode = oppResp.Heritage.get(0).typeExternalCode; 
        String HerfinancingTypeDescription = oppResp.Heritage.get(0).financingTypeDescription; 
        String HerfinancingTypeExternalCode = oppResp.Heritage.get(0).financingTypeExternalCode; 

        String GmaritalStatus = oppResp.guarantor.get(0).maritalStatus; 
        String GmaritalRegime = oppResp.guarantor.get(0).maritalRegime; 
        String GworkType = oppResp.guarantor.get(0).workType; 
        Integer Gsalary = oppResp.guarantor.get(0).salary; 
        Integer GgeographicDataId = oppResp.guarantor.get(0).geographicDataId; 
        Integer GnationalityId = oppResp.guarantor.get(0).nationalityId; 
        Integer GactivityTypeId = oppResp.guarantor.get(0).activityTypeId; 
        String GdocumentSerialNumber = oppResp.guarantor.get(0).documentSerialNumber; 
        String Gphone = oppResp.guarantor.get(0).phone; 
        String GworkPhone = oppResp.guarantor.get(0).workPhone; 
        String Gemail = oppResp.guarantor.get(0).email; 
        String Ggender = oppResp.guarantor.get(0).gender; 
        String GacademicLevel = oppResp.guarantor.get(0).academicLevel; 
        String GlivingHousehold = oppResp.guarantor.get(0).livingHousehold; 
        String GworkEntryDate = oppResp.guarantor.get(0).workEntryDate; 
        String GemployerIdentificationTypeId = oppResp.guarantor.get(0).employerIdentificationTypeId; 
        String GemployerIdentificationValue = oppResp.guarantor.get(0).employerIdentificationValue; 
        String GemployerName = oppResp.guarantor.get(0).employerName; 
        String GemployerAddress = oppResp.guarantor.get(0).employerAddress; 
        String GbusinessSectorId = oppResp.guarantor.get(0).businessSectorId; 
        String GemployerPhone = oppResp.guarantor.get(0).employerPhone; 
        String GemploymentContractType = oppResp.guarantor.get(0).employmentContractType; 
        String GsalaryType = oppResp.guarantor.get(0).salaryType; 
        String GsalaryPayday = oppResp.guarantor.get(0).salaryPayday; 
        String GmortgageCost = oppResp.guarantor.get(0).mortgageCost; 
        String GpreviousEmployerName = oppResp.guarantor.get(0).previousEmployerName; 
        String GpreviousEmployerPhone = oppResp.guarantor.get(0).previousEmployerPhone; 
        String GpreviousEmployerSeniority = oppResp.guarantor.get(0).previousEmployerSeniority; 
        String GyearsOfResidence = oppResp.guarantor.get(0).yearsOfResidence; 
        String GmonthsOfResidence = oppResp.guarantor.get(0).monthsOfResidence; 
        String GnumberOfChildren = oppResp.guarantor.get(0).numberOfChildren; 

        Integer GATid = oppResp.guarantor.get(0).ActivityTypeData.id; 
        String GATname = oppResp.guarantor.get(0).ActivityTypeData.name; 
        Integer GATparentId = oppResp.guarantor.get(0).ActivityTypeData.parentId; 
        String GATinternalCode = oppResp.guarantor.get(0).ActivityTypeData.internalCode; 
        String GATexternalCode = oppResp.guarantor.get(0).ActivityTypeData.externalCode; 
        String GATtype = oppResp.guarantor.get(0).ActivityTypeData.type; // in json: type
        String GATcreatedAt = oppResp.guarantor.get(0).ActivityTypeData.createdAt; 
        String GATupdatedAt = oppResp.guarantor.get(0).ActivityTypeData.updatedAt; 
        String GATdeletedAt = oppResp.guarantor.get(0).ActivityTypeData.deletedAt; 

        String BAname = oppResp.buyForAnother.name; 
        String BAlastName = oppResp.buyForAnother.lastName; 
        String BAmotherLastName = oppResp.buyForAnother.motherLastName; 
        String BAaddress = oppResp.buyForAnother.address; 
        String BAdob = oppResp.buyForAnother.dob; 
        String BAmaritalStatus = oppResp.buyForAnother.maritalStatus; 
        String BAmaritalRegime = oppResp.buyForAnother.maritalRegime; 
        Integer BAgeographicDataId = oppResp.buyForAnother.geographicDataId; 
        Integer BAnationalityId = oppResp.buyForAnother.nationalityId;

        Test.stopTest();
    }

    //Test de error
    static testmethod void test5(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        String jsonString = 'Test';
        //String jsonBody = JSON.serialize(jsonString);
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();

        Test.stopTest();
    }

    //Test de error - Usuario no Existente
    static testmethod void test6(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('194391811','');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de Error
    static testmethod void test7(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('194391811','173758693');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test Persona Jurídica - Camino Feliz
    static testmethod void test8(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringPjTest();
        //String jsonBody = JSON.serialize(jsonString);
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Local no Existente
    static testmethod void test9(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('"id":1,','"id":2,');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Vendedor no Existente
    static testmethod void test10(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('"rut":"112223339",','"rut":"173758693",');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test11(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('NU','TEST');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test12(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('831','380');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test13(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('1146','1111');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test14(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('US','TEST');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test15(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('824','328');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }

    //Test de error - Modelo
    static testmethod void test16(){
        Test.startTest();
                
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunities/insertOpportunity';  
        req.httpMethod = 'PUT';  
        AMICAR_ServicioRestOpportunity_HelpTest jsonHelper = new AMICAR_ServicioRestOpportunity_HelpTest();
        String jsonString = jsonHelper.getStringTest();
        jsonString = jsonString.replace('1147','1111');
        req.requestBody = Blob.valueOf(jsonString);
        req.addHeader('Content-Type', 'application/json;charset=UTF-8');
        RestContext.request = req;
        RestContext.response = res;
        AMICAR_ServiciosRestOpportunityWS.insertOpportunity();
        Test.stopTest();
    }
}