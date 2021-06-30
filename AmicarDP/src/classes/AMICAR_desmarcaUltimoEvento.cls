/**********************************************************************************
  Desarrollado por: Cloud Solutions
  Autor: Robinson Silva (RSI)
  Proyecto: AMICAR
  Descripción: Cada vez que se crea un evento asociado a un credito, desmarca el check box ultimo evento de los
  reguistros antiguos.
  Test: 
  ---------------------------------------------------------------------------------
  No. Fecha                Autor                     Descripción
  ------ ---------- ---------------------------------------------------------------
  1.0 28-05-2020            RSI                   Creación de la Clase.
  ********************************************************************************/



public class AMICAR_desmarcaUltimoEvento {
    @InvocableMethod(label = 'Desmarca Check' description = 'desmarca el check de los eventos antiguos asociados a creditos')
    public static void desmarcaCheck(List<Event> listaEventos) {

        List<Event> listaUPD = new List<Event> ();

        for (Event evento : listaEventos) {

            List<Event> lista = [select Id, Ultimo_Evento__c
                                 FROM Event
                                 WHERE WhatId = :evento.WhatId AND Id != :evento.Id];
            for (Event obj : lista) {
                obj.Ultimo_Evento__c = false;
                listaUPD.add(obj);

            }
        }


        if (listaUPD.size() > 0) {
            update listaUPD;
        }
    }
}