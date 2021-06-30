@isTest
private class AMICAR_EnviaSimulacionSincronizadaTest {

	@isTest
	private static void testMetodoInvocable() {
		Test.startTest();

		Recordtype recordtypeCuenta = [Select Id from recordtype where Name = 'Cliente Persona'];
		Account cuenta = new Account(
		                             LastName = 'HARRIS',
		                             FirstName = 'PAUL',
		                             Salutation = 'Mr.',
		                             RecordTypeId = recordtypeCuenta.Id,
		                             PersonMobilePhone = '99999999',
		                             PersonEmail = 'ee@gmail.com',
		                             PersonBirthdate = Date.newInstance(1978, 9, 1),
		                             PersonHasOptedOutOfEmail = false,
		                             PersonDoNotCall = false,
		                             N_mes_en_curso__c = false,
		                             N_mes_vencimiento_posterior__c = false,
		                             RUT__c = '16522280-6',
		                             No_enviar_SMS__c = false,
		                             et4ae5__HasOptedOutOfMobile__pc = false,
		                             et4ae5__Mobile_Country_Code__pc = 'US',
		                             Genero__pc = 'M',
		                             Nacionalidad__pc = 'CHILE');
		insert cuenta;

		Local__c local = new Local__c(
		                              Name = '112 PLAZA VESPUCIO (GWM-GEE-JAC-CHA)',
		                              Codigo_Local__c = '22',
		                              Concesionario__c = '69',
		                              Importador__c = '829957000');
		insert local;

		Modelo_de_vehiculo__c modeloVehiculo = new Modelo_de_vehiculo__c(
		                                                                 Name = 'NEW ECOSPORT',
		                                                                 Codigo_modelo__c = '668',
		                                                                 //Marca__c = 'FORD');
																		 Marca__c = '818');
		insert modeloVehiculo;

		Modelo_de_vehiculo__c modeloVehiculo2 = new Modelo_de_vehiculo__c(
		                                                                  Name = 'MORNING',
		                                                                  Codigo_modelo__c = '69',
		                                                                  //Marca__c = 'KIA');
																		  Marca__c = '827');
		insert modeloVehiculo2;

		Vendedor__c vendedor = new Vendedor__c(
		                                       Name = 'Vendedor Dummy',
		                                       Local__c = '153 DERCOUSADOS VITACURA',
		                                       RUT__c = '112223339');
		insert vendedor;

		RecordType recordtypeOportunidad = [Select Id from recordtype where Name = 'Simulación de crédito'];
		Opportunity oportunidad = new Opportunity(
		                                          AccountId = cuenta.Id,
		                                          RecordTypeId = recordtypeOportunidad.id,
		                                          //Name = '16522280-6  FORD - Simulación',
												  Name = '16522280-6  FORD - Simulación',
		                                          Description = 'holi',
		                                          StageName = 'Pre evaluación',
		                                          Probability = 10.0,
		                                          CloseDate = Date.newInstance(2020, 11, 05),
		                                          ForecastCategoryName = 'Pipeline',
		                                          Budget_Confirmed__c = false,
		                                          Discovery_Completed__c = false,
		                                          ROI_Analysis_Completed__c = false,
		                                          A_o_Veh_culo__c = 2020.0,
		                                          Ano__c = '2019',
		                                          Cargo__c = 'sdfsf',
		                                          Comuna__c = '6302',
		                                          Confirma_Asistencia__c = false,
		                                          Empleador__c = 'gggg',
		                                          Envio_Correo_Agenda__c = false,
		                                          Envio_SMS_Agenda__c = false,
		                                          Estado_Asistencia__c = false,
		                                          Estado_contacto_telefonico_agenda__c = false,
		                                          //Marca_vehiculo__c = 'FORD',
												  Marca_vehiculo__c = '818',
		                                          Pie__c = 2500000.0,
		                                          Precio_vehiculo__c = 14000000,
		                                          Regi_n__c = '6',
		                                          Tipo_de_Veh_culo__c = 'NU',
		                                          Tipo_de_contrato__c = 'DE',
		                                          Tipo_de_trabajador__c = 'DE',
		                                          Version__c = '4.9',
		                                          Ano_retoma__c = 2016.0,
		                                          Arriendo__c = 0.0,
		                                          Banco_cuenta_1__c = '1',
		                                          Banco_cuenta_2__c = '6',
		                                          Comuna_empleador__c = '4302',
		                                          Cuotas__c = '36',
		                                          Descripcion_otros_ingresos__c = 'fds',
		                                          Detalles_retoma__c = 'ggg',
		                                          Deuda_retoma__c = 1500000.0,
		                                          Direccion__c = 'Galvarino gallardo 1683, depto 203',
		                                          Direccion_empleador__c = 'Galvarino gallardo 1683, depto 203',
		                                          Dividendo__c = 1000000.0,
		                                          Estado_civil__c = 'SO',
		                                          Estudios__c = 'MA',
		                                          Fecha_de_ingreso__c = Date.newInstance(2003, 10, 01),
		                                          Formalizacion_OK__c = false,
		                                          Kilometraje_retoma__c = 76000.0,
		                                          Local__c = local.Id,
		                                          //Marca_retoma__c = 'KIA',
												  Marca_retoma__c = '827',
		                                          Modelo2__c = modeloVehiculo.Id,
		                                          Modelo2_retoma__c = modeloVehiculo2.Id,
		                                          Monto_retoma__c = 3500000.0,
		                                          N_de_serie_C_I__c = '66666666',
		                                          Numero_cuenta_1__c = '5435435345',
		                                          Numero_cuenta_2__c = '444444444',
		                                          Opcion_inmediata__c = false,
		                                          Otros_egresos__c = 0.0,
		                                          Otros_ingresos__c = 0.0,
		                                          PAC_cuenta_1__c = true,
		                                          PAC_cuenta_2__c = false,
		                                          PPU_retoma__c = 'glfh60',
		                                          Precio_retoma__c = 5000000.0,
		                                          Profesion__c = 'gggg',
		                                          RUT_empleador__c = '1-9',
		                                          Regimen_matrimonial__c = 'NA',
		                                          Region_empleador__c = '4',
		                                          Renta__c = 5000000.0,
		                                          Respuesta_Servicio__c = 'OK',
		                                          Rubro_de_empleador__c = '6',
		                                          Tasa__c = 2.0,
		                                          Telefono_empleador__c = '+56973311570',
		                                          Tipo_cuenta_1__c = 'Corriente',
		                                          //Tipo_de_actividad__c = 'Artesano',
												  Tipo_de_actividad__c = '2',
		                                          Tipo_de_cuenta_2__c = 'Corriente',
		                                          Tipo_de_financiamiento__c = 'CONVENTIONAL',
		                                          Tipo_de_renta__c = 'FI',
		                                          Tipo_de_residencia__c = '1',
		                                          Tipo_de_tasa__c = 'CONVENTIONAL_3_ZERO_FEES',
		                                          Tipo_retoma__c = 'US',
		                                          Vendedor__c = vendedor.Id,
		                                          Version_retoma__c = 'glx',
		                                          Remate_finalizado__c = false,
		                                          Codigo_158__c = 345000.0,
		                                          Codigo_170__c = 345000.0,
		                                          Codigo_18__c = 345000.0,
		                                          Codigo_25__c = 345000.0,
		                                          Codigo_305__c = 345000.0,
		                                          Codigo_36__c = 345000.0,
		                                          Codigo_545__c = 345000.0,
		                                          Codigo_611__c = 345000.0,
		                                          Codigo_628__c = 345000.0,
		                                          Codigo_636__c = 345000.0,
		                                          Codigo_641__c = 345000.0,
		                                          Descripcion_otros_egresos__c = 'pension',
		                                          Empleador_anterior__c = 'anterior',
		                                          Telefono_empleador_anterior__c = '44444444',
		                                          Antiguedad_empleo_anterior__c = '12');


		insert oportunidad;

		System.debug('oportunidada->' + oportunidad.Respuesta_Servicio__c);
		//List<string> inputParams = new List<string>();
		//inputParams.add(oportunidad.Id);
		//AMICAR_ObtieneSimulaciones.ObtieneSimulaciones (inputParams);

		RecordType recordtypeReferencia = [Select Id from recordtype where Name = 'Referencia'];
		Relacion__c referencia = new Relacion__c(
		                                         RecordTypeId = recordtypeReferencia.Id,
		                                         Apellidos__c = 'Pinto',
		                                         Complementa_renta__c = false,
		                                         Direccion__c = 'Moneda 333',
		                                         Es_aval__c = false,
		                                         Nombre__c = 'Marcelo',
		                                         Telefono__c = '998855665',
		                                         Tipo_de_relacion__c = 'Primo(a)',
		                                         Solicitud__c = oportunidad.Id);
		insert referencia;

		Patrimonio__c patrimonio = new Patrimonio__c(
		                                             Con_deuda__c = false,
		                                             Descripcion__c = 'prueba',
		                                             Financiamiento__c = '1',
		                                             Tipo__c = 'MA',
		                                             Valor_venta__c = 2000000.0,
		                                             Solicitud__c = oportunidad.Id);
		insert patrimonio;

		RecordType recordtypeAval = [Select Id from recordtype where Name = 'Aval'];
		Relacion__c aval = new Relacion__c(
		                                   RecordTypeId = recordtypeAval.Id,
		                                   Complementa_renta__c = false,
		                                   Comuna__c = '5402',
		                                   Cuenta__c = cuenta.Id,
		                                   Direccion__c = 'prueba',
		                                   Es_aval__c = false,
		                                   Estado_civil__c = 'CA',
		                                   Regimen_matrimonial__c = 'CB',
		                                   Region__c = '5',
		                                   Sueldo_liquido__c = 6000000.0,
		                                   //Tipo_de_actividad__c = 'Artesano',
										   Tipo_de_actividad__c = '2',
		                                   Tipo_de_trabajador__c = 'DE',
		                                   Solicitud__c = oportunidad.Id);
		insert aval;

		RecordType recordtypeCompraPara = [Select Id from recordtype where Name = 'Compra para'];
		Relacion__c compraPara = new Relacion__c(
		                                         RecordTypeId = recordtypeCompraPara.Id,
		                                         Complementa_renta__c = false,
		                                         Comuna__c = '1101',
		                                         Cuenta__c = cuenta.Id,
		                                         Direccion__c = 'prueba 23',
		                                         Es_aval__c = false,
		                                         Estado_civil__c = 'SL',
		                                         Regimen_matrimonial__c = 'NA',
		                                         Region__c = '1',
		                                         Solicitud__c = oportunidad.Id);
		insert compraPara;

		RecordType recordtypeConyuge = [Select Id from recordtype where Name = 'Conyuge'];
		Relacion__c Conyuge = new Relacion__c(
		                                      RecordTypeId = recordtypeConyuge.Id,
		                                      Apellidos__c = 'Perez',
		                                      Complementa_renta__c = true,
		                                      Comuna__c = '4102',
		                                      Direccion__c = 'portugal 885',
		                                      Empleador__c = 'sqm',
		                                      Es_aval__c = false,
		                                      Nombre__c = 'Ana',
		                                      RUT_referencia__c = '27',
		                                      Region__c = '4',
		                                      Sueldo_liquido__c = 3000000.0,
		                                      Telefono_empleador__c = '989898988',
		                                      //Tipo_de_actividad__c = 'Artesano',
											  Tipo_de_actividad__c = '2',
		                                      Tipo_de_trabajador__c = 'DE',
		                                      Solicitud__c = oportunidad.Id);
		insert Conyuge;

		Pricebook2 pricebook2 = new Pricebook2(
		                                       Name = 'Standard Price Book',
		                                       IsActive = true);
		insert pricebook2;

		Id pricebookIdStd = Test.getStandardPricebookId();

		RecordType recordtypeQuote = [Select Id from recordtype where Name = 'Simulación CORE'];
		Quote quote = new Quote(
		                        Name = 'simulacion CONVENTIONAL 36',
		                        RecordTypeId = recordtypeQuote.Id,
		                        OpportunityId = oportunidad.Id,
		                        Pricebook2Id = pricebookIdStd,
		                        Status = 'Borrador',
		                        Comisi_n_dealer__c = 512838.0,
		                        CI__c = false,
		                        Tasa__c = 1.6,
		                        Cuotas__c = 36.0,
		                        CAE__c = 28.48,
		                        Capital_final__c = 9059464.0,
		                        Costo_total_cr_dito__c = 11988036,
		                        Fecha_creacion__c = DateTime.newInstance(2020, 10, 1, 17, 1066, 63981),
		                        Interes_por_desfase__c = 24094.0,
		                        Saldo_precio__c = 8000000.0,
		                        Tasa_dealer__c = 1.27,
		                        Tipo_de_financiamiento__c = 'CONVENTIONAL',
		                        Tipo_de_tasa2__c = 'CONVENTIONAL_3_ZERO_FEES',
		                        Total_a_financiar__c = 9035370.0,
		                        Valor_UF__c = 28708.8,
		                        Valor_cuota__c = 333001.0);
		insert quote;

		//Id pricebookIdStd = Test.getStandardPricebookId();

		Product2 producto = new Product2(
		                                 Name = 'DESGRAVAMEN',
		                                 ProductCode = '337',
		                                 IsActive = true,
		                                 Family = 'financingEntityInsurance',
		                                 Identificador__c = 'DESGRAVAMEN 337 financingEntityInsurance');
		insert producto;

		Product2 producto2 = new Product2(
		                                  Name = 'Garantía Mecánica >5 años',
		                                  ProductCode = '67',
		                                  IsActive = true,
		                                  Family = 'amicarAssistance',
		                                  Identificador__c = 'GARANTIA MECANICA >5 AÑOS 67 amicarAssistance');
		insert producto2;

		Product2 producto3 = new Product2(
		                                  Name = 'IMPUESTO VERDE',
		                                  ProductCode = '4',
		                                  IsActive = true,
		                                  Family = 'dealerSurcharges',
		                                  Identificador__c = 'IMPUESTO VERDE 4 dealerSurcharges');
		insert producto3;

		Product2 producto4 = new Product2(
		                                  Name = 'G. OPERACIONALES',
		                                  ProductCode = '118',
		                                  IsActive = true,
		                                  Family = 'financingEntitySurcharges',
		                                  Identificador__c = 'G. OPERACIONALES 118 financingEntitySurcharges');
		insert producto4;

		PricebookEntry pricebookentry2 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebookIdStd,
		                                                    Product2Id = producto.Id);
		insert pricebookentry2;

