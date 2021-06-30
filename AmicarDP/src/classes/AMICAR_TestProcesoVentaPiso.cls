@isTest
private class AMICAR_TestProcesoVentaPiso {
	
	@isTest static void test_method_one() {
		//*****************************************************************
		// test clase obtiene simulaciones
		//*****************************************************************

		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();

		Product2 dealerSurcharge = new Product2();
		dealerSurcharge.Name = 'IMPUESTO VERDE';
		dealerSurcharge.ProductCode = '1';
		dealerSurcharge.Identificador__c = 'IMPUESTO VERDE 1 dealerSurcharges';
		dealerSurcharge.Family = 'dealerSurcharges';
		dealerSurcharge.IsActive = true;
		insert dealerSurcharge;

		PricebookEntry entradaTest = new PricebookEntry();
		entradaTest.Product2Id = dealerSurcharge.Id;
		entradaTest.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest.UnitPrice = 1;
		entradaTest.IsActive = true;
		insert entradaTest;

		Product2 ffeeInsurance = new Product2();
		ffeeInsurance.Name = 'DESGRAVAMEN';
		ffeeInsurance.ProductCode = '336';
		ffeeInsurance.Identificador__c = 'DESGRAVAMEN 336 financingEntityInsurance';
		ffeeInsurance.Family = 'financingEntityInsurance';
		ffeeInsurance.IsActive = true;
		insert ffeeInsurance;

		PricebookEntry entradaTest2 = new PricebookEntry();
		entradaTest2.Product2Id = ffeeInsurance.Id;
		entradaTest2.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest2.UnitPrice = 1;
		entradaTest2.IsActive = true;
		insert entradaTest2;

		Product2 ffSurcharges = new Product2();
		ffSurcharges.Name = 'G. OPERACIONALES';
		ffSurcharges.ProductCode = '567';
		ffSurcharges.Identificador__c = 'G. OPERACIONALES 567 financingEntitySurcharges';
		ffSurcharges.Family = 'financingEntitySurcharges';
		ffSurcharges.IsActive = true;
		insert ffSurcharges;

		PricebookEntry entradaTest3 = new PricebookEntry();
		entradaTest3.Product2Id = ffSurcharges.Id;
		entradaTest3.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest3.UnitPrice = 1;
		entradaTest3.IsActive = true;
		insert entradaTest3;

		Product2 amicarAsistencia = new Product2();
		amicarAsistencia.Name = 'FAMILIA PROTEGIDA';
		amicarAsistencia.ProductCode = '1';
		amicarAsistencia.Identificador__c = 'FAMILIA PROTEGIDA 1 amicarAssistance';
		amicarAsistencia.Family = 'amicarAssistance';
		amicarAsistencia.IsActive = true;
		insert amicarAsistencia;

		PricebookEntry entradaTest4 = new PricebookEntry();
		entradaTest4.Product2Id = amicarAsistencia.Id;
		entradaTest4.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest4.UnitPrice = 1;
		entradaTest4.IsActive = true;
		insert entradaTest4;


		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		insert cuentaTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_Vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		insert solicitudTest;
		List<String> idList = new List<String>();
		idList.add(solicitudTest.Id);
		AMICAR_ObtieneSimulaciones.ObtieneSimulaciones(idList);
	}

