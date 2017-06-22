/* 
* WAM_CodeCoverageDataFactory 
* Date / Author / Description
* 
* 10-May / ONGFT / To generate WAM mock data.
* 
*/

@IsTest
public class WAM_CodeCoverageDataFactory {

    public WAM_CodeCoverageDataFactory() {}

    public static void initDocumentOptOutData() {
        initAccountAndContacts();
    }  

    public static String testUserName = 'wamusertest@manulife.com.japan.wamtest';
    
    /**
    * Create Test Data for Distributor with Contacts
    *
    * @return void
    * 
    */
    private static void initAccountAndContacts() {

        Profile p = [SELECT Id FROM Profile WHERE Name='WAM Partnership Distribution'];
        User u2 = new User(Alias = 'wamuser', Email='wamusertest@manulife.com',
            EmailEncodingKey='UTF-8', LastName='wamuser', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=WAM_CodeCoverageDataFactory.testUserName);

        insert u2;   
        
        WAM_CustomSetting__c settings = WAM_CustomSetting__c.getOrgDefaults();
        settings.Account_Distributor_Record_Type_Name__c = 'WAM_Distributor';
        settings.Account_Distributor_Record_Type_Label__c = 'WAM Distributor';      
        settings.Contact_Distributor_Record_Type_Name__c = 'WAM_Distributor';
        settings.Contact_Distributor_Record_Type_Label__c = 'WAM Distributor';
        settings.AUM_in_Manulife_Record_Type__c = 'WAM';
        settings.Distributor_Sales_Info_Record_Type__c = 'WAM';
        settings.Event_Record_Type__c = 'WAMEventRT';
        settings.Fund_Record_Type__c = 'WAM';
        settings.Opportunity_Distributor_Record_Type__c = 'WAM';
        settings.Task_Record_Type__c = 'WAM';
        settings.Contact_Purpose_Record_Type_Label__c = 'WAM';
        settings.Default_Country_Code__c = '+(81)';

        upsert settings;

        String contactWAMId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(WAM_CustomSetting__c.getInstance().Contact_Distributor_Record_Type_Label__c).getRecordTypeId();
        String wamContactPurposeRecordTypeId = Schema.SObjectType.Contact_Purpose__c.getRecordTypeInfosByName().get(WAM_CustomSetting__c.getInstance().Contact_Purpose_Record_Type_Label__c).getRecordTypeId();

        System.runAs(u2){
            Account acc = new Account(Name = 'TestAccount');
            insert acc;
            
            Account noDataAcc = new Account(Name = 'TestAccount1');
            insert noDataAcc;
            
            List<Contact_Purpose__c> contactPurposeList = new List<Contact_Purpose__c>();
            Contact_Purpose__c cp = new Contact_Purpose__c();    
            cp.Contact_Method_Type__c = 'Email';                    
            cp.Purpose__c = 'Fund Information';
            cp.Role__c = 'Product';   
            cp.Account__c = acc.Id;
            cp.RecordTypeId = wamContactPurposeRecordTypeId;
            contactPurposeList.add(cp); 
            
            cp = new Contact_Purpose__c();  
            cp.Contact_Method_Type__c = 'Email';                    
            cp.Purpose__c = 'Market Information';
            cp.Role__c = 'Product';   
            cp.Account__c = acc.Id;
            cp.RecordTypeId = wamContactPurposeRecordTypeId;
            contactPurposeList.add(cp); 
            
            cp = new Contact_Purpose__c();    
            cp.Contact_Method_Type__c = 'Email';                    
            cp.Purpose__c = 'Market Information';
            cp.Role__c = 'Compliance';   
            cp.Account__c = acc.Id;
            cp.RecordTypeId = wamContactPurposeRecordTypeId;
            contactPurposeList.add(cp); 
            
            cp = new Contact_Purpose__c();    
            cp.Contact_Method_Type__c = 'Email';                    
            cp.Purpose__c = 'Event Promotion';
            cp.Role__c = 'Wealth';   
            cp.Account__c = acc.Id;
            cp.RecordTypeId = wamContactPurposeRecordTypeId;
            contactPurposeList.add(cp); 
            
            cp = new Contact_Purpose__c();    
            cp.Contact_Method_Type__c = 'Email';                    
            cp.Purpose__c = 'Legal Document';
            cp.Role__c = 'Senior Management';   
            cp.Account__c = acc.Id;
            cp.RecordTypeId = wamContactPurposeRecordTypeId;
            contactPurposeList.add(cp); 
            
            insert contactPurposeList;
                
            List<Contact> conList = new List<Contact>();
            integer i = 1;
            for (String role : WAM_UtilityClass.getRoleList){
                
                Contact con = new Contact(FirstName='FName_'+role, AccountId=acc.Id, LastName='LName', 
                                          Email='wamtest'+i+'@manulife.com', Title=role, Role__c=role, RecordTypeID=contactWAMId);
                conList.add(con);
                i++;
                
            }
            System.debug('conList: ' + conList );
            insert conList;
        }
    }
}