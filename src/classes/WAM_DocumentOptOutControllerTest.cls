/*
* WAM_ContactTriggerHandlerTest 
* Date / Author / Description
* 
* 07-Feb / TANSH / Test Scripts
*/

@IsTest public with sharing class WAM_DocumentOptOutControllerTest {
    
    @IsTest
    public static void WAM_DocumentOptOutControllerTest() {
        
    }  
    
    @testSetup 
    static void setup() {
        WAM_CodeCoverageDataFactory.initDocumentOptOutData();
    }
    
    @IsTest
    public static void loadContactPurpose() {
        try {
            User u2 =  [SELECT Id FROM User WHERE UserName =: WAM_CodeCoverageDataFactory.testUserName LIMIT 1];
            System.runAs(u2){ 
                Account[] insertedAcc = [SELECT Id, 
                                         Name FROM Account WHERE Name = 'TestAccount' LIMIT 1];
                
                ApexPages.StandardController ssc = new ApexPages.StandardController(insertedAcc[0]);
                WAM_DocumentOptOutController controller = new WAM_DocumentOptOutController(ssc);
                
                controller.documentOptOutList = new List<WAM_DocumentOptOutController.DocumentOptOutWrapper>();                
                WAM_DocumentOptOutController.DocumentOptOutWrapper doo=new WAM_DocumentOptOutController.DocumentOptOutWrapper();
                doo.role = 'Sales - Branch RMs';
                doo.fundInformation = true;
                doo.marketInformation = true;
                doo.eventPromotion = true;
                doo.legalDocument = true;
                controller.documentOptOutList.add(doo);

                controller.quickSave();

            }
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'WAM_DocumentOptOutControllerTest.loadContactPurpose -> e.getStackTraceString(): ' + e.getStackTraceString());
            System.assert(false);
        }
    }
    
    @IsTest
    public static void loadEmptyContactPurpose() {
        try {
            User u2 =  [SELECT Id FROM User WHERE UserName =: WAM_CodeCoverageDataFactory.testUserName LIMIT 1];
            System.runAs(u2){ 
                Account[] insertedAcc = [SELECT Id, 
                                         Name FROM Account WHERE Name = 'TestAccount1' LIMIT 1];
            
                ApexPages.StandardController ssc = new ApexPages.StandardController(insertedAcc[0]);
                WAM_DocumentOptOutController controller = new WAM_DocumentOptOutController(ssc);
                
                controller.quickSave();
                controller.cancelEdit();
                
               
            }
        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'WAM_DocumentOptOutControllerTest.loadEmptyContactPurpose -> e.getStackTraceString(): ' + e.getStackTraceString());
        }
    }
    

}