	@isTest static void test_method_two() {
		//*****************************************************************
		// test clase envia sincronizada
		//*****************************************************************

		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
		Id rtSimulacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();

		Product2 dealerSurcharge = new Product2();
		dealerSurcharge.Name = 'IMPUESTO VERDE';
		dealerSurcharge.ProductCode = '1';
		dealerSurcharge.Identificador__c = 'IMPUESTO VERDE 1 dealerSurcharges';
		dealerSurcharge.Family = 'dealerSurcharges';
		dealerSurcharge.IsActive = true;
		insert dealerSurcharge;

		PricebookEntry entradaTest = new PricebookEntry();
		entradaTest.Product2Id = dealerSurcharge.Id;
		entradaTest.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest.UnitPrice = 1;
		entradaTest.IsActive = true;
		insert entradaTest;

		Product2 ffeeInsurance = new Product2();
		ffeeInsurance.Name = 'DESGRAVAMEN';
		ffeeInsurance.ProductCode = '336';
		ffeeInsurance.Identificador__c = 'DESGRAVAMEN 336 financingEntityInsurance';
		ffeeInsurance.Family = 'financingEntityInsurance';
		ffeeInsurance.IsActive = true;
		insert ffeeInsurance;

		PricebookEntry entradaTest2 = new PricebookEntry();
		entradaTest2.Product2Id = ffeeInsurance.Id;
		entradaTest2.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest2.UnitPrice = 1;
		entradaTest2.IsActive = true;
		insert entradaTest2;

		Product2 ffSurcharges = new Product2();
		ffSurcharges.Name = 'G. OPERACIONALES';
		ffSurcharges.ProductCode = '567';
		ffSurcharges.Identificador__c = 'G. OPERACIONALES 567 financingEntitySurcharges';
		ffSurcharges.Family = 'financingEntitySurcharges';
		ffSurcharges.IsActive = true;
		insert ffSurcharges;

		PricebookEntry entradaTest3 = new PricebookEntry();
		entradaTest3.Product2Id = ffSurcharges.Id;
		entradaTest3.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest3.UnitPrice = 1;
		entradaTest3.IsActive = true;
		insert entradaTest3;

		Product2 amicarAsistencia = new Product2();
		amicarAsistencia.Name = 'FAMILIA PROTEGIDA';
		amicarAsistencia.ProductCode = '1';
		amicarAsistencia.Identificador__c = 'FAMILIA PROTEGIDA 1 amicarAssistance';
		amicarAsistencia.Family = 'amicarAssistance';
		amicarAsistencia.IsActive = true;
		insert amicarAsistencia;

		PricebookEntry entradaTest4 = new PricebookEntry();
		entradaTest4.Product2Id = amicarAsistencia.Id;
		entradaTest4.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest4.UnitPrice = 1;
		entradaTest4.IsActive = true;
		insert entradaTest4;


		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		insert cuentaTest;

		Quote simulacionTest = new Quote();
		simulacionTest.RecordTypeId = rtSimulacion;
		simulacionTest.Name = 'escenario test';
		simulacionTest.Status = 'Borrador';

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		solicitudTest.SyncedQuoteId = simulacionTest.Id;
		insert solicitudTest;

		simulacionTest.CAE__c = 123;
		simulacionTest.Costo_total_cr_dito__c = 1234567;
		simulacionTest.Valor_UF__c = 28000;
		simulacionTest.Saldo_precio__c = 123456;
		simulacionTest.Total_a_financiar__c = 123456;
		simulacionTest.Interes_por_desfase__c = 123456;
		simulacionTest.Capital_final__c = 123456;
		simulacionTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		simulacionTest.Cuotas__c = 48;
		simulacionTest.Valor_cuota__c = 123456;
		simulacionTest.Tasa__c = 1;
		simulacionTest.Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL';
		simulacionTest.Comisi_n_dealer__c = 123456;
		simulacionTest.Fecha_creacion__c = System.now();
		simulacionTest.Tasa_dealer__c = 1;
		simulacionTest.Pricebook2Id = Test.getStandardPricebookId();
		simulacionTest.OpportunityId = solicitudTest.Id;
		insert simulacionTest;

		Test.startTest();
			solicitudTest.SyncedQuoteId = simulacionTest.Id;
			update solicitudTest;
		Test.stopTest();
	}
	
