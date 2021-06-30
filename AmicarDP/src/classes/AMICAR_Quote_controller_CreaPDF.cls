/***************************************************************************************************
Desarrollado por: Cloud Solution
Autor: John Guaracan (JG)
Proyecto: Amicar
Descripción: Crear controller para crear PDF en el objeto Quote
Test:AMICAR_Quote_controller_test
Visualforce:AMICAR_Quote_CreatePDF_V
Cobertura:98%
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 14/01/2021            JG                    Crear controller para crear PDF en el objeto Quote
**************************************************************************************************/
public class AMICAR_Quote_controller_CreaPDF {
    public Quote SimulacionList;
    public Opportunity oportunidades;
    public Desarrollo__c desarrollo;
    public list<impuesto__c> impuesto;
    public list<Patrimonio__c> patrimonio;
    public list<Modelo_de_vehiculo__c> modelolista;
    public list<relacion__c> relacion {get;set;} 
    public String id_Quote;
    /////////////////////////////Variable del PDF///////////////////////////////////////////////
    public string eneroA                        {get;set;}
    public string febreroA                        {get;set;}
    public string marzoA                        {get;set;}
    public string abrilA                        {get;set;}
    public string mayoA                        {get;set;}
    public string junioA                        {get;set;}
    public string julioA                        {get;set;}
    public string agostoA                        {get;set;}
    public string septiembreA                        {get;set;}
    public string octubreA                        {get;set;}
    public string noviembreA                        {get;set;}
    public string diciembreA                        {get;set;}
    
     public string eneroc                        {get;set;}
    public string febreroc                        {get;set;}
    public string marzoc                        {get;set;}
    public string abrilc                        {get;set;}
    public string mayoc                        {get;set;}
    public string junioc                        {get;set;}
    public string julioc                        {get;set;}
    public string agostoc                        {get;set;}
    public string septiembrec                        {get;set;}
    public string octubrec                        {get;set;}
    public string noviembrec                        {get;set;}
    public string diciembrec                        {get;set;}
    
    public string enerov                        {get;set;}
    public string febrerov                        {get;set;}
    public string marzov                        {get;set;}
    public string abrilv                        {get;set;}
    public string mayov                        {get;set;}
    public string juniov                        {get;set;}
    public string juliov                        {get;set;}
    public string agostov                        {get;set;}
    public string septiembrev                        {get;set;}
    public string octubrev                        {get;set;}
    public string noviembrev                        {get;set;}
    public string diciembrev                        {get;set;}
    
    
    
