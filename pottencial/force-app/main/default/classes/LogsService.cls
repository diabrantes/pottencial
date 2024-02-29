public without sharing class LogsService {

    public static void addLogRestResource(RestRequest request, RestResponse response, Boolean hasException, String error) {
        Log__c log = new Log__c();
        log.Endpoint__c = request != null ? request.requestURI : '';
        log.Request__c = request.requestBody.toString();
        log.StatusCode__c = RestContext.response.statusCode;
        log.Response__c = response.responseBody.toString();
        log.Exception__c = hasException;
        log.Error__c = error;

        ((DML) Injector.getInstance().instantiate(DML.class)).doInsert(new List<Log__c>{log});
    }
}