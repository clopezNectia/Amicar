/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Esteban Flores (EF)
Proyecto: Amicar
Descripción: Clase controladora de json para copia de Leads
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 02-02-2020            EF                   Creación de la Clase.
***********************************************************************************/
public class AMICAR_CopyLeadsWSJSON{
    public String idTransaccion;    //46306123
    public String Contador; //1
    public String nombreCanal;  //AUTOPIA
    public String nombreMotor;  //EQUIFAX
    public String nombreOperaciones;    //EQUIFAX
    public String respuestaAPI; //RECHAZA
    public String FechaTransaccion; //2019-12-13
    public String HoraTransaccion;  //10:46:55
    public String rut;  //269614587
    public String nombre;   //Richard
    public String apellidoPaterno;  //Cumana
    public String apellidoMaterno;  //Guerra
    public String rentaLiquida; //450
    public String email;    //richadcumana1971@gmail.com
    public String telefono; //56957327370
    public String valorVehiculo;    //4000000
    public String montoPie; //1600000
    public String tipoVehiculo; //USADO
    public String situacionLaboral; //Sin Informacion
    public String marcaVehiculo;    //135
    public String marcaVehiculoNombre;  //TOYOTA
    public String modelo;   //0
    public String modeloNombre; //
    public String version;  //
    public String valorCuota;   //0
    public String idTripleta;   //
    public String anioVehiculo; //
    public String escenario_interes;    //
    public String Canal;    //37
    public String concesionario;    //
    public String local;    //
    public String nombreEmpresa;    //
    public String antiguedadLaboral;    //0
    public String plazoCredito; //
    public String codigoProducto;   //
    public String tipoCredito;  //
    public String porcentaje;   //0
    public String meses;    //0
    public String fuente;   //KI
    public String estado;   //KI
    public String sub_estado;   //KI
    public String id;   //KI
    public static AMICAR_CopyLeadsWSJSON parse(String json){
        return (AMICAR_CopyLeadsWSJSON) System.JSON.deserialize(json, AMICAR_CopyLeadsWSJSON.class);
    }
    public static String testJSON(){
        String falseJson = '{'+
                    '   "idTransaccion":"46306123",'+
                    '   "Contador":"1",'+
                    '   "nombreCanal":"AUTOPIA",'+
                    '   "nombreMotor":"EQUIFAX",'+
                    '   "nombreOperaciones":"EQUIFAX",'+
                    '   "respuestaAPI":"RECHAZA",'+
                    '   "FechaTransaccion":"2019-12-13",'+
                    '   "HoraTransaccion":"10:46:55",'+
                    '   "rut":"269614587",'+
                    '   "nombre":"Richard",'+
                    '   "apellidoPaterno":"Cumana",'+
                    '   "apellidoMaterno":"Guerra",'+
                    '   "rentaLiquida":"450",'+
                    '   "email":"richadcumana1971@gmail.com",'+
                    '   "telefono":"56957327370",'+
                    '   "valorVehiculo":"4000000",'+
                    '   "montoPie":"1600000",'+
                    '   "tipoVehiculo":"USADO",'+
                    '   "situacionLaboral":"Sin Informacion",'+
                    '   "marcaVehiculo":"135",'+
                    '   "marcaVehiculoNombre":"TOYOTA",'+
                    '   "modelo":"0",'+
                    '   "modeloNombre":"",'+
                    '   "version":"",'+
                    '   "valorCuota":"0",'+
                    '   "idTripleta":"",'+
                    '   "anioVehiculo":"",'+
                    '   "escenario_interes":"",'+
                    '   "Canal":"37",'+
                    '   "concesionario":"",'+
                    '   "local":"",'+
                    '   "nombreEmpresa":"",'+
                    '   "antiguedadLaboral":"0",'+
                    '   "plazoCredito":"",'+
                    '   "codigoProducto":"",'+
                    '   "tipoCredito":"",'+
                    '   "porcentaje":"0",'+
                    '   "meses":"0",'+
                    '   "fuente":"KI",'+
                    '   "estado":"KI",'+
                    '   "sub_estado":"KI",'+
                    '   "id":"KI"'+
                    '}';
        return falseJson;
    }
/*
    static testMethod void testParse() {
        String json=        '{'+
        '   "idTransaccion":"46306123",'+
        '   "Contador":"1",'+
        '   "nombreCanal":"AUTOPIA",'+
        '   "nombreMotor":"EQUIFAX",'+
        '   "nombreOperaciones":"EQUIFAX",'+
        '   "respuestaAPI":"RECHAZA",'+
        '   "FechaTransaccion":"2019-12-13",'+
        '   "HoraTransaccion":"10:46:55",'+
        '   "rut":"269614587",'+
        '   "nombre":"Richard",'+
        '   "apellidoPaterno":"Cumana",'+
        '   "apellidoMaterno":"Guerra",'+
        '   "rentaLiquida":"450",'+
        '   "email":"richadcumana1971@gmail.com",'+
        '   "telefono":"56957327370",'+
        '   "valorVehiculo":"4000000",'+
        '   "montoPie":"1600000",'+
        '   "tipoVehiculo":"USADO",'+
        '   "situacionLaboral":"Sin Informacion",'+
        '   "marcaVehiculo":"135",'+
        '   "marcaVehiculoNombre":"TOYOTA",'+
        '   "modelo":"0",'+
        '   "modeloNombre":"",'+
        '   "version":"",'+
        '   "valorCuota":"0",'+
        '   "idTripleta":"",'+
        '   "anioVehiculo":"",'+
        '   "escenario_interes":"",'+
        '   "Canal":"37",'+
        '   "concesionario":"",'+
        '   "local":"",'+
        '   "nombreEmpresa":"",'+
        '   "antiguedadLaboral":"0",'+
        '   "plazoCredito":"",'+
        '   "codigoProducto":"",'+
        '   "tipoCredito":"",'+
        '   "porcentaje":"0",'+
        '   "meses":"0",'+
        '   "fuente":"KI"'+
        '   "estado":"KI"'+
        '   "sub_estado":"KI"'+
        '   "id":"KI"'+
        '}';
        copyLeads obj = parse(json);
        System.assert(obj != null);
    }
*/
}