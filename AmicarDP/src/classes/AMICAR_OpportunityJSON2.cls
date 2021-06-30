/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Rodrigo López (RL)
Proyecto: Amicar
Descripción: Clase Deserializadora de json recibido en AMICAR_ServicioRestOpportunityWS
PD: Sí, si hubo una versión 1 pero esta es la estructura real ;)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 21-10-2020            RL                       Creación de la Clase.
1.1 01-04-2021            RL                       Se agregan campos y secciones nuevas para "Persona Jurídica"
***********************************************************************************/

public class AMICAR_OpportunityJSON2 {
    public LoanSimulationData loanSimulationData {get;set;} 
    public EquivalentAnnualCharge equivalentAnnualCharge {get;set;} 
    public FinalLoanValues finalLoanValues {get;set;} 
    public CustomerRequestData customerRequestData {get;set;} 
    public List<AmortizationSchedule> amortizationSchedule {get;set;} 
    public Expenses expenses {get;set;} 
    public Income income {get;set;} 
    public CustomerActivity customerActivity {get;set;} 
    public OtherIncome otherIncome {get;set;} 
    public IndexaProductsConversion indexaProductsConversion {get;set;} 
    public SpouseData spouseData {get;set;} 
    public List<TaxReturn> taxReturn {get;set;} 
    public TradeInCar tradeInCar {get;set;} 
    public List<MajorityPartners> majorityPartners {get;set;} 
    public List<CustomerSuppliers> customerSuppliers {get;set;} 
    public List<OtherIncome> manualAssignmentLogs {get;set;} 
    public List<SurchargesAndInsurances> surchargesAndInsurances {get;set;} 
    public List<BankInformation> bankInformation {get;set;} 
    public List<PersonalReferences> personalReferences {get;set;} 
    public List<Heritage> heritage {get;set;} 
    public LoanSimulationCar loanSimulationCar {get;set;} 
    public BuyForAnother buyForAnother {get;set;} 
    public List<LegalRepresentative> legalRepresentative;
    public Customer customer {get;set;} 
    public List<Guarantor> guarantor {get;set;} 
    public String token {get;set;} 

    public class LoanSimulationData {
        public Integer id {get;set;} 
        public Integer customerDataId {get;set;} 
        public Integer salesRoomId {get;set;} 
        public Integer ratesId {get;set;} 
        public Integer loanTypeId {get;set;} 
        public Integer salesRepresentativeId {get;set;} 
        public Integer amicarExecutiveId {get;set;} 
        public String status {get;set;} 
        public String dateOfLoanStart {get;set;} 
        public String dateOfFirstDue {get;set;} 
        public Integer daysDelayedFirstDue {get;set;} 
        public Integer term {get;set;} 
        public Integer totalToFinance {get;set;} 
        public Integer downPayment {get;set;} 
        public Integer balance {get;set;} 
        public Integer monthlyPayment {get;set;} 
        public Integer finalCapital {get;set;} 
        public Decimal annualCAE {get;set;} 
        public String externalId {get;set;} 
        public String salesForceSourceId {get;set;} 
        public Integer totalSurchargesToMAF {get;set;} 
        public String campaign {get;set;} 
        public String currencyType {get;set;} 
        public Integer accessories {get;set;} 
        public Integer tradeInCarValue {get;set;} 
        public Decimal dealerRate {get;set;} 
        public Decimal UFValue {get;set;} 
        public Integer totalSurchargesToQuote {get;set;} 
        public Decimal factorTotal {get;set;} 
        public Decimal promissoryFactor {get;set;} 
        public Integer promissoryValue {get;set;} 
        public Decimal totalToFinanceUF {get;set;} 
        public Integer delayedInterest {get;set;} 
        public Integer dealerCommission {get;set;} 
        public Integer amicarCommission {get;set;} 
        public Decimal customerRate {get;set;} 
        public Integer totalLoanCost {get;set;} 
        public Decimal monthlyCAE {get;set;} 
        public Boolean auctionTimeEnded {get;set;} 
        public String auctionTime {get;set;} 
        public String source {get;set;}
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public String idPropietario {get;set;}
        public LoanType LoanType {get;set;} 
        public Rate Rate {get;set;} 
        public SalesRoom SalesRoom {get;set;} 
        public SalesRepresentative salesRepresentative {get;set;} 
        public SalesRepresentative amicarExecutive {get;set;} 
    }

