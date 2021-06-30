/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Modelo para llevar las consultas SOQL como operaciones DML de ServicioRestOpportunityWS
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 25-03-2021            RL                       Creación de la Clase.
1.1 11-05-2021            RL                       Se cambia método de búsqueda de vehículos a método anterior
***********************************************************************************/

public class AMICAR_ServicioRestOpportunityWS_SOQL  {
    
    public AMICAR_ServicioRestOpportunityWS_SOQL (){
    }

    public User getPropietario(String rut){
        try{
            User propietario = [SELECT Id, Name, 
                                RUT_F_I__c 
                                FROM User 
                                WHERE RUT_F_I__c  =: rut];
            return propietario;
        }catch(Exception ex){
            System.debug('ERROR AL LLAMAR A LA SOQL PROPIETARIO ('+rut+')');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            return null;
        }
    } 

    public List<Account> getCuentas(Set<String> rutCuentas){
        try{
            List<Account> cuentas = [SELECT Id, RUT__c, RUT__pc 
                                     FROM Account
                                     WHERE RUT__c in : rutCuentas];
            //List<Account> cuentas = Database.query('SELECT Id, RUT__c, RUT__pc FROM Account');
            return cuentas;
        }catch(Exception ex){
            return null;
        }
    }

    public List<Account> insertarCuentas(List<Account> accLst){
        insert accLst;
        return accLst;
    }

    public Modelo_de_vehiculo__c getVehiculo(String marcaVehiculo, String codigoVehiculo){
        System.debug('SELECT Id, Marca_Busqueda__r.Codigo_Marca__c, Modelo__c, Codigo_modelo__c FROM Modelo_de_vehiculo__c WHERE Marca_Busqueda__r.Codigo_Marca__c = '+marcaVehiculo+' AND Codigo_modelo__c = '+codigoVehiculo);
        try{
            //Modelo_de_vehiculo__c modelo = [SELECT Id, Marca_Busqueda__r.Codigo_Marca__c, 
                                            //Modelo__c, Codigo_modelo__c
                                            //FROM Modelo_de_vehiculo__c 
                                            //WHERE Marca_Busqueda__r.Codigo_Marca__c =: marcaVehiculo
                                            //WHERE Marca
                                            //AND Codigo_modelo__c =: codigoVehiculo];
            Modelo_de_vehiculo__c modelo = [SELECT Id, Marca__c, 
                                            Modelo__c, Codigo_modelo__c
                                            FROM Modelo_de_vehiculo__c 
                                            WHERE Marca__c =: marcaVehiculo
                                            AND Codigo_modelo__c =: codigoVehiculo];
            return modelo;
        }catch(Exception ex){
            System.debug('ERROR AL LLAMAR A LA SOQL');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            return null;
        }
    }

    public Vendedor__c getVendedor(String rutVendedor){
        try{
            Vendedor__c vendedor = [SELECT Id, Name, 
                                    Local__c, RUT__c 
                                    FROM Vendedor__c 
                                    WHERE RUT__c =: rutVendedor];
            return vendedor;
        }catch(Exception ex){
            System.debug('ERROR AL CONSULTAR POR EL VENDEDOR '+rutVendedor);
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            return null;
        }
    }

    public Local__c getLocal(String codigoLocal){
        try{
            Local__c local = [SELECT Id, OwnerId, 
                              Name, CreatedById, 
                              LastModifiedById, Codigo_Local__c, 
                              Concesionario__c, Importador__c 
                              FROM Local__c 
                              WHERE Codigo_Local__c =: codigoLocal];
            return local;
        }catch(Exception ex){
            System.debug('ERROR AL CONSULTAR POR EL LOCAL '+codigoLocal);
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            return null;
        }
    }

    public Opportunity upsertOpportunity(Opportunity opp){
        upsert  opp  Opportunity.Fields.Id_Solicitud__c;
        return opp;
    }

    public Opportunity updateOpportunity(Opportunity opp){
        update opp;
        return opp;
    }

    public List<Impuesto__c> getImpuestosOpportunity(String idOpp){
        List<Impuesto__c> listImpuesto = [SELECT Id 
                                          FROM Impuesto__c 
                                          WHERE Solicitud__c =: idOpp];
        return listImpuesto;
    }