    public string dia                        {get;set;}
    public string mes                        {get;set;}
    public string ano                        {get;set;}
    public string producto                   {get;set;}
    public string local                      {get;set;}
    public string concecionario              {get;set;}
    public string vendedor                   {get;set;}
    public string ejecutivo                  {get;set;}
    public string pie                        {get;set;}
    public string monto_a_Financiar          {get;set;}
    public string cuotas                     {get;set;}
    public string fecha_de_Vencimiento       {get;set;}
    public string fechaVCoompleta            {get;set;}
    public string valor_en_Cuotas            {get;set;}
    public string tipo_de_Vehiculo           {get;set;}
    public string marca                      {get;set;}
    public string anoV                       {get;set;}
    public string modelo                     {get;set;}
    public string precioVehiculo             {get;set;}
    public string apellido_Paterno           {get;set;}
    public string apellido_Materno           {get;set;}
    public string nombres                    {get;set;}
    public string rut                        {get;set;}
    public string n_serie                    {get;set;}
    public string direccion                  {get;set;} 
    public string comuna                     {get;set;}
    public string region                     {get;set;}
    public string telefono_Particular        {get;set;}
    public string telefono_Celular           {get;set;}
    public date   fecha_de_Cumpleano         {get;set;}
    public string nacionalidad               {get;set;}
    public string estudios                   {get;set;}
    public string estado_Civil               {get;set;}
    public string tipo_de_residencia         {get;set;}
    public string regimen_Matrimonial        {get;set;}
    public string email                      {get;set;}
    public string tipo_de_trabajador         {get;set;}
    public string nombre_Empleador           {get;set;}
    public string rut_empleador              {get;set;}
    public string rubro_Empleado             {get;set;}
    public string tipo_de_Contrato           {get;set;}
    public string tipo_de_renta              {get;set;}
    public string tipo_de_Actividad          {get;set;}
    public string cargo                      {get;set;}
    public date fecha_de_Ingreso             {get;set;}
    public string empleador_Anterior         {get;set;}
    public string antiguedad_Empleo_Anterior {get;set;}
    public string telefono_Empleador_Anterior{get;set;}
    public string renta                      {get;set;}
    public string otros_Ingresos             {get;set;}
    public string descripcion_Otros_Ingresos {get;set;}
    public string total_I                    {get;set;}
    public string arriendo                   {get;set;}
    public string dividendo                  {get;set;}
    public string otros_Egresos              {get;set;}
    public string total_E                    {get;set;}
    public integer ano_Declaracion_IVA       {get;set;}
    //public integer mes_Declaracion_IVA       {get;set;}
    //public string IVA_Compra                 {get;set;}
    //public string IVA_Venta                  {get;set;}
    public string decimalDescripcion_P       {get;set;}
    public string valor_comercial_P          {get;set;}
    public string financiamoento_P           {get;set;}
    public string con_deuda_P                {get;set;}
    public string nombre_Completo            {get;set;}
    public string parententesco              {get;set;}
    public string fono                       {get;set;}
    public string Description                {get;set;}
    public string valida_nombre              {get;set;}
    public string idSolicitud                {get;set;}
    
    
    public AMICAR_Quote_controller_CreaPDF(apexpages.standardController controller) {
        //id_Quote= ApexPages.CurrentPage().getparameters().get('id');
        id_Quote = controller.getId();
        if(id_Quote == null || id_Quote == ''){
          //  id_Quote = '0Q07A000000BuUCSA0';
        }
        
        SimulacionList= [SELECT Id, Name, RecordTypeId, OpportunityId, Comisi_n_dealer__c, Tasa__c, Cuotas__c, CAE__c, 
                         Capital_final__c, Costo_total_cr_dito__c, Id_Simulacion__c, Interes_por_desfase__c, 
                         Saldo_precio__c, Tipo_de_financiamiento__c, Tipo_de_tasa2__c, Total_a_financiar__c, Valor_UF__c,
                         Valor_cuota__c,Opportunity.Cuotas__c,Opportunity.Local__r.name
                         FROM Quote 
                         WHERE Id =: id_Quote
                        ];
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::SimulacionList:: '+SimulacionList);
        oportunidades=[SELECT Id, AccountId, RecordTypeId, Name, StageName, Probability, CloseDate, OwnerId, A_o_Veh_culo__c, Cargo__c,
                       Comision_dealer__c, toLabel(Comuna__c), Empleador__c, toLabel(Marca_vehiculo__c), Pie__c, Precio_vehiculo__c, toLabel(Regi_n__c),
                       Tipo_Cr_dito__c, toLabel(Tipo_de_Veh_culo__c) , toLabel(Tipo_de_contrato__c), Tipo_de_trabajador__c, Valor_Cuota__c, Version__c,
                       Arriendo__c, Banco_cuenta_1__c, CAE__c, Capital_final__c, Comuna_empleador__c, Costo_total_credito__c, Cuotas__c,
                       Direccion__c, Direccion_empleador__c, Dividendo__c, toLabel(Estado_civil__c),toLabel( Estudios__c), Fecha_de_ingreso__c, 
                       Id_Solicitud__c, Local__c, Modelo2_retoma__c, N_de_serie_C_I__c, Numero_cuenta_1__c, Otros_egresos__c, Otros_ingresos__c, 
                       Pie_formula__c, Profesion__c, RUT__c, RUT_empleador__c,toLabel( Regimen_matrimonial__c), Region_empleador__c, Renta__c, 
                       toLabel(Rubro_de_empleador__c), Saldo_precio__c, Tasa__c, Telefono_empleador__c, Tipo_cuenta_1__c,toLabel( Tipo_de_actividad__c), 
                       Tipo_de_cuenta_2__c, Tipo_de_financiamiento__c, toLabel(Tipo_de_renta__c), toLabel(Tipo_de_residencia__c), Tipo_de_tasa__c,
                       Total_a_financiar__c, Valor_UF__c, Vendedor__c,CreatedDate,Local__r.name,Vendedor__r.name,Owner.name,
                       // Modelo2_retoma__r.name,Modelo2_retoma__r.Modelo__c,Modelo2_retoma__r.Marca_Busqueda__c,
                       Account.lastname, toLabel(local__r.Concesionario__c),
                       Account.firstname,Account.rut__c,Account.N_de_serie_C_I__pc,Account.PersonMobilePhone, Account.PersonOtherPhone,
                       Account.PersonBirthdate,Account.Nacionalidad__pc,Account.PersonEmail,Empleador_anterior__c,Antiguedad_empleo_anterior__c,
                       Telefono_empleador_anterior__c,Descripcion_otros_ingresos__c,Description,RecordType.name,Modelo2__r.name
                       FROM Opportunity 
                       WHERE Id =: SimulacionList.OpportunityId          
                      ];
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::oportunidades:: '+oportunidades);
        
        desarrollo= [SELECT Id, Name, Fecha_vencimiento__c, Numero_de_pago__c, Pago__c, Simulacion__c, Solicitud__c 
                     FROM Desarrollo__c 
                     WHERE Simulacion__c =:id_Quote
                     and Solicitud__c =: oportunidades.Id
                     and Numero_de_pago__c=1
                    ]; 
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::desarrollo '+desarrollo);
        patrimonio=[SELECT Id, Name, Solicitud__c, Descripcion__c, Financiamiento__c, Tipo__c, Valor_venta__c,Con_deuda__c 
                    FROM Patrimonio__c 
                    WHERE Solicitud__c =: oportunidades.Id
                   ];
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::patrimonio '+patrimonio);
        relacion= [SELECT Id, Name, Solicitud__c, Apellidos__c, Direccion__c, Nombre__c, Telefono__c,Tipo_de_relacion__c, 
                   Telefono_empleador__c, Cuenta__r.Name, RecordType.Name, Cuenta__r.Phone
                   FROM Relacion__c 
                   WHERE Solicitud__c =: oportunidades.Id
                  ];
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::relacion '+relacion);
        impuesto= [SELECT Id, Name, Solicitud__c, Fecha__c, Impuesto_compras__c, Impuesto_ventas__c,CreatedDate
                   FROM Impuesto__c 
                   WHERE Solicitud__c =: oportunidades.Id
                   order by Fecha__c
                  ];
        System.debug('AMICAR_Oportunitys_cotroller_CreaPDF::impuesto '+impuesto);
        
        dia=string.valueOf(oportunidades.CreatedDate.day());
        mes=string.valueOf(oportunidades.CreatedDate.month());
        ano=string.valueOf(oportunidades.CreatedDate.year());
        producto=oportunidades.Tipo_de_Veh_culo__c==null?'':oportunidades.Tipo_de_Veh_culo__c;
        System.debug('producto'+producto);
        /*string valorproducto=  producto;
switch on valorproducto  {
when 'Nuevo' {
producto='Nuevo';
}
when 'Usado' {
producto='Usado';
}
when 'NU' {
producto='Particular Nuevo';
}
when 'NP' {
producto='Comercial Nuevo';
}
when 'US' {
producto='Particular Usado';
}
when 'UP' {
producto='Comercial Usado';
}
when 'NM' {
producto='Maquinaria Pesada Nuevas';
}
when 'UM' {
producto='Maquinaria Pesada Usadas';
}
when 'NT' {
producto='Motos Nuevas';
}
when 'UT' {
producto='Motos Usadas';
}
when else  {
producto='';
}

}*/
        local=oportunidades.Local__r.name==null?'':oportunidades.Local__r.name; 
        concecionario=oportunidades.local__r.Concesionario__c==null?'':oportunidades.local__r.Concesionario__c;
        vendedor=oportunidades.Vendedor__r.name==null?'':oportunidades.Vendedor__r.name; 
        ejecutivo=oportunidades.Owner.name==null?'':oportunidades.Owner.name; 
        pie=string.valueof(oportunidades.Pie__c)==null?'':convertir(string.valueof(oportunidades.Pie__c),0); 
        monto_a_Financiar=string.valueof(oportunidades.Saldo_precio__c)==null?'':convertir(string.valueof(oportunidades.Saldo_precio__c),0);
        cuotas=string.valueof(oportunidades.Cuotas__c)==null?'':string.valueof(oportunidades.Cuotas__c);
        fecha_de_Vencimiento=desarrollo.Fecha_vencimiento__c==null?'':desarrollo.Fecha_vencimiento__c;
        if(fecha_de_Vencimiento!=null ||fecha_de_Vencimiento!=''){
            String[] arrTest  = fecha_de_Vencimiento.split('-');
            fechaVCoompleta= arrTest[2]+'/'+arrTest[1]+'/'+arrTest[0];
        }
        valor_en_Cuotas=string.valueof(SimulacionList.Valor_Cuota__c)==null?'':convertir(string.valueof(SimulacionList.Valor_Cuota__c),0);
        tipo_de_Vehiculo=oportunidades.Tipo_de_Veh_culo__c==null?'':oportunidades.Tipo_de_Veh_culo__c;
        string valortipoproducto=  tipo_de_Vehiculo;
        /* switch on valorproducto  {
when 'Nuevo' {
tipo_de_Vehiculo='Nuevo';
}
when 'Usado' {
tipo_de_Vehiculo='Usado';
}
when 'NU' {
tipo_de_Vehiculo='Particular Nuevo';
}
when 'NP' {
tipo_de_Vehiculo='Comercial Nuevo';
}
when 'US' {
tipo_de_Vehiculo='Particular Usado';
}
when 'UP' {
tipo_de_Vehiculo='Comercial Usado';
}
when 'NM' {
tipo_de_Vehiculo='Maquinaria Pesada Nuevas';
}
when 'UM' {
tipo_de_Vehiculo='Maquinaria Pesada Usadas';
}
when 'NT' {
tipo_de_Vehiculo='Motos Nuevas';
}
when 'UT' {
tipo_de_Vehiculo='Motos Usadas';
}
when else  {
tipo_de_Vehiculo='';
}

}*/
        System.debug('oportunidades.Marca_vehiculo__c '+oportunidades.Marca_vehiculo__c);
        marca=oportunidades.Marca_vehiculo__c==null?'':oportunidades.Marca_vehiculo__c;
        /*string valortipoMarca=  marca;
switch on valortipoMarca  {
when '799' { marca='ALFA ROMEO';

}
when '800' { marca='AUDI';

}
when '801' {marca='BAIC';

}
when 'BENELLI' {     marca='BENELLI';

}
when 'BENTLEY' { marca='BENTLEY';

}
when '802' { marca='BMW';

}
when '803' { marca='BRILLIANCE';

}
when '804' {marca='BYD';

}
when '805' {marca='CHANGAN';

}
when '806' { marca='CHERY';

}
when '807' { marca='CHEVROLET';

}
when '808' { marca='CHRYSLER';

}
when '809' {marca='CITROËN';

}
when '810' { marca='DAEWOO';

}
when '811' { marca='DAIHATSU';

}
when '812' {marca='DFM';

}
when '813' {  marca='DFSK';

}
when '814' {marca='DODGE';

}
when 'DONG FENG' {marca='DONG FENG';

}
when 'DS' {marca='DS';

}
when '815' { marca='FAW';

}
when 'FERRARI' { marca='FERRARI';

}
when '816' { marca='FIAT';

}
when '817' {marca='FORD';

}
when 'FOTON' { marca='FOTON';

}
when 'FUSO' {marca='FUSO';

}
when 'GAC' {marca='GAC';

}
when 'GAC GONOW' { marca='GAC GONOW';

}
when '818' { marca='GEELY';

}
when '819' { marca='GREAT WALL';

}
when 'GREAT WALL MOTORS' {marca='GREAT WALL MOTORS';

}
when 'GRUPO GREAT WALL' { marca='GRUPO GREAT WALL';

}
when 'HAFEI' {marca='HAFEI';

}
when '820' { marca='HAIMA';

}
when '821' { marca='HAVAL';

}
when 'HIGER' {marca='HIGER';

}
when '822' {  marca='HONDA';

}
when '823' {  marca='HYUNDAI';

}
when 'HYUNDAI VC' {marca='HYUNDAI VC';

}
when 'IVECO' { marca='IVECO';

}
when '824' { marca='JAC';

}
when 'JAGUAR' { marca='JAGUAR';

}
when '825' { marca='JEEP';

}
when 'JINBEI' { marca='JINBEI';

}
when 'KEEWAY' {marca='KEEWAY';

}
when '826' { marca='KIA';

}
when 'LADA' { marca='LADA';

}
when '827' { marca='LAND ROVER';

}
when 'LANDWIND' { marca='LANDWIND';

}
when 'LEXUS' {marca='LEXUS';

}
when '828' { marca='LIFAN';

}
when 'LINHAI' { marca='LINHAI';

}
when '829' { marca='MAHINDRA';

}
when 'MASERATI' { marca='MASERATI';

}
when 'MAXUS' {marca='MAXUS';

}
when '830' { marca='MAZDA';

}
when '831' {marca='MERCEDES BENZ';

}
when '832' { marca='MG';

}
when '833' { marca='MINI';

}
when '834' {marca='MITSUBISHI';

}
when '835' { marca='NISSAN';

}
when '836' {  marca='OPEL';

}
when 'Otros' { marca='Otros';

}
when '837' { marca='PEUGEOT';

}
when 'PORSCHE' {marca='PORSCHE';

}
when 'PROTON' {marca='PROTON';

}
when '838' { marca='RENAULT';

}
when '839' { marca='SAMSUNG';

}
when 'SINOTRUCK' {marca='SINOTRUCK';

}
when '840' {  marca='SKODA';

}
when '841' {  marca='SSANGYONG';

}
when '842' {marca='SUBARU';

}
when '843' { marca='SUZUKI';

}
when 'TATA' {marca='TATA';

}
when 'TODAS' { marca='TODAS';

}
when '844' { marca='TOYOTA';

}
when 'USADOS' { marca='USADOS';

}
when '845' {marca='VOLKSWAGEN';

}
when '846' {marca='VOLVO';

}
when 'YUEJIN' { marca='YUEJIN';

}
when 'YUTONG' {marca='YUTONG';

}
when '847' {marca='ZNA';

}
when '848' {marca='ZOTYE';

}
when '849' { marca='ZXAUTO';

}
when else  {marca='';

}

}*/
        //System.debug('Modelo2_retoma__r.name '+oportunidades.Modelo2_retoma__r.name);////este valor no me viene ni en la query 
        anoV=string.valueof(oportunidades.A_o_Veh_culo__c)==null?'':string.valueof(oportunidades.A_o_Veh_culo__c); 
        modelo=oportunidades.Modelo2__r.name==''?'':oportunidades.Modelo2__r.name;
        precioVehiculo=string.valueof(oportunidades.Precio_vehiculo__c)==null?'':convertir(string.valueof(oportunidades.Precio_vehiculo__c),0);
        string apellidoCompleto =oportunidades.Account.lastname;
          apellido_Paterno= apellidoCompleto==null?'': apellidoCompleto;
       // String[] apellidoFraccionado = apellidoCompleto.split(' ');
        //apellido_Paterno= apellidoFraccionado[0]==null?'': apellidoFraccionado[0];////preguntar si dejar en uno solo 
     /*   if(apellidoFraccionado.size()>0){
        apellido_Materno= apellidoFraccionado[1]==null?'': apellidoFraccionado[1];
        }*/
        Nombres= oportunidades.Account.firstname==null?'':oportunidades.Account.firstname; 
        rut= oportunidades.Account.rut__c==null?'':oportunidades.Account.rut__c;
        n_serie=oportunidades.Account.N_de_serie_C_I__pc==null?'':oportunidades.Account.N_de_serie_C_I__pc;
        direccion=oportunidades.Direccion__c==null?'':oportunidades.Direccion__c;
        comuna=oportunidades.Comuna__c==null?'':oportunidades.Comuna__c;
        /*  string valorComuna=  comuna;
switch on valorComuna  {
when '11201' {comuna='AISEN';

}
when '5602' {comuna='ALGARROBO';

}
when '13502' {comuna='ALHUE';

}
when '3302' {comuna='ALTO DEL CARMEN';

}
when '1303' {  comuna='ALTO HOSPICIO';

}
when '10202' {comuna='ANCUD';

}
when '4103' {comuna='ANDACOLLO';

}
when '9201' {comuna='ANGOL';

}
when '12202' {comuna='ANTARTICA';

}
when '2101' {comuna='ANTOFAGASTA';

}
when '8302' {comuna='ANTUCO';

}
when '8202' {comuna='ARAUCO';

}
when '1501' {comuna='ARICA';

}
when '13402' {comuna='BUIN';

}
when '8402' {comuna='BULNES';

}
when '5402' {comuna='CABILDO';

}
when '8303' {comuna='CABRERO';

}
when '2201' {comuna='CALAMA';

}
when '10102' {comuna='CALBUCO';

}
when '3102' {comuna='CALDERA';

}
when '5502' { comuna='CALERA';

}
when '13403' {comuna='CALERA DE TANGO';

}
when '5302' {comuna='CALLE LARGA';

}
when '1502' {comuna='CAMARONES';

}
when '1102' {comuna='CAMIÑA';

}
when '4202' {comuna='CANELA';

}
when '8203' {comuna='CAÑETE';

}
when '9102' {comuna='CARAHUE';

}
when '5603' {comuna='CARTAGENA';

}
when '5102' {comuna='CASABLANCA';

}
when '10201' {comuna='CASTRO';

}
when '5702' { comuna='CATEMU';

}
when '7201' {comuna='CAUQUENES';

}
when '13102' {comuna='CERRILLOS';

}
when '13103' {comuna='CERRO NAVIA';

}
when '10401' { comuna='CHAITEN';

}
when '7202' {comuna='CHANCO';

}
when '3201' {comuna='CHAÑARAL';

}
when '6302' {comuna='CHEPICA';

}
when '8103' {comuna='CHIGUAYANTE';

}
when '11401' { comuna='CHILE CHICO';

}
when '8401' {comuna='CHILLÁN';

}
when '8406' {comuna='CHILLAN VIEJO';

}
when '6303' {comuna='CHIMBARONGO';

}
when '10203' {comuna='CHONCHI';

}
when '11202' {comuna='CISNES';

}
when '8403' {comuna='COBQUECURA';

}
when '10103' {comuna='COCHAMO';

}
when '11301' {comuna='COCHRANE';

}
when '6102' {comuna='CODEGUA';

}
when '8404' {comuna='COELEMU';

}
when '8405' {comuna='COIHUECO';

}
when '6103' {comuna='COINCO';

}
when '7402' {comuna='COLBUN';

}
when '1103' {comuna='COLCHANE';

}
when '13301' {comuna='COLINA';

}
when '9202' {comuna='COLLIPULLI';

}
when '6104' { comuna='COLTAUCO';

}
when '4302' {comuna='COMBARBALA';

}
when '8101' {comuna='CONCEPCIÓN';

}
when '13104' {comuna='CONCHALI';

}
when '5103' {comuna='CON-CON';

}
when '7102' {comuna='CONSTITUCION';

}
when '8204' {comuna='CONTULMO';

}
when '3101' {comuna='COPIAPÓ';

}
when '4102' { comuna='COQUIMBO';

}
when '8102' {comuna='CORONEL';

}
when '1401' {comuna='CORRAL';

}
when '11101' {comuna='COYHAIQUE';

}
when '9103' {comuna='CUNCO';

}
when '9203' {comuna='CURACAUTIN';

}
when '13503' {comuna='CURACAVI';

}
when '10204' { comuna='CURACO DE VELEZ';

}
when '8205' { comuna='CURANILAHUE';

}
when '9104' {comuna='CURARREHUE';

}
when '7103' {comuna='CUREPTO';

}
when '7301' {comuna='CURICÓ';

}
when '10205' {comuna='DALCAHUE';

}
when '3202' {comuna='DIEGO DE ALMAGRO';

}
when '6105' {comuna='DOÑIHUE';

}
when '13105' {comuna='EL BOSQUE';

}
when '8407' {comuna='EL CARMEN';

}
when '13602' {comuna='EL MONTE';

}
when '5604' { comuna='EL QUISCO';

}
when '3305' {comuna='EL SALVADOR';

}
when '5605' {comuna='EL TABO';

}
when '7104' {comuna='EMPEDRADO';

}
when '9204' { comuna='ERCILLA';

}
when '13106' {comuna='ESTACIÓN CENTRAL';

}
when '8104' {comuna='FLORIDA';

}
when '9105' {comuna='FREIRE';

}
when '3303' {comuna='FREIRINA';

}
when '10104' {comuna='FRESIA';

}
when '10105' { comuna='FRUTILLAR';

}
when '10402' { comuna='FUTALEUFU';

}
when '1402' {comuna='FUTRONO';

}
when '9106' {comuna='GALVARINO';

}
when '1503' {comuna='GENERAL LAGOS';

}
when '9107' {comuna='GORBEA';

}
when '6106' {comuna='GRANEROS';

}
when '11203' {comuna='GUAITECAS';

}
when '5503' { comuna='HIJUELAS';

}
when '10403' {comuna='HUALAIHUE';

}
when '7302' { comuna='HUALAÑE';

}
when '8343' {comuna='HUALPEN';

}
when '8105' { comuna='HUALQUI';

}
when '1104' { comuna='HUARA';

}
when '3304' { comuna='HUASCO';

}
when '13107' { comuna='HUECHURABA';

}
when '4201' {comuna='ILLAPEL';

}
when '13108' {comuna='INDEPENDENCIA';

}
when '1101' { comuna='IQUIQUE';

}
when '13603' { comuna='ISLA DE MAIPO';

}
when '5201' {comuna='ISLA DE PASCUA';

}
when '5104' {comuna='JUAN FERNANDEZ';

}
when '13109' {comuna='LA CISTERNA';

}
when '5504' {comuna='LA CRUZ';

}
when '6202' {comuna='LA ESTRELLA';

}
when '13110' { comuna='LA FLORIDA';

}
when '13111' { comuna='LA GRANJA';

}
when '4104' { comuna='LA HIGUERA';

}
when '5401' {comuna='LA LIGUA';

}
when '13112' {comuna='LA PINTANA';

}
when '13113' { comuna='LA REINA';

}
when '4101' {comuna='LA SERENA';

}
when '1403' {comuna='LA UNION';

}
when '1404' {comuna='LAGO RANCO';

}
when '11102' {comuna='LAGO VERDE';

}
when '12102' { comuna='LAGUNA BLANCA';

}
when '8304' { comuna='LAJA';

}
when '13302' {comuna='LAMPA';

}
when '1405' { comuna='LANCO';

}
when '6107' {comuna='LAS CABRAS';

}
when '13114' {comuna='LAS CONDES';

}
when '9108' { comuna='LAUTARO';

}
when '8201' {comuna='LEBU';

}
when '7303' { comuna='LICANTEN';

}
when '5505' { comuna='LIMACHE';

}
when '7401' {comuna='LINARES';

}
when '6203' {comuna='LITUECHE';

}
when '5703' {comuna='LLAILLAY';

}
when '10107' {comuna='LLANQUIHUE';

}
when '13115' {comuna='LO BARNECHEA';

}
when '13116' {comuna='LO ESPEJO';

}
when '13117' {comuna='LO PRADO';

}
when '6304' {comuna='LOLOL';

}
when '9109' {comuna='LONCOCHE';

}
when '7403' {comuna='LONGAVI';

}
when '9205' {comuna='LONQUIMAY';

}
when '8206' {comuna='LOS ALAMOS';

}
when '5301' { comuna='LOS ANDES';

}
when '8301' { comuna='LOS ANGELES';

}
when '1406' {comuna='LOS LAGOS';

}
when '10106' {comuna='LOS MUERMOS';

}
when '9206' { comuna='LOS SAUCES';

}
when '4203' { comuna='LOS VILOS';

}
when '8106' {comuna='LOTA';

}
when '9207' { comuna='LUMACO';

}
when '6108' {comuna='MACHALI';

}
when '13118' {comuna='MACUL';

}
when '1407' {comuna='MAFIL';

}
when '13119' {comuna='MAIPÚ';

}
when '6109' { comuna='MALLOA';

}
when '6204' {comuna='MARCHIGUE';

}
when '2302' {comuna='MARIA ELENA';

}
when '13504' {comuna='MARIA PINTO';

}
when '1408' {comuna='MARIQUINA';

}
when '7105' {comuna='MAULE';

}
when '10108' {comuna='MAULLIN';

}
when '2102' {comuna='MEJILLONES';

}
when '9110' { comuna='MELIPEUCO';

}
when '13501' { comuna='MELIPILLA';

}
when '7304' { comuna='MOLINA';

}
when '4303' { comuna='MONTE PATRIA';

}
when '6110' {comuna='MOSTAZAL';

}
when '8305' {  comuna='MULCHEN';

}
when '8306' {comuna='NACIMIENTO';

}
when '6305' { comuna='NANCAGUA';

}
when '12401' {comuna='NATALES';

}
when '12201' { comuna='NAVARINO';

}
when '6205' {comuna='NAVIDAD';

}
when '8307' { comuna='NEGRETE';

}
when '8408' { comuna='NINHUE';

}
when '5506' { comuna='NOGALES';

}
when '9111' {comuna='NUEVA IMPERIAL';

}
when '8409' { comuna='ÑIQUEN';

}
when '13120' { comuna='ÑUÑOA';

}
when '11302' {comuna='O HIGGINS';

}
when '6111' { comuna='OLIVAR';

}
when '2202' { comuna='OLLAGUE';

}
when '5507' {comuna='OLMUE';

}
when '10301' {comuna='OSORNO'
;
}
when '4301' {comuna='OVALLE';

}
when '13604' {comuna='PADRE HURTADO';

}
when '9112' {  comuna='PADRE LAS CASAS';

}
when '4105' { comuna='PAIHUANO';

}
when '1409' { comuna='PAILLACO';

}
when '13404' { comuna='PAINE';

}
when '10404' { comuna='PALENA';

}
when '6306' {comuna='PALMILLA';

}
when '1410' {comuna='PANGUIPULLI';

}
when '5704' {  comuna='PANQUEHUE';

}
when '5403' {comuna='PAPUDO';

}
when '6206' {comuna='PAREDONES';

}
when '7404' { comuna='PARRAL';

}
when '13121' {comuna='PEDRO AGUIRRE CERDA';

}
when '7106' {comuna='PELARCO';

}
when '7203' { comuna='PELLUHUE';

}
when '8410' { comuna='PEMUCO';

}
when '7107' {comuna='PENCAHUE';

}
when '8107' { comuna='PENCO';

}
when '13605' { comuna='PEÑAFLOR';

}
when '13122' {comuna='PEÑALOLEN';

}
when '6307' {comuna='PERALILLO';

}
when '9113' {comuna='PERQUENCO';

}
when '5404' { comuna='PETORCA';

}
when '6112' {comuna='PEUMO';

}
when '1105' { comuna='PICA';

}
when '6113' {comuna='PICHIDEGUA';

}
when '6201' {comuna='PICHILEMU';

}
when '8411' { comuna='PINTO';

}
when '13202' {comuna='PIRQUE';

}
when '9114' {comuna='PITRUFQUEN';

}
when '6308' {comuna='PLACILLA';

}
when '8412' { comuna='PORTEZUELO';

}
when '12301' {comuna='PORVENIR';

}
when '1106' { comuna='POZO ALMONTE';

}
when '12302' { comuna='PRIMAVERA';

}
when '13123' { comuna='PROVIDENCIA';

}
when '5105' {comuna='PUCHUNCAVI';

}
when '9115' {comuna='PUCON';

}
when '13124' { comuna='PUDAHUEL';

}
when '13201' {comuna='PUENTE ALTO';

}
when '10101' { comuna='PUERTO MONTT';

}
when '10302' {comuna='PUERTO OCTAY';

}
when '10109' { comuna='PUERTO VARAS';

}
when '6309' {comuna='PUMANQUE';

}
when '4304' { comuna='PUNITAQUI';

}
when '12101' { comuna='PUNTA ARENAS';

}
when '10206' {comuna='PUQUELDON';

}
when '9208' { comuna='PUREN';

}
when '10303' { comuna='PURRANQUE';

}
when '5705' { comuna='PUTAENDO';

}
when '1504' {comuna='PUTRE';

}
when '10304' {comuna='PUYEHUE';

}
when '10207' { comuna='QUEILEN';

}
when '10208' {comuna='QUELLON';

}
when '10209' { comuna='QUEMCHI';

}
when '8308' { comuna='QUILACO';

}
when '13125' {comuna='QUILICURA';

}
when '8309' { comuna='QUILLECO';

}
when '8413' { comuna='QUILLON';

}
when '5501' { comuna='QUILLOTA';

}
when '5106' { comuna='QUILPUE';

}
when '10210' {comuna='QUINCHAO';

}
when '6114' { comuna='QUINTA DE TILCOCO';

}
when '13126' {comuna='QUINTA NORMAL';

}
when '5107' {comuna='QUINTERO';

}
when '8414' { comuna='QUIRIHUE';

}
when '6101' { comuna='RANCAGUA';

}
when '8415' { comuna='RANQUIL';

}
when '7305' { comuna='RAUCO';

}
when '13127' {comuna='RECOLETA';

}
when '9209' { comuna='RENAICO';

}
when '13128' { comuna='RENCA';

}
when '6115' {comuna='RENGO';

}
when '6116' {comuna='REQUINOA';

}
when '7405' {comuna='RETIRO';

}
when '5303' { comuna='RINCONADA';

}
when '1411' {  comuna='RIO BUENO';

}
when '7108' {  comuna='RIO CLARO';

}
when '4305' { comuna='RIO HURTADO';

}
when '11402' {comuna='RIO IBAÑEZ';

}
when '10305' {comuna='RIO NEGRO';

}
when '12103' {comuna='RIO VERDE';

}
when '7306' { comuna='ROMERAL';

}
when '9116' {  comuna='SAAVEDRA';

}
when '7307' {comuna='SAGRADA FAMILIA';

}
when '4204' { comuna='SALAMANCA';

}
when '5601' { comuna='SAN ANTONIO';

}
when '13401' {comuna='SAN BERNARDO';

}
when '8416' { comuna='SAN CARLOS';

}
when '7109' { comuna='SAN CLEMENTE';

}
when '5304' { comuna='SAN ESTEBAN';

}
when '8417' { comuna='SAN FABIAN';

}
when '5701' {comuna='SAN FELIPE';

}
when '6301' {comuna='SAN FERNANDO';

}
when '12104' {comuna='SAN GREGORIO';

}
when '8418' {comuna='SAN IGNACIO';

}
when '7406' { comuna='SAN JAVIER';

}
when '13129' { comuna='SAN JOAQUIN';

}
when '13203' {comuna='SAN JOSE DE MAIPO';

}
when '10306' { comuna='SAN JUAN DE LA COSTA';

}
when '13130' { comuna='SAN MIGUEL';

}
when '8419' {comuna='SAN NICOLAS';

}
when '10307' {comuna='SAN PABLO';

}
when '13505' { comuna='SAN PEDRO';

}
when '2203' {  comuna='SAN PEDRO DE ATACAMA';

}
when '8108' {comuna='SAN PEDRO DE LA PAZ';

}
when '7110' { comuna='SAN RAFAEL';

}
when '13131' { comuna='SAN RAMON';

}
when '8310' {comuna='SAN ROSENDO';

}
when '6117' { comuna='SAN VICENTE';

}
when '8311' {comuna='SANTA BARBARA';

}
when '6310' {comuna='SANTA CRUZ';

}
when '8109' { comuna='SANTA JUANA';

}
when '5706' {comuna='SANTA MARIA';

}
when '13101' {comuna='SANTIAGO';

}
when '5606' {comuna='SANTO DOMINGO';

}
when '2103' {comuna='SIERRA GORDA';

}
when '13601' {comuna='TALAGANTE';

}
when '7101' {comuna='TALCA';

}
when '8110' { comuna='TALCAHUANO';

}
when '2104' {  comuna='TALTAL';

}
when '9101' { comuna='TEMUCO';

}
when '7308' {  comuna='TENO';

}
when '9117' {  comuna='TEODORO SCHMIDT';

}
when '3103' {comuna='TIERRA AMARILLA';

}
when '13303' { comuna='TILTIL';

}
when '12303' {comuna='TIMAUKEL';

}
when '8207' {comuna='TIRUA';

}
when '2301' { comuna='TOCOPILLA';

}
when '9118' {comuna='TOLTEN';

}
when '8111' {comuna='TOME';

}
when '12402' {comuna='TORRES DEL PAINE';

}
when '11303' {comuna='TORTEL';

}
when '9210' {comuna='TRAIGUEN';

}
when '8420' { comuna='TREGUACO';

}
when '8312' { comuna='TUCAPEL';

}
when '1412' {comuna='VALDIVIA';

}
when '3301' {comuna='VALLENAR';

}
when '5101' {comuna='VALPARAISO';

}
when '7309' { comuna='VICHUQUEN';

}
when '9211' { comuna='VICTORIA';

}
when '4106' {comuna='VICUÑA';

}
when '9119' {comuna='VILCUN';

}
when '7407' {comuna='VILLA ALEGRE';

}
when '5108' {comuna='VILLA ALEMANA';

}
when '9120' {comuna='VILLARRICA';

}
when '5109' {comuna='VIÑA DEL MAR';

}
when '13132' {comuna='VITACURA';

}
when '7408' { comuna='YERBAS BUENAS';

}
when '8313' {comuna='YUMBEL';

}
when '8421' {comuna='YUNGAY';

}
when '5405' {comuna='ZAPALLAR';

}
when else { comuna='';

}
}*/
        region=oportunidades.Regi_n__c==null?'':oportunidades.Regi_n__c;
        /* string valorRegion=  region;
switch on valorRegion  {
when '1' {
region='Tarapacá';
}
when '2' {
region='Antofagasta';
}
when '3' {
region='Atacama';
}
when '4' {
region='Coquimbo';
}
when '5' {
region='Valparaíso';
}
when '6' {
region='Lib. Gral. Bernardo O'+' Higgins';
}
when '7' {
region='Maule';
}
when '8' {
region='Biobío';
}
when '9' {
region='La Araucanía';
}
when '10' {
region='Los Lagos';
}
when '11' {
region='Aysén del Gral. C. Ibáñez del Campo';
}
when '12' {
region='Magallanes y Antártica Chilena';
}
when '13' {
region='Metropolitana de Santiago';
}
when '14' {
region='Los Ríos';
}
when '15' {
region='Arica y Parinacota';
}
when '16' {
region='Ñuble';
}
when else {
region='';
}
} */
        telefono_Particular=oportunidades.Account.PersonOtherPhone==null?'':oportunidades.Account.PersonOtherPhone;
        telefono_Celular=oportunidades.Account.PersonMobilePhone==null?'':oportunidades.Account.PersonMobilePhone;
        fecha_de_Cumpleano=oportunidades.Account.PersonBirthdate ==null?null:oportunidades.Account.PersonBirthdate ;
        nacionalidad=oportunidades.Account.Nacionalidad__pc ==null?'':oportunidades.Account.Nacionalidad__pc ;
        estudios=oportunidades.Estudios__c==null?'':oportunidades.Estudios__c ; 
        /*string valorEstudios=  estudios;
switch on valorEstudios  {
when 'PR' {
estudios='PRIMARIOS';
}
when 'SE' {
estudios='SECUNDARIOS';
}
when 'SU' {
estudios='SUPERIORES';
}
when 'PO' {
estudios='POSTGRADO';
}
when 'OT' {
estudios='OTROS';
}
when 'MA' {
estudios='MAGISTER';
}
when 'SN' {
estudios='SUPERIOR NO TERMINADO';
}
when else {
estudios='';
}
}*/
        estado_Civil=oportunidades.Estado_civil__c==null?'':oportunidades.Estado_civil__c;
        /* string valorestado_Civil=  estado_Civil;
switch on valorestado_Civil  {
when 'CA' {
estado_Civil='Casado';
}
when 'EP' {
estado_Civil='Conviviente civil';
}
when 'SL' {
estado_Civil='Divorciado';
}
when 'SH' {
estado_Civil='Separado';
}
when 'SO' {
estado_Civil='Soltero';
}
when 'VI' {
estado_Civil='Viudo';
}
when else {
estado_Civil='';
}
}*/
        tipo_de_residencia=oportunidades.Tipo_de_residencia__c==null?'':oportunidades.Tipo_de_residencia__c;
        /*  string valorestadotipo_de_residencia=  tipo_de_residencia;
switch on valorestadotipo_de_residencia  {
when '1' {
tipo_de_residencia='PROPIA SIN DEUDA';
}
when '2' {
tipo_de_residencia='PROPIA CON DEUDA';
}
when '3' {
tipo_de_residencia='ARRENDADA';
}
when '4' {
tipo_de_residencia='VIVE CON FAMILIARES';
}
when '5' {
tipo_de_residencia='VIVE CON PADRES';
}
when '6' {
tipo_de_residencia='FISCAL O EMPRESA';
}
when else {
tipo_de_residencia='';
}
}*/
        regimen_Matrimonial=oportunidades.Regimen_matrimonial__c==null?'':oportunidades.Regimen_matrimonial__c;
        /* string valoresregimen_Matrimonial=  regimen_Matrimonial;
switch on valoresregimen_Matrimonial  {
when 'CB' { regimen_Matrimonial='Comunidad de Bienes';

}
when 'PG' { regimen_Matrimonial='Participación en los gananciales';

}
when 'SB' {regimen_Matrimonial='Separación total de bienes';

}
when 'NA' {regimen_Matrimonial='No aplica';

}
when else {
regimen_Matrimonial='';
}
}*/
        email=oportunidades.Account.PersonEmail==null?'':oportunidades.Account.PersonEmail;
        Tipo_de_trabajador=oportunidades.Tipo_de_trabajador__c==null?'':oportunidades.Tipo_de_trabajador__c;
        nombre_Empleador=oportunidades.empleador__c==null?'':oportunidades.empleador__c;
        rut_empleador=oportunidades.rut_empleador__c==null?'':oportunidades.rut_empleador__c;
        rubro_Empleado=oportunidades.Rubro_de_empleador__c==null?'':oportunidades.Rubro_de_empleador__c;
        /* string valoresrubro_Empleado=  rubro_Empleado;
switch on valoresrubro_Empleado  {
when '5' {
rubro_Empleado='COMERCIO';
}
when '12' {
rubro_Empleado='COMUNICACIONES';
}
when '11' {
rubro_Empleado='CONSTRUCCIÓN';
}
when '10' {
rubro_Empleado='ELECTRICIDAD, GAS Y AGUA';
}
when '9' {
rubro_Empleado='ENERGÍA';
}
when '14' {
rubro_Empleado='ENTIDADES FISCALES';
}
when '7' {
rubro_Empleado='MANUFACTURA';
}
when '2' {
rubro_Empleado='MINERÍA';
}
when '1' {
rubro_Empleado='PESCA';
}
when '3' {
rubro_Empleado='PRENSA';
}
when '8' {
rubro_Empleado='SERVICIOS';
}
when '13' {
rubro_Empleado='SERVICIOS FINANCIEROS';
}
when '4' {
rubro_Empleado='TEXTIL';
}
when '6' {
rubro_Empleado='TRANSPORTE';
}
when else {
rubro_Empleado='';
}
}*/
        tipo_de_Contrato=oportunidades.Tipo_de_contrato__c==null?'':oportunidades.Tipo_de_contrato__c;  
        /*  string valorestipo_de_Contrato=  tipo_de_Contrato;
switch on valorestipo_de_Contrato  {
when 'DE' {
tipo_de_Contrato='Fijo';
}
when 'IN' {
tipo_de_Contrato='Indefinido';
}
when 'CN' {
tipo_de_Contrato='Contrata';
}
when else {
tipo_de_Contrato='';
}
}*/
        tipo_de_renta=oportunidades.Tipo_de_renta__c==null?'':oportunidades.Tipo_de_renta__c;
        /*string valorestipo_de_renta=  tipo_de_renta;
switch on valorestipo_de_renta  {
when 'FI' {
tipo_de_renta='FIJA';
}
when 'VA' {
tipo_de_renta='VARIABLE';
}
when else {
tipo_de_renta='';
}
}*/
        tipo_de_Actividad=oportunidades.Tipo_de_actividad__c==null?'':oportunidades.Tipo_de_actividad__c;
        /* string valorestipo_de_Actividad=  tipo_de_Actividad;
switch on valorestipo_de_Actividad  {
when '62' {tipo_de_Actividad='Act. Inmobiliarias, Empresariales y de Alquiler';

}
when '63' { tipo_de_Actividad='Adm. Pública y Defensa';

}
when '36' {tipo_de_Actividad='Agricultor / Ganadero / Pescado';

}
when '1' {tipo_de_Actividad='Agricultor Propietario';

}
when '51' { tipo_de_Actividad='Agricultura, Ganadería, Caza y Silvicultura';

}
when '2' { tipo_de_Actividad='Artesano';

}
when '43' { tipo_de_Actividad='Asesor Financiero';

}
when '3' { tipo_de_Actividad='Comerciante';

}
when '38' { tipo_de_Actividad='Comercio';

}
when '58' { tipo_de_Actividad='Comercio al Por Mayor y Menor';

}
when '67' { tipo_de_Actividad='Consejo de Adm. de Edificios y Condominios';

}
when '57' {  tipo_de_Actividad='Construcción';

}
when '4' {tipo_de_Actividad='Dependiente No Profesional';

}
when '5' { tipo_de_Actividad='Dependiente Profesional';

}
when '6' { tipo_de_Actividad='Dueña de Casa';

}
when '50' { tipo_de_Actividad='Dueño';

}
when '26' { tipo_de_Actividad='Empleada Casa Particular';

}
when '35' { tipo_de_Actividad='Empleado Oficina';

}
when '40' {tipo_de_Actividad='Empresario';

}
when '7' {tipo_de_Actividad='Empresario Individual';

}
when '8' { tipo_de_Actividad='Empresario más de 5 trabajadores';

}
when '64' {tipo_de_Actividad='Enseñanza';

}
when '9' { tipo_de_Actividad='Estudiante';

}
when '53' {  tipo_de_Actividad='Explotación de Minas y Canteras';

}
when '39' { tipo_de_Actividad='FF.A.A., carabineros e investigaciones';

}
when '10' {tipo_de_Actividad='FF.AA.';

}
when '11' { tipo_de_Actividad='Funcionario de Gobierno';

}
when '37' {  tipo_de_Actividad='Gendarme';

}
when '28' {tipo_de_Actividad='Gerente / Administrador';

}
when '12' {tipo_de_Actividad='Gerente Empresas Prime';

}
when '59' {tipo_de_Actividad='Hoteles y Restaurantes';

}
when '13' {tipo_de_Actividad='Independiente No Profesional';

}
when '14' { tipo_de_Actividad='Independiente Profesional';

}
when '55' { tipo_de_Actividad='Industrias Manufactureras Metálicas';

}
when '54' { tipo_de_Actividad='Industrias Manufactureras No Metálicas';

}
when '61' {tipo_de_Actividad='Intermediación Financiera';

}
when '47' {  tipo_de_Actividad='Jefe Area / Local';

}
when '44' { tipo_de_Actividad='Jubilado';

}
when '15' {tipo_de_Actividad='Jubilado / Pensionado / Montepiado';

}
when '49' {tipo_de_Actividad='Medico';

}
when '16' {tipo_de_Actividad='Obrero /Jornalero';

}
when '31' {tipo_de_Actividad='Obrero /Jornalero';

}
when '45' {tipo_de_Actividad='Operador';

}
when '68' {tipo_de_Actividad='Organizaciones y Órganos Extraterritoriales';

}
when '66' {tipo_de_Actividad='Otras Actividades de Servicios Comunitarias';

}
when '17' {tipo_de_Actividad='Otros';

}
when '52' {tipo_de_Actividad='Pesca';

}
when '27' {tipo_de_Actividad='Profesional';

}
when '18' {tipo_de_Actividad='Profesor';

}
when '48' {tipo_de_Actividad='Profesor / Educador';

}
when '19' { tipo_de_Actividad='Rentista';

}
when '65' {tipo_de_Actividad='Servicios Sociales y de Salud';

}
when '20' { tipo_de_Actividad='Sostenedor';

}
when '46' { tipo_de_Actividad='Sub Gerente';

}
when '56' {tipo_de_Actividad='Suministro de Electricidad, Gas y Agua';

}
when '34' { tipo_de_Actividad='Tecnico';

}
when '21' { tipo_de_Actividad='Temporero';

}
when '60' {tipo_de_Actividad='Transporte, Almacenamiento y Comunicaciones';

}
when '41' {tipo_de_Actividad='Transportista / Transporte';

}
when '22' {  tipo_de_Actividad='Transportista de Carga';

}
when '23' { tipo_de_Actividad='Transportista de Pasajeros';

}
when '33' { tipo_de_Actividad='Transportista Escolar';

}
when '42' {tipo_de_Actividad='Transportista Publico';

}
when '29' {tipo_de_Actividad='Vendedor';

}
when '24' {tipo_de_Actividad='Vendedor A (RF < RME)';

}
when '25' { tipo_de_Actividad='Vendedor B (RF >= RME)';

}
when else { tipo_de_Actividad='';

}
}*/
        cargo=oportunidades.Cargo__c==null?'':oportunidades.Cargo__c;
        fecha_de_ingreso=oportunidades.Fecha_de_ingreso__c==null?null:oportunidades.Fecha_de_ingreso__c;
        empleador_Anterior=oportunidades.Empleador_anterior__c==null?'':oportunidades.Empleador_anterior__c;
        antiguedad_Empleo_Anterior=oportunidades.Antiguedad_empleo_anterior__c==null?'':oportunidades.Antiguedad_empleo_anterior__c;
        telefono_Empleador_Anterior=oportunidades.Telefono_empleador_anterior__c==null?'':oportunidades.Telefono_empleador_anterior__c;
        renta=string.valueof(oportunidades.Renta__c)==null?'':convertir(string.valueof(oportunidades.Renta__c),0);
        otros_Ingresos=string.valueof(oportunidades.Otros_ingresos__c)==null?'':convertir(string.valueof(oportunidades.Otros_ingresos__c),0);
        descripcion_Otros_Ingresos=oportunidades.Descripcion_otros_ingresos__c==null?'':oportunidades.Descripcion_otros_ingresos__c;
        total_I=convertir(string.valueof(oportunidades.Renta__c+oportunidades.Otros_ingresos__c),0);
        arriendo=string.valueof(oportunidades.arriendo__c)==null?'':convertir(string.valueof(oportunidades.arriendo__c),0);
        dividendo=string.valueof(oportunidades.dividendo__c)==null?'':convertir(string.valueof(oportunidades.dividendo__c),0);
        otros_Egresos=string.valueof(oportunidades.Otros_egresos__c)==null?'':convertir(string.valueof(oportunidades.Otros_egresos__c),0);
        total_E=convertir(string.valueof(oportunidades.arriendo__c+oportunidades.dividendo__c+oportunidades.Otros_egresos__c),0);
        if(!impuesto.isEmpty()){
            System.debug('impuesto.size() -->'+impuesto.size());
            for(integer i=0;i<impuesto.size();i++){
                string meses_Ano=string.valueof(impuesto[i].Fecha__c.month());
                switch on meses_Ano  {
                    when '1' {
                        eneroc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        enerov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        eneroA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '2' {
                        febreroc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        febrerov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        febreroA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '3' {
                        marzoc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        marzov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        marzoA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '4' {
                        abrilc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        abrilv=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        abrilA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '5' {
                        mayoc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        mayov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        mayoA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '6' {
                        junioc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        juniov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        junioA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '7' {
                        julioc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        juliov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        julioA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '8' {
                        agostoc=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        agostov=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        agostoA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '9' {
                        septiembrec=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        septiembrev=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        septiembreA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '10' {
                        octubrec=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        octubrev=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        octubreA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '11' {
                        noviembrec=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        noviembrev=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                         noviembreA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                    when '12' {
                        diciembrec=convertir(string.valueof(impuesto[i].Impuesto_compras__c),0);
                        diciembrev=convertir(string.valueof(impuesto[i].Impuesto_ventas__c),0);
                        diciembreA=string.valueOf(impuesto[i].Fecha__c)==null?'':string.valueOf(impuesto[i].Fecha__c.year());
                    }
                }
            }
            ano_Declaracion_IVA=impuesto[0].Fecha__c==null?null:impuesto[0].Fecha__c.year();
           /* mes_Declaracion_IVA=impuesto[0].Fecha__c==null?null:impuesto[0].Fecha__c.month();
            IVA_Compra=convertir(string.valueof(impuesto[0].Impuesto_compras__c),0);
            IVA_Venta=convertir(string.valueof(impuesto[0].Impuesto_ventas__c),0);*/
        }
        if(!patrimonio.isEmpty()){
            decimalDescripcion_P=patrimonio[0].Descripcion__c==null?'':patrimonio[0].Descripcion__c;
            valor_comercial_P=string.valueof(patrimonio[0].Valor_venta__c)==null?'':convertir(string.valueof(patrimonio[0].Valor_venta__c),0);
            financiamoento_P=patrimonio[0].Financiamiento__c==null?'':convertir(string.valueof(patrimonio[0].Financiamiento__c),0);
            con_deuda_P=string.valueof(patrimonio[0].Con_deuda__c)==null?'':string.valueof(patrimonio[0].Con_deuda__c);
        }
        // if(!relacion.isEmpty()){
            // nombre_Completo=relacion[0].Nombre__c==null?'':relacion[0].Nombre__c;
            // parententesco=relacion[0].Tipo_de_relacion__c==null?'':relacion[0].Tipo_de_relacion__c;
            // fono=relacion[0].Telefono__c==null?'':relacion[0].Telefono__c;            
        // }
        Description=oportunidades.Description==null?'':oportunidades.Description;
            valida_nombre=oportunidades.RecordType.name;   
            idSolicitud=oportunidades.Id_Solicitud__c==null?'':oportunidades.Id_Solicitud__c;
        }
    
    public string convertir(string numeros, integer decimales){
        String fin = '';
        String inicio = '';
        string ceros='';
        System.debug('numeros='+numeros);
        
        if(numeros.indexOf('.') > 0){
            String[] aux = numeros.split('\\.');
            inicio = aux[0];
            fin = (aux[1].split('%'))[0];
        }else if(numeros.indexOf(',') > 0){
            String[] aux = numeros.split(',');
            inicio = aux[0];
            fin = (aux[1].split('%'))[0];
        }else{
            inicio = numeros;
        }
        System.debug('inicio='+inicio);
        System.debug('fin='+fin);
        
        for(integer j=fin.length();j<decimales;j++){
            ceros=ceros+'0';
        }
        System.debug('ceros='+ceros);
        String[] s = inicio.split('');
        String r = '';
        
        System.debug('S='+s);
        
        Integer counter = 0;
        boolean a = false;
        if(s.size() >= 0){
            for(Integer i = s.size()-1; i >= 0 ; i--){                
                r += s[i];
                counter++;
                if(math.mod((counter),3)==0 && i > 0 && counter != 0 && a != true){
                    r += '.';
                }
                System.debug('R='+r.reverse());
            }
        }
        if(r.reverse() == ''){            
            return '0,'+ceros;
        }else{
            String auxT1;
            if(fin != ''){
                auxT1= (r.reverse()+','+ceros+fin);
            }else{
                auxT1 = r.reverse();
            }
            system.debug('auxT1 :'+auxT1); 
            return auxT1;
        }
    }
}