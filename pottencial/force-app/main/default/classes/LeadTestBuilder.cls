/**
 *  @author
 *  @company
 *  @description Build Lead instances for test classes
 *  @lastOnDemand
**/
@isTest
public class LeadTestBuilder implements ITestBuilder {
    private Lead record;

    public LeadTestBuilder(){
         record = new Lead();
    }

    public static LeadTestBuilder build(){
        return new LeadTestBuilder();
    }

    public Lead persist(){
        insert record;
        return record;
    }

    public LeadTestBuilder withMockId() {
        record.Id = fflib_IDGenerator.generate(Lead.SObjectType);
        return this;
    }

    public Lead getInstance(){
        return record;
    }

    public LeadTestBuilder isPreCandidate(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('PreCandidate').getRecordTypeId();
    	record.FirstName='Lead';
        record.LastName=' - 1';
        record.Status='New';
        record.Email='testclass@test.com';
        record.MobilePhone='+5511912345678';
        return this;
    }

    public LeadTestBuilder isDigitalB2CPreSales(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('DigitalB2CPreSales').getRecordTypeId();
    	record.FirstName='Lead';
        record.LastName=' - 1';
        record.Status='New';
        return this;
    }

    public LeadTestBuilder isAdvisor(String cpfcnpj){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectAdvisors').getRecordTypeId();
    	record.FirstName='Lead';
        record.LastName='Advisor '+(Math.random()*1000).intValue().format();
        record.Status='New';
        record.LeadId__c=cpfcnpj;
        return this;
    }
    
    
    public LeadTestBuilder isPMELeadSDR() {
        record.RecordTypeId = LeadsSelector.RECORDTYPE_PME_SDR;
        record.FirstName = 'Lead';
        record.LastName = ' - 1';
        record.Status = 'New';
        record.Email = 'testclass@test.com';
        record.MobilePhone = '+5511912345678';
        return this;
    }

    public LeadTestBuilder isB2C(String cpfcnpj){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectB2C').getRecordTypeId();
    	record.FirstName='Lead';
        record.LastName='Advisor '+(Math.random()*1000).intValue().format();
        record.Status='New';
        record.LeadId__c=cpfcnpj;
        return this;
    }

    public LeadTestBuilder isBTGPlus(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('BTGPlus').getRecordTypeId();
    	record.FirstName='Lead';
        record.LastName=' - 1';
        record.Status='New';
        record.Email='testclass@test.com';
        record.MobilePhone='+5511912345678';
        return this;
    }

    public LeadTestBuilder isSolutions(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Solutions').getRecordTypeId();
        return this;
    }

    public LeadTestBuilder isPMEPartner(){
        record.FirstName = 'Lead PME';
        record.LastName = 'Test';
        record.RecordTypeId = LeadsSelector.RECORDTYPE_PME_PARTNERS;
        record.Title = 'Teste Lead Parceiros';
        record.Company = 'Test Company';
        return this;
    }

    public LeadTestBuilder isPMELead(){
        record.RecordTypeId = LeadsSelector.RECORDTYPE_PME;
    	record.FirstName='Lead';
        record.LastName=' - 1';
        record.Status='New';
        record.Email='testclass@test.com';
        record.MobilePhone='+5511912345678';
        return this;
    }

    public LeadTestBuilder isFOPA(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('FOPA').getRecordTypeId();
        record.Company = 'Company '+(Math.random()*1000).intValue().format();
        return this;
    }

    public LeadTestBuilder isProducts(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Products').getRecordTypeId();
        record.Company = 'Company '+(Math.random()*1000).intValue().format();
        return this;
    }

    public LeadTestBuilder caseId( Case caseId ){
        record.CaseId__c = caseId.Id;
        return this;
    }

    public LeadTestBuilder isRemoteBanking(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('RemoteBank').getRecordTypeId();
        return this;
    }
    public LeadTestBuilder withAcademicDegree( String academicDegree ){
        record.AcademicDegree__c = academicDegree;
        return this;
    }
    public LeadTestBuilder withInterestArea( String interestArea ){
        record.InterestArea__c = interestArea;
        return this;
    }
    public LeadTestBuilder withChatbotStatus( String chatbotStatus ){
        record.ChatbotStatus__c = chatbotStatus;
        return this;
    }
    public LeadTestBuilder withBirthDate( Date birthdate ){
        record.BirthDate__c = birthdate;
        return this;
    }
    public LeadTestBuilder withLastName( String lastName ){
        record.LastName = lastName;
        return this;
    }

    public LeadTestBuilder withEmail( String email ){
        record.Email = email;
        return this;
    }

