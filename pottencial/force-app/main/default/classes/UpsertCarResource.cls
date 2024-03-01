@RestResource(urlMapping='/upsertCars/*')
global with sharing class UpsertCarResource {
    
    @HttpPut
    global static List<Response> upsertCars() {
        if (RestContext.request.requestBody == null) {
            return null;
        }
        List<Response> lstResponse = new List<Response>();
        Boolean hasException = false;
        String error;

        try {
            String request = RestContext.request.requestBody.toString();
            List<Request> lstRequest = createRequest(request);
            UpsertCarService service = ((UpsertCarService) Injector.getInstance().instantiate(UpsertCarService.class));
            lstResponse = service.upsertCars(lstRequest);
           
            if (lstResponse != null) {
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(lstResponse));
            }
            RestContext.response.statusCode = 200;
        } catch (Exception ex) {
            RestContext.response.statusCode = 500;
            hasException = true;
            error = ex.getMessage() + '. Número da linha com erro: ' + ex.getLineNumber() + '. Classe: ' + ex.getStackTraceString().substringAfter('\n');
        }

        LogsService.addLogRestResource(RestContext.request, RestContext.response, hasException, error);
        
        return lstResponse;
    }
    

    public static List<Request> createRequest(String strRequest) {
        List<Request> lstRequest = new  List<Request>();
        if (strRequest.startsWith('[')) {
            lstRequest = (List<Request>) JSON.deserialize(strRequest, List<Request>.class);
        } else {
            Request req = (Request) JSON.deserialize(strRequest, Request.class);
            lstRequest.add(req);
        }
        return lstRequest;
    }

    global class Request {
        public String chassi;
        public String combustivel;
        public String renavam;
        public String cor;
        public String modelo;
        public String fabricante;
        public String placa;
        public String situacaoVeiculo;
        public Decimal quilometragem;
    }

    global class Response {
        public String chassi;
        public String combustivel;
        public String renavam;
        public String cor;
        public String modelo;
        public String fabricante;
        public String placa;
        public String situacaoVeiculo;
        public Decimal quilometragem;
        public Boolean success;
        public String salesforceId;
        public String mensagem;
    }
}
