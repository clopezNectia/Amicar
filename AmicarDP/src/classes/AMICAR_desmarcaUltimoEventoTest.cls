@isTest
public class AMICAR_desmarcaUltimoEventoTest {
    @isTest
    private static void test01(){
        RecordType registro = [select id, name from recordType where name='Credito Renovaciones'];
        RecordType regCuenta = [select id, name from recordType where name='Cliente Persona'];
        Account account = new Account(        
            LastName = 'Norambuena',
            FirstName = 'Marcelo',
            Salutation = 'Mr.',
            RecordTypeId = regCuenta.Id,
            ShippingStreet = 'Rogelio Ugarte 1746',
            ShippingCity = 'Santiago',
            ShippingCountry = 'Chile',
            PersonMobilePhone = '+56983537065',
            PersonEmail = 'mnorambuena@nectia.com',
            PersonHasOptedOutOfEmail = true,
            PersonDoNotCall = true,
            Situaci_n_Laboral__c = 'Trabajando',
            N_10__c = false,
            N_111__c = false,
            N_11__c = false,
            N_1__c = true,
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
            RUT__c = '18874834-1',
            et4ae5__HasOptedOutOfMobile__pc = false,
            et4ae5__Mobile_Country_Code__pc = 'US',
            Fecha_de_ingreso__pc = Date.newInstance(2020,03,02),
            Renta__pc = 600000.0,
            Empleador__pc = 'Nectia',
            Cargo__pc = 'Consultor');
        insert account;
        
        Asset asset = new Asset(
            AccountId = account.id,
            IsCompetitorProduct = false,
            Name = 'Credito1Prueba',
            SerialNumber = '0123456789',
            RecordTypeId = registro.Id,
            Fecha_de_Vencimiento_Cuoton__c = Date.newInstance(2020,04,30),
            Nombre_EF__c = 'CMR FALABELLA',
            Concesionario__c = '69',
            Egresos__c = 100000.0,
            Estado_Cierre__c = 'VIGENTE',
            Estado_Solicitud__c = 'APROBADA',
            Estado_cr_dito__c = 'PREPAGADO',
            Fecha_ingreso_empleo__c = Date.newInstance(2020,03,11),
            Fecha_ltima_Cuota__c = Date.newInstance(2020,06,19),
            Id_Credito__c = '700293',
            Importadores__c = '829957000',
            Local__c = '2 ANFRUNS SANTIAGO',
            Marca_Veh_culo__c = 'MAZDA',
            Respuesta_EF__c = 'Preaprobado',
            Sueldo_Liquido__c = 600000.0,
            Tipo_de_Contrato__c = 'Plazo Fijo',
            Tipo_de_Credito__c = 'Compra Inteligente',
            Total_a_Financiar__c = 1000000.0,
            EF_Original__c = 'Santander',
            Ejecutivo_Call__c = 'Jocelyn Umaña',
            Preevaluacion_EF__c = 'Preaprobado',
            Fecha_Hora_Ultimo_Evento__c = DateTime.newInstance(2020,6,5,20,1219,73190));
        insert asset;
       
            RecordType regEvent=[select id,name from recordType where name='Evento Renovaciones'];
        Event event = new Event(
            Subject ='Prueba Evento Desarrollo',
            Estado_de_Actividad__c = 'CONTACTADO',
            StartDateTime = DateTime.newInstance(2020,6,5,20,1219,73190),
            EndDateTime = DateTime.newInstance(2020,6,6,20,1219,73190),
            WhatId = asset.id,
            RecordTypeId=regEvent.Id);
        insert event;
         Event event2 = new Event(
            Subject ='Prueba Evento Desarrollo',
            Estado_de_Actividad__c = 'CONTACTADO',
            StartDateTime = DateTime.newInstance(2020,6,5,20,1219,73190),
            EndDateTime = DateTime.newInstance(2020,6,6,20,1219,73190),
            WhatId = asset.id,
            RecordTypeId=regEvent.Id);
        insert event2;
        List<Event> listaEventos=new List<Event>();
        listaEventos.add(event2);
        AMICAR_desmarcaUltimoEvento.desmarcaCheck(listaEventos);

        
    }
    
}