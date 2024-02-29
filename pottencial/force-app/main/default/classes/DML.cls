public inherited sharing class DML {
    public List<Database.SaveResult> doInsert(List<SObject> lstSObject) {
        return Database.insert(lstSObject);
    }

    public List<Database.UpsertResult> doUpsert(List<SObject> lstSObject, Schema.SObjectField externalIdField, Boolean allOrNone) {
        return Database.upsert(lstSObject, externalIdField, allOrNone);
    }
}