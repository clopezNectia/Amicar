/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Apex de apoyo para clase Apex Rest ServicioRestOpportunityWS
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 26-01-2021		      RL					   Creación de Clase
***********************************************************************************/

public class AMICAR_ServiciosRestOpportunityWS_Class  {
	public AMICAR_ServiciosRestOpportunityWS_Class (){
	}

	public Account crearCliente(AMICAR_OpportunityJSON2.Customer cliente){
		Account acc = new Account();
		acc.RUT__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(cliente.identificationValue);
			
		//1 = Persona Natural, 2 = Persona Jurídica
		if(cliente.identificationTypeId == 1){
			acc.FirstName = cliente.name;
			acc.LastName = cliente.lastName + ' ' + cliente.motherLastName;
			acc.PersonBirthDate = Date.valueOf(cliente.dob);
			if(String.isNotBlank(cliente.gender)){
				acc.Genero__pc = cliente.gender.substring(0,0+1);//(customer.gender).toString().substring(0,0+1);
			}
			if(cliente.nationalityData != null){
				acc.Nacionalidad__pc = cliente.nationalityData.externalCode;
			}
			acc.PersonEmail = cliente.email;
			acc.PersonMobilePhone = cliente.phone;
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		}else{
			acc.Name = cliente.companyName;
			acc.Description = cliente.businessSectorDescription;
			acc.Phone = cliente.workPhone;
			acc.ShippingStreet = cliente.address;
			acc.ShippingCity = cliente.geographicData.COMMUNE.name.toLowerCase().capitalize();
			acc.ShippingState = cliente.geographicData.REGION.name.toLowerCase().capitalize();
			acc.ShippingCountry = cliente.geographicData.COUNTRY.name.toLowerCase().capitalize();
			acc.BillingStreet = cliente.address;
			acc.BillingCity = cliente.geographicData.COMMUNE.name.toLowerCase().capitalize();
			acc.BillingState = cliente.geographicData.REGION.name.toLowerCase().capitalize();
			acc.BillingCountry = cliente.geographicData.COUNTRY.name.toLowerCase().capitalize();
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Empresa').getRecordTypeId();
		}
		return acc;
	}


	//Si identificationTypeId es NULL, 0 o 1, se considerará Cuenta Persona, caso contrario Cuenta Empresa
	public Account crearAval(AMICAR_OpportunityJSON2.Guarantor aval){
		Account acc = new Account();
		acc.RUT__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(aval.identificationValue);
		if(aval.identificationTypeId == null || aval.identificationTypeId == 0 || aval.identificationTypeId == 1){
			acc.FirstName = aval.name;
			acc.LastName = aval.lastName + ' ' +aval.motherLastName;
			acc.PersonBirthDate = Date.valueOf(aval.dob);
			/*********************/
			//Debería venir siempre??
			/*********************/
			if(String.isNotBlank(aval.gender)){
				acc.Genero__pc = aval.gender.substring(0,0+1);
			}
			acc.Nacionalidad__pc = aval.nationalityData.externalCode;
			acc.PersonEmail = aval.email;
			acc.PersonMobilePhone = aval.phone;
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId();
		}else{
			String nombreAval = aval.name + ' ' + aval.lastName + ' ' + aval.motherLastName;
			acc.Name = nombreAval.trim();
			acc.Phone = aval.phone;
			acc.Description = aval.activityTypeData.name;
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Empresa').getRecordTypeId();
		}
		return acc;
	}

	public Account crearRepLegal(AMICAR_OpportunityJSON2.LegalRepresentative repLegal){
		Account acc = new Account();
		acc.RUT__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(repLegal.identificationValue);
		acc.FirstName = repLegal.name;
		acc.LastName = '.';
		if(String.isBlank(repLegal.email)){
			acc.PersonEmail = 'sincorreo@replegal.com';
		}else{
			acc.PersonEmail = repLegal.email;
		}
		acc.PersonMobilePhone = repLegal.phone;
		return acc;
	}

	public Account crearSocio(AMICAR_OpportunityJSON2.MajorityPartners socio){
		Account acc = new Account();
		acc.RUT__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(socio.identificationValue);
		acc.FirstName = socio.name;
		acc.LastName = '.';
		acc.PersonEmail = 'sincorreo@socio.com';
		acc.PersonMobilePhone = socio.phone;
		return acc;
	}