	@isTest static void test_method_three() {
		//*****************************************************************
		// test clase envia formalizada
		//*****************************************************************

		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
		Id rtSimulacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
		Id rtReferencia = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();
		Id rtConyuge = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Conyuge').getRecordTypeId();
		Id rtCompraPara = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Compra para').getRecordTypeId();
		Id rtAval = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Aval').getRecordTypeId();

		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		cuentaTest.PersonBirthdate = System.today();
		cuentaTest.Genero__pc = 'M';
		cuentaTest.Nacionalidad__pc = 'CHILE';
		insert cuentaTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		// datos formalizada
		solicitudTest.N_de_serie_C_I__c = '12345678';
		solicitudTest.Id_Solicitud__c = '11111111';
		solicitudTest.Direccion__c = 'Calle 1234';
		solicitudTest.Regi_n__c = '13';
		solicitudTest.Comuna__c = '13101';
		solicitudTest.Tipo_de_residencia__c = '1';
		solicitudTest.Estado_civil__c = 'SH';
		solicitudTest.Regimen_matrimonial__c = 'NA';
		solicitudTest.Estudios__c = 'SU';
		solicitudTest.Profesion__c = 'Profesion';
		solicitudTest.Tipo_de_trabajador__c = '';
		solicitudTest.Empleador__c = 'Empleador';
		solicitudTest.RUT_empleador__c = '14381623-0';
		solicitudTest.Rubro_de_empleador__c = '5';
		solicitudTest.Direccion_empleador__c = 'Calle 1234';
		solicitudTest.Region_empleador__c = '13';
		solicitudTest.Comuna_empleador__c = '13101';
		solicitudTest.Telefono_empleador__c = '123456';
		solicitudTest.Fecha_de_ingreso__c = System.today();
		solicitudTest.Cargo__c = 'Cargo';
		//solicitudTest.Tipo_de_actividad__c = 'Artesano';
		solicitudTest.Tipo_de_actividad__c = '2';
		solicitudTest.Tipo_de_contrato__c = 'IN';
		solicitudTest.Tipo_de_renta__c = 'FI';
		solicitudTest.Renta__c = 1234567;
		solicitudTest.Otros_ingresos__c = 0;
		solicitudTest.Arriendo__c = 0;
		solicitudTest.Dividendo__c = 100;
		solicitudTest.Otros_egresos__c = 0;
		solicitudTest.Banco_cuenta_1__c = '6';
		solicitudTest.Numero_cuenta_1__c = '123456';
		solicitudTest.Tipo_cuenta_1__c = 'Corriente';
		solicitudTest.PAC_cuenta_1__c = false;
		solicitudTest.Banco_cuenta_2__c = '6';
		solicitudTest.Numero_cuenta_2__c = '123456';
		solicitudTest.Tipo_de_cuenta_2__c = 'Corriente';
		solicitudTest.PAC_cuenta_2__c = false;
		insert solicitudTest;

		Relacion__c referenciaTest = new Relacion__c();
		referenciaTest.Nombre__c = 'Nombre';
		referenciaTest.Apellidos__c = 'Apellido';
		referenciaTest.Tipo_de_relacion__c = 'Amigo(a)';
		referenciaTest.Direccion__c = 'Calle 1234';
		referenciaTest.Telefono__c = '1111111';
		referenciaTest.Solicitud__c = solicitudTest.Id;
		referenciaTest.RecordTypeId = rtReferencia;
		insert referenciaTest;

		Relacion__c conyugeTest = new Relacion__c();
		conyugeTest.RUT_referencia__c = '14381623-0';
		conyugeTest.Nombre__c = 'nombre';
		conyugeTest.Apellidos__c = 'apellidos';
		conyugeTest.Direccion__c = 'calle 1234';
		conyugeTest.Region__c = '13';
		conyugeTest.Comuna__c = '13101';
		conyugeTest.Complementa_renta__c = false;
		conyugeTest.Empleador__c = 'Empleador';
		conyugeTest.Telefono_empleador__c = '123456';
		conyugeTest.Tipo_de_trabajador__c = 'IN';
		//conyugeTest.Tipo_de_actividad__c = 'Artesano';
		conyugeTest.Tipo_de_actividad__c = '2';
		conyugeTest.Sueldo_liquido__c = 1500000;
		conyugeTest.Solicitud__c = solicitudTest.Id;
		conyugeTest.RecordTypeId = rtConyuge;
		insert conyugeTest;

		Relacion__c compraParaTest = new Relacion__c();
		compraParaTest.Cuenta__c = cuentaTest.Id;
		compraParaTest.Estado_civil__c = 'SO';
		compraParaTest.Regimen_matrimonial__c = 'NA';
		compraParaTest.Direccion__c = 'Calle 12345';
		compraParaTest.Region__c = '13';
		compraParaTest.Comuna__c = '13101';
		compraParaTest.Solicitud__c = solicitudTest.Id;
		compraParaTest.RecordTypeId = rtCompraPara;
		insert compraParaTest;

		Relacion__c avalTest = new Relacion__c();
		avalTest.Cuenta__c = cuentaTest.Id;
		avalTest.Estado_civil__c = 'SO';
		avalTest.Regimen_matrimonial__c = 'NA';
		avalTest.Direccion__c = 'Calle 12345';
		avalTest.Region__c = '13';
		avalTest.Comuna__c = '13101';
		avalTest.Tipo_de_trabajador__c = 'IN';
		//avalTest.Tipo_de_actividad__c = 'Artesano';
		avalTest.Tipo_de_actividad__c = '2';
		avalTest.Solicitud__c = solicitudTest.Id;
		avalTest.RecordTypeId = rtAval;
		insert avalTest;

		Patrimonio__c patrimonioTest = new Patrimonio__c();
		patrimonioTest.Tipo__c = 'BR';
		patrimonioTest.Valor_venta__c = 123456789;
		patrimonioTest.Financiamiento__c = '1';
		patrimonioTest.Descripcion__c = 'casa';
		patrimonioTest.Solicitud__c = solicitudTest.Id;
		insert patrimonioTest;

		Quote simulacionTest = new Quote();
		simulacionTest.RecordTypeId = rtSimulacion;
		simulacionTest.Name = 'escenario test';
		simulacionTest.Status = 'Borrador';
		simulacionTest.OpportunityId = solicitudTest.Id;
		simulacionTest.CAE__c = 123;
		simulacionTest.Costo_total_cr_dito__c = 1234567;
		simulacionTest.Valor_UF__c = 28000;
		simulacionTest.Saldo_precio__c = 123456;
		simulacionTest.Total_a_financiar__c = 123456;
		simulacionTest.Interes_por_desfase__c = 123456;
		simulacionTest.Capital_final__c = 123456;
		simulacionTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		simulacionTest.Cuotas__c = 48;
		simulacionTest.Valor_cuota__c = 123456;
		simulacionTest.Tasa__c = 1;
		simulacionTest.Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL';
		simulacionTest.Comisi_n_dealer__c = 123456;
		simulacionTest.Fecha_creacion__c = System.now();
		simulacionTest.Tasa_dealer__c = 1;
		simulacionTest.Pricebook2Id = Test.getStandardPricebookId();
		insert simulacionTest;

		solicitudTest.SyncedQuoteId = simulacionTest.Id;
		solicitudTest.StageName = 'Formalización';
		update solicitudTest;
	}

