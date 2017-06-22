/*
* WAM_UtilityClass 
* Date / Author / Description
* 
* 30-Jan / TANSH/ Util for WAM
*/
public class WAM_UtilityClass {
    
    public static String wamContactRecordTypeId {
        get {
            return Schema.SObjectType.Contact.getRecordTypeInfosByName().get(WAM_CustomSetting__c.getInstance().Contact_Distributor_Record_Type_Label__c).getRecordTypeId();
        }
        set;
    }
    
    public static String wamContactPurposeRecordTypeId {
        get {
            return Schema.SObjectType.Contact_Purpose__c.getRecordTypeInfosByName().get(WAM_CustomSetting__c.getInstance().Contact_Purpose_Record_Type_Label__c).getRecordTypeId();
        }
        set;
    }
    
    public static List<String> getRoleList {
        get {
                List<String> lroleList = new List<String>();
                for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get('Contact_Purpose__c').getDescribe().fields.getMap().get('Role__c').getDescribe().getPickListValues()) { 
                    lroleList.add(a.getValue());
                }
            return lroleList;           
        }
        set;
    }
    
    public static Map<String, String> getFieldMapper() {
        Map<String, String> fieldMapper = new Map<String, String>();
        
        for (WAM_Document_Opt_Out_Mapper__mdt rec: [SELECT Document_Category__c, Contact_Level_API__c FROM WAM_Document_Opt_Out_Mapper__mdt ORDER BY Document_Category__c]) {
            fieldMapper.put(rec.Contact_Level_API__c, rec.Document_Category__c);
        }
        
        return fieldMapper;
    }
    
    public static String exceptionStr = System.Label.WAM_UnexpectedExceptionMessage;
}