	public Account crearCompraPara(AMICAR_OpportunityJSON2.BuyForAnother compraPara){
		Account acc = new Account();
		acc.RUT__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(compraPara.identificationValue);
		acc.FirstName = compraPara.name;
		acc.LastName = compraPara.lastName + ' ' + compraPara.motherLastName;
		acc.PersonBirthDate = Date.valueOf(compraPara.dob);
		//acc.Genero__pc = compraPara.gender.substring(0,0+1);
		acc.Nacionalidad__pc = compraPara.nationalityData.externalCode;
		//acc.PersonEmail = compraPara.email;
		//acc.PersonMobilePhone = compraPara.phone;
		return acc;
	}

	public Opportunity crearOportunidad(AMICAR_OpportunityJSON2 oppResp, User propietario, Account acc, Local__c local, Vendedor__c vendedor, Modelo_de_vehiculo__c modelo, Modelo_de_vehiculo__c modeloRetoma){
		AMICAR_ServicioRestOpportunityWS_SOQL consultasSOQL = new AMICAR_ServicioRestOpportunityWS_SOQL();
        Opportunity opp = new Opportunity();
		
		opp.Id_Solicitud__c = String.valueOf(oppResp.loanSimulationData.id);
		opp.Name = AMICAR_ServiciosRestOpportunityWS.nameConcat(oppResp.customer.identificationValue, oppResp.loanSimulationCar.Brand.name, oppResp.loanSimulationCar.Model.name);
		opp.CloseDate = Date.valueOf(oppResp.loanSimulationData.dateOfFirstDue);
		opp.Local__c =  local.Id;
		opp.Vendedor__c = vendedor.Id;
		opp.Tipo_de_Veh_culo__c = oppResp.loanSimulationCar.VehicleType.externalCode;
		opp.Marca_vehiculo__c = String.valueOf(oppResp.loanSimulationCar.Brand.id);
		//opp.Modelo2_retoma__c = modelo.Id;
		opp.Modelo2__c = modelo.Id;
		//opp.Modelo__c = modelo.Id;			
		opp.A_o_Veh_culo__c = oppResp.loanSimulationCar.year;
		opp.Version__c = oppResp.loanSimulationCar.carVersion;
		opp.Precio_vehiculo__c = oppResp.loanSimulationCar.price;
		opp.Pie__c = oppResp.loanSimulationData.downPayment;
		opp.Tipo_de_financiamiento__c = oppResp.loanSimulationData.LoanType.cod;
		opp.Cuotas__c = String.valueOf(oppResp.loanSimulationData.term);
		opp.Tasa__c = oppResp.loanSimulationData.Rate.customerRate;
		opp.AccountId = acc.Id;
		
		//En el caso de Persona Natural se debe ingresar el Nro Serie, para PJ 1111111111
		if(oppResp.customer.identificationTypeId == 1){
			opp.N_de_serie_C_I__c = oppResp.customer.documentSerialNumber;
		}else{
			opp.N_de_serie_C_I__c = '1111111111';
		}
		
		opp.Direccion__c = oppResp.customer.address;
		opp.Regi_n__c = oppResp.customer.geographicData.REGION.externalCode;
		opp.Comuna__c = oppResp.customer.geographicData.COMMUNE.externalCode;
		if(oppResp.customerRequestData.profession != null){
			opp.Tipo_de_residencia__c = oppResp.customerRequestData.livingHousehold.externalCode;
			opp.Estado_civil__c = oppResp.customerRequestData.maritalStatus.externalCode;
			opp.Regimen_matrimonial__c = oppResp.customerRequestData.maritalRegime.externalCode;
			opp.Estudios__c = oppResp.customerRequestData.academicLevel.externalCode;
			opp.Profesion__c = oppResp.customerRequestData.profession;
		}

		if(oppResp.customerActivity.loanSimulationDataId != null){
			opp.Tipo_de_trabajador__c = oppResp.customerActivity.workType.externalCode;
			opp.Empleador__c = oppResp.customerActivity.employerName;
			opp.RUT_empleador__c = oppResp.customerActivity.employerIdentificationValue;
			opp.Rubro_de_empleador__c = oppResp.customerActivity.businessSector.externalCode;
			opp.Direccion_empleador__c = oppResp.customerActivity.workAddress;
			//opp.Region_empleador__c = oppResp.customer.geographicData.REGION.externalCode;
			opp.Region_empleador__c = oppResp.customerActivity.workGeographicData.REGION.externalCode;
			opp.Comuna_empleador__c = oppResp.customerActivity.workGeographicData.COMMUNE.externalCode;
			opp.Telefono_empleador__c = oppResp.customerActivity.workPhone;
			opp.Fecha_de_ingreso__c = Date.valueOf(oppResp.customerActivity.workEntryDate);
			opp.Cargo__c = oppResp.customerActivity.workPosition;
			opp.Tipo_de_actividad__c = oppResp.customerActivity.activityType.externalCode;
			opp.Tipo_de_contrato__c = oppResp.customerActivity.employmentContractType.externalCode;
			opp.Tipo_de_renta__c = oppResp.customerActivity.salaryType.externalCode;
		}
		
		//Renta y Otros Ingresos corresponden solo cuando es Persona Natural
		if(oppResp.customer.identificationTypeId == 1){
			opp.Renta__c = oppResp.income.salary;
			opp.Otros_ingresos__c = oppResp.income.otherIncome;
		}else{
			//En el caso de PJ solo ingresar si vienen los datos del IF
			if(oppResp.income.otherIncome != null && oppResp.income.descriptionForOtherIncome != null){
				opp.Otros_ingresos__c = oppResp.income.otherIncome;
				opp.Descripcion_otros_ingresos__c = oppResp.income.descriptionForOtherIncome;	
			}
		}

		opp.Tipo_de_tasa__c = oppResp.loanSimulationData.Rate.RateType.cod;
		opp.Tipo_Cr_dito__c = oppResp.loanSimulationData.LoanType.cod;
		opp.Valor_UF__c = oppResp.loanSimulationData.UFValue;
		opp.CAE__c = oppResp.loanSimulationData.annualCAE;
		opp.Comision_dealer__c = oppResp.loanSimulationData.dealerCommission;
		opp.Costo_total_credito__c = oppResp.loanSimulationData.totalLoanCost;
		opp.Total_a_financiar__c = oppResp.loanSimulationData.totalToFinance;
		opp.Capital_final__c = oppResp.loanSimulationData.finalCapital;
		opp.Valor_Cuota__c = oppResp.loanSimulationData.monthlyPayment;
		opp.Arriendo__c = 0;
            
		if(oppResp.otherIncome != null){
			opp.Ano__c = String.valueOf(oppResp.otherIncome.year);
			opp.Folio__c = String.valueOf(oppResp.otherIncome.folioNumber);
			opp.Codigo_18__c = oppResp.otherIncome.code18;
			opp.Codigo_36__c = oppResp.otherIncome.code36;
			opp.Codigo_158__c = oppResp.otherIncome.code158;
			opp.Codigo_305__c = oppResp.otherIncome.code305;
			opp.Codigo_611__c = oppResp.otherIncome.code611;
			opp.Codigo_170__c = oppResp.otherIncome.code170;
			opp.Codigo_25__c = oppResp.otherIncome.code25;
			opp.Codigo_628__c = oppResp.otherIncome.code628;
			opp.Codigo_636__c = oppResp.otherIncome.code636;
			opp.Codigo_641__c = oppResp.otherIncome.code461;
			opp.Codigo_545__c = oppResp.otherIncome.code545;
		}else{
			opp.Folio__c = '';
			opp.Codigo_18__c = 0;
			opp.Codigo_36__c = 0;
			opp.Codigo_158__c =0;
			opp.Codigo_305__c =0;
			opp.Codigo_611__c =0;
			opp.Codigo_170__c =0;
			opp.Codigo_25__c = 0;
			opp.Codigo_628__c =0;
			opp.Codigo_636__c =0;
			opp.Codigo_641__c =0;
			opp.Codigo_545__c =0;
		}

		//En el caso de PJ no necesariamente vendrán estos datos por lo tanto se hace la distinción
		//En caso de no venir Otros Egresos no se hace el ingreso
		//Si viene la sección consultar si dividendo es distinto de NULL para ingresar valor, caso contrario 0
		if(oppResp.expenses.otherFixedExpenses != null){
			if(oppResp.expenses.mortgageCost != null){
				opp.Dividendo__c = oppResp.expenses.mortgageCost;
			}else{
				opp.Dividendo__c = 0;
			}
			opp.Otros_egresos__c = oppResp.expenses.otherFixedExpenses;
		}
		
		opp.Monto_retoma__c = oppResp.loanSimulationData.tradeInCarValue;
            
		//MODIFICAR DESPUES
		opp.OwnerId = propietario.Id;            
			
		if(oppResp.tradeInCar.licensePlate != null){
			opp.PPU_retoma__c = oppResp.tradeInCar.licensePlate;
			opp.Marca_retoma__c = String.valueof(oppResp.tradeInCar.Brand.id);
			opp.Modelo2_retoma__c = modeloRetoma.Id;
			//opp.Modelo2__c = modeloRetoma.Id;
			opp.Version_retoma__c = oppResp.tradeInCar.carVersion;
			/*********************/
			//CAMPOS A REVISAR PORQUE LOS PIDE REGLA DE VALIDACION VENTA10_SeccionRetoma y no vienen en JSON
			/*********************/
			opp.Tipo_retoma__c = oppResp.tradeInCar.vehicleType.externalCode;
			if(oppResp.tradeInCar.price > 0 && oppResp.tradeInCar.prepaidAmount > 0){
				opp.Deuda_retoma__c = oppResp.tradeInCar.price-oppResp.tradeInCar.prepaidAmount;
			}else{
				opp.Deuda_retoma__c = 0;
			}
                
			/*********************/
			opp.Ano_retoma__c = oppResp.tradeInCar.year;
			opp.Precio_retoma__c = oppResp.tradeInCar.price;
			opp.Kilometraje_retoma__c = oppResp.tradeInCar.mileage;
		}
        
		if(oppResp.customer.identificationTypeId == 2){
			opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito Empresa').getRecordTypeId();
		}else{ 
			opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId();
        }    
		//Por las validaciones debo crear la solicitud como pre evaluación antes de los datos de webservice
		opp.StageName = 'Pre evaluación';
		opp.Formalizacion_OK__c = false;
            
		/*********************/
		// ME PIDIÓ AGREGAR INFORMACIÓN BANCARIA
		/*********************/
		//Agrego la información bancaria
		if(oppResp.bankInformation.size() > 0){
			if(oppResp.bankInformation.size() > 1){
				opp.Banco_cuenta_1__c = oppResp.bankInformation.get(0).externalCode;
				opp.Numero_cuenta_1__c = oppResp.bankInformation.get(0).accountNumber;
				opp.PAC_cuenta_1__c = oppResp.bankInformation.get(0).automaticPayment;
				opp.Tipo_cuenta_1__c = 'Corriente';
				opp.Banco_cuenta_2__c = oppResp.bankInformation.get(1).externalCode;
				opp.Numero_cuenta_2__c = oppResp.bankInformation.get(1).accountNumber;
				opp.PAC_cuenta_2__c = oppResp.bankInformation.get(1).automaticPayment;
				opp.Tipo_de_cuenta_2__c = 'Corriente';
			}else{
				opp.Banco_cuenta_1__c = oppResp.bankInformation.get(0).externalCode;
				opp.Numero_cuenta_1__c = oppResp.bankInformation.get(0).accountNumber;
				opp.Tipo_cuenta_1__c = 'Corriente';
				opp.PAC_cuenta_1__c = oppResp.bankInformation.get(0).automaticPayment;
			}
		}
		return opp;
	}

