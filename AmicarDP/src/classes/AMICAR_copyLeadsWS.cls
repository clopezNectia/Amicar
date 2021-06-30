/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Esteban Flores (EF)
Proyecto: Amicar
Descripción: Clase controladora para copia de Leads por integracion
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 02-02-2020            EF                   Creación de la Clase.
***********************************************************************************/
public class AMICAR_copyLeadsWS{
    public AMICAR_copyLeadsWS(Id iLead){
        Lead myLead = [SELECT Id, transactionId__c, channel__c, engine__c, evaluationResult__c, transactionDate__c, 
                    transactionTime__c, rut__c, FirstName, lastName, motherLastName__c, income__c, Email, 
                    carPrice__c, downPayment__c, vehicleType__c, workType__c, carBrandId__c, carBrandDescription__c, 
                    carModelId__c, carModelDescription__c, carVersion__c, monthlyPayment__c, tripletId__c, carYear__c, 
                    loanSetting__c, channelId__c, salesChannel__c, Locales__c, Company, monthsWorked__c, termDescription__c, 
                    productCode__c, loanType__c, downPaymentPercentage__c, terms__c, status, status__c, MobilePhone, Phone, workPhone__c
                 FROM Lead
                 WHERE Id =: iLead];
    }

    @InvocableMethod(label='Copiar Lead' description='Copia Leads en base de datos replica')
    public static List<String> CopiaLeads (List<String> iLead) {
        Lead lead = [SELECT Id, transactionId__c, channel__c, engine__c, evaluationResult__c, transactionDate__c, 
                    transactionTime__c, rut__c, FirstName, lastName, motherLastName__c, income__c, Email,
                    carPrice__c, downPayment__c, vehicleType__c, workType__c, carBrandId__c, carBrandDescription__c, 
                    carModelId__c, carModelDescription__c, carVersion__c, monthlyPayment__c, tripletId__c, carYear__c, 
                    loanSetting__c, channelId__c, salesChannel__c, Locales__c, Company, monthsWorked__c, termDescription__c, 
                    productCode__c, loanType__c, downPaymentPercentage__c, terms__c, status, status__c, MobilePhone, Phone, workPhone__c
                 FROM Lead
                 WHERE Id =: iLead];
        String json = AMICAR_copyLeadsWS.loadRequest(lead);
        callService(json, lead.Id);
        return null;
    }

    @future(callout=true)
    static void callService(String json, String idLead){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        //Para chequear si es sandbox o productivo
        Organization ox = [SELECT Id, IsSandbox FROM Organization LIMIT 1];
        String endP = '';
        try{
            //Obtener endpoint de metadata
            endP = [SELECT URL__c
                    FROM AMICAR_Integracion__mdt
                    WHERE MasterLabel = 'Leads'].URL__c;
            request.setEndpoint(endP+'?IdSended='+idLead);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(json);
            System.debug(json);
            if (!Test.IsRunningTest()){
                Http http = new Http();
                response = http.send(request);
            }else{
                String falseJson = AMICAR_CopyLeadsWSJSON.testJSON();
                response.setBody(falseJson);
            }
            System.debug('Body de respuesta: '+response.getBody());
        }catch(Exception e){
            System.debug('Tipo de excepción: ' + e.getTypeName());
            System.debug('Mensaje: ' + e.getMessage());
            System.debug('Causa: ' + e.getCause());
            System.debug('Línea: ' + e.getLineNumber());
            System.debug('Traza: ' + e.getStackTraceString());
        }
    }