		PricebookEntry pricebookentry = new PricebookEntry(
		                                                   UnitPrice = 1.0,
		                                                   IsActive = true,
		                                                   UseStandardPrice = false,
		                                                   Pricebook2Id = pricebook2.Id,
		                                                   Product2Id = producto.Id);
		insert pricebookentry;
		/*********************/
		PricebookEntry pricebookentry4 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebookIdStd,
		                                                    Product2Id = producto2.Id);
		insert pricebookentry4;

		PricebookEntry pricebookentry3 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebook2.Id,
		                                                    Product2Id = producto2.Id);
		insert pricebookentry3;

		PricebookEntry pricebookentry6 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebookIdStd,
		                                                    Product2Id = producto3.Id);
		insert pricebookentry6;

		PricebookEntry pricebookentry5 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebook2.Id,
		                                                    Product2Id = producto3.Id);
		insert pricebookentry5;

		PricebookEntry pricebookentry8 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebookIdStd,
		                                                    Product2Id = producto4.Id);
		insert pricebookentry8;

		PricebookEntry pricebookentry7 = new PricebookEntry(
		                                                    UnitPrice = 1.0,
		                                                    IsActive = true,
		                                                    UseStandardPrice = false,
		                                                    Pricebook2Id = pricebook2.Id,
		                                                    Product2Id = producto4.Id);
		insert pricebookentry7;
		/*********************/


		QuoteLineItem quotelineitem = new QuoteLineItem(
		                                                Quantity = 1.0,
		                                                UnitPrice = 120000.0,
		                                                Divisa__c = 'CLP',
		                                                Editable__c = true,
		                                                Requerido__c = false,
		                                                Seleccionado__c = true,
		                                                Value__c = 120000.0,
		                                                QuoteId = quote.Id,
		                                                Product2Id = producto.Id,
		                                                pricebookentryId = pricebookentry2.Id);
		insert quotelineitem;
		/*************/

		QuoteLineItem quotelineitem2 = new QuoteLineItem(
		                                                 Quantity = 1.0,
		                                                 UnitPrice = 120000.0,
		                                                 Divisa__c = 'CLP',
		                                                 Editable__c = true,
		                                                 Requerido__c = false,
		                                                 Seleccionado__c = true,
		                                                 Value__c = 120000.0,
		                                                 QuoteId = quote.Id,
		                                                 Product2Id = producto2.Id,
		                                                 pricebookentryId = pricebookentry4.Id);
		insert quotelineitem2;



		QuoteLineItem quotelineitem3 = new QuoteLineItem(
		                                                 Quantity = 1.0,
		                                                 UnitPrice = 120000.0,
		                                                 Divisa__c = 'CLP',
		                                                 Editable__c = true,
		                                                 Requerido__c = false,
		                                                 Seleccionado__c = true,
		                                                 Value__c = 120000.0,
		                                                 QuoteId = quote.Id,
		                                                 Product2Id = producto3.Id,
		                                                 pricebookentryId = pricebookentry6.Id);
		insert quotelineitem3;

		QuoteLineItem quotelineitem4 = new QuoteLineItem(
		                                                 Quantity = 1.0,
		                                                 UnitPrice = 120000.0,
		                                                 Divisa__c = 'CLP',
		                                                 Editable__c = true,
		                                                 Requerido__c = false,
		                                                 Seleccionado__c = true,
		                                                 Value__c = 120000.0,
		                                                 QuoteId = quote.Id,
		                                                 Product2Id = producto4.Id,
		                                                 pricebookentryId = pricebookentry8.Id);
		insert quotelineitem4;

		/**************************/
		oportunidad.SyncedQuoteId = quote.Id;
		update oportunidad;

		Desarrollo__c desarrollo1 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2020-11-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 1.0,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo1;
		Desarrollo__c desarrollo2 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2020-12-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 2.0,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo2;
		Desarrollo__c desarrollo3 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-01-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 3,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo3;
		Desarrollo__c desarrollo4 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-02-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 4,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo4;
		Desarrollo__c desarrollo5 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-03-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 5,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo5;
		Desarrollo__c desarrollo6 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-04-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 6,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo6;
		Desarrollo__c desarrollo7 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-05-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 7,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo7;
		Desarrollo__c desarrollo8 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-06-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 8,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo8;
		Desarrollo__c desarrollo9 = new Desarrollo__c(
		                                              Fecha_vencimiento__c = '2021-07-07',
		                                              Modificado__c = false,
		                                              Numero_de_pago__c = 9,
		                                              Pago__c = 290493.0,
		                                              Simulacion__c = quote.Id,
		                                              Solicitud__c = oportunidad.Id);
		insert desarrollo9;
		Desarrollo__c desarrollo10 = new Desarrollo__c(
		                                               Fecha_vencimiento__c = '2021-08-07',
		                                               Modificado__c = false,
		                                               Numero_de_pago__c = 10,
		                                               Pago__c = 290493.0,
		                                               Simulacion__c = quote.Id,
		                                               Solicitud__c = oportunidad.Id);
		insert desarrollo10;
		List<string> inputParams = new List<string>();
		inputParams.add(oportunidad.Id);
		AMICAR_ObtieneSimulaciones.ObtieneSimulaciones (inputParams);

		oportunidad.Fecha_de_ingreso__c = Date.newInstance(2018, 10, 10);
		oportunidad.StageName = 'Formalización';
		oportunidad.Id_Solicitud__c = '99998988';
        oportunidad.Formalizacion_OK__c=true;
		update oportunidad;
		
		AMICAR_EnviaSimulacionFormalizada.EnviaFormalizada(inputParams);

		oportunidad.StageName = 'Remate';
		update oportunidad;
		System.debug('MPI->'+oportunidad.Formalizacion_OK__c);

		AMICAR_EnviaSimulacionRemate.EnviaARemate(inputParams);

		//List<Quote> simulacionesSalesforce = [SELECT Id,Name,Cuotas__c FROM Quote WHERE OpportunityId =: oportunidad.Id];
		//System.debug('simulacionesSalesforce->'+simulacionesSalesforce);
		/*List<string> inputParams = new List<string>();
		  inputParams.add(oportunidad.Id);
		  AMICAR_EnviaSimulacionSincronizada.EnviaSincronizada(inputParams);
		 */

		Test.stopTest();
	}
}