	public Impuesto__c crearImpuesto(AMICAR_OpportunityJSON2.TaxReturn iva, String idOpp){
		Impuesto__c impuesto = new Impuesto__c();
		impuesto.Solicitud__c = idOpp;
		impuesto.Impuesto_ventas__c = iva.salesTax;
		impuesto.Impuesto_compras__c = iva.purchaseTax;
		impuesto.Fecha__c = Date.valueOf(iva.dateTax);
		return impuesto;
	}

	public Relacion__c crearCompraPara(AMICAR_OpportunityJSON2.BuyForAnother compraPara, String idCuenta, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Compra para').getRecordTypeId();
		rel.Cuenta__c = idCuenta;
		rel.Direccion__c = compraPara.address;
		rel.Region__c = compraPara.geographicData.REGION.externalCode;
		rel.Comuna__c = compraPara.geographicData.COMMUNE.externalCode;
		rel.Estado_civil__c = compraPara.maritalStatusData.externalCode;
		//if(rel.Estado_civil__c == 'CA'){
			rel.Regimen_matrimonial__c = compraPara.maritalRegimeData.externalCode;
		//}else{
			//rel.Regimen_matrimonial__c = 'NA';
		//}
		rel.Es_aval__c = false;
		rel.Solicitud__c = idOpp;
		return rel;
	}

