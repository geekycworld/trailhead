/*
* WAM_ContactTrigger 
* Date / Author / Description
* 
* 6-May / ONGFT / WAM Trigger on Contact
*/
trigger WAM_ContactTrigger on Contact (before insert, before update) {

	ID wamRecordTypeId = null;
    if(WAM_CustomSetting__c.getInstance().Contact_Distributor_Record_Type_Label__c != null)
        wamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(WAM_CustomSetting__c.getInstance().Contact_Distributor_Record_Type_Label__c).getRecordTypeId();
    else
        return;
    
	if (Trigger.isBefore && Trigger.isUpdate){        
		List<Contact> contactList = Trigger.New;		
		if(contactList != null && contactList.size() > 0) {
			if(contactList[0].RecordTypeId == wamRecordTypeId) {
				WAM_ContactTriggerHandler controller = new WAM_ContactTriggerHandler();
				controller.executeUpdate(Trigger.old, Trigger.new);
			}
		}
	}
    
	if (Trigger.isBefore && Trigger.isInsert){
		List<Contact> contactList = Trigger.New;
		
		if(contactList != null && contactList.size() > 0) {
			if(contactList[0].RecordTypeId == wamRecordTypeId) {
				WAM_ContactTriggerHandler controller = new WAM_ContactTriggerHandler();
				controller.executeInsert(Trigger.old, Trigger.new);
			}
		}
	}
}