/**
*  @author Diego Abrantes
*  @description Test Class for Domain LeadsPartnersService
*  @lastOnDemand 
*  @upd
**/
@isTest
public class LeadsPartnersServiceTest {

    public static fflib_ApexMocks mocks;
    public static DML mockDML;
    public static AccountsSelector mockAccountsSelector;
    public static Injector mockInjector;

    static {
        // Create a new mock provider
        mocks = new fflib_ApexMocks();

        // Create a DML Mock
        mockDML = (DML) mocks.mock(DML.class);

        // Create a LogsSelector Mock
        mockAccountsSelector = (AccountsSelector) mocks.mock(AccountsSelector.class);

        // Create a Injector Mock
        mockInjector = (Injector) mocks.mock(Injector.class);

        // Stub Injector Mock
        mocks.startStubbing();
        mocks.when(mockInjector.instantiate(AccountsSelector.class)).thenReturn(mockAccountsSelector);
        mocks.when(mockInjector.instantiate(DML.class)).thenReturn(mockDML);
        mocks.stopStubbing();

        // Setup the Injector to return the mock injector
        Injector.mockInjector = mockInjector;
    }

    @isTest
    static void testMethd() {

        List<Lead> lstLead = new List<Lead>();
        Map<Id, Lead> mapLeadById = new Map<Id, Lead>(); 
        
        Account leadAccount = AccountTestBuilder.build()
                                                .isPJ()
                                                .withIdNumber('79439863000110')
                                                .withMockId()
                                                .getInstance();
        leadAccount.Id = fflib_IDGenerator.generate(Account.SObjectType);
        List<Account> lstAccount = new List<Account>{ leadAccount };

        // First Lead
        Lead leadPartner = LeadTestBuilder.build()
                                          .isPMEPartner()
                                          .withCpf('79439863000110')
                                          .withParners('[{"firstName":"Fulano Sócio 2","lastName":"Teste"}]')
                                          .withMockId()
                                          .getInstance();

        Lead clonedLead = leadPartner.clone(true, true, false, false);
        clonedLead.OwnerId = fflib_IDGenerator.generate(User.SObjectType);
        leadPartner.Id = fflib_IDGenerator.generate(Lead.SObjectType);
        leadPartner.OwnerId = fflib_IDGenerator.generate(User.SObjectType);
        lstLead.add( leadPartner );
        mapLeadById.put( leadPartner.Id, clonedLead );

        // Second Lead
        Lead leadPartner2 = LeadTestBuilder.build()
                                          .isPMEPartner()
                                          .withCpf('32094997000182')
                                          .withMockId()
                                          .getInstance();

        Lead clonedLead2 = leadPartner2.clone(true, true, false, false);
        clonedLead2.OwnerId = fflib_IDGenerator.generate(User.SObjectType);
        leadPartner2.OwnerId = fflib_IDGenerator.generate(User.SObjectType);
        lstLead.add( leadPartner2 );
        mapLeadById.put( leadPartner2.Id, clonedLead2 );
        
        Set<String> setDocuments = new Set<String>{ '79439863000110', '32094997000182' };
        List<Contact> lstContact = new List<Contact>();
        List<Database.SaveResult> dmlResult = new List<Database.SaveResult>();

        mocks.startStubbing();
        // Mock selector return value
        mocks.when(mockAccountsSelector.selectByIdNumber(setDocuments)).thenReturn(lstAccount);
        mocks.when(mockDML.doInsert(lstContact)).thenReturn(lstContact);

        mocks.stopStubbing();

        Test.startTest();
        LeadsPartnersService serviceClass = new LeadsPartnersService( lstLead );
        serviceClass.checkLeadConversion(lstLead, mapLeadById);
        Test.stopTest();

        List<Contact> testContact = [SELECT Id FROM Contact];
        System.debug('testeContact = ' + testContact);
        
    }
}