	public Relacion__c crearAval(AMICAR_OpportunityJSON2.Guarantor aval, String idCuenta, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Aval').getRecordTypeId();
		rel.Cuenta__c = idCuenta;
		//rel.Nombre__c = aval.name;
		//rel.Apellidos__c = aval.lastName + ' ' + aval.motherLastName;
		rel.Direccion__c = aval.address;
		rel.Sueldo_liquido__c = aval.salary;
		rel.Tipo_de_actividad__c = aval.activityTypeData.externalCode;
		rel.Tipo_de_trabajador__c = aval.workTypeData.externalCode;
		rel.Region__c = aval.geographicData.REGION.externalCode;
		rel.Comuna__c = aval.geographicData.COMMUNE.externalCode;
		rel.Estado_civil__c = aval.maritalStatusData.externalCode;
		rel.Regimen_matrimonial__c = aval.maritalRegimeData.externalCode;
		rel.Es_aval__c = true;
		rel.Solicitud__c = idOpp;
		return rel;
	}

	public Relacion__c crearConyuge(AMICAR_OpportunityJSON2.SpouseData conyuge, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Conyuge').getRecordTypeId();
		rel.RUT_referencia__c = AMICAR_ServiciosRestOpportunityWS.formatoRut(conyuge.identificationValue);
		rel.Nombre__c = conyuge.name;
		rel.Apellidos__c = conyuge.lastName +' '+conyuge.motherLastName;
		rel.Direccion__c = conyuge.address;
		rel.Region__c = conyuge.spouseGeographicData.REGION.externalCode;
		rel.Comuna__c = conyuge.spouseGeographicData.COMMUNE.externalCode;
		rel.Complementa_renta__c = conyuge.combinedIncome;
		rel.Empleador__c = conyuge.employerName;
		rel.Telefono_empleador__c = conyuge.workPhone;
		rel.Tipo_de_trabajador__c = conyuge.workType.externalCode;
		rel.Tipo_de_actividad__c = conyuge.activityType.externalCode;
		rel.Sueldo_liquido__c = conyuge.salary;
		rel.Solicitud__c = idOpp;
		return rel;
	}

