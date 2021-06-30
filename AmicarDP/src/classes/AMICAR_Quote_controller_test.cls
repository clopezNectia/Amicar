/***************************************************************************************************
Desarrollado por: Cloud Solution
Autor: John Guaracan (JG)
Proyecto: Amicar
Descripción: Cobertura de código
Clase:AMICAR_Quote_controller_CreaPDF
Cobertura:98%
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 20/01/2021            JG                    Cobertura de código
**************************************************************************************************/
@istest
private class AMICAR_Quote_controller_test {
    @testSetup static void setup() {
        Account cuenta = new Account(
            LastName = 'Morales',
            FirstName = 'Pedro',
            PersonMobilePhone = '999999999',
            PersonEmail = 'ee@gmail.com',
            PersonBirthdate = Date.newInstance(1996,09,18),
            PersonHasOptedOutOfEmail = false,
            PersonDoNotCall = false,
            N_10__c = false,
            N_111__c = false,
            N_11__c = false,
            N_1__c = false,
            N_2__c = false,
            N_3__c = false,
            N_4__c = false,
            N_5__c = false,
            N_6__c = false,
            N_7__c = false,
            N_8__c = false,
            N_9__c = false,
            N_mes_en_curso__c = false,
            N_mes_vencimiento_posterior__c = false,
            RUT__c = '26492637-8',
            No_enviar_SMS__c = false,
            et4ae5__HasOptedOutOfMobile__pc = false,
            et4ae5__Mobile_Country_Code__pc = 'US',
            Genero__pc = 'M',
            Nacionalidad__pc = 'EXTRANJERO');
        insert cuenta;
        Local__c local = new Local__c(
            Name = '60 CARMEISTER MOVICENTER',
            Codigo_Local__c = '144',
            Concesionario__c = 'CARMEISTER',
            Importador__c = '79649140K');
        insert local;
        //Create Product
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile');
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
       /* Marca__c marca = new Marca__c(
            Name = 'NISSAN',
            Codigo_Marca__c = '836');
        insert marca;
        
        Modelo_de_vehiculo__c modelo_de_vehiculo = new Modelo_de_vehiculo__c(
            Name = 'NEW QASHQAI',
            Codigo_modelo__c = '7348',
            Marca__c = '835',
            Marca_Busqueda__c = marca.Id);
        insert modelo_de_vehiculo;*/
        
      /*  Vendedor__c vendedor = new Vendedor__c(
            Name = 'Vendedor Genérico',
            Local__c = '145 AG SUCURSAL LAS CONDES 11000',
            RUT__c = '112223339',
            Local_Busqueda__c = local.Id);
        insert vendedor;*/
        
        Opportunity opportunity = new Opportunity(
            AccountId = cuenta.Id,
            IsPrivate = false,
            Name = '26492637-8  NEW QASHQAI - Simulación2',
            Description = 'textos para describir algo',
            StageName = 'Cerrada ganada',
            Amount = 895558.0,
            Probability = 100.0,
            TotalOpportunityQuantity = 12.0,
            CloseDate = Date.newInstance(2020,11,27),
            ForecastCategoryName = 'Closed',
            Pricebook2Id = standardPricebook.Id,
            Budget_Confirmed__c = false,
            Discovery_Completed__c = false,
            ROI_Analysis_Completed__c = false,
            A_o_Veh_culo__c = 2021.0,
            Asisti__c = false,
            Cargo__c = 'TECNICO',
            Comision_dealer__c = 482143.0,
            Confirma_Asistencia__c = false,
            Empleador__c = 'COOPERATIVA VITIVINICOLA LONCOMILLA SPA',
            Envio_Correo_Agenda__c = false,
            Envio_SMS_Agenda__c = false,
            Estado_Asistencia__c = false,
            Estado_contacto_telefonico_agenda__c = false,
            Pie__c = 1550455.0,
            Precio_vehiculo__c = 1.0999,
            Quiero_agendar__c = false,
            Regi_n__c = '1',
            Tipo_Cr_dito__c = 'CONVENTIONAL',
            Tipo_de_Veh_culo__c = 'NU',
            Tipo_de_contrato__c = 'IN',
            Tipo_de_trabajador__c = 'DE',
            Valor_Cuota__c = 332178.0,
            Version__c = '2.0 SENSE',
            Ano_otros_ingresos__c = 0.0,
            Arriendo__c = 0.0,
            Banco_cuenta_1__c = '18',
            CAE__c = 25.52,
            Capital_final__c = 9175038.0,
            Codigo_158__c = 0.0,
            Codigo_170__c = 0.0,
            Codigo_18__c = 0.0,
            Codigo_25__c = 0.0,
            Codigo_305__c = 0.0,
            Codigo_36__c = 0.0,
            Codigo_545__c = 0.0,
            Codigo_611__c = 0.0,
            Codigo_628__c = 0.0,
            Codigo_636__c = 0.0,
            Codigo_641__c = 0.0,
            Comuna_empleador__c = '7406',
            Costo_total_credito__c = 1.2290586,
            Cuotas__c = '37',
            Direccion__c = 'LOS SAUCES 123',
            Direccion_empleador__c = 'CAMINO LONCOMILLA FUNDO RIO S/N',
            Dividendo__c = 0.0,
            Ejecutado__c = false,
            Estado_civil__c = 'SO',
            Estudios__c = 'SE',
            Fecha_de_ingreso__c = Date.newInstance(2019,09,16),
            Folio__c = '0',
            Formalizacion_OK__c = true,
            Id_Solicitud__c = '10001580',
            Local__c = local.Id,
           // Marca_retoma__c = '800',
          //  Modelo2__c = modelo_de_vehiculo.Id,
            N_de_serie_C_I__c = '111111111',
            Numero_cuenta_1__c = '123456789',
            Opcion_inmediata__c = false,
            Otros_egresos__c = 0.0,
            Otros_ingresos__c = 1500000.0,
            PAC_cuenta_1__c = true,
            PAC_cuenta_2__c = false,
            Profesion__c = '5',
            RUT_empleador__c = '19',
            Region_empleador__c = '7',
            Remate_finalizado__c = true,
            Renta__c = 800000.0,
            Rubro_de_empleador__c = '9',
            Tasa__c = 1.63,
            Telefono_empleador__c = '73245678',
            Tipo_cuenta_1__c = 'Corriente',
            Tipo_de_cuenta_2__c = 'Corriente',
            Tipo_de_financiamiento__c = 'CONVENTIONAL',
            Tipo_de_renta__c = 'FI',
            Tipo_de_residencia__c = '5',
            Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL',
            Total_a_financiar__c = 9170056.0,
            Valor_UF__c = 29075.93
            //,Vendedor__c = vendedor.Id
        );
        insert opportunity;
        
        Quote quote = new Quote(
            Name = 'Simulación CRÉDITO CONVENCIONAL 372',
            OpportunityId = opportunity.Id,
            Pricebook2Id = standardPricebook.Id,
            Status = 'Borrador',
            Comisi_n_dealer__c = 496253.0,
            Pie__c = 1550455.0,
            CI__c = false,
            Tasa__c = 1.63,
            Cuotas__c = 37.0,
            CAE__c = 27.66,
            Capital_final__c = 9443547.0,
            Costo_total_cr_dito__c = 1.2650263,
            Id_Simulacion__c = string.valueof(opportunity.Id),
            Interes_por_desfase__c = 5128.0,
            Saldo_precio__c = 8449545.0,
            Tasa_dealer__c = 1.33,
            Tipo_de_financiamiento__c = 'CONVENTIONAL',
            Tipo_de_tasa2__c = 'CONVENTIONAL_NORMAL',
            Total_a_financiar__c = 9438419.0,
            Valor_UF__c = 29075.93,
            Valor_cuota__c = 332178.0);
        insert quote;
        Desarrollo__c desarrollo = new Desarrollo__c(
            Fecha_vencimiento__c = '2020-11-27',
            Modificado__c = false,
            Numero_de_pago__c = 1.0,
            Pago__c = 341899.0,
            Simulacion__c = quote.Id,
            Solicitud__c = opportunity.Id);
        insert desarrollo;
        Patrimonio__c patrimonio = new Patrimonio__c(
            Con_deuda__c = false,
            Descripcion__c = 'PARCELA ALTOS DE MACHICURA SAN JAVIER',
            Financiamiento__c = '3',
            Tipo__c = 'BR',
            Solicitud__c= opportunity.Id,
            Valor_venta__c = 2.37);
        insert patrimonio;
        Relacion__c relacion = new Relacion__c(
            Apellidos__c = 'LUIS',
            Complementa_renta__c = false,
            Direccion__c = 'X',
            Es_aval__c = false,
            Nombre__c = 'LUIS',
            Telefono__c = '222222222',
            Solicitud__c=opportunity.Id,
            Tipo_de_relacion__c = 'Padre o Madre');
        insert relacion;
        Impuesto__c impuesto = new Impuesto__c(
            Fecha__c = Date.newInstance(2021,01,20),
            Impuesto_compras__c = 670000.0,
            Solicitud__c=opportunity.Id,
            Impuesto_ventas__c = 879999.0);
        insert impuesto;
        
    }
 