    public static String loadRequest(Lead myLead){
        /* Llenar datos con información del lead */
        AMICAR_CopyLeadsWSJSON objToJSON = new AMICAR_CopyLeadsWSJSON();
        objToJSON.idTransaccion = myLead.transactionId__c != null?myLead.transactionId__c:'';
        objToJSON.Contador = '1';
        objToJSON.nombreCanal = myLead.channel__c != null?myLead.channel__c:'';
        objToJSON.nombreMotor = myLead.engine__c != null?myLead.engine__c:'';
        objToJSON.nombreOperaciones = '';
        objToJSON.respuestaAPI = myLead.evaluationResult__c != null?myLead.evaluationResult__c:'';
        if(myLead.transactionDate__c != null){
            String fecha = String.valueOf(myLead.transactionDate__c.year())+'-';
            if(myLead.transactionDate__c.month() < 10){
                fecha = fecha + '0'+String.valueOf(myLead.transactionDate__c.month())+'-';
            }else{
                fecha = fecha + String.valueOf(myLead.transactionDate__c.month())+'-';
            }
            if(myLead.transactionDate__c.day() < 10){
                fecha = fecha + '0'+String.valueOf(myLead.transactionDate__c.day());
            }else{
                fecha = fecha + String.valueOf(myLead.transactionDate__c.day());
            }
            objToJSON.FechaTransaccion = fecha;
        }else{
            objToJSON.FechaTransaccion = null;
        }
        if(myLead.transactionTime__c != null){
            String hora = String.valueOf(myLead.transactionTime__c.hour())+':'+String.valueOf(myLead.transactionTime__c.minute())+':'+String.valueOf(myLead.transactionTime__c.second());
            System.debug('Hora');
            System.debug(myLead.transactionTime__c);
            //objToJSON.HoraTransaccion = hora[0];
            objToJSON.HoraTransaccion = hora;
        }else{
            System.debug('Sin hora');
            objToJSON.HoraTransaccion = '00:00:00';
        }
        objToJSON.rut = myLead.rut__c != null?myLead.rut__c:'';
        objToJSON.nombre = myLead.FirstName != null?myLead.FirstName:'';
        objToJSON.apellidoPaterno = myLead.lastName != null?myLead.lastName:'';
        objToJSON.apellidoMaterno = myLead.motherLastName__c != null?myLead.motherLastName__c:'';
        objToJSON.rentaLiquida = myLead.income__c != null?String.valueOf(myLead.income__c):'0';
        objToJSON.email = myLead.Email != null?myLead.Email:'';
        if(myLead.MobilePhone != null){
            objToJSON.telefono = myLead.MobilePhone;
        }else if(myLead.Phone != null){
            objToJSON.telefono = myLead.Phone;
        }else if(myLead.workPhone__c != null){
            objToJSON.telefono = myLead.workPhone__c;
        }
        objToJSON.valorVehiculo = myLead.carPrice__c != null?String.valueOf(myLead.carPrice__c):'0';
        objToJSON.montoPie = myLead.downPayment__c != null?String.valueOf(myLead.downPayment__c):'0';
        objToJSON.tipoVehiculo = myLead.vehicleType__c != null?myLead.vehicleType__c:'';
        objToJSON.situacionLaboral = myLead.workType__c != null?myLead.workType__c:'';
        objToJSON.marcaVehiculo = myLead.carBrandId__c != null?String.valueOf(myLead.carBrandId__c):'0';
        objToJSON.marcaVehiculoNombre = myLead.carBrandDescription__c != null?myLead.carBrandDescription__c:'';
        objToJSON.modelo = myLead.carModelId__c != null?String.valueOf(myLead.carModelId__c):'0';
        objToJSON.modeloNombre = myLead.carModelDescription__c != null?myLead.carModelDescription__c:'';
        objToJSON.version = myLead.carVersion__c != null?myLead.carVersion__c:'';
        objToJSON.valorCuota = myLead.monthlyPayment__c != null?String.valueOf(myLead.monthlyPayment__c):'0';
        objToJSON.idTripleta = myLead.tripletId__c != null?myLead.tripletId__c:'0';
        objToJSON.anioVehiculo = myLead.carYear__c != null?myLead.carYear__c:null;
        objToJSON.escenario_interes = myLead.loanSetting__c != null?myLead.loanSetting__c:'0';
        objToJSON.Canal = myLead.channelId__c != null?myLead.channelId__c:'';
        objToJSON.concesionario = myLead.salesChannel__c != null?myLead.salesChannel__c:'';
        objToJSON.local = myLead.Locales__c != null?myLead.Locales__c:'';
        objToJSON.nombreEmpresa = myLead.Company != null?myLead.Company:'';
        objToJSON.antiguedadLaboral = myLead.monthsWorked__c != null?String.valueOf(myLead.monthsWorked__c):'0';
        objToJSON.plazoCredito = myLead.termDescription__c != null?myLead.termDescription__c:'';
        objToJSON.codigoProducto = myLead.productCode__c != null?myLead.productCode__c:'';
        objToJSON.tipoCredito = myLead.loanType__c != null?myLead.loanType__c:'';
        objToJSON.porcentaje = myLead.downPaymentPercentage__c != null?String.valueOf(myLead.downPaymentPercentage__c):'0';
        objToJSON.meses = myLead.terms__c != null?myLead.terms__c:'';
        objToJSON.fuente = '';
        objToJSON.estado = myLead.status;
        objToJSON.sub_estado = myLead.status__c;
        objToJSON.id = myLead.Id;
        return JSON.serialize(objToJSON);
    }
}