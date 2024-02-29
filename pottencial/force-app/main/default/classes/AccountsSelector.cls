public inherited sharing class AccountsSelector extends fflib_SObjectSelector {

    public Schema.SOBjectType getSObjectType() {
        return Account.SOBjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.Name,
            Account.Identificador__c
        };
    }

    public List<Account> selectByIdentifier(Set<String> setIdentifiers) {
        return [SELECT Id, Identificador__c FROM Account WHERE Identificador__c IN :setIdentifiers];
    }
}