    private static testMethod void AMICAR_Quote_controller_test1() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
       
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test2() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,02,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test3() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,03,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test4() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,04,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test5() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,05,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test6() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,06,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test7() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,07,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test8() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,08,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    private static testMethod void AMICAR_Quote_controller_test9() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,09,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
     private static testMethod void AMICAR_Quote_controller_test10() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,10,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
     private static testMethod void AMICAR_Quote_controller_test11() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,11,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
     private static testMethod void AMICAR_Quote_controller_test12() {
        Opportunity opportunity=[SELECT Id, Name 
                                 FROM opportunity
                                 WHERE Name='26492637-8  NEW QASHQAI - Simulación2' 
                                ];
        opportunity.Regi_n__c = '15';
        opportunity.Tipo_Cr_dito__c = 'CONVENTIONAL';
        opportunity.Tipo_de_Veh_culo__c = 'NP';
        opportunity.Tipo_de_contrato__c = '';
        opportunity.Rubro_de_empleador__c='';
        opportunity.Tipo_de_renta__c = '';
        opportunity.Tipo_de_residencia__c = '';
        opportunity.Estado_civil__c = 'EP';
        opportunity.Estudios__c = '';
        opportunity.Valor_Cuota__c = 332178.0;
        opportunity.Version__c = '2.0 SENSE';
        update opportunity;
        Quote quotes=[SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, Capital_final__c, 
                      Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, Saldo_precio__c, Tipo_de_financiamiento__c, 
                      Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c, Valor_cuota__c
                      FROM Quote 
                      WHERE  Name = 'Simulación CRÉDITO CONVENCIONAL 372'
                      and OpportunityId =:opportunity.Id
                     ];
         Impuesto__c impuesto=[SELECT Id, Fecha__c,Solicitud__c 
                                 FROM Impuesto__c
                                 WHERE Solicitud__c=:opportunity.Id 
                                ];
        impuesto.Fecha__c=Date.newInstance(2021,12,20);
        update impuesto;
        PageReference p = Page.AMICAR_Quote_CreatePDF_V;
        p.getParameters().put('id',quotes.Id);
        Test.setCurrentPage(p);
        ApexPages.StandardController  apst= new ApexPages.StandardController(quotes);
        AMICAR_Quote_controller_CreaPDF pdfcontroller = new AMICAR_Quote_controller_CreaPDF(apst);
        pdfcontroller.convertir('111,1', 0);
        
        
        System.assertEquals(quotes.Id, pdfcontroller.id_Quote);
    }
    
}