/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Test para AMICAR_GetProductosChecklist
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 02-09-2020            RL                       Creación de la Clase.
1.1 05-10-2020            RL                       Actualización de métodos para agregar otros métodos
***********************************************************************************/

@isTest 
private class AMICAR_GetProductosChecklistTest {
    
    @testSetup 
    static void setup(){
        Local__c local = new Local__c(
          Name = '153 DERCOUSADOS VITACURA',// Nombre de Local
          Codigo_Local__c = '27',             // Código Local
          Importador__c = '829957000',       // Importador
          Concesionario__c = '69'  // Concesionario
        );
        insert local;
        
        Vendedor__c vendedor = new Vendedor__c(
          Name = 'Vendedor Dummy',              // Nombre
          RUT__c = '112223339',                   // RUT
          Local__c = '99 MOTOSUR'  // Local
        );
        insert vendedor;

        Modelo_de_vehiculo__c modVeh = new Modelo_de_vehiculo__c(
          Modelo__c = 'DUSTER',    // Modelo
          Marca__c = '838',      // Marca
          Codigo_modelo__c = '396'  // Código modelo
        );
        insert modVeh;

        Account cliente = new Account(
          RUT__pc = '15539757-8',                      // RUT
          PersonBirthdate = Date.valueOf('1983-08-10'),  // Birthdate
          FirstName = 'Mr. Oscar',                 // Account Name
          LastName = 'Marguirott',
          //Genero__pc = 'Masculino',                      // Género
          //Nacionalidad__pc = 'Chileno',                  // Nacionalidad
          PersonEmail = 'ee@gmail.com',                  // Email
          PersonHasOptedOutOfEmail = false,              // Email Opt Out
          PersonMobilePhone = '999999999',               // Mobile
          PersonDoNotCall = false,                       // Do Not Call
          RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona').getRecordTypeId()                    // Account Record Type
        );
        insert cliente;

        Opportunity opp = new Opportunity();
        opp = new Opportunity(
            Name = '15539757-8  RENAULT - Simulación',         // Opportunity Name
            StageName = 'Pre evaluación',                   // Stage
            CloseDate = Date.today().addDays(60),              // Close Date
            Id_Solicitud__c = '10000431',                        // Id Solicitud
            Probability = 95,                                    // Probability (%)
            Formalizacion_OK__c = true,                          // Formalización OK
            Remate_finalizado__c = true,                         // Remate finalizado
            Local__c = local.Id,                                 // Local
            Vendedor__c = vendedor.Id,                           // Vendedor
            Tipo_de_Veh_culo__c = 'Particular Nuevo',            // Tipo de Vehículo
            Marca_vehiculo__c = '838',                       // Marca vehículo
			A_o_Veh_culo__c = 2020,                              // Año Vehículo
            Modelo2__c = modVeh.Id,                      // Modelo
            Version__c = '2.0',                                  // Version
            Precio_vehiculo__c = 10.000,                         // Precio vehículo
            Pie__c = 3.000,                                      // Pie
            Tipo_de_financiamiento__c = 'CONVENTIONAL',          // Tipo de financiamiento
            Cuotas__c = '48',                                    // Cuotas
            Valor_Cuota__c = 234.259,                            // Valor Cuota
            Tipo_de_tasa__c = 'CONVENTIONAL_NORMAL',                       // Tipo de tasa
            Valor_UF__c = 28.67575,                              // Valor UF
            Tasa__c = 157,                                       // Tasa
            CAE__c = 2555,                                       // CAE
            Comision_dealer__c = 615.515,                        // Comisión dealer
            Costo_total_credito__c = 11.244,                     // Costo total crédito
            Total_a_financiar__c = 7.852,                        // Total a financiar
            Capital_final__c = 7.856,                            // Capital final
            AccountId = cliente.Id,                              // Account Name
            N_de_serie_C_I__c = '222222222',                     // N° de serie C.I.
            Monto_retoma__c = 0,                                 // Monto retoma
            Direccion__c = 'Los magnolios 768',                  // Dirección
            Estado_civil__c = 'CA',                          // Estado civil
            Regi_n__c = '9',                              // Región
            Regimen_matrimonial__c = 'CB',      // Régimen matrimonial
            Comuna__c = '9101',                                  // Comuna
            Tipo_de_residencia__c = '5',           // Tipo de residencia
            Estudios__c = 'SU',                          // Nivel de estudios
            Profesion__c = 'ingeniero',                          // Profesión
            Tipo_de_trabajador__c = 'DE',               // Tipo de trabajador
            Empleador__c = 'Fast easy ltda',                     // Empleador
            Fecha_de_ingreso__c = Date.valueOf('2017-07-14'),    // Fecha de ingreso
            RUT_empleador__c = '1-9',                            // RUT empleador
            Cargo__c = 'Tecnico',                                // Cargo
            Rubro_de_empleador__c = '5',                  // Rubro de empleador
            Tipo_de_actividad__c = '2',          // Tipo de actividad
            Direccion_empleador__c = 'Los sauces s/n',           // Dirección empleador
                
            Comuna_empleador__c = '9101',                        // Comuna empleador
            Region_empleador__c = '9',                    // Región empleador
                
                
            Telefono_empleador__c = '22222222',                  // Teléfono empleador
            Tipo_de_contrato__c = 'IN',                  // Tipo de contrato
            Tipo_de_renta__c = 'FI',                           // Tipo de renta
            Renta__c = 780.000,                                  // Sueldo Líquido
            Arriendo__c = 0,                                     // Arriendo
            Otros_ingresos__c = 500.000,                         // Otros ingresos
            Dividendo__c = 0,                                    // Dividendo
            Otros_egresos__c = 0,                                // Otros egresos
            Banco_cuenta_1__c = '18',               // Banco cuenta 1
            Numero_cuenta_1__c = '12345678',                     // Número cuenta 1
            Tipo_cuenta_1__c = 'Corriente',                      // Tipo de cuenta 1
            PAC_cuenta_1__c = false,                             // PAC cuenta 1
            PAC_cuenta_2__c = false,                             // PAC cuenta 2
            Description = 'ok',                                  // Description
            Respuesta_Servicio__c = 'Ejecución correcta',        // Respuesta Servicio
            ConteoCarta__c = '001',                              // ConteoCarta
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Simulación de crédito').getRecordTypeId()                          // Opportunity Record Type
        );
        insert opp;


        Pricebook2 pricebook2 = new Pricebook2(
                                               Name = 'Standard Price Book',
                                               IsActive = true);
        insert pricebook2;
        Id pricebookIdStd = Test.getStandardPricebookId();

        Product2 prod2 = new Product2(
          Name = 'PROTECAR',                                // Product Name
          Family = 'amicarAssistance',                        // Product Family
          ProductCode = '1020',                                 // Product Code
          IsActive = true,                                    // Active
          Identificador__c = 'PROTECAR 1020 amicarAssistance'  // Identificador
        );
        insert prod2;

        PricebookEntry entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'NEUMATICOS',                                // Product Name
          Family = 'amicarAssistance',                          // Product Family
          ProductCode = '1019',                                   // Product Code
          IsActive = true,                                      // Active
          Identificador__c = 'NEUMATICOS 1019 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1018',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'GARANTIA MECANICA 1018 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA >5 AÑOS',                                // Product Name
          Family = 'amicarAssistance',                                            // Product Family
          ProductCode = '1017',                                                     // Product Code
          IsActive = true,                                                        // Active
          Identificador__c = 'GARANTIA MECANICA >5 AÑOS 1017 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'FAMILIA PROTEGIDA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1016',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'FAMILIA PROTEGIDA 1016 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        //PARA CUBRIR TEST DE SERVICIO PUT
        OpportunityLineItem sobj = new OpportunityLineItem(
          OpportunityId = opp.Id,// Opportunity
          Product2Id = prod2.Id,     // Product
          PricebookEntryId = entradaTest.Id,
          //UnitPrice = 3.490,                  // Sales Price
          TotalPrice = 3.490,                 // Total Price
          Quantity = 1,                  // Quantity
          Seleccionado__c = true,            // Seleccionado
          Requerido__c = false,               // Requerido
          Editable__c = false                // Editable
        );
        insert sobj;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1013',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'GARANTIA MECANICA 1013 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA >5 AÑOS',                                // Product Name
          Family = 'amicarAssistance',                                            // Product Family
          ProductCode = '1012',                                                     // Product Code
          IsActive = true,                                                        // Active
          Identificador__c = 'GARANTIA MECANICA >5 AÑOS 1012 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'FAMILIA PROTEGIDA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1011',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'FAMILIA PROTEGIDA 1011 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'PROTECAR',                                // Product Name
          Family = 'amicarAssistance',                        // Product Family
          ProductCode = '1015',                                 // Product Code
          IsActive = true,                                    // Active
          Identificador__c = 'PROTECAR 1015 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1023',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'GARANTIA MECANICA 1023 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA >5 AÑOS',                                // Product Name
          Family = 'amicarAssistance',                                            // Product Family
          ProductCode = '1022',                                                     // Product Code
          IsActive = true,                                                        // Active
          Identificador__c = 'GARANTIA MECANICA >5 AÑOS 1022 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'FAMILIA PROTEGIDA',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1021',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'FAMILIA PROTEGIDA 1021 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'NEUMATICOS',                               // Product Name
          Family = 'amicarAssistance',                         // Product Family
          ProductCode = '10109',                                   // Product Code
          IsActive = true,                                     // Active
          Identificador__c = 'NEUMATICOS 10109 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA >5 AÑOS',                               // Product Name
          Family = 'amicarAssistance',                                           // Product Family
          ProductCode = '10107',                                                     // Product Code
          IsActive = true,                                                       // Active
          Identificador__c = 'GARANTIA MECANICA >5 AÑOS 10107 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'FAMILIA PROTEGIDA',                               // Product Name
          Family = 'amicarAssistance',                                // Product Family
          ProductCode = '10106',                                          // Product Code
          IsActive = true,                                            // Active
          Identificador__c = 'FAMILIA PROTEGIDA 10106 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'NEUMATICOS',                               // Product Name
          Family = 'amicarAssistance',                         // Product Family
          ProductCode = '10104',                                   // Product Code
          IsActive = true,                                     // Active
          Identificador__c = 'NEUMATICOS 10104 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA',                               // Product Name
          Family = 'amicarAssistance',                                // Product Family
          ProductCode = '10103',                                          // Product Code
          IsActive = true,                                            // Active
          Identificador__c = 'GARANTIA MECANICA 10103 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'GARANTIA MECANICA >5 AÑOS',                               // Product Name
          Family = 'amicarAssistance',                                           // Product Family
          ProductCode = '10102',                                                     // Product Code
          IsActive = true,                                                       // Active
          Identificador__c = 'GARANTIA MECANICA >5 AÑOS 10102 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'Protecar',                                // Product Name
          Family = 'amicarAssistance',                        // Product Family
          ProductCode = '1014',                                 // Product Code
          IsActive = true,                                    // Active
          Identificador__c = 'PROTECAR 1014 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'Garantía Mecánica',                               // Product Name
          Family = 'amicarAssistance',                                // Product Family
          ProductCode = '10107',                                          // Product Code
          IsActive = true,                                            // Active
          Identificador__c = 'GARANTIA MECANICA 10107 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'Protecar',                                // Product Name
          Family = 'amicarAssistance',                        // Product Family
          ProductCode = '1024',                                 // Product Code
          IsActive = true,                                    // Active
          Identificador__c = 'PROTECAR 1024 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'Garantía Mecánica',                                // Product Name
          Family = 'amicarAssistance',                                 // Product Family
          ProductCode = '1027',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'GARANTIA MECANICA 1027 amicarAssistance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        prod2 = new Product2(
          Name = 'DESGRAVAMEN',                                // Product Name
          Family = 'financingEntityInsurance',                                 // Product Family
          ProductCode = '1221',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'DESGRAVAMEN 1221 financingEntityInsurance'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        //PARA CUBRIR TEST DE SERVICIO PUT
        sobj = new OpportunityLineItem(
          OpportunityId = opp.Id,// Opportunity
          Product2Id = prod2.Id,     // Product
          PricebookEntryId = entradaTest.Id,
          //UnitPrice = 3.490,                  // Sales Price
          TotalPrice = 3.490,                 // Total Price
          Quantity = 1,                  // Quantity
          Seleccionado__c = true,            // Seleccionado
          Requerido__c = false,               // Requerido
          Editable__c = false                // Editable
        );
        insert sobj;

        prod2 = new Product2(
          Name = 'GASTOS OPERACIONALES',                                // Product Name
          Family = 'dealerInsurances',                                 // Product Family
          ProductCode = '1011',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'GASTOS OPERACIONALES 1011 dealerInsurances'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        sobj = new OpportunityLineItem(
          OpportunityId = opp.Id,// Opportunity
          Product2Id = prod2.Id,     // Product
          PricebookEntryId = entradaTest.Id,
          //UnitPrice = 3.490,                  // Sales Price
          TotalPrice = 3.490,                 // Total Price
          Quantity = 1,                  // Quantity
          Seleccionado__c = true,            // Seleccionado
          Requerido__c = false,               // Requerido
          Editable__c = false                // Editable
        );
        insert sobj;

        prod2 = new Product2(
          Name = 'Inscripción',                                // Product Name
          Family = 'dealerSurcharges',                                 // Product Family
          ProductCode = '10102',                                          // Product Code
          IsActive = true,                                             // Active
          Identificador__c = 'Inscripción 10102 dealerSurcharges'  // Identificador
        );
        insert prod2;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebookIdStd;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        entradaTest = new PricebookEntry();
        entradaTest.Product2Id = prod2.Id;
        entradaTest.Pricebook2Id = pricebook2.Id;
        entradaTest.UnitPrice = 1;
        entradaTest.IsActive = true;
        insert entradaTest;

        sobj = new OpportunityLineItem(
          OpportunityId = opp.Id,// Opportunity
          Product2Id = prod2.Id,     // Product
          PricebookEntryId = entradaTest.Id,
          //UnitPrice = 3.490,                  // Sales Price
          TotalPrice = 3.490,                 // Total Price
          Quantity = 1,                  // Quantity
          Seleccionado__c = true,            // Seleccionado
          Requerido__c = false,               // Requerido
          Editable__c = false                // Editable
        );
        insert sobj;

        Quote cuota = new Quote(
          Name = 'simulacion CONVENTIONAL 48',                        // Quote Name
          OpportunityId = opp.Id,                            // Opportunity Name
          Tipo_de_financiamiento__c = 'CONVENTIONAL',           // Tipo de financiamiento
          Cuotas__c = 48,                                             // Cuotas
          Valor_cuota__c = 269.470,                                     // Valor cuota
          Valor_UF__c = 28.70689,                                       // Valor UF
          CAE__c = 2594,                                                // CAE
          Costo_total_cr_dito__c = 12.934,                              // Costo total crédito
          Tasa__c = 160,                                                // Tasa
          Comisi_n_dealer__c = 472.755,                                 // Comisión dealer
          Saldo_precio__c = 8.000,                                      // Saldo precio
          Total_a_financiar__c = 8.975,                                 // Total a financiar
          Interes_por_desfase__c = 4.787,                               // Interes por desfase
          Capital_final__c = 8.980,                                     // Capital final
          Tipo_de_tasa2__c = 'CONVENTIONAL_COMMERCIAL_NORMAL',
          Fecha_creacion__c = Datetime.valueOf('2020-09-29 12:05:00')  // Fecha creación
        );
        insert cuota;

        Remate__c remate = new Remate__c(
          Id_remate__c = '10000431-782',   // Id remate
          Solicitud__c = opp.Id,  // Solicitud
          Orden__c = 1,                    // Orden
          Entidad_Financiera__c = '966675608',  // Entidad Financiera
          Estado__c = 'WINNER',            // Estado
          Ganadora__c = true                // Ganadora
        );
        insert remate;
    }

    static testmethod void test1(){
        Test.startTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        List<String> idList = new List<String>();
        idList.add(oppList.get(0).Id);
        AMICAR_GetProductosChecklist.InvocaServicioGet(idList);
        AMICAR_GetProductosInsuranceChecklist.InvocaServicioInsuranceGet(idList);
        //SE INVOCA CLASE DEL SERVICIO PUT 
        List<OpportunityLineItem> OLI = [SELECT Id 
                                         FROM OpportunityLineItem
                                         WHERE OpportunityId =: oppList.get(0).Id];
        idList = new List<String>();
        idList.add(OLI.get(0).Id);
        
        AMICAR_EnviaProductosChecklist.InvocaServicioPut(idList);

        List<AMICAR_PutProductosChecklistBody.FlowInputs> flowInputs = new List<AMICAR_PutProductosChecklistBody.FlowInputs>();
        AMICAR_PutProductosChecklistBody.FlowInputs fi = new AMICAR_PutProductosChecklistBody.FlowInputs();
        fi.oppli = OLI.get(0);
        fi.remate = null;
        fi.seleccionado = false;
        fi.familiaUpd = 'amicarAssistance';
        flowInputs.add(fi);
        AMICAR_PutProductosChecklistBody.InvocaServicioPutBody(flowInputs);

        String familia = 'financingEntityInsurance';
        List<OpportunityLineItem> productosInsurance = [SELECT Id, OpportunityId, 
                                                    ProductCode, Seleccionado__c, 
                                                    Value__c 
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId =: oppList.get(0).Id
                                                    AND Product2.Family =: familia];
        
        delete productosInsurance;
        fi = new AMICAR_PutProductosChecklistBody.FlowInputs();
        fi.oppli = OLI.get(0);
        fi.remate = null;
        fi.seleccionado = false;
        fi.familiaUpd = 'financingEntityInsurance';
        flowInputs.add(fi);
        AMICAR_PutProductosChecklistBody.InvocaServicioPutBody(flowInputs);

        
        Opportunity op = [SELECT Id FROM Opportunity WHERE Id =: oppList.get(0).Id];
        op.Id_Solicitud__c = 'Test3';
        update op;
        idList = new List<String>();
        idList.add(op.Id);
        AMICAR_GetProductosChecklist.InvocaServicioGet(idList);

        op.Id_Solicitud__c = 'Test 2';
        update op;
        idList = new List<String>();
        idList.add(op.Id);
        AMICAR_GetProductosChecklist.InvocaServicioGet(idList);
        AMICAR_GetProductosInsuranceChecklist.InvocaServicioInsuranceGet(idList);

        List<Quote> cuota = [SELECT Id FROM Quote WHERE OpportunityId =: oppList.get(0).Id];
        op.SyncedQuoteId = cuota.get(0).Id;
        update op;

        AMICAR_PutProductosChecklistNoBody.InvocaServicioPutNoBody(idList);

        List<Remate__c> remate = [SELECT Entidad_Financiera__c , Estado__c, 
                                  Solicitud__r.Id_Solicitud__c, Solicitud__c, 
                                  Solicitud__r.OwnerId, Solicitud__r.Owner.RUT_F_I__c
                                  FROM Remate__c
                                  WHERE Solicitud__c =: oppList.get(0).Id];
        
        remate.get(0).Estado__c = 'APPROVED';
        update remate;

        PageReference pref1 = Page.AMICAR_AsignacionManual;
        Test.setCurrentPage(pref1);
        //pref1.getParameters()
        ApexPages.StandardSetController sSc = new ApexPages.StandardSetController(remate);
        sSc.setSelected(remate);
        AMICAR_AsignacionManualController testC = new AMICAR_AsignacionManualController(sSc); 
        System.debug('sSc'+sSc);
        System.debug('testC'+testC);
        //testC.remates = remate.get(0);
        //testC.postGanadora();
        
        System.debug(remate);
        testC.remates = remate.get(0);
        testC.postGanadora();

        testC.remates = null;
        testC.postGanadora();

        PageReference pref = Page.AMICAR_CartaAdjudicacion;
        Test.setCurrentPage(pref);
        pref.getParameters().put('id', String.valueOf(oppList.get(0).Id));

        AMICAR_CartaAdjudicacionController testCarta;
        testCarta = new AMICAR_CartaAdjudicacionController(); 
        testCarta.cargaDatos();
        
        Test.stopTest();
    }

    static testmethod void test2(){
        Test.startTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];

        AMICAR_EnviaAdjudicacionController testC;
        ApexPages.StandardController sc = new ApexPages.StandardController(oppList.get(0));
        testC = new AMICAR_EnviaAdjudicacionController(sc); 
        testC.putAdjudicacion();

        List<String> idList = new List<String>();
        idList.add(oppList.get(0).Id);      
        AMICAR_EliminaProductosOportunidad.AMICAR_EliminaProductosOportunidad(idList);

        Test.stopTest();
    }

