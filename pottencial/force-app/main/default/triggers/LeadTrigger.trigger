trigger LeadTrigger on Lead (before insert, before update, before delete, 
                                           after insert, after update, after delete){
                                               
	fflib_SObjectDomain.triggerHandler(Leads.class);
}