    public void insertarImpuestos(List<Impuesto__c> impToAdd){
        insert impToAdd;
    }

    public void eliminarImpuestos(List<Impuesto__c> impList){
        delete impList;
    }

    public List<Relacion__c> getRelacionesOportunidad(String idOpp){
        List<Relacion__c> relList = [SELECT Id 
                                     FROM Relacion__c 
                                     WHERE Solicitud__c =: idOpp];
        return relList;
    }

    public void insertarRelacionesOportunidad(List<Relacion__c> relToAdd){
        upsert relToAdd;
    }

    public void eliminarRelacionesOportunidad(List<Relacion__c> relList){
        delete relList;
    }

    public List<Quote> getQuotesOportunidad(String idOpp){
        List<Quote> quoteList = [SELECT Id 
                                 FROM Quote 
                                 WHERE OpportunityId =: idOpp];
        return quoteList;
    }

    public void eliminarQuotesOportunidad(List<Quote> quoteList){
        delete quoteList;
    }

    public Quote insertarQuoteOportunidad(Quote q){
        upsert q;
        return q;
    }

    public Pricebook2 getListaStandardPrecio(){
        Pricebook2 pb2 = [SELECT Id 
                          FROM Pricebook2 
                          WHERE Name =: 'Standard Price Book'
                          AND IsActive = true];
        return pb2;
    }

    public List<Product2> getListaProductos(){
        List<Product2> prod2List = [SELECT Identificador__c, Id,
                                    Family 
                                    FROM Product2 
                                    WHERE IsActive = true 
                                    AND (
                                        Family = 'amicarAssistance' 
                                        OR Family = 'dealerSurcharges' 
                                        OR Family = 'financingEntityInsurance' 
                                        OR Family = 'dealerInsurance' 
                                        OR Family = 'financingEntitySurcharges'
                                        )];
        return prod2List;
    }

    public List<PricebookEntry> getListaEntradas(){
        List<PricebookEntry> listaEntrada = [SELECT Id, Product2Id 
                                             FROM PricebookEntry 
                                             WHERE IsActive = true 
                                             AND (
                                                 Product2.Family = 'amicarAssistance' 
                                                 OR Product2.Family = 'dealerSurcharges' 
                                                 OR Product2.Family = 'financingEntityInsurance' 
                                                 OR Product2.Family = 'dealerInsurance' 
                                                 OR Product2.Family = 'financingEntitySurcharges'
                                                 )];
        return listaEntrada;
    }