    static testmethod void test3(){
        Test.startTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        //List<Pricebook2> pricebook2 = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' AND IsActive = true];
        Quote cuota2 = new Quote(
          Name = 'simulacion CONVENTIONAL 36',                       // Quote Name
          OpportunityId = oppList.get(0).Id,                            // Opportunity Name
          Tipo_de_financiamiento__c = 'CONVENTIONAL',           // Tipo de financiamiento
          Cuotas__c = 48,                                             // Cuotas
          Valor_cuota__c = 269.470,                                     // Valor cuota
          Valor_UF__c = 28.70689,                                       // Valor UF
          CAE__c = 2594,                                                // CAE
          Costo_total_cr_dito__c = 12.934,                              // Costo total crédito
          Tasa__c = 160,                                                // Tasa
          Comisi_n_dealer__c = 472.755,                                 // Comisión dealer
          Saldo_precio__c = 8.000,                                      // Saldo precio
          Total_a_financiar__c = 8.975,                                 // Total a financiar
          Interes_por_desfase__c = 4.787,                               // Interes por desfase
          Capital_final__c = 8.980,                                     // Capital final
          Tipo_de_tasa2__c = 'CONVENTIONAL_COMMERCIAL_NORMAL',                     // Tipo de Tasa
          Fecha_creacion__c = Datetime.valueOf('2020-09-29 12:05:00'),  // Fecha creación
          Pricebook2Id = Test.getStandardPricebookId(),
          RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId()
        );
        insert cuota2;

        Desarrollo__c desarrollo1 = new Desarrollo__c(
                                                      Fecha_vencimiento__c = '2020-11-07',
                                                      Modificado__c = false,
                                                      Numero_de_pago__c = 1.0,
                                                      Pago__c = 290493.0,
                                                      Simulacion__c = cuota2.Id,
                                                      Solicitud__c = oppList.get(0).Id);
        insert desarrollo1;

        //oppList.get(0).StageName = 'Formalización';
        oppList.get(0).Formalizacion_OK__c = false;
        oppList.get(0).SyncedQuoteId = cuota2.Id;
        update oppList;

        desarrollo1.Numero_de_pago__c = 2;
        desarrollo1.Fecha_vencimiento__c = '2020-11-08';
        update desarrollo1;

        List<Desarrollo__c> listadoDesarrollos = [SELECT Id, Pago__c, 
                                                  Simulacion__c 
                                                  FROM Desarrollo__c 
                                                  WHERE Solicitud__c =: oppList.get(0).Id];

        AMICAR_MultipleEditDesarrollosController testC;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(listadoDesarrollos.get(0));
        testC = new AMICAR_MultipleEditDesarrollosController(sc); 

        ApexPages.StandardSetController sSc = new ApexPages.StandardSetController(listadoDesarrollos);
        testC = new AMICAR_MultipleEditDesarrollosController(sSc);
        
        testC.idsSeleccionados.add(listadoDesarrollos.get(0).ID);
        testC.guardaMontoNuevo();

        PageReference pref = Page.AMICAR_ProcesaCarta;
        Test.setCurrentPage(pref);
        pref.getParameters().put('id', String.valueOf(oppList.get(0).Id));

        AMICAR_ProcesaCartaController testPCarta;
		sc = new ApexPages.StandardController(oppList.get(0));
		testPCarta = new AMICAR_ProcesaCartaController(sc); 
        testPCarta.procesaCarta();

        List<String> idList = new List<String>();
        idList.add(oppList.get(0).Id);  
        AMICAR_ObtieneSimulacionesRenovacion.ObtieneSimulacionesRenovacion(idList);

        AMICAR_EnviaSimulacionSincronizada.EnviaSincronizada(idList);
        AMICAR_EnviaSimulSincroModRemateFin.EnviaFormalizada(idList);
        Test.stopTest();
    }