	public Relacion__c crearReferencia(AMICAR_OpportunityJSON2.PersonalReferences referencia, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();
		rel.Solicitud__c = idOpp;
		rel.Direccion__c = referencia.address;
		rel.Telefono__c = referencia.phone;
		rel.Tipo_de_relacion__c = referencia.typeData.externalCode;
		rel.Nombre__c = referencia.name;
		rel.Apellidos__c = referencia.name;
		return rel;
	}

	public Relacion__c crearReferenciaProveedor(AMICAR_OpportunityJSON2.CustomerSuppliers proveedor, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Referencia').getRecordTypeId();
		rel.Solicitud__c = idOpp;
		rel.Direccion__c = '.';
		rel.Telefono__c = proveedor.phone;
		rel.Tipo_de_relacion__c = 'Otro';
		rel.Nombre__c = proveedor.name;
		rel.Apellidos__c = '.';
		return rel;
	}

	public Relacion__c crearRepresentanteLegal(AMICAR_OpportunityJSON2.LegalRepresentative legalRep, String idCuenta, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Representante Legal').getRecordTypeId();
		rel.Cuenta__c = idCuenta;
		rel.Direccion__c = legalRep.address;
		//rel.Sueldo_liquido__c = legalRep.salary;
		//rel.Tipo_de_actividad__c = legalRep.activityTypeData.externalCode;
		//rel.Tipo_de_trabajador__c = legalRep.workTypeData.externalCode;
		rel.Region__c = legalRep.geographicData.REGION.externalCode;
		rel.Comuna__c = legalRep.geographicData.COMMUNE.externalCode;
		rel.Estado_civil__c = legalRep.maritalStatusData.externalCode;
		//rel.Regimen_matrimonial__c = legalRep.maritalRegimeData.externalCode;
		rel.Es_aval__c = legalRep.isGuarantor;
		rel.Solicitud__c = idOpp;
		return rel;
	}