	@isTest static void test_method_four() {
		//*****************************************************************
		// test actualiza desarrollos
		//*****************************************************************

		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
		Id rtSimulacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();

		Product2 dealerSurcharge = new Product2();
		dealerSurcharge.Name = 'IMPUESTO VERDE';
		dealerSurcharge.ProductCode = '10101';
		dealerSurcharge.Identificador__c = 'IMPUESTO VERDE 10101 dealerSurcharges';
		dealerSurcharge.Family = 'dealerSurcharges';
		dealerSurcharge.IsActive = true;
		insert dealerSurcharge;

		PricebookEntry entradaTest = new PricebookEntry();
		entradaTest.Product2Id = dealerSurcharge.Id;
		entradaTest.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest.UnitPrice = 1;
		entradaTest.IsActive = true;
		insert entradaTest;

		Product2 ffeeInsurance = new Product2();
		ffeeInsurance.Name = 'DESGRAVAMEN';
		ffeeInsurance.ProductCode = '10336';
		ffeeInsurance.Identificador__c = 'DESGRAVAMEN 10336 financingEntityInsurance';
		ffeeInsurance.Family = 'financingEntityInsurance';
		ffeeInsurance.IsActive = true;
		insert ffeeInsurance;

		PricebookEntry entradaTest2 = new PricebookEntry();
		entradaTest2.Product2Id = ffeeInsurance.Id;
		entradaTest2.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest2.UnitPrice = 1;
		entradaTest2.IsActive = true;
		insert entradaTest2;

		Product2 ffSurcharges = new Product2();
		ffSurcharges.Name = 'G. OPERACIONALES';
		ffSurcharges.ProductCode = '10567';
		ffSurcharges.Identificador__c = 'G. OPERACIONALES 10567 financingEntitySurcharges';
		ffSurcharges.Family = 'financingEntitySurcharges';
		ffSurcharges.IsActive = true;
		insert ffSurcharges;

		PricebookEntry entradaTest3 = new PricebookEntry();
		entradaTest3.Product2Id = ffSurcharges.Id;
		entradaTest3.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest3.UnitPrice = 1;
		entradaTest3.IsActive = true;
		insert entradaTest3;

		Product2 amicarAsistencia = new Product2();
		amicarAsistencia.Name = 'FAMILIA PROTEGIDA';
		amicarAsistencia.ProductCode = '10101';
		amicarAsistencia.Identificador__c = 'FAMILIA PROTEGIDA 10101 amicarAssistance';
		amicarAsistencia.Family = 'amicarAssistance';
		amicarAsistencia.IsActive = true;
		insert amicarAsistencia;

		PricebookEntry entradaTest4 = new PricebookEntry();
		entradaTest4.Product2Id = amicarAsistencia.Id;
		entradaTest4.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest4.UnitPrice = 1;
		entradaTest4.IsActive = true;
		insert entradaTest4;

		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		insert cuentaTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		insert solicitudTest;

		Quote simulacionTest = new Quote();
		simulacionTest.RecordTypeId = rtSimulacion;
		simulacionTest.Name = 'escenario test';
		simulacionTest.Status = 'Borrador';
		simulacionTest.OpportunityId = solicitudTest.Id;
		simulacionTest.CAE__c = 123;
		simulacionTest.Costo_total_cr_dito__c = 1234567;
		simulacionTest.Valor_UF__c = 28000;
		simulacionTest.Saldo_precio__c = 123456;
		simulacionTest.Total_a_financiar__c = 123456;
		simulacionTest.Interes_por_desfase__c = 123456;
		simulacionTest.Capital_final__c = 123456;
		simulacionTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		simulacionTest.Cuotas__c = 48;
		simulacionTest.Valor_cuota__c = 123456;
		simulacionTest.Tasa__c = 1;
		simulacionTest.Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL';
		simulacionTest.Comisi_n_dealer__c = 123456;
		simulacionTest.Fecha_creacion__c = System.now();
		simulacionTest.Tasa_dealer__c = 1;
		simulacionTest.Pricebook2Id = Test.getStandardPricebookId();
		insert simulacionTest;

		Desarrollo__c desarolloTest = new Desarrollo__c();
		desarolloTest.Numero_de_pago__c = 1;
		desarolloTest.Fecha_vencimiento__c = '2020-09-5';
		desarolloTest.Pago__c = 1234567;
		desarolloTest.Simulacion__c = simulacionTest.Id;
		insert desarolloTest;

		desarolloTest.Pago__c = 1;
		update desarolloTest;
		
		List<String> idList = new List<String>();
		idList.add(desarolloTest.Id);
		AMICAR_ActualizaDesarrollo.ObtieneDesarrollos(idList);
	}

