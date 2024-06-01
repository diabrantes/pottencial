/**
 *  @author Diego Abrantes
 *  @company
 *  @description Factory class for Lead Domain
 *  @lastOnDemand
 *  @upd
 **/
public class LeadsDomainFactory extends SObjectDomainFactory {
    private static LeadsDomainFactory instance;

    private Map<String, String> mapIdentifierType;
    private Map<String, Schema.RecordTypeInfo> mapRecordTypeInfo;

    public static LeadsDomainFactory getInstance() {
        if (instance == null)
            instance = new LeadsDomainFactory();
        return instance;
    }

    public LeadsDomainFactory() {
        this.mapRecordTypeInfo = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName();
    }

    protected override Map<String, String> getIdentifierType() {
        if (this.mapIdentifierType == null) {
            this.mapIdentifierType = new Map<String, String>();

            Map<String, String> mapIdentifiersDomainConstructor = getIdentifiersDomainConstructor();

            for (String identifier : mapIdentifiersDomainConstructor.keySet()) {
                RecordTypeInfo recordTypeInfo = mapRecordTypeInfo.get(identifier);
                if (recordTypeInfo != null) {
                    this.mapIdentifierType.put(recordTypeInfo.getRecordTypeId(), mapIdentifiersDomainConstructor.get(identifier));
                }
            }
        }

        return this.mapIdentifierType;
    }

    protected override Map<String, String> getIdentifiersDomainConstructor() {
        return new Map<String, String>{ 'Partners' => 'LeadsPartnersService.Constructor'};
    }
}