/*
* WAM_ContactTriggerHandler 
* Date / Author / Description
* 10-Jan / TANSH / WAM Contact Handler 
* 
*/
public class WAM_ContactTriggerHandler {
	
	public WAM_ContactTriggerHandler(){}
    private static String wamContactRecordTypeId = WAM_UtilityClass.wamContactRecordTypeId;
    private static String wamContactPurposeRecordTypeId = WAM_UtilityClass.wamContactPurposeRecordTypeId;
    private static Map<String, String> fieldMapper = WAM_UtilityClass.getFieldMapper();
	
	public void executeUpdate(Contact[] oldConList, Contact[] newConList) {
		Savepoint sp = Database.setSavepoint();
		try {
            System.debug(' START UPDATE Contact '); 
            if ((!newConList.get(0).Role__c.equals(oldConList.get(0).Role__c)) || (!newConList.get(0).Account.Id.equals(oldConList.get(0).Account.Id)))
                getDocumentOptOut(oldConList, newConList);
            else{
                Map<String, String> optOutfields = getOptOutFieldsbyCategory(oldConList, newConList);
                
                if(!optOutfields.isEmpty())
                {
                    for (String fieldname : optOutfields.keySet()){                                      
                        Object val = newConList.get(0).get(fieldname) ;
                        if(String.valueOf(val).equals('false'))
                        {
                            newConList.get(0).addError('You are not allow to opt in '+ optOutfields.get(fieldname));
    						break;
                        }
                    }     
                }
            }
           System.debug(' END UPDATE Contact ');  
            
		} catch (Exception e ) {
			Database.rollback(sp);
			for (Contact con : newConList) {
				con.addError(WAM_UtilityClass.exceptionStr + '</br>' + e.getStackTraceString() + '</br>' + e.getMessage(), false);
			}
		}
	}

	public void executeInsert(Contact[] oldConList, Contact[] newConList) {

		Savepoint sp = Database.setSavepoint();
		try {
            System.debug(' START INSERT Contact '); 
			getDocumentOptOut(oldConList, newConList);
            System.debug(' END INSERT Contact '); 
		} catch (Exception e ) {
			Database.rollback(sp);
			for (Contact con : newConList) {
				con.addError(WAM_UtilityClass.exceptionStr + '</br>' + e.getStackTraceString() + '</br>' + e.getMessage(), false);
			}
		}
	}

	private void getDocumentOptOut(Contact[] oldConList, Contact[] newConList) {
        
        if(!newConList.isEmpty())
        {                                
            List<Contact_Purpose__c> contactPurposeList = [SELECT Id, Purpose__c, Role__c FROM Contact_Purpose__c WHERE Account__r.Id = :newConList.get(0).AccountId 
                                                           AND recordTypeId =:wamContactPurposeRecordTypeId AND Role__c =:newConList.get(0).Role__c];
               
            for(Contact con : newConList){                      
                Map<String, String> fields = new Map<String, String>();
                if(!contactPurposeList.isEmpty()){
                    for(Contact_Purpose__c cp: contactPurposeList){                                                                                     
                        for (String fieldname : fieldMapper.keySet()){                                      
                            if(fieldMapper.get(fieldname).equals(cp.Purpose__c)){
                                con.put(fieldname, true);
                                fields.put(fieldname, fieldname); 
                            }  
                            else{
                                if(!fields.containsKey(fieldname))
                                    con.put(fieldname, false); 
                            }
                        }                         
                    }   
                } 
                else{
                    for (String fieldname : fieldMapper.keySet()){                                      
                        con.put(fieldname, false);                     
                    } 
                }               
            }                     
        }	
	}
    
    private Map<String, String> getOptOutFieldsbyCategory(Contact[] oldConList, Contact[] newConList) {
        
        Map<String, String> fields = new Map<String, String>();
        if(!newConList.isEmpty())
        {                                
            List<Contact_Purpose__c> contactPurposeList = [SELECT Id, Purpose__c, Role__c FROM Contact_Purpose__c WHERE Account__r.Id = :newConList.get(0).AccountId 
                                                           AND recordTypeId =:wamContactPurposeRecordTypeId AND Role__c =:newConList.get(0).Role__c];
           
            for(Contact con : newConList){                      
                if(!contactPurposeList.isEmpty()){
                    for(Contact_Purpose__c cp: contactPurposeList){                                                                                     
                        for (String fieldname : fieldMapper.keySet()){                                      
                            if(fieldMapper.get(fieldname).equals(cp.Purpose__c)){
                                fields.put(fieldname, fieldMapper.get(fieldname)); 
                            }  
                        }                         
                    }   
                }             
            } 
        }	
        return fields;
	}
	
	
}