	@isTest static void test_method_five() {
		//*****************************************************************
		// test simulación a remate
		//*****************************************************************
		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
		Id rtSimulacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
		Id rtReferencia = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();
		Id rtConyuge = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Conyuge').getRecordTypeId();
		Id rtCompraPara = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Compra para').getRecordTypeId();
		Id rtAval = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Aval').getRecordTypeId();

		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		cuentaTest.PersonBirthdate = System.today();
		cuentaTest.Genero__pc = 'M';
		cuentaTest.Nacionalidad__pc = 'CHILE';
		insert cuentaTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		// datos formalizada
		solicitudTest.N_de_serie_C_I__c = '12345678';
		solicitudTest.Id_Solicitud__c = '11111111';
		solicitudTest.Direccion__c = 'Calle 1234';
		solicitudTest.Regi_n__c = '13';
		solicitudTest.Comuna__c = '13101';
		solicitudTest.Tipo_de_residencia__c = '1';
		solicitudTest.Estado_civil__c = 'SH';
		solicitudTest.Regimen_matrimonial__c = 'NA';
		solicitudTest.Estudios__c = 'SU';
		solicitudTest.Profesion__c = 'Profesion';
		solicitudTest.Tipo_de_trabajador__c = '';
		solicitudTest.Empleador__c = 'Empleador';
		solicitudTest.RUT_empleador__c = '14381623-0';
		solicitudTest.Rubro_de_empleador__c = '5';
		solicitudTest.Direccion_empleador__c = 'Calle 1234';
		solicitudTest.Region_empleador__c = '13';
		solicitudTest.Comuna_empleador__c = '13101';
		solicitudTest.Telefono_empleador__c = '123456';
		solicitudTest.Fecha_de_ingreso__c = System.today();
		solicitudTest.Cargo__c = 'Cargo';
		//solicitudTest.Tipo_de_actividad__c = 'Artesano';
		solicitudTest.Tipo_de_actividad__c = '2';
		solicitudTest.Tipo_de_contrato__c = 'IN';
		solicitudTest.Tipo_de_renta__c = 'FI';
		solicitudTest.Renta__c = 1234567;
		solicitudTest.Otros_ingresos__c = 0;
		solicitudTest.Arriendo__c = 0;
		solicitudTest.Dividendo__c = 100;
		solicitudTest.Otros_egresos__c = 0;
		solicitudTest.Banco_cuenta_1__c = '6';
		solicitudTest.Numero_cuenta_1__c = '123456';
		solicitudTest.Tipo_cuenta_1__c = 'Corriente';
		solicitudTest.PAC_cuenta_1__c = false;
		solicitudTest.Banco_cuenta_2__c = '6';
		solicitudTest.Numero_cuenta_2__c = '123456';
		solicitudTest.Tipo_de_cuenta_2__c = 'Corriente';
		solicitudTest.PAC_cuenta_2__c = false;
		insert solicitudTest;

		Relacion__c referenciaTest = new Relacion__c();
		referenciaTest.Nombre__c = 'Nombre';
		referenciaTest.Apellidos__c = 'Apellido';
		referenciaTest.Tipo_de_relacion__c = 'Amigo(a)';
		referenciaTest.Direccion__c = 'Calle 1234';
		referenciaTest.Telefono__c = '1111111';
		referenciaTest.Solicitud__c = solicitudTest.Id;
		referenciaTest.RecordTypeId = rtReferencia;
		insert referenciaTest;

		Relacion__c conyugeTest = new Relacion__c();
		conyugeTest.RUT_referencia__c = '14381623-0';
		conyugeTest.Nombre__c = 'nombre';
		conyugeTest.Apellidos__c = 'apellidos';
		conyugeTest.Direccion__c = 'calle 1234';
		conyugeTest.Region__c = '13';
		conyugeTest.Comuna__c = '13101';
		conyugeTest.Complementa_renta__c = false;
		conyugeTest.Empleador__c = 'Empleador';
		conyugeTest.Telefono_empleador__c = '123456';
		conyugeTest.Tipo_de_trabajador__c = 'IN';
		//conyugeTest.Tipo_de_actividad__c = 'Artesano';
		conyugeTest.Tipo_de_actividad__c = '2';
		conyugeTest.Sueldo_liquido__c = 1500000;
		conyugeTest.Solicitud__c = solicitudTest.Id;
		conyugeTest.RecordTypeId = rtConyuge;
		insert conyugeTest;

		Relacion__c compraParaTest = new Relacion__c();
		compraParaTest.Cuenta__c = cuentaTest.Id;
		compraParaTest.Estado_civil__c = 'SO';
		compraParaTest.Regimen_matrimonial__c = 'NA';
		compraParaTest.Direccion__c = 'Calle 12345';
		compraParaTest.Region__c = '13';
		compraParaTest.Comuna__c = '13101';
		compraParaTest.Solicitud__c = solicitudTest.Id;
		compraParaTest.RecordTypeId = rtCompraPara;
		insert compraParaTest;

		Relacion__c avalTest = new Relacion__c();
		avalTest.Cuenta__c = cuentaTest.Id;
		avalTest.Estado_civil__c = 'SO';
		avalTest.Regimen_matrimonial__c = 'NA';
		avalTest.Direccion__c = 'Calle 12345';
		avalTest.Region__c = '13';
		avalTest.Comuna__c = '13101';
		avalTest.Tipo_de_trabajador__c = 'IN';
		//avalTest.Tipo_de_actividad__c = 'Artesano';
		avalTest.Tipo_de_actividad__c = '2';
		avalTest.Solicitud__c = solicitudTest.Id;
		avalTest.RecordTypeId = rtAval;
		insert avalTest;

		Patrimonio__c patrimonioTest = new Patrimonio__c();
		patrimonioTest.Tipo__c = 'BR';
		patrimonioTest.Valor_venta__c = 123456789;
		patrimonioTest.Financiamiento__c = '1';
		patrimonioTest.Descripcion__c = 'casa';
		patrimonioTest.Solicitud__c = solicitudTest.Id;
		insert patrimonioTest;

		Quote simulacionTest = new Quote();
		simulacionTest.RecordTypeId = rtSimulacion;
		simulacionTest.Name = 'escenario test';
		simulacionTest.Status = 'Borrador';
		simulacionTest.OpportunityId = solicitudTest.Id;
		simulacionTest.CAE__c = 123;
		simulacionTest.Costo_total_cr_dito__c = 1234567;
		simulacionTest.Valor_UF__c = 28000;
		simulacionTest.Saldo_precio__c = 123456;
		simulacionTest.Total_a_financiar__c = 123456;
		simulacionTest.Interes_por_desfase__c = 123456;
		simulacionTest.Capital_final__c = 123456;
		simulacionTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		simulacionTest.Cuotas__c = 48;
		simulacionTest.Valor_cuota__c = 123456;
		simulacionTest.Tasa__c = 1;
		simulacionTest.Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL';
		simulacionTest.Comisi_n_dealer__c = 123456;
		simulacionTest.Fecha_creacion__c = System.now();
		simulacionTest.Tasa_dealer__c = 1;
		simulacionTest.Pricebook2Id = Test.getStandardPricebookId();
		insert simulacionTest;

		solicitudTest.SyncedQuoteId = simulacionTest.Id;
		solicitudTest.StageName = 'Formalización';
		update solicitudTest;

		solicitudTest.StageName = 'Envío a Evaluar';
		update solicitudTest;
		
		List<String> idList = new List<String>();
		idList.add(solicitudTest.Id);
		AMICAR_EliminaSimulaciones.ElmininaSimulaciones(idList);
	}