    static testmethod void test4(){
        Test.startTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];

        Quote cuota2 = new Quote(
          Name = 'simulacion CONVENTIONAL 36',                       // Quote Name
          OpportunityId = oppList.get(0).Id,                            // Opportunity Name
          Tipo_de_financiamiento__c = 'CONVENTIONAL',           // Tipo de financiamiento
          Cuotas__c = 48,                                             // Cuotas
          Valor_cuota__c = 269.470,                                     // Valor cuota
          Valor_UF__c = 28.70689,                                       // Valor UF
          CAE__c = 2594,                                                // CAE
          Costo_total_cr_dito__c = 12.934,                              // Costo total crédito
          Tasa__c = 160,                                                // Tasa
          Comisi_n_dealer__c = 472.755,                                 // Comisión dealer
          Saldo_precio__c = 8.000,                                      // Saldo precio
          Total_a_financiar__c = 8.975,                                 // Total a financiar
          Interes_por_desfase__c = 4.787,                               // Interes por desfase
          Capital_final__c = 8.980,                                     // Capital final
          Tipo_de_tasa2__c = 'CONVENTIONAL_COMMERCIAL_NORMAL',                     // Tipo de Tasa
          Fecha_creacion__c = Datetime.valueOf('2020-09-29 12:05:00'),  // Fecha creación
          RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Simulación CORE').getRecordTypeId()
        );
        insert cuota2;

