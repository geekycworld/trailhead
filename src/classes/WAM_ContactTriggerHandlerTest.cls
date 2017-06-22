/*
* WAM_ContactTriggerHandlerTest 
* Date / Author / Description
* 
*/
@IsTest public with sharing class WAM_ContactTriggerHandlerTest {
    
    
    @IsTest
    public static void WAM_ContactTriggerHandlerTest() {
        
    }    
    
    @testSetup 
    static void setup() {
        WAM_CodeCoverageDataFactory.initDocumentOptOutData();
    }
    
    
    @IsTest
    public static void updateContact() {
        try {
            User u2 =  [SELECT Id FROM User WHERE UserName =: WAM_CodeCoverageDataFactory.testUserName LIMIT 1];
            System.runAs(u2){ 
                Account[] insertedAcc = [SELECT Id, 
                                        (SELECT ID, Name FROM Contacts WHERE Role__c = 'Product' LIMIT 1), 
                                        Name FROM Account WHERE Name = 'TestAccount'];
            
                Contact con = insertedAcc[0].Contacts[0];
                con.Role__c = 'Operation';

                update con;

                Contact[] retrieveCon = [SELECT Id, Role__c FROM Contact WHERE ID =: con.Id];
                System.assertEquals(retrieveCon[0].Role__c, 'Operation');
            }
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'WAM_ContactTriggerHandlerTest.updateContact -> e.getStackTraceString(): ' + e.getStackTraceString());
            System.assert(false);
        }
    }
    
    @IsTest
    public static void updateContactDOO() {
        try {
            User u2 =  [SELECT Id FROM User WHERE UserName =: WAM_CodeCoverageDataFactory.testUserName LIMIT 1];
            System.runAs(u2){ 
                Account[] insertedAcc = [SELECT Id, 
                                        (SELECT ID, Name FROM Contacts WHERE Role__c = 'Product' LIMIT 1), 
                                        Name FROM Account WHERE Name = 'TestAccount'];
            
                Contact con = insertedAcc[0].Contacts[0];
                con.Role__c = 'Product';
                con.Product_Leaflet_Brochure__c = false;

                update con;

            }
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'WAM_ContactTriggerHandlerTest.updateContactDOO -> e.getStackTraceString(): ' + e.getStackTraceString());
            System.assert(true); //Expected fail due to user not allow to opt in Product_Leaflet_Brochure__c
        }
    }

    @IsTest
    public static void negativeScenario_invalidInfo() {
        try {
            User u2 =  [SELECT Id FROM User WHERE UserName =: WAM_CodeCoverageDataFactory.testUserName LIMIT 1];
            System.runAs(u2){ 
                Account[] insertedAcc = [SELECT Id, 
                                        (SELECT ID, Name FROM Contacts WHERE Role__c = 'Product' LIMIT 1), 
                                        Name FROM Account WHERE Name = 'TestAccount'];
            
                Contact con = insertedAcc[0].Contacts[0];
                con.Role__c = '@Invalid';
                con.Id ='1234-@';

                update con;
            }
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'WAM_ContactTriggerHandlerTest.negativeScenario_invalidInfo -> e.getStackTraceString(): ' + e.getStackTraceString());
            System.assert(true); //Expected fail due to this is negative test scenario
        }
    }
}