    public class LoanType {
        public Integer id {get;set;} 
        public String description {get;set;} 
        public String cod {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
    }

    public class Rate {
        public Integer id {get;set;} 
        public Integer financingEntityId {get;set;} 
        public Integer rateTypeId {get;set;} 
        public Integer vehicleTypeId {get;set;} 
        public Integer loanTypeId {get;set;} 
        public Integer salesChannelId {get;set;} 
        public Decimal customerRate {get;set;} 
        public Decimal baseRate {get;set;} 
        public Decimal dealerRate {get;set;} 
        public Integer termsFrom {get;set;} 
        public Integer termsTo {get;set;} 
        public Decimal amountFinancedFrom {get;set;} 
        public Decimal amountFinancedTo {get;set;} 
        public Integer fee {get;set;} 
        public Integer highlight {get;set;} 
        public Boolean immediateOption {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public RateType RateType {get;set;} 
    }
    
    public class RateType {
        public Integer id {get;set;} 
        public String description {get;set;} 
        public String cod {get;set;} 
    }
    
    public class SalesRoom {
        public Integer id {get;set;} 
        public Integer salesChannelId {get;set;} 
        public String name {get;set;} 
        public String address {get;set;} 
        public List<Decimal> latLong {get;set;} 
        public String type {get;set;} // in json: type
        public Integer legacyId {get;set;} 
        public Integer supervisorId {get;set;} 
        public String supervisorName {get;set;} 
        public String zone {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public SalesChannel SalesChannel {get;set;} 
    }

    public class SalesChannel {
        public Integer id {get;set;} 
        public Integer identificationTypeId {get;set;} 
        public Integer salesChannelTypeId {get;set;} 
        public String identificationValue {get;set;} 
        public String description {get;set;} 
        public String apiKey {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public SalesChannelType SalesChannelType {get;set;} 
    }