    public void checkProductsAndPricebookentries( AMICAR_OpportunityJSON2 jsonR){
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
            
            List<Product2> prod2List = [SELECT Identificador__c,Id,
                                        Family 
                                        FROM Product2 
                                        WHERE IsActive = true 
                                        AND Family IN : familias];
            List<PricebookEntry> pricebookList = [SELECT Id,Product2Id 
                                                  FROM PricebookEntry 
                                                  WHERE IsActive = true 
                                                  AND Product2.Family IN : familias];
        
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
            for(AMICAR_OpportunityJSON2.SurchargesAndInsurances prod : jsonR.surchargesAndInsurances){
                if(prod.type == 'amicarAssistance'){
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
            }

            //revisar si no existen productos financingEntityInsurance
            for(AMICAR_OpportunityJSON2.SurchargesAndInsurances prod : jsonR.surchargesAndInsurances){
                if(prod.type == 'financingEntityInsurance'){
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
            }

            //revisar si no existen productos dealerSurcharges
            for(AMICAR_OpportunityJSON2.SurchargesAndInsurances prod : jsonR.surchargesAndInsurances){
                if(prod.type == 'dealerSurcharges'){
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
            }

            //revisar si no existen productos financingEntitySurcharges
            for(AMICAR_OpportunityJSON2.SurchargesAndInsurances prod : jsonR.surchargesAndInsurances){
                if(prod.type == 'financingEntitySurcharges'){
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
            }

            //revisar si no existen productos dealerInsurance
            //for(AMICAR_sincromodificadaWSJSON.DealerInsurance prod : jsonR.dealerInsurance){
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
                //if(!Test.isRunningTest()){
                    System.debug(prodToAdd);
                    insert prodToAdd;
                    //for(Product2 prod2 : prodToAdd){
                        //String clave = prod2.Name + ' ' + prod2.ProductCode + ' ' + prod2.Family;
                        //mapProducts.put(clave, prod2.Id);
                    //}
                    prod2List = [SELECT Identificador__c,Id,
                                 Family 
                                 FROM Product2 
                                 WHERE IsActive = true 
                                 AND Family IN : familias];
                    
                    for(Product2 prod2 : prod2List){
                        mapProducts.put(prod2.Identificador__c, prod2.Id);
                    }
                //}
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
                    //if(Test.isRunningTest()){
                        //price.UseStandardPrice = false;
                    //}
                    System.debug(price);
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
                //if(!Test.isRunningTest()){
                    insert priceToAdd;
                //}
            }
        }catch(Exception ex){
            System.debug('ERROR INSERT PRODUCTOS/PRICEBOOK');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
    }

    public void insertarQuoteLineItem(List<QuoteLineItem> listaQuoteLineItems){
        upsert listaQuoteLineItems;
    }

    public List<Patrimonio__c> getListaPatrimonios(String idOpp){
        List<Patrimonio__c> listaPatrimonios = [SELECT Id 
                                                FROM Patrimonio__c 
                                                WHERE Solicitud__c =: idOpp];
        return listaPatrimonios;
    }

    public void eliminarPatrimonios(List<Patrimonio__c> patToDelete){
        delete patToDelete;
    }

    public void insertarPatrimonios(List<Patrimonio__c> patToAdd){
        upsert patToAdd;
    }

    public List<Desarrollo__c> getListaDesarrollos(String idOpp){
        List<Desarrollo__c> listaDesarrollos = [SELECT Id 
                                                FROM Desarrollo__c 
                                                WHERE Solicitud__c =: idOpp];
        return listaDesarrollos;
    }

    public void eliminarDesarrollos(List<Desarrollo__c> desarrolloToDelete){
        delete desarrolloToDelete;
    }

    public void insertarDesarrollos(List<Desarrollo__c> desarrolloToAdd){
        upsert desarrolloToAdd;
    }

    public Map<String, String> getMapMarcaVehiculo(){
        Map<String,String> mapMarcas = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Marca_vehiculo__c.getDescribe();
        List<Schema.PicklistEntry> valorPicklist = fieldResult.getPicklistValues();
            
        for(Schema.PicklistEntry pickVal : valorPicklist){
            if(pickVal.isActive()){
                mapMarcas.put(pickVal.getLabel(), pickVal.getValue());
            }
        }
        return mapMarcas;
    }

    public Map<String, String> getMapMarcaRetoma(){
        Map<String,String> mapMarcas = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Marca_vehiculo__c.getDescribe();
        List<Schema.PicklistEntry> valorPicklist = fieldResult.getPicklistValues();
            
        for(Schema.PicklistEntry pickVal : valorPicklist){
            if(pickVal.isActive()){
                mapMarcas.put(pickVal.getLabel(), pickVal.getValue());
            }
        }
        return mapMarcas;
    }

    public Map<String, String> getMapTipoVehiculo(){
        Map<String,String> mapTipoVehiculo = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Tipo_de_Veh_culo__c.getDescribe();
        List<Schema.PicklistEntry> valorPicklist = fieldResult.getPicklistValues();
            
        for(Schema.PicklistEntry pickVal : valorPicklist){
            if(pickVal.isActive()){
                mapTipoVehiculo.put(pickVal.getValue(),pickVal.getValue());
            }
        }
        return mapTipoVehiculo;
    }

    public Map<String, String> getMapTipoVehiculoRetoma(){
        Map<String,String> mapTipoVehiculoRetoma = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Tipo_retoma__c.getDescribe();
        List<Schema.PicklistEntry> valorPicklist = fieldResult.getPicklistValues();
            
        for(Schema.PicklistEntry pickVal : valorPicklist){
            if(pickVal.isActive()){
                mapTipoVehiculoRetoma.put(pickVal.getValue(),pickVal.getValue());
            }
        }
        return mapTipoVehiculoRetoma;
    }
}