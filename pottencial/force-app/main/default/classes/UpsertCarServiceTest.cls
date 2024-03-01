@isTest
private class UpsertCarServiceTest {
    private static fflib_ApexMocks mocks = new fflib_ApexMocks();
    public static AccountsSelector mockAccountsSelector;
    public static Injector mockInjector;
    public static DML mockDML;

    static {
        mocks = new fflib_ApexMocks();
        mockAccountsSelector = (AccountsSelector) mocks.mock(AccountsSelector.class);
        mockInjector = (Injector) mocks.mock(Injector.class);
        mockDML = (DML) mocks.mock(DML.class);

        mocks.startStubbing();
        mocks.when(mockInjector.instantiate(DML.class)).thenReturn(mockDML);
        mocks.when(mockInjector.instantiate(AccountsSelector.class)).thenReturn(mockAccountsSelector);
        mocks.stopStubbing();

        Injector.mockInjector = mockInjector;
    }

    @isTest
    static void testUpsertCarsSuccess() {
        List<UpsertCarResource.Request> lstRequest = new List<UpsertCarResource.Request>();
        lstRequest.add(UpsertCarResourceTest.buildRequest('123456ABCDE', 'Etanol', '12345A', 'Preto', 'Celta', '015235450', 'ABC-123', 'Regular', 10000));
        lstRequest.add(UpsertCarResourceTest.buildRequest('123456ABCDE23124312', 'Etanol', '12345A', 'Branco', 'Prisma', '015235450', 'ABC-123', 'Regular', 10000));

        Account mockAccount = AccountTestBuilder.build().withMockId().withIdentifier('015235450').getInstance();

        String dmlResult = '[{"id":"'+ fflib_IDGenerator.generate(Carro__c.SOBjectType) +'","success":true,"errors":[],"created":false}, {"id":"","success":false,"errors":[{"statusCode":"ERROR", "message":"TEST ERROR"}],"created":false}]';

        List<Database.UpsertResult> upsertResult = (List<Database.UpsertResult>) JSON.deserialize(dmlResult, List<Database.UpsertResult>.class);

        mocks.startStubbing();
            mocks.when(mockAccountsSelector.selectByIdentifier((Set<String>) fflib_Match.anyObject())).thenReturn(new List<Account>{mockAccount});
            mocks.when(mockDML.doUpsert((List<SObject>) fflib_Match.anyObject(), (Schema.SObjectField) fflib_Match.anyObject(), fflib_Match.anyBoolean())).thenReturn(upsertResult);
        mocks.stopStubbing();

        Test.startTest();
            //UpsertCarService serviceClass = ((UpsertCarService) Injector.getInstance().instantiate(UpsertCarService.class));
            UpsertCarService serviceClass = new UpsertCarService();
            List<UpsertCarResource.Response> lstResponse = serviceClass.upsertCars(lstRequest);
        Test.stopTest();

        ((AccountsSelector) mocks.verify(mockAccountsSelector, mocks.times(1))).selectByIdentifier((Set<String>) fflib_Match.anyObject());
        ((DML) mocks.verify(mockDML, mocks.times(1))).doUpsert((List<SObject>) fflib_Match.anyObject(), (Schema.SObjectField) fflib_Match.anyObject(), fflib_Match.anyBoolean());
    }
}
