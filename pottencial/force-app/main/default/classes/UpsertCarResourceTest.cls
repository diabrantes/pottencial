@isTest
public with sharing class UpsertCarResourceTest {
    public static fflib_ApexMocks mocks;
    public static DML mockDML;
    public static UpsertCarService mockUpsertCarService;
    public static LogsService mockLogsService;
    public static Injector mockInjector;

    static {
        mocks = new fflib_ApexMocks();
        mockDML = (DML) mocks.mock(DML.class);
        mockUpsertCarService = (UpsertCarService) mocks.mock(UpsertCarService.class);
        mockLogsService = (LogsService) mocks.mock(LogsService.class);
        mockInjector = (Injector) mocks.mock(Injector.class);

        mocks.startStubbing();
        mocks.when(mockInjector.instantiate(DML.class)).thenReturn(mockDML);
        mocks.when(mockInjector.instantiate(UpsertCarService.class)).thenReturn(mockUpsertCarService);
        mocks.when(mockInjector.instantiate(LogsService.class)).thenReturn(mockLogsService);
        mocks.stopStubbing();

        Injector.mockInjector = mockInjector;
    }

    @isTest
    static void testUpsertCarsSuccess() {
        List<UpsertCarResource.Request> lstRequest = new List<UpsertCarResource.Request>();
        lstRequest.add(buildRequest('123456ABCDE', 'Etanol', '12345A', 'Preto', 'Celta', '015235450', 'ABC-123', 'Regular', 10000));

        List<UpsertCarResource.Response> lstMockResponse = new List<UpsertCarResource.Response>();
        Id sfId = fflib_IDGenerator.generate(Carro__c.SObjectType);
        lstMockResponse.add(buildResponse(sfId, true, null, '123456ABCDE', 'Etanol', '12345A', 'Preto', 'Celta', '015235450', 'ABC-123', 'Regular', 10000));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/upsertCars';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(lstRequest));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        mocks.startStubbing();
            mocks.when(mockUpsertCarService.upsertCars((List<UpsertCarResource.Request>) fflib_Match.anyObject())).thenReturn(lstMockResponse);
        mocks.stopStubbing();

        Test.startTest();
            UpsertCarResource.upsertCars();
        Test.stopTest();

        ((UpsertCarService) mocks.verify(mockUpsertCarService, mocks.times(1))).upsertCars((List<UpsertCarResource.Request>) fflib_Match.anyObject());
    }

    @isTest
    static void testUpsertCarsNullRequest() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/upsertCars';
        req.httpMethod = 'POST';
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
            UpsertCarResource.upsertCars();
        Test.stopTest();

    }

    private static UpsertCarResource.Request buildRequest(String chassi, String combustivel, String renavam, String cor, String modelo, String fabricante, String placa, String situacao, Decimal km) {
        UpsertCarResource.Request req = new UpsertCarResource.Request();
        req.chassi = chassi;
        req.combustivel = combustivel;
        req.renavam = renavam;
        req.cor = cor;
        req.modelo = modelo;
        req.placa = placa;
        req.situacaoVeiculo = situacao;
        req.quilometragem = km;

        return req;
    }

    private static UpsertCarResource.Response buildResponse(Id sfId, Boolean success, String message, String chassi, String combustivel, String renavam, String cor, String modelo, String fabricante, String placa, String situacao, Decimal km) {
        UpsertCarResource.Response resp = new UpsertCarResource.Response();
        resp.chassi = chassi;
        resp.combustivel = combustivel;
        resp.renavam = renavam;
        resp.cor = cor;
        resp.modelo = modelo;
        resp.placa = placa;
        resp.situacaoVeiculo = situacao;
        resp.quilometragem = km;
        resp.success = success;
        resp.salesforceId = sfId;
        resp.mensagem = message;

        return resp;
    }
}