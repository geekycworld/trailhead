/*
* WAM_DocumentOptOutController 
* Date / Author / Description
* 10-Jan / TANSH / Controller Extension for Account 
* 
*/

public class WAM_DocumentOptOutController {
    
    static final String FUND_INFORMATION = 'Fund Information'; 
    static final String MARKET_INFORMATION = 'Market Information'; 
    static final String EVENT_PROMOTION = 'Event Promotion'; 
    static final String LEGAL_DOCUMENT = 'Legal Document'; 
    public List<DocumentOptOutWrapper> documentOptOutList {get; set;}
    public List<Contact_Purpose__c> contactPurposeList {get; set;}
    public boolean chkboxDisable {get; set;}
    public boolean buttonDisable {get; set;}
    private Id accountId{get;set;}
    private static String wamContactRecordTypeId = WAM_UtilityClass.wamContactRecordTypeId;
    private static String wamContactPurposeRecordTypeId = WAM_UtilityClass.wamContactPurposeRecordTypeId;
    private static List<String> roleList = WAM_UtilityClass.getRoleList;
    private static Map<String, String> fieldMapper = WAM_UtilityClass.getFieldMapper();
    
    public WAM_DocumentOptOutController(ApexPages.StandardController controller) {
        
        if (controller != null && controller.getId() != null) {
            accountId = controller.getId();
            init();
        }
    }
    