	@isTest static void test_method_six() {
		//*****************************************************************
		// test agrega productos en checklist
		//*****************************************************************
		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
		Id rtSimulacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
		Id rtReferencia = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();
		Id rtConyuge = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Conyuge').getRecordTypeId();
		Id rtCompraPara = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Compra para').getRecordTypeId();
		Id rtAval = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Aval').getRecordTypeId();

		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		cuentaTest.PersonBirthdate = System.today();
		cuentaTest.Genero__pc = 'M';
		cuentaTest.Nacionalidad__pc = 'CHILE';
		insert cuentaTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		// datos formalizada
		solicitudTest.N_de_serie_C_I__c = '12345678';
		solicitudTest.Id_Solicitud__c = '11111111';
		solicitudTest.Direccion__c = 'Calle 1234';
		solicitudTest.Regi_n__c = '13';
		solicitudTest.Comuna__c = '13101';
		solicitudTest.Tipo_de_residencia__c = '1';
		solicitudTest.Estado_civil__c = 'SH';
		solicitudTest.Regimen_matrimonial__c = 'NA';
		solicitudTest.Estudios__c = 'SU';
		solicitudTest.Profesion__c = 'Profesion';
		solicitudTest.Tipo_de_trabajador__c = '';
		solicitudTest.Empleador__c = 'Empleador';
		solicitudTest.RUT_empleador__c = '14381623-0';
		solicitudTest.Rubro_de_empleador__c = '5';
		solicitudTest.Direccion_empleador__c = 'Calle 1234';
		solicitudTest.Region_empleador__c = '13';
		solicitudTest.Comuna_empleador__c = '13101';
		solicitudTest.Telefono_empleador__c = '123456';
		solicitudTest.Fecha_de_ingreso__c = System.today();
		solicitudTest.Cargo__c = 'Cargo';
		//solicitudTest.Tipo_de_actividad__c = 'Artesano';
		solicitudTest.Tipo_de_actividad__c = '2';
		solicitudTest.Tipo_de_contrato__c = 'IN';
		solicitudTest.Tipo_de_renta__c = 'FI';
		solicitudTest.Renta__c = 1234567;
		solicitudTest.Otros_ingresos__c = 0;
		solicitudTest.Arriendo__c = 0;
		solicitudTest.Dividendo__c = 100;
		solicitudTest.Otros_egresos__c = 0;
		solicitudTest.Banco_cuenta_1__c = '6';
		solicitudTest.Numero_cuenta_1__c = '123456';
		solicitudTest.Tipo_cuenta_1__c = 'Corriente';
		solicitudTest.PAC_cuenta_1__c = false;
		solicitudTest.Banco_cuenta_2__c = '6';
		solicitudTest.Numero_cuenta_2__c = '123456';
		solicitudTest.Tipo_de_cuenta_2__c = 'Corriente';
		solicitudTest.PAC_cuenta_2__c = false;
		solicitudTest.Pricebook2Id = Test.getStandardPricebookId();
		insert solicitudTest;

		Relacion__c referenciaTest = new Relacion__c();
		referenciaTest.Nombre__c = 'Nombre';
		referenciaTest.Apellidos__c = 'Apellido';
		referenciaTest.Tipo_de_relacion__c = 'Amigo(a)';
		referenciaTest.Direccion__c = 'Calle 1234';
		referenciaTest.Telefono__c = '1111111';
		referenciaTest.Solicitud__c = solicitudTest.Id;
		referenciaTest.RecordTypeId = rtReferencia;
		insert referenciaTest;

		Relacion__c conyugeTest = new Relacion__c();
		conyugeTest.RUT_referencia__c = '14381623-0';
		conyugeTest.Nombre__c = 'nombre';
		conyugeTest.Apellidos__c = 'apellidos';
		conyugeTest.Direccion__c = 'calle 1234';
		conyugeTest.Region__c = '13';
		conyugeTest.Comuna__c = '13101';
		conyugeTest.Complementa_renta__c = false;
		conyugeTest.Empleador__c = 'Empleador';
		conyugeTest.Telefono_empleador__c = '123456';
		conyugeTest.Tipo_de_trabajador__c = 'IN';
		//conyugeTest.Tipo_de_actividad__c = 'Artesano';
		conyugeTest.Tipo_de_actividad__c = '2';
		conyugeTest.Sueldo_liquido__c = 1500000;
		conyugeTest.Solicitud__c = solicitudTest.Id;
		conyugeTest.RecordTypeId = rtConyuge;
		insert conyugeTest;

		Relacion__c compraParaTest = new Relacion__c();
		compraParaTest.Cuenta__c = cuentaTest.Id;
		compraParaTest.Estado_civil__c = 'SO';
		compraParaTest.Regimen_matrimonial__c = 'NA';
		compraParaTest.Direccion__c = 'Calle 12345';
		compraParaTest.Region__c = '13';
		compraParaTest.Comuna__c = '13101';
		compraParaTest.Solicitud__c = solicitudTest.Id;
		compraParaTest.RecordTypeId = rtCompraPara;
		insert compraParaTest;

		Relacion__c avalTest = new Relacion__c();
		avalTest.Cuenta__c = cuentaTest.Id;
		avalTest.Estado_civil__c = 'SO';
		avalTest.Regimen_matrimonial__c = 'NA';
		avalTest.Direccion__c = 'Calle 12345';
		avalTest.Region__c = '13';
		avalTest.Comuna__c = '13101';
		avalTest.Tipo_de_trabajador__c = 'IN';
		//avalTest.Tipo_de_actividad__c = 'Artesano';
		avalTest.Tipo_de_actividad__c = '2';
		avalTest.Solicitud__c = solicitudTest.Id;
		avalTest.RecordTypeId = rtAval;
		insert avalTest;

		Patrimonio__c patrimonioTest = new Patrimonio__c();
		patrimonioTest.Tipo__c = 'BR';
		patrimonioTest.Valor_venta__c = 123456789;
		patrimonioTest.Financiamiento__c = '1';
		patrimonioTest.Descripcion__c = 'casa';
		patrimonioTest.Solicitud__c = solicitudTest.Id;
		insert patrimonioTest;

		Quote simulacionTest = new Quote();
		simulacionTest.RecordTypeId = rtSimulacion;
		simulacionTest.Name = 'escenario test';
		simulacionTest.Status = 'Borrador';
		simulacionTest.OpportunityId = solicitudTest.Id;
		simulacionTest.CAE__c = 123;
		simulacionTest.Costo_total_cr_dito__c = 1234567;
		simulacionTest.Valor_UF__c = 28000;
		simulacionTest.Saldo_precio__c = 123456;
		simulacionTest.Total_a_financiar__c = 123456;
		simulacionTest.Interes_por_desfase__c = 123456;
		simulacionTest.Capital_final__c = 123456;
		simulacionTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		simulacionTest.Cuotas__c = 48;
		simulacionTest.Valor_cuota__c = 123456;
		simulacionTest.Tasa__c = 1;
		simulacionTest.Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL';
		simulacionTest.Comisi_n_dealer__c = 123456;
		simulacionTest.Fecha_creacion__c = System.now();
		simulacionTest.Tasa_dealer__c = 1;
		simulacionTest.Pricebook2Id = Test.getStandardPricebookId();
		insert simulacionTest;

		Product2 amicarAsistencia = new Product2();
		amicarAsistencia.Name = 'FAMILIA PROTEGIDA';
		amicarAsistencia.ProductCode = '1';
		amicarAsistencia.Identificador__c = 'FAMILIA PROTEGIDA 1 amicarAssistance';
		amicarAsistencia.Family = 'amicarAssistance';
		amicarAsistencia.IsActive = true;
		insert amicarAsistencia;

		PricebookEntry entradaTest4 = new PricebookEntry();
		entradaTest4.Product2Id = amicarAsistencia.Id;
		entradaTest4.Pricebook2Id = Test.getStandardPricebookId();
		entradaTest4.UnitPrice = 1;
		entradaTest4.IsActive = true;
		insert entradaTest4;

		solicitudTest.SyncedQuoteId = simulacionTest.Id;
		solicitudTest.StageName = 'Checklist';
		update solicitudTest;


		OpportunityLineItem productoOportunidad = new OpportunityLineItem();
		productoOportunidad.OpportunityId = solicitudTest.Id;
		productoOportunidad.PricebookEntryId = entradaTest4.Id;
		productoOportunidad.Quantity = 1;
		productoOportunidad.UnitPrice = 1;
		productoOportunidad.Seleccionado__c = true;
		insert productoOportunidad;
	}