    public class SalesChannelType {
        public Integer id {get;set;} 
        public String description {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class CustomerSuppliers {
        public Integer id {get;set;} 
        public Integer loanApplicationId {get;set;} 
        public String name {get;set;} 
        public String phone {get;set;} 
        public String relationship {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
    }

    public class SalesRepresentative {
        public Integer id {get;set;} 
        public String fullName {get;set;} 
        public String rut {get;set;} 
        public String gender {get;set;} 
        public String phone {get;set;} 
        public String position {get;set;} 
        public Boolean status {get;set;} 
        public String birthdate {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class EquivalentAnnualCharge {
        public Decimal annualCAE {get;set;} 
        public Decimal monthlyCAE {get;set;} 
        public Integer totalLoanCost {get;set;} 
    }

    public class FinalLoanValues {
        public Integer loanTypeId {get;set;} 
        public Integer term {get;set;} 
        public Integer balance {get;set;} 
        public Decimal UFValue {get;set;} 
        public Integer totalSurchargesToMAF {get;set;} 
        public Integer totalSurchargesToQuote {get;set;} 
        public Decimal factorTotal {get;set;} 
        public Decimal promissoryFactor {get;set;} 
        public Integer promissoryValue {get;set;} 
        public Integer totalToFinance {get;set;} 
        public Decimal totalToFinanceUF {get;set;} 
        public Integer finalCapital {get;set;} 
        public Integer daysDelayedFirstDue {get;set;} 
        public Integer delayedInterest {get;set;} 
        public Integer monthlyPayment {get;set;} 
        public Decimal customerRate {get;set;} 
        public Integer dealerCommission {get;set;} 
        public Integer amicarCommission {get;set;} 
    }

    public class AmortizationSchedule {
        public Integer id {get;set;} 
        public Integer loanSimulationDataId {get;set;} 
        public Integer paymentNumber {get;set;} 
        public String expirationDate {get;set;} 
        public Integer daysBetweenExpirationsDates {get;set;} 
        public Integer payment {get;set;} 
        public Integer beginningBalance {get;set;} 
        public Integer principal {get;set;} 
        public Integer interest {get;set;} 
        public Integer endingBalance {get;set;} 
        public Integer cumulativeInterest {get;set;} 
        public String quotaType {get;set;} 
        public Integer totalSurchargesToQuote {get;set;} 
        public Integer finalPayment {get;set;} 
    }

    public class Income {
        public Integer salary {get;set;} 
        public Integer honorarium {get;set;} 
        public Integer retirementSalary {get;set;} 
        public Integer pensionSalary {get;set;} 
        public Integer rentalIncome {get;set;} 
        public Integer otherIncome {get;set;} 
        public String descriptionForOtherIncome {get;set;} 
    }

    public class Expenses {
        public Integer mortgageCost {get;set;} 
        public Integer otherFixedExpenses {get;set;} 
    }

    public class IndexaProductsConversion {
        public Integer id {get;set;} 
        public Integer rateTypeId {get;set;} 
        public Integer vehicleTypeId {get;set;} 
        public Integer loanTypeId {get;set;} 
        public Integer salesChannelId {get;set;} 
        public Boolean immediateOption {get;set;} 
        public Integer indexaId {get;set;} 
        public String indexaName {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class Customer {
        public Integer id {get;set;} 
        public String identificationValue {get;set;} 
        public Integer identificationTypeId {get;set;} 
        public String documentSerialNumber {get;set;} 
        public String name {get;set;} 
        public String lastName {get;set;} 
        public String motherLastName {get;set;} 
        public String email {get;set;} 
        public String phone {get;set;} 
        public String address {get;set;} 
        public String latLong {get;set;} 
        public String dob {get;set;} 
        public String nationality {get;set;} 
        public Integer geographicDataId {get;set;} 
        public String gender {get;set;} 
        public String companyName {get;set;}
        public Integer businessSectorId {get;set;}
        public String businessSectorDescription {get;set;}
        public Integer numberOfWorkers {get;set;}
        public String workPhone {get;set;}
        public String contactName {get;set;}
        public String contactWorkPosition {get;set;}
        public String contactPhone {get;set;}
        public String contactWorkPhone {get;set;}
        public String contactEmail {get;set;}
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public GeographicData geographicData {get;set;} 
        public TypeData nationalityData {get;set;} 
        public TypeData genderData {get;set;} 
        public Model businessSectorData{get;Set;}
    }
    
    public class OtherIncome {
        public Integer year{get;set;}
        public Integer folioNumber{get;set;}
        public Decimal code18{get;set;}
        public Decimal code36{get;set;}
        public Decimal code158{get;set;}
        public Decimal code305{get;set;}
        public Decimal code611{get;set;}
        public Decimal code170{get;set;}
        public Decimal code25{get;set;}
        public Decimal code628{get;set;}
        public Decimal code636{get;set;}
        public Decimal code461{get;set;}
        public Decimal code545{get;set;}
    }

    public class MajorityPartners {
        public Integer id {get;set;} 
        public Integer loanApplicationId {get;set;} 
        public String identificationValue {get;set;} 
        public String name {get;set;} 
        public String address {get;set;} 
        public String phone {get;set;} 
        public String profession {get;set;} 
        public Integer houseAppraisal {get;set;} 
        public Integer vehicleAppraisal {get;set;} 
        public Integer participationPercentage {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
    }

    public class SurchargesAndInsurances {
        public Integer id {get;set;} 
        public String description {get;set;} 
        public Decimal value {get;set;} 
        public Boolean valueToMAF {get;set;} 
        public String calculateFormulae {get;set;} 
        public Boolean calculateCommissionFinancialEntity {get;set;} 
        public Boolean isEditable {get;set;} 
        public Boolean calculateCommissionDealer {get;set;} 
        public Boolean calculateCommissionFnI {get;set;} 
        public String currencyType {get;set;} 
        public Boolean isRequired {get;set;} 
        public Boolean selected {get;set;} 
        public String type {get;set;} // in json: type
        public Integer idRef {get;set;} 
        public String insuranceType {get;set;} 
        public Decimal factorCalculated {get;set;} 
        public Integer legacyId {get;set;}
    }
    
    public class PersonalReferences {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public String type {get;set;} // in json: type
        public String address {get;set;} 
        public String phone {get;set;} 
        public TypeData typeData {get;set;} 
    }

    public class TypeData {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public Integer parentId {get;set;} 
        public String internalCode {get;set;} 
        public String externalCode {get;set;} 
        public String type {get;set;} // in json: type
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class BankInformation {
        public Integer codeId {get;set;} 
        public Boolean automaticPayment {get;set;} 
        public String accountNumber {get;set;} 
        public String externalCode {get;set;} 
        public String name {get;set;} 
    }
    
    public class CustomerRequestData {
        public TypeData maritalStatus {get;set;} 
        public TypeData maritalRegime {get;set;} 
        public TypeData academicLevel {get;set;} 
        public TypeData livingHousehold {get;set;} 
        public String profession {get;set;} 
        public String generalComments {get;set;} 
        public String yearsOfResidence {get;set;} 
        public String monthsOfResidence {get;set;} 
        public String numberOfChildren {get;set;} 
    }

    public class Heritage {
        public String type {get;set;} // in json: type
        public String description {get;set;} 
        public Integer saleValue {get;set;} 
        public String financing {get;set;} 
        public Boolean stillPaying {get;set;} 
        public List<TypeData> typeData {get;set;} 
        public String typeDescription {get;set;} 
        public String typeExternalCode {get;set;} 
        public String financingTypeDescription {get;set;} 
        public String financingTypeExternalCode {get;set;} 
        public TypeData financingTypeData {get;set;} 
    }

    public class LoanSimulationCar {
        public Integer id {get;set;} 
        public Integer loanSimulationDataId {get;set;} 
        public Integer vehicleTypeId {get;set;} 
        public Integer carBrandId {get;set;} 
        public String carBrandDescription {get;set;} 
        public Integer carModelId {get;set;} 
        public String carModelDescription {get;set;} 
        public String carVersion {get;set;} 
        public Integer year {get;set;} 
        public Integer price {get;set;} 
        public String additionalDescription {get;set;} 
        public String licensePlate {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public VehicleType VehicleType {get;set;} 
        public Model Model {get;set;} 
        public Brand Brand {get;set;} 
    }

    public class Model {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public Integer parentId {get;set;} 
        public String internalCode {get;set;} 
        public String externalCode {get;set;} 
        public String type {get;set;} // in json: type
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class Brand {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public Integer parentId {get;set;} 
        public String internalCode {get;set;} 
        public String externalCode {get;set;} 
        public String type {get;set;} // in json: type
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class Guarantor {
        public Integer identificationTypeId {get;set;}
        public String identificationValue {get;set;} 
        public String name {get;set;} 
        public String lastName {get;set;} 
        public String motherLastName {get;set;} 
        public String address {get;set;} 
        public String dob {get;set;} 
        public String maritalStatus {get;set;} 
        public String maritalRegime {get;set;} 
        public String workType {get;set;} 
        public Integer salary {get;set;} 
        public Integer geographicDataId {get;set;} 
        public Integer nationalityId {get;set;} 
        public Integer activityTypeId {get;set;} 
        public String documentSerialNumber {get;set;} 
        public String phone {get;set;} 
        public String workPhone {get;set;} 
        public String email {get;set;} 
        public String gender {get;set;} 
        public String academicLevel {get;set;} 
        public String livingHousehold {get;set;} 
        public String workEntryDate {get;set;} 
        public String employerIdentificationTypeId {get;set;} 
        public String employerIdentificationValue {get;set;} 
        public String employerName {get;set;} 
        public String employerAddress {get;set;} 
        public String businessSectorId {get;set;} 
        public String employerPhone {get;set;} 
        public String employmentContractType {get;set;} 
        public String salaryType {get;set;} 
        public String salaryPayday {get;set;} 
        public String mortgageCost {get;set;} 
        public String previousEmployerName {get;set;} 
        public String previousEmployerPhone {get;set;} 
        public String previousEmployerSeniority {get;set;} 
        public String yearsOfResidence {get;set;} 
        public String monthsOfResidence {get;set;} 
        public String numberOfChildren {get;set;} 
        public TypeData maritalStatusData {get;set;} 
        public TypeData maritalRegimeData {get;set;} 
        public GeographicData geographicData {get;set;} 
        public TypeData nationalityData {get;set;} 
        public TypeData workTypeData {get;set;} 
        public ActivityTypeData activityTypeData {get;set;} 
    }

    public class GeographicData {
        public Model COMMUNE {get;set;} 
        public Model REGION {get;set;} 
        public TypeData COUNTRY {get;set;} 
    }

    public class LegalRepresentative {
        public Integer id {get;set;} 
        public Integer loanApplicationId {get;set;} 
        public String identificationValue {get;set;} 
        public String name {get;set;} 
        public Integer activityTypeId {get;set;} 
        public String phone {get;set;} 
        public String address {get;set;} 
        public Integer geographicDataId {get;set;} 
        public Boolean isGuarantor {get;set;} 
        public String maritalStatus {get;set;} 
        public String email {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public TypeData maritalStatusData {get;set;} 
        public GeographicData geographicData {get;set;} 
    }

    public class BuyForAnother {
        public String identificationValue {get;set;} 
        public String name {get;set;} 
        public String lastName {get;set;} 
        public String motherLastName {get;set;} 
        public String address {get;set;} 
        public String dob {get;set;} 
        public String maritalStatus {get;set;} 
        public String maritalRegime {get;set;} 
        public Integer geographicDataId {get;set;} 
        public Integer nationalityId {get;set;} 
        public TypeData maritalStatusData {get;set;} 
        public TypeData maritalRegimeData {get;set;} 
        public TypeData nationalityData {get;set;} 
        public GeographicData geographicData {get;set;} 
    }

    public class ActivityTypeData {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public Integer parentId {get;set;} 
        public String internalCode {get;set;} 
        public String externalCode {get;set;} 
        public String type {get;set;} // in json: type
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }

    public class CustomerActivity {
        public Integer id {get;set;} 
        public Integer loanSimulationDataId {get;set;} 
        public TypeData workType {get;set;} 
        public Integer activityTypeId {get;set;} 
        public String workPosition {get;set;} 
        public String workEntryDate {get;set;} 
        public String employerName {get;set;} 
        public Integer employerIdentificationTypeId {get;set;} 
        public String employerIdentificationValue {get;set;} 
        public Integer businessSectorId {get;set;} 
        public String workAddress {get;set;} 
        public Integer workGeographicDataId {get;set;} 
        public String workPhone {get;set;} 
        public TypeData employmentContractType {get;set;} 
        public TypeData salaryType {get;set;} 
        public Integer salaryPayday {get;set;} 
        public String previousEmployerName {get;set;} 
        public String previousEmployerPhone {get;set;} 
        public String previousEmployerSeniority {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
        public GeographicData workGeographicData {get;set;} 
        public Model activityType {get;set;} 
        public Model businessSector {get;set;} 
    }
        
    public class VehicleType {
        public Integer id {get;set;} 
        public String description {get;set;} 
        public String cod {get;set;} 
        public String name {get;set;} 
        public Integer parentId {get;set;} 
        public String internalCode {get;set;} 
        public String externalCode {get;set;} 
        public String type {get;set;} // in json: type
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public String deletedAt {get;set;} 
    }
    
    public class SpouseData {
        public Integer identificationType {get;set;} 
        public String identificationValue {get;set;} 
        public String name {get;set;} 
        public String lastName {get;set;} 
        public String motherLastName {get;set;} 
        public Integer activityTypeId {get;set;} 
        public String address {get;set;} 
        public TypeData workType {get;set;} 
        public String employerName {get;set;} 
        public String workPhone {get;set;} 
        public Boolean combinedIncome {get;set;} 
        public Integer salary {get;set;} 
        public Integer spouseGeographicDataId {get;set;} 
        public GeographicData spouseGeographicData {get;set;} 
        public Model activityType {get;set;} 
    }
    
    public class TradeInCar {
        public Integer id {get;set;} 
        public Integer loanSimulationDataId {get;set;} 
        public Integer vehicleTypeId {get;set;} 
        public Integer carBrandId {get;set;} 
        public String carBrandDescription {get;set;} 
        public Integer carModelId {get;set;} 
        public String carModelDescription {get;set;} 
        public String carVersion {get;set;} 
        public Integer year {get;set;} 
        public Integer price {get;set;} 
        public String additionalDescription {get;set;} 
        public String licensePlate {get;set;} 
        public Integer mileage {get;set;} 
        public Integer prepaidAmount {get;set;} 
        public String singlePatentPlate {get;set;} 
        public String createdAt {get;set;} 
        public String updatedAt {get;set;} 
        public VehicleType VehicleType {get;set;} 
        public Model Model {get;set;} 
        public Brand Brand {get;set;} 
    }
    
    public class TaxReturn {
        public String dateTax{get;set;}
        public Integer purchaseTax{get;set;}
        public Integer salesTax{get;set;}
    }   

    public static AMICAR_OpportunityJSON2 parse(String json) {
        return (AMICAR_OpportunityJSON2) System.JSON.deserialize(json, AMICAR_OpportunityJSON2.class);
    }
}