public class AccountsSelector extends fflib_SObjectSelector {

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

    public List<Account> selectByIdNumber(Set<String> setIdNumbers) {
        return [
            SELECT
                Id,
                IDNumber__c
            FROM Account
            WHERE IdNumber__c != NULL AND IdNumber__c = :setIdNumbers
        ];
    }
}