	public Relacion__c crearSocio(AMICAR_OpportunityJSON2.MajorityPartners socio, String idCuenta, String idOpp){
		Relacion__c rel = new Relacion__c();
		rel.RecordTypeId = Schema.SObjectType.Relacion__c.getRecordTypeInfosByName().get('Socio').getRecordTypeId();
		rel.Cuenta__c = idCuenta;
		rel.Direccion__c = socio.address;
		rel.Es_aval__c = false;
		rel.Solicitud__c = idOpp;
		return rel;
	}

	public Quote crearQuote(AMICAR_OpportunityJSON2.LoanSimulationData datosQuote, List<AMICAR_OpportunityJSON2.AmortizationSchedule> amrtSchLst, String idOpp, String idPricebook2){
		Quote q = new Quote();
		
		q.Tipo_de_financiamiento__c = datosQuote.LoanType.cod;
		q.Cuotas__c = datosQuote.term;
		q.Valor_cuota__c = datosQuote.monthlyPayment;
		q.Valor_UF__c = datosQuote.UFValue;
		q.CAE__c = datosQuote.annualCAE;
		q.Costo_total_cr_dito__c = datosQuote.totalLoanCost;
		q.Tasa__c = datosQuote.customerRate;
		q.Tasa_dealer__c = datosQuote.Rate.dealerRate;
		q.Saldo_precio__c = datosQuote.balance;
		q.Total_a_financiar__c = datosQuote.totalToFinance;
		q.Interes_por_desfase__c = datosQuote.delayedInterest;
		q.Capital_final__c = datosQuote.finalCapital;
		q.Tipo_de_tasa2__c = datosQuote.Rate.RateType.cod;
		q.OpportunityId = idOpp;
		q.Name = 'Simulación ' + datosQuote.LoanType.description+ ' ' +datosQuote.term;
		q.Pie__c = datosQuote.downPayment;
		q.Comisi_n_dealer__c = datosQuote.dealerCommission;
		q.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId();
		q.Pricebook2Id =  idPricebook2;
		q.Comisi_n_dealer__c = datosQuote.dealerCommission;
		//Se agrega VFMG
		for(AMICAR_OpportunityJSON2.AmortizationSchedule amrtSch : amrtSchLst){
			if(amrtSch.quotaType == 'SMART'){
				q.VFMG__c = amrtSch.payment;
				break;
			}
		}
		//Fin VFMG
		
		return q;		
	}

	public QuoteLineItem crearQuoteLineItem(AMICAR_OpportunityJSON2.SurchargesAndInsurances item, String idProduct2, String idPricebookEntry, String idQuote){
		QuoteLineItem nuevoItem = new QuoteLineItem();
		nuevoItem.Product2Id = idProduct2;
		nuevoItem.Quantity = 1;
		nuevoItem.UnitPrice = item.factorCalculated;
		//Según definición de Patricio Anabalón se debe pegar el value como factorCalculated
		//nuevoItem.Value__c = asistenciasAmicar.value;
		nuevoItem.Value__c = item.factorCalculated;
		nuevoItem.Divisa__c = item.currencyType;
		nuevoItem.QuoteId = idQuote;
		nuevoItem.PricebookEntryId = idPricebookEntry;
		nuevoItem.Requerido__c = item.isRequired;
		nuevoItem.Seleccionado__c = item.selected;
		return nuevoItem;
	}

	public Patrimonio__c crearPatrimonio(AMICAR_OpportunityJSON2.Heritage patrimonio, String idOpp){
		Patrimonio__c pat = new Patrimonio__c();
		pat.Solicitud__c = idOpp;
		pat.Tipo__c = patrimonio.typeExternalCode;
		pat.Valor_venta__c = patrimonio.saleValue;
		pat.Financiamiento__c = patrimonio.financingTypeExternalCode;
		pat.Descripcion__c = patrimonio.description;
		pat.Con_deuda__c = patrimonio.stillPaying;
		return pat;
	}

	public Desarrollo__c crearDesarrollo(AMICAR_OpportunityJSON2.AmortizationSchedule desarrollo, String idOpp, String idQuote){
		Desarrollo__c des = new Desarrollo__c();
		des.Solicitud__c = idOpp;
		des.Simulacion__c = idQuote;
        des.Numero_de_pago__c = desarrollo.paymentNumber;
		des.Fecha_vencimiento__c = desarrollo.expirationDate;
		des.Pago__c = desarrollo.payment;
		return des;
	}
}