    public void quickSave() {
     
        Savepoint sp = Database.setSavepoint();
        try {            

               Map<String, String> initialContactPurpose = new Map<String, String>();
            
               if(!contactPurposeList.isEmpty())   
               {
                   initialContactPurpose = getContactPurposeMap (contactPurposeList);
                   delete contactPurposeList;
               }
                    
               List<Contact_Purpose__c> insertContactPurposeList = new List<Contact_Purpose__c>(); 
            
               System.debug(' START INSERT Document Opt Out ');   

               for(DocumentOptOutWrapper doowrap : documentOptOutList){ 
                  
                    if(doowrap.fundInformation){
                        
                        insertContactPurposeList.add(setContactPurpose(doowrap.role, FUND_INFORMATION));                      
                    }    
                    
                    if(doowrap.marketInformation){
                        insertContactPurposeList.add(setContactPurpose(doowrap.role, MARKET_INFORMATION));
                    }
                    
                    if(doowrap.eventPromotion){
                        insertContactPurposeList.add(setContactPurpose(doowrap.role, EVENT_PROMOTION));                        
                    }  
                    
                    if(doowrap.legalDocument){
                        insertContactPurposeList.add(setContactPurpose(doowrap.role, LEGAL_DOCUMENT));                           
                    }  
                }           
                insert insertContactPurposeList;  
                System.debug(' COMPLETE INSERT Document Opt Out ');
            
                UpdateWAMContact(initialContactPurpose);
                init();
                                                              
        } 
        catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getStackTraceString() + '</br>' + e.getMessage()));
        }
        
    }
    
    public void cancelEdit() {
        init();
    }
    
    public void init() {
        
        documentOptOutList = new List<DocumentOptOutWrapper>();
        contactPurposeList = new List<Contact_Purpose__c>();
        
        List <Profile> profileName = [Select Name from Profile where Id =: UserInfo.getProfileId() LIMIT 1];
        
        if('WAM Marketing'.equals(profileName[0].Name))
        {
            chkboxDisable = true;
            buttonDisable= true;
        }
        
        if(!roleList.isEmpty()) {
                                  
                contactPurposeList = [SELECT Id, Purpose__c, Role__c FROM Contact_Purpose__c WHERE Account__r.Id = :accountId AND recordTypeId =: wamContactPurposeRecordTypeId];
                
                System.debug(' START RETRIEVE Document Opt Out ');  
                if(!contactPurposeList.isEmpty()) {
                                  
                    for(String role :roleList){
                         DocumentOptOutWrapper doowrap = new DocumentOptOutWrapper(role);
                        
                            for(Contact_Purpose__c cp :contactPurposeList){
                                if(cp.Role__c.equals(role)){
                                    if(cp.Purpose__c.equals(FUND_INFORMATION))
                                        doowrap.fundInformation = true;
                                    else if (cp.Purpose__c.equals(MARKET_INFORMATION))
                                        doowrap.marketInformation = true;
                                    else if (cp.Purpose__c.equals(EVENT_PROMOTION))
                                        doowrap.eventPromotion = true;
                                    else if (cp.Purpose__c.equals(LEGAL_DOCUMENT))
                                        doowrap.legalDocument = true;
                                }
                            }
                        
                            documentOptOutList.add(doowrap); 
                    }                                       
                }
                else
                    defineDocOptOutList();

                System.debug(' COMPLETE RETRIEVE Document Opt Out '); 
        }
    } 
    
    private void defineDocOptOutList()
    {      
        for(String role: roleList){
            DocumentOptOutWrapper doowrap = new DocumentOptOutWrapper(role);
            documentOptOutList.add(doowrap);  
       }
    }
      
    private Contact_Purpose__c setContactPurpose(String role, String docCategory)
    {
        Contact_Purpose__c cp = new Contact_Purpose__c();    
        cp.Contact_Method_Type__c = 'Email';                    
        cp.Purpose__c = docCategory;
        cp.Role__c = role;   
        cp.Account__c = accountId;
        cp.RecordTypeId = wamContactPurposeRecordTypeId;
        return cp; 
    }
    
    private Map<String, String> getContactPurposeMap (List<Contact_Purpose__c> dooList){
        
        Map<String, String> cpMap = new Map<String, String>();
        
        for(Contact_Purpose__c cp: dooList)
        {
             String mapString = cp.Role__c + '|' + cp.Purpose__c;
             cpMap.put(mapString,mapString);
        }
        
        return cpMap;
    }
            

    private List<String> getDocOptOutRemove (Map<String,String> initialDOOMap, List <Contact_Purpose__c> newDOOList){
 
        Map<String, String> newDOOMap = getContactPurposeMap (newDOOList);
        List<String> docOptOutRemoveList = new List<String>();

        for (String fieldname : initialDOOMap.keySet()){

            if(!newDOOMap.containsKey(fieldname))
            {
                docOptOutRemoveList.add(fieldname);
            }             
        }
        
        return docOptOutRemoveList;
    }
    
    private void UpdateWAMContact(Map<String,String> initialDOOMap)
    {
        System.debug(' START Update Contact level Document Opt Out ');            
        List<Contact> contactList = [SELECT Id, Role__c FROM Contact WHERE Contact.AccountId =:accountId AND recordTypeId =:wamContactRecordTypeId];
        List <Contact_Purpose__c> newContactPurposeList = [SELECT Id, Purpose__c, Role__c FROM Contact_Purpose__c WHERE Account__r.Id = :accountId AND recordTypeId =:wamContactPurposeRecordTypeId];
        List<Contact> updateContactList = new List<Contact>();
        List<String> removeContactOptOut = getDocOptOutRemove(initialDOOMap, newContactPurposeList);
        
        Map<String, String> fieldMap = fieldMapper;

        for(Contact con : contactList){                      
            for(Contact_Purpose__c cp: newContactPurposeList){                            
                if(con.Role__c.equals(cp.Role__c)){
                    for (String fieldname : fieldMap.keySet()){
                        if(fieldMap.get(fieldname).equals(cp.Purpose__c)){
                            con.put(fieldname, true);
                        }
                    }
                }
            }
            
            for(String s :removeContactOptOut)
            {
                String[] sarray = s.split('\\|');
                 
                if(con.Role__c.equals(sarray[0]))
                {
                    for (String fieldname : fieldMap.keySet()){
                        if(fieldMap.get(fieldname).equals(sarray[1])){
                            con.put(fieldname, false);
                        }
                    }
                }
            }
           
            updateContactList.add(con); 
        }
        
        update updateContactList;
        
        System.debug(' COMPLETE Update Contact level Document Opt Out '); 
    }
    
    public class DocumentOptOutWrapper {

    public String role{get;set;}
    public boolean fundInformation{get;set;}
    public boolean marketInformation{get;set;}
    public boolean eventPromotion{get;set;}
    public boolean legalDocument{get;set;}

        public DocumentOptOutWrapper(){
        }  
        
        public DocumentOptOutWrapper(String prole){
            role = prole;      
            System.Debug('ABC');     
        }       
    }
    
}