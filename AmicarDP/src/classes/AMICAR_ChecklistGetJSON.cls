/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase que deserializa JSON de servicio web "GET" de amicar-assistance
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 01-09-2020            RL	                   Creación de la Clase.
1.1 17-09-2020			  RL					   Se agrega Lista "FnancingEntityInsurance"
***********************************************************************************/

public class AMICAR_ChecklistGetJSON {

	public class FinancingEntityInsurance {
		public Integer id{get;set;}
		public String description{get;set;}
		public Double value{get;set;}
		public Decimal factorCalculated{get;set;}
		public Boolean isRequired{get;set;}
		public Boolean selected{get;set;}
	}

	public List<AmicarAssistance> amicarAssistance{get;set;}
	public List<FinancingEntityInsurance> financingEntityInsurance{get;set;}

	public class AmicarAssistance {
		public Integer id{get;set;}
		public String description{get;set;}
		public Decimal factorCalculated{get;set;}
		public Integer value{get;set;}
		public Boolean isRequired{get;set;}
		public Boolean selected{get;set;}
	}

	
	public static AMICAR_ChecklistGetJSON parse(String json) {
		return (AMICAR_ChecklistGetJSON) System.JSON.deserialize(json, AMICAR_ChecklistGetJSON.class);
	}
}