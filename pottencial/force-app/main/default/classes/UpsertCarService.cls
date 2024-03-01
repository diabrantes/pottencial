public with sharing class UpsertCarService {
    private static List<UpsertCarResource.Response> lstResponse = new List<UpsertCarResource.Response>();

    public List<UpsertCarResource.Response> upsertCars(List<UpsertCarResource.Request> lstRequest) {
        Map<String, Integer> mapIndex = new Map<String, Integer>();
        Set<String> setAccountIdentifiers = new Set<String>();
        Map<String, Account> mapAccountByIdentifier = new Map<String, Account>();
        List<Carro__c> lstCarsToUpsert = new List<Carro__c>();
        
        // Montagem da lista de retorno e do set de identificadores das Accounts
        for (Integer index=0; index < lstRequest.size(); index++) {
            UpsertCarResource.Request request = lstRequest[index];
            UpsertCarResource.Response response= assembleResponse(request);
            lstResponse.add(response);
            mapIndex.put(request.chassi, index);
            setAccountIdentifiers.add(request.fabricante);
        }

        // Busca das Accounts existentes
        if (setAccountIdentifiers != null && !setAccountIdentifiers.isEmpty()) {
            List<Account> lstAccounts = ((AccountsSelector) Injector.getInstance().instantiate(AccountsSelector.class)).selectByIdentifier(setAccountIdentifiers);

            if (lstAccounts != null && !lstAccounts.isEmpty()) {
                for (Account iAccount : lstAccounts) {
                    mapAccountByIdentifier.put(iAccount.Identificador__c, iAccount);
                }
            }
        }

        // Montagem do objeto Carro__c
        for (UpsertCarResource.Request req : lstRequest) {
            Carro__c car = new Carro__c();
            car.Chassi__c = req.chassi;
            car.Combustivel__c = req.combustivel;
            car.Renavam__c = req.renavam;
            car.Cor__c = req.cor;
            car.Modelo__c = req.modelo;
            car.Placa__c = req.placa;
            car.SituacaoVeiculo__c = req.situacaoVeiculo;
            car.Quilometragem__c = req.quilometragem;

            Account manufacturerAccount = mapAccountByIdentifier.get(req.fabricante);
            if (manufacturerAccount != null) {
                car.Fabricante__c = manufacturerAccount.Id;
            }

            lstCarsToUpsert.add(car);
        }

        saveResult(lstCarsToUpsert, Carro__c.Chassi__c, mapIndex);
        return lstResponse;
    }

    private static void saveResult(List<Carro__c> lstCars, SObjectField upsertField, Map<String, Integer> mapIndex) {
        List<Database.UpsertResult> lstResults = ((DML) Injector.getInstance().instantiate(DML.class)).doUpsert(lstCars, upsertField, false);
        for (Integer index = 0; index < lstResults.size(); index++) {
            Database.upsertResult result = lstResults[index];
            SObject record = lstCars[index];
            Integer correctIndex = mapIndex.get((String) record.get('Chassi__c'));
            UpsertCarResource.Response response = lstResponse[correctIndex];
            response.success = result.isSuccess();
            response.salesforceId = result.getId();
            response.mensagem = 'Ação realizada com sucesso!';

            if (!result.isSuccess()) {
                Database.Error error = result.getErrors().get(0);
                response.mensagem = 'Erro: ' + error.getMessage() + '. Campos: ' + error.getFields();
            }

        }
    }

    private UpsertCarResource.Response assembleResponse(UpsertCarResource.Request request) {
        UpsertCarResource.Response response= new UpsertCarResource.Response();
        response.chassi = request.chassi;
        response.combustivel = request.combustivel;
        response.renavam = request.renavam;
        response.cor = request.cor;
        response.modelo = request.modelo;
        response.fabricante = request.fabricante;
        response.placa = request.placa;
        response.situacaoVeiculo = request.situacaoVeiculo;
        response.quilometragem = request.quilometragem;
        response.success = false;

        return response;
    }
}