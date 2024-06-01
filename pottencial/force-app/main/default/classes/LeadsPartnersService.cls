/**
*  @author Diego Abrantes
*  @description PME Domain class for Lead SObject (RT PMEPartners)
*  @lastOnDemand 
*  @upd
**/
public class LeadsPartnersService extends fflib_SObjectDomain {
    public LeadsPartnersService( List<Lead> sObjectList ) {
        super( sObjectList );
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct( List<SObject> sObjectList ) {
            return new LeadsPartnersService( sObjectList );
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        // cast only once
        List<Lead> lstLead = (List<Lead>) Records;
        checkLeadConversion( lstLead, (Map<Id, Lead>) existingRecords );
    }

    /**
     *  @author Diego Abrantes
     *  @description Check if Owner ir changed to convert lead based on PME Criterias
     *  @lastOnDemand 
    **/
    public void checkLeadConversion( List<Lead> lstLead, Map<Id, Lead> oldMap ) {

        DML dml = (DML)Injector.getInstance().instantiate(DML.class);

        Set<String> setDocuments = new Set<String>();
        List<Lead> lstLeadsToConvert = new List<Lead>();
        Map<String, Account> mapAccountByDocument = new Map<String, Account>();
        Map<String, Lead> mapLeadByDocument = new Map<String, Lead>();
        for ( Lead currentLead : lstLead ) {
            Lead oldLead = oldMap.get( currentLead.Id );
           if ( !currentLead.IsConverted && oldLead.OwnerId != currentLead.OwnerId ) {
                setDocuments.add( currentLead.DocumentId__c );
                lstLeadsToConvert.add( currentLead );
                mapLeadByDocument.put( currentLead.DocumentId__c, currentLead );
            }
        }

        if ( setDocuments != null && !setDocuments.isEmpty() ) {
            // Find Accounts
            for ( Account each : ((AccountsSelector) Injector.getInstance().instantiate(AccountsSelector.class)).selectByIdNumber( setDocuments ) ) {
                mapAccountByDocument.put( each.IDNumber__c, each );
                setDocuments.remove( each.IDNumber__c );
            }
        }

       // Create Accounts to inexisting Documents
        if ( setDocuments != null && !setDocuments.isEmpty() ) {
            List<Account> lstAccountsToInsert = new List<Account>();
            Id rtPJ = AccountsSelector.RECORDTYPE_ACCOUNT_PJ;
            SettingPME__c settingPME = SettingPME__c.getOrgDefaults();
            for ( String document : setDocuments ) {
                Lead relatedLead = mapLeadByDocument.get( document );
                if ( relatedLead != null && relatedLead.Company != null ) {
                    Account acc = new Account();
                    acc.Name = relatedLead.Company;
                    acc.Segments__c = 'PME';
                    acc.RecordTypeId = rtPJ;
                    acc.IdNumber__c = document;
                    acc.OwnerId = settingPME.PartnerOppsDefaultUser__c;
                    acc.Type = 'Prospect';
                    acc.BillingStreet = relatedLead.Street;
                    acc.BillingCity = relatedLead.City;
                    acc.BillingState = relatedLead.State;
                    acc.BillingPostalCode = relatedLead.PostalCode;
                    acc.BillingCountry = relatedLead.Country;
                    lstAccountsToInsert.add( acc );
                    mapAccountByDocument.put( document, acc );
                }
            }

            //insert lstAccountsToInsert;
            dml.doInsert( lstAccountsToInsert );
        }

        // Create Contacts 
        List<Contact> lstContactsToInsert = new List<Contact>();
        Map<String, Contact> mapContactByDocument = new Map<String, Contact>();
        Id rtDefault = ContactsSelector.RECORDTYPE_CONTACT_DEFAULT;
        for ( Lead each : lstLeadsToConvert ) {
            Account account = mapAccountByDocument.get( each.DocumentId__c );
            if ( account != null ) {
                if ( each.Partners__c != null ) {
                    //List<String> lstPartners = each.Partners__c.split(';');
                    List<PMELeadPartnersWrapper> lstPartners = (List<PMELeadPartnersWrapper>) JSON.deserialize( each.Partners__c, List<PMELeadPartnersWrapper>.class );
                    PMELeadPartnersWrapper firstParnter = new PMELeadPartnersWrapper();
                    firstParnter.firstName = each.FirstName;
                    firstParnter.lastName = each.LastName;
                    lstPartners.add( firstParnter );

                    for ( PMELeadPartnersWrapper partner : lstPartners ) {
                        Contact contact = new Contact();
                        contact.RecordTypeId = rtDefault;
                        contact.FirstName = partner.firstName;
                        contact.LastName = partner.lastName;
                        contact.AccountId = account.Id;
                        contact.OwnerId = each.OwnerId;
                        contact.Title = 'Sócio';

                        if ( !mapContactByDocument.containsKey( each.DocumentId__c )) {
                            mapContactByDocument.put( each.DocumentId__c, contact );
                        }

                        lstContactsToInsert.add( contact );
                    }
                }
            }
        }


        
        if ( lstContactsToInsert != null && !lstContactsToInsert.isEmpty() ) {
            //insert lstContactsToInsert;
            List<Database.SaveResult> saveResult = dml.doInsert( lstContactsToInsert );
        }

        // Create Opportunity and Convert Lead
        Id rtPartners = OpportunitiesSelector.RECORDTYPE_PME_PARTNERS;
        List<Opportunity> lstOppToInsert = new List<Opportunity>();
        List<Database.LeadConvert> lstLeadConvert = new List<Database.LeadConvert>();
        for ( Lead each : lstLeadsToConvert ) {
            Account account = mapAccountByDocument.get( each.DocumentId__c );
            if ( account != null ) {

                //Create opp
                Opportunity opp = new Opportunity();
                opp.RecordTypeId = rtPartners;
                opp.Name = 'Cliente potencial ' + each.Company;
                opp.AccountId = account.Id;
                opp.StageName = 'Novo';
                opp.CloseDate = System.today().addDays(30);
                opp.OwnerId = each.OwnerId;
                lstOppToInsert.add( opp );

                // Convert lead
                Contact con = mapContactByDocument.get( each.DocumentId__c );
                Database.LeadConvert leadConvertion = new Database.LeadConvert();
                leadConvertion.setLeadId( each.Id );
                leadConvertion.setDoNotCreateOpportunity( true );
                leadConvertion.setOpportunityId( opp.Id );
                leadConvertion.setOwnerId( each.OwnerId );
                leadConvertion.setAccountId( account.Id );
                leadConvertion.setConvertedStatus('Converted');

                if ( con != null ) {
                    leadConvertion.setContactId( con.Id );
                }
                lstLeadConvert.add( leadConvertion );
            }
        }

        if ( lstOppToInsert != null && !lstOppToInsert.isEmpty() ) {
            //insert lstOppToInsert;
            //Database.LeadConvertResult[] lcr = Database.convertLead( lstLeadConvert );
            dml.doInsert( lstOppToInsert );
            dml.doConvertLead( lstLeadConvert );
        }

        System.debug('### lstOppToInsert = ' + lstOppToInsert);

    }
}