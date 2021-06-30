/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase que deserializa JSON de servicio web "PUT" de amicar-assistance
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 28-08-2020            RL	                   Creación de la Clase.
1.1 16-09-2020			  RL					   Se agrega campo Boolean "preselected" en las estructuras para deserializar servicio assistance-insurance
1.2
***********************************************************************************/

public class AMICAR_ChecklistPutJSON {
	
	public FinalLoanValues finalLoanValues{get;set;}
	public EquivalentAnnualCharge equivalentAnnualCharge{get;set;}
	public List<AmortizationSchedule> amortizationSchedule{get;set;}
	public SurchargesAndInsurances surchargesAndInsurances{get;set;}

    public class FinancingEntityInsurance {
		public Integer id{get;set;}
		public String description{get;set;}
		public String insuranceType{get;set;}
		public Decimal value{get;set;}
		public Boolean valueToMAF{get;set;}
		public String calculateFormulae{get;set;}
		public Boolean calculateCommissionFinancialEntity{get;set;}
		public Boolean calculateCommissionDealer{get;set;}
		public Boolean calculateCommissionFnI{get;set;}
		public String currencyType{get;set;}
		public Boolean isRequired{get;set;}
		public Boolean preselected{get;set;}
		public Decimal financingEntityId{get;set;}
		public Decimal amountFrom{get;set;}
		public Decimal amountTo{get;set;}
		public String amountFilter{get;set;}
		public String amountFilterCurrencyType{get;set;}
		public Boolean selected{get;set;}
		public Decimal factorCalculated{get;set;}
	}

	public class AmortizationSchedule {
		public Decimal paymentNumber{get;set;}
		public String expirationDate{get;set;}
		public Decimal daysBetweenExpirationsDates{get;set;}
		public String quotaType{get;set;}
		public Decimal payment{get;set;}
		public Decimal beginningBalance{get;set;}
		public Decimal principal{get;set;}
		public Decimal interest{get;set;}
		public Decimal endingBalance{get;set;}
		public Decimal cumulativeInterest{get;set;}
	}

	public class EquivalentAnnualCharge {
		public Decimal annualCAE{get;set;}
		public Decimal monthlyCAE{get;set;}
		public Decimal totalLoanCost{get;set;}
	}

	public class SurchargesAndInsurances {
		public List<AmicarAssistance> amicarAssistance{get;set;}
		public List<DealerSurcharges> dealerSurcharges{get;set;}
		public List<DealerInsurance> dealerInsurance{get;set;}
		public List<FinancingEntitySurcharges> financingEntitySurcharges{get;set;}
		public List<FinancingEntityInsurance> financingEntityInsurance{get;set;}
	}

	public class AmicarAssistance {
		public Integer id{get;set;}
		public String description{get;set;}
		public Decimal value{get;set;}
		public Boolean valueToMAF{get;set;}
		public String calculateFormulae{get;set;}
		public Boolean calculateCommissionFinancialEntity{get;set;}
		public Boolean calculateCommissionDealer{get;set;}
		public Boolean calculateCommissionFnI{get;set;}
		public String currencyType{get;set;}
		public Boolean isRequired{get;set;}
		public Decimal financingEntityId{get;set;}
		public Boolean preselected{get;set;}
		public Boolean selected{get;set;}
		public Decimal factorCalculated{get;set;}
	}

	public class FinalLoanValues {
		public String loanType{get;set;}
		public String rateType{get;set;}
		public Decimal term{get;set;}
		public Decimal balance{get;set;}
		public Decimal downPaymentPercentage{get;set;}
		public Decimal UFValue{get;set;}
		public Decimal totalSurchargesToMAF{get;set;}
		public Decimal totalSurchargesToQuote{get;set;}
		public Decimal factorTotal{get;set;}
		public Decimal promissoryFactor{get;set;}
		public Decimal promissoryValue{get;set;}
		public Decimal totalToFinance{get;set;}
		public Decimal totalToFinanceUF{get;set;}
		public Decimal finalCapital{get;set;}
		public Decimal daysDelayedFirstDue{get;set;}
		public Decimal delayedInterest{get;set;}
		public Decimal monthlyPayment{get;set;}
		public Decimal customerRate{get;set;}
		public Decimal dealerRate{get;set;}
		public Decimal dealerCommission{get;set;}
		public Decimal amicarCommission{get;set;}
	}

	public class DealerInsurance {
	}

	public class FinancingEntitySurcharges {
		public Integer id{get;set;}
		public String description{get;set;}
		public Decimal value{get;set;}
		public Boolean valueToMAF{get;set;}
		public String calculateFormulae{get;set;}
		public Boolean calculateCommissionFinancialEntity{get;set;}
		public Boolean isEditable{get;set;}
		public Boolean calculateCommissionDealer{get;set;}
		public Boolean calculateCommissionFnI{get;set;}
		public String currencyType{get;set;}
		public Boolean isRequired{get;set;}
		public Boolean preselected{get;set;}
		public Decimal financingEntityId{get;set;}
		public Boolean selected{get;set;}
		public Decimal factorCalculated{get;set;}
	}

	public class DealerSurcharges {
		public Integer id{get;set;}
		public String description{get;set;}
		public Decimal value{get;set;}
		public Boolean valueToMAF{get;set;}
		public String calculateFormulae{get;set;}
		public Boolean calculateCommissionFinancialEntity{get;set;}
		public Boolean isEditable{get;set;}
		public Boolean calculateCommissionDealer{get;set;}
		public Boolean calculateCommissionFnI{get;set;}
		public String currencyType{get;set;}
		public Boolean isRequired{get;set;}
		public Boolean preselected;
		public Boolean selected{get;set;}
		public Decimal factorCalculated{get;set;}
	}

    
    public static AMICAR_ChecklistPutJSON parse(String json) {
        return (AMICAR_ChecklistPutJSON) System.JSON.deserialize(json, AMICAR_ChecklistPutJSON.class);
    }
}