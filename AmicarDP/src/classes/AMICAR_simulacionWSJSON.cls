public class AMICAR_simulacionWSJSON{
    public String transactionId;    //A-10382
    public cls_customer customer;
    public cls_vehicle vehicle;
    public cls_loan loan;
    public class cls_customer {
        public String rut;  //247426507 requerido
        public String name; //Roberto
        public String fatherLastName;   //O'Higgins
        public String motherLastName;   //De la Cerda
        public String email;    //email@domain.com.co requerido
        public String phone;    //+56977665544
        public String address;  //Colon 125, San Bernardo, Región Metropolitana
        public String state;    //Metropolitana
        public String province; //Maipo
        public String city; //San Bernardo
        public String gender;   //MALE
        public String nationality;  //Chileno
        public String profession;   //Médico
        public String workType; //HIRED
        public String companyName;  //Saysa Ltda
        public String companyPosition;  //Medico
        public Integer income;  //3000000
        public Integer monthsWorked;    //18
        public String dob;  //1983-04-11
        public String workAddress;  //Las condes 11000, Vitacura, Región Metropolitana
        public String maritalStatus;    //SINGLE
        public String academicLevel;    //POST_GRADUATE
        public String livingHousehold;  //OWNER
    }
    public class cls_vehicle {
        public String type; //USED_PERSONAL requerido
        public String brandName;    //KIA
        public String modelName;    //MORNING
        public String version;  //EX 1.2 5MT FULL
        public Integer year;    //2020
        public Integer price;   //10000000 requerido
    }
    public class cls_loan {
        public Integer downPayment; //3000000 requerido
        public Integer downPaymentPercentage;   //30 requerido
        public String type; //CONVENTIONAL
        public Integer term;    //24 requerido
        public Integer balance; //7000000
        public String startDate;    //2020-01-02 requerido
        public String firstDueDate; //2020-02-02 requerido
        public String rateType; //NORMAL requerido
        public String saleChannel;  //829957000 requerido
        public String saleChannelType;  //IMPORTADOR
        public Integer salesRoomId; //1 requerido
        public boolean immediateOption; //requerido
        public Integer accessories; //0 requerido
        public Integer tradeInCarValue; //0 requerido
        public cls_modifyTerm[] modifyTerm;
    }
    class cls_modifyTerm {
    }
    public static AMICAR_simulacionWSJSON parse(String json){
        return (AMICAR_simulacionWSJSON) System.JSON.deserialize(json, AMICAR_simulacionWSJSON.class);
    }
/*
    static testMethod void testParse() {
        String json=        '{'+
        '    "transactionId": "A-10382",'+
        '    "customer": {'+
        '        "rut": "247426507",'+
        '        "name": "Roberto",'+
        '        "fatherLastName": "O'Higgins",'+
        '        "motherLastName": "De la Cerda",'+
        '        "email": "email@domain.com.co",'+
        '        "phone": "+56977665544",'+
        '        "address": "Colon 125, San Bernardo, Región Metropolitana",'+
        '        "state": "Metropolitana",'+
        '        "province": "Maipo",'+
        '        "city": "San Bernardo",'+
        '        "gender": "MALE",'+
        '        "nationality": "Chileno",'+
        '        "profession": "Médico",'+
        '        "workType": "HIRED",'+
        '        "companyName": "Saysa Ltda",'+
        '        "companyPosition": "Medico",'+
        '        "income": 3000000,'+
        '        "monthsWorked": 18,'+
        '        "dob": "1983-04-11",'+
        '        "workAddress": "Las condes 11000, Vitacura, Región Metropolitana",'+
        '        "maritalStatus": "SINGLE",'+
        '        "academicLevel": "POST_GRADUATE",'+
        '        "livingHousehold": "OWNER"'+
        '    },'+
        '    "vehicle": {'+
        '        "type": "USED_PERSONAL",'+
        '        "brandName": "KIA",'+
        '        "modelName": "MORNING",'+
        '        "version": "EX 1.2 5MT FULL",'+
        '        "year": 2020,'+
        '        "price": 10000000'+
        '    },'+
        '    "loan": {'+
        '        "downPayment": 3000000,'+
        '        "downPaymentPercentage": 30,'+
        '        "type": "CONVENTIONAL",'+
        '        "term": 24,'+
        '        "balance": 7000000,'+
        '        "startDate": "2020-01-02",'+
        '        "firstDueDate": "2020-02-02",'+
        '        "rateType": "NORMAL",'+
        '        "saleChannel": "829957000",'+
        '        "saleChannelType": "IMPORTADOR",'+
        '        "salesRoomId": 1,'+
        '        "immediateOption": false,'+
        '        "accessories": 0,'+
        '        "tradeInCarValue": 0,'+
        '        "modifyTerm": []'+
        '    }'+
        '}';
        AMICAR_simulacionJSON obj = parse(json);
        System.assert(obj != null);
    }
*/
}