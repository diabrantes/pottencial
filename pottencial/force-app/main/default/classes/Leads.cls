/**
*  @author
*  @company X
*  @description Domain class for Lead SObject
*  @lastOnDemand    
**/
public class Leads extends fflib_SObjectDomain {


    Map<Id, List<Lead>> mapRecords;

    public Leads(List<Lead> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
        fetchMapRecords();
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Leads(sObjectList);
        }
    }

    private void fetchMapRecords() {
        this.mapRecords = new Map<Id, List<Lead>>();

        List<Lead> leads = (List<Lead>) Records;
        for (Lead record : leads) {
            List<Lead> values = mapRecords.get(record.RecordTypeId);

            if (values == null) {
                values = new List<Lead>();
                mapRecords.put(record.RecordTypeId, values);
            }

            values.add(record);
        }
    }
    public override void onApplyDefaults(){
        // ApplyDefaults
    }
    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        for ( Id key : mapRecords.keySet() ) {
            List<Lead> leads = mapRecords.get( key );
            fflib_SObjectDomain domain = LeadsDomainFactory.getInstance().createDomain( key , leads );
            if ( domain != null ) {
                domain.onBeforeUpdate( existingRecords );
            } else {

            }
        }
    }

    public override void onAfterInsert(){
        for ( Id key : mapRecords.keySet() ) {
            List<Lead> leads = mapRecords.get( key );
            fflib_SObjectDomain domain = LeadsDomainFactory.getInstance().createDomain( key , leads );
            if ( domain != null ) {
                domain.onAfterInsert();
            } else {

            }
        }
	}

    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
        for ( Id key : mapRecords.keySet() ) {
            List<Lead> leads = mapRecords.get( key );
            fflib_SObjectDomain domain = LeadsDomainFactory.getInstance().createDomain( key , leads );
            if ( domain != null ) {
                domain.onAfterUpdate( existingRecords );
            } else {
            }
        }
    }

    public override void onBeforeInsert(){
        for ( Id key : mapRecords.keySet() ) {
            List<Lead> leads = mapRecords.get( key );
            fflib_SObjectDomain domain = LeadsDomainFactory.getInstance().createDomain( key , leads );
            if ( domain != null ) {
                domain.onBeforeInsert();
            } else {
                // Methods
            }
        }
    }
}