    public LeadTestBuilder withMobilePhone( String phone ){
        record.MobilePhone = phone;
        return this;
    }

    public LeadTestBuilder withPhone( String phone ){
        record.Phone = phone;
        return this;
    }

    public LeadTestBuilder withCpf( String cpf ){
        record.DocumentId__c = cpf;
        return this;
    }

    public LeadTestBuilder inReprocessing(){
        record.InReprocessing__c = true;
        return this;
    }

    public LeadTestBuilder withLeadId(String leadId){
        record.LeadId__c = leadId;
        return this;
    }

    public LeadTestBuilder withHostCoupon(String hostCoupon){
        record.HostCoupon__c = hostCoupon;
        return this;
    }

    public LeadTestBuilder withStatus(String strStatus){
        record.Status = strStatus;
        return this;
    }

    public LeadTestBuilder withConvertedAccountId(String strAccountId){
        record.ConvertedAccountId = strAccountId;
        return this;
    }

    public LeadTestBuilder IsConverted(Boolean isConverted){
        record = (Lead) fflib_ApexMocksUtils.setReadOnlyFields(
            record,
            Lead.class,
                new Map<SObjectField, Object> {Lead.IsConverted => isConverted}
        );
        return this;
    }

    public LeadTestBuilder withOwner(String strOwnerId){
        record.OwnerId = strOwnerId;
        return this;
    }

    public LeadTestBuilder withProspector(String strProspector){
        record.Prospector__c = strProspector;
        return this;
    }

    public LeadTestBuilder withPersonIndication(String strPersonIndication){
        record.PersonIndication__c = strPersonIndication;
        return this;
    }

    public LeadTestBuilder withDocumentId(String strDocumentId){
        record.DocumentId__c = strDocumentId;
        return this;
    }

    public LeadTestBuilder withCnpj(String cnpj){
        record.CompanyId__c = cnpj;
        return this;
    }

    public LeadTestBuilder withPayload(String payload){
        record.LeadDuplicityPayload__c = payload;
        return this;
    }

    public LeadTestBuilder withAssignedOwnerId(String pStrOwnerId){
        record.AssignedOwner__c = pStrOwnerId;
        return this;
    }

    public LeadTestBuilder isProspectB2BIndicated(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectB2BIndicated').getRecordTypeId();
        return this;
    }

    public LeadTestBuilder withLeadType(String leadType){
        record.LeadType__c = leadType;
        return this;
    }

    public LeadTestBuilder withClimbId(String climbId){
        record.ClimbId__c = climbId;
        return this;
    }

    public LeadTestBuilder withCampaign(String Campaign){
        record.Campaign__c = Campaign;
        return this;
    }

    public LeadTestBuilder isProspectB2BProject(){
        record.FirstName='Lead';
        record.LastName='Prospect B2B Project';
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectB2BProject').getRecordTypeId();
        return this;
    }

    public LeadTestBuilder isSejaBTGSource(){
        record.LeadSource='Seja BTG';
        return this;
    }

    public LeadTestBuilder isProfLucasSilvaSource(){
        record.LeadSource= 'Professor Lucas Silva';
        return this;
    }

    public LeadTestBuilder withSubscriptionDate(Datetime subscriptionDate){
        record.SubscriptionDate__c = subscriptionDate;
        return this;
    }

    public LeadTestBuilder withCGEClient(String CGEClient){
        record.CGEClient__c = CGEClient;
        return this;
    }

    public LeadTestBuilder withMappingBTGMais(String mappingBTGMais){
        record.MappingBTGMais__c = mappingBTGMais;
        return this;
    }

    public LeadTestBuilder withCertification(String certName){
        record.Certifications__c = certName;
        return this;
    }

    public LeadTestBuilder withParners(String partners){
        record.Partners__c = partners;
        return this;
    }

    public LeadTestBuilder withOnboardingID(String OnboardingID){
        record.OnboardingID__c = OnboardingID;
        return this;
    }

    public LeadTestBuilder isWmPf(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectWM').getRecordTypeId();
        return this;
    }

     public LeadTestBuilder isWmPj(){
        record.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ProspectWMCompanies').getRecordTypeId();
        return this;
    }

    public LeadTestBuilder withFeeScheduleLead (String leadId){
        record.FeeSchedule__c = leadId;
        return this;
    }
    public LeadTestBuilder withClientType(String type){
        record.ClientType__c = type;
        return this;
    }

    public LeadTestBuilder withAccountId (String acc){
        record.AccountId__c = acc;
        return this;
    }

}