	@isTest static void test_method_seven() {
		//*****************************************************************
		// test controlador carta adjudicación
		//*****************************************************************
		Id rtCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		Id rtSolicitud = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = rtCuenta;
		cuentaTest.FirstName = 'Cuenta';
		cuentaTest.LastName = 'Test';
		cuentaTest.RUT__c = '14381623-0';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		cuentaTest.PersonMobilePhone = '9999999';
		cuentaTest.PersonBirthdate = System.today();
		cuentaTest.Genero__pc = 'M';
		cuentaTest.Nacionalidad__pc = 'CHILE';
		insert cuentaTest;

		Local__c localTest = new Local__c();
		localTest.Name = 'Local Test';
		localTest.Codigo_Local__c = '12345';
		localTest.Importador__c = '	829957000';
		localTest.Concesionario__c = '69';
		insert localTest;

		Vendedor__c vendedorTest = new Vendedor__c();
		vendedorTest.Name = 'Vendedor test';
		vendedorTest.RUT__c = '112223339';
		vendedorTest.Local__c = '27 PLAZA VESPUCIO SUZUKI';
		insert vendedorTest;

		Modelo_de_vehiculo__c modeloTest = new Modelo_de_vehiculo__c();
		modeloTest.Modelo__c = 'CAMRY TEST';
		//modeloTest.Marca__c = 'TOYOTA';
		modeloTest.Marca__c = '845';
		modeloTest.Codigo_modelo__c = '561';
		insert modeloTest;

		Opportunity solicitudTest = new Opportunity();
		solicitudTest.Name = 'test';
		solicitudTest.StageName = 'Pre evaluación';
		solicitudTest.CloseDate = system.today() + 31;
		solicitudTest.Local__c = localTest.Id;
		solicitudTest.Vendedor__c = vendedorTest.Id;
		solicitudTest.Tipo_de_Veh_culo__c = 'NU';
		//solicitudTest.Marca_vehiculo__c = 'TOYOTA';
		solicitudTest.Marca_vehiculo__c = '845';
		solicitudTest.A_o_Veh_culo__c = 2020;
		solicitudTest.Modelo2__c = modeloTest.Id;
		solicitudTest.Version__c = 'XXX';
		solicitudTest.Precio_vehiculo__c = 26000000;
		solicitudTest.Pie__c = 10000000;
		solicitudTest.Tipo_de_financiamiento__c = 'CONVENTIONAL';
		solicitudTest.Cuotas__c = '48';
		solicitudTest.Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL';
		solicitudTest.Monto_retoma__c = 0;
		solicitudTest.AccountId = cuentaTest.Id;
		solicitudTest.RecordTypeId = rtSolicitud;
		// datos formalizada
		solicitudTest.N_de_serie_C_I__c = '12345678';
		solicitudTest.Id_Solicitud__c = '11111111';
		solicitudTest.Direccion__c = 'Calle 1234';
		solicitudTest.Regi_n__c = '13';
		solicitudTest.Comuna__c = '13101';
		solicitudTest.Tipo_de_residencia__c = '1';
		solicitudTest.Estado_civil__c = 'SH';
		solicitudTest.Regimen_matrimonial__c = 'NA';
		solicitudTest.Estudios__c = 'SU';
		solicitudTest.Profesion__c = 'Profesion';
		solicitudTest.Tipo_de_trabajador__c = '';
		solicitudTest.Empleador__c = 'Empleador';
		solicitudTest.RUT_empleador__c = '14381623-0';
		solicitudTest.Rubro_de_empleador__c = '5';
		solicitudTest.Direccion_empleador__c = 'Calle 1234';
		solicitudTest.Region_empleador__c = '13';
		solicitudTest.Comuna_empleador__c = '13101';
		solicitudTest.Telefono_empleador__c = '123456';
		solicitudTest.Fecha_de_ingreso__c = System.today();
		solicitudTest.Cargo__c = 'Cargo';
		//solicitudTest.Tipo_de_actividad__c = 'Artesano';
		solicitudTest.Tipo_de_actividad__c = '2';
		solicitudTest.Tipo_de_contrato__c = 'IN';
		solicitudTest.Tipo_de_renta__c = 'FI';
		solicitudTest.Renta__c = 1234567;
		solicitudTest.Otros_ingresos__c = 0;
		solicitudTest.Arriendo__c = 0;
		solicitudTest.Dividendo__c = 100;
		solicitudTest.Otros_egresos__c = 0;
		solicitudTest.Banco_cuenta_1__c = '6';
		solicitudTest.Numero_cuenta_1__c = '123456';
		solicitudTest.Tipo_cuenta_1__c = 'Corriente';
		solicitudTest.PAC_cuenta_1__c = false;
		solicitudTest.Banco_cuenta_2__c = '6';
		solicitudTest.Numero_cuenta_2__c = '123456';
		solicitudTest.Tipo_de_cuenta_2__c = 'Corriente';
		solicitudTest.PAC_cuenta_2__c = false;
		solicitudTest.Pricebook2Id = Test.getStandardPricebookId();
		insert solicitudTest;

		PageReference pagina = Page.AMICAR_ProcesaCarta;
		Test.setCurrentPage(pagina);
		pagina.getParameters().put('id', String.valueOf(solicitudTest.Id));

		ApexPages.StandardController sc = new ApexPages.StandardController(solicitudTest);
		AMICAR_ProcesaCartaController procesaCarta = new AMICAR_ProcesaCartaController(sc);
		String id = solicitudTest.Id;


	}

	@isTest static void test_method_eight() {
		//*****************************************************************
		// test clases elimina datos
		//*****************************************************************
		//AMICAR_EliminaSimulaciones


	}
}