        Desarrollo__c desarrollo1 = new Desarrollo__c(
                                                      Fecha_vencimiento__c = '2020-11-07',
                                                      Modificado__c = false,
                                                      Numero_de_pago__c = 1.0,
                                                      Pago__c = 290493.0,
                                                      Simulacion__c = cuota2.Id,
                                                      Solicitud__c = oppList.get(0).Id);
        insert desarrollo1;

        oppList.get(0).Name = '15539757-8  RENAULT - SALTAR CUOTA';
        update oppList;
        
        List<Desarrollo__c> listadoDesarrollos = [SELECT Id, Pago__c, 
                                                  Simulacion__c 
                                                  FROM Desarrollo__c 
                                                  WHERE Solicitud__c =: oppList.get(0).Id];
        List<String> idList = new List<String>();
        idList.add(listadoDesarrollos.get(0).Id);   
        AMICAR_ActualizaDesarrolloSincronizado.ObtieneDesarrollosSincronizados(idList);
        idList = new List<String>();
        idList.add(oppList.get(0).Id);  
        AMICAR_EnviaSimulSincronizadaModificada.EnviaFormalizada(idList);
        AMICAR_EnviaSimulacionSincronizada.EnviaSincronizada(idList);
        AMICAR_EnviaSimulSincroModRemateFin.EnviaFormalizada(idList);
        Test.stopTest();
    }

    static testmethod void test5(){
        Test.startTest();
        Test.stopTest();
    }
}