public class AMICAR_sincromodificadaWSJSON {

    public class FinancingEntityInsurance {
        public String currencyType;
        public String description;
        public Integer id;
        public Boolean isRequired;
        public Boolean selected;
        public Double value;
        //public Integer factorCalculated;
        public Double factorCalculated;
    }

	public class AmortizationSchedule {
		public Integer beginningBalance;
		public Integer cumulativeInterest;
		public Integer daysBetweenExpirationsDates;
		public Integer endingBalance;
		public String expirationDate;
		public Integer interest;
		public Integer payment;
		public Integer paymentNumber;
		public Integer principal;
		public String quotaType;
	}

	public class EquivalentAnnualCharge {
		public Double annualCAE;
		public Double monthlyCAE;
		public Integer totalLoanCost;
	}

	public class SurchargesAndInsurances {
		public List<AmicarAssistance> amicarAssistance;
		public List<DealerInsurance> dealerInsurance;
		public List<DealerSurcharges> dealerSurcharges;
		public List<FinancingEntityInsurance> financingEntityInsurance;
		public List<DealerSurcharges> financingEntitySurcharges;
	}

	public class AmicarAssistance {
		public String currencyType;
		public String description;
		public Integer factorCalculated;
		public Integer id;
		public Boolean isRequired;
		public Boolean selected;
		public Integer value;
	}

	public class FinalLoanValues {
		public Double UFValue;
		public Integer amicarCommission;
		public Integer balance;
		public Double customerRate;
		public Integer daysDelayedFirstDue;
		public Integer dealerCommission;
		public Double dealerRate;
		public Integer delayedInterest;
		public Double downPaymentPercentage;
		public Double factorTotal;
		public Integer finalCapital;
		public String loanType;
		public Integer monthlyPayment;
		public Double promissoryFactor;
		public Integer promissoryValue;
		public Integer term;
		public Integer totalSurchargesToMAF;
		public Integer totalSurchargesToQuote;
		public Integer totalToFinance;
		public Double totalToFinanceUF;
	}

	public class DealerInsurance {
	}

	public List<AmortizationSchedule> amortizationSchedule;
	public EquivalentAnnualCharge equivalentAnnualCharge;
	public FinalLoanValues finalLoanValues;
	public Integer simulationId;
	public SurchargesAndInsurances surchargesAndInsurances;

	public class DealerSurcharges {
		public String currencyType;
		public String description;
		public Integer factorCalculated;
		public Integer id;
		public Boolean isEditable;
		public Boolean isRequired;
		public Boolean selected;
		public Integer value;
	}

	
	public static AMICAR_sincromodificadaWSJSON parse(String json) {
		return (AMICAR_sincromodificadaWSJSON) System.JSON.deserialize(json, AMICAR_sincromodificadaWSJSON.class);
	}
}