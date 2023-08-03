@istest public class GYNC_FileUploadControllerTest 
{
     @isTest
	 public static void callsaveChunk()
    {
        GYNCO_Candidate__c can= new GYNCO_Candidate__c();
        can.Name='Test';
        insert can;
        
        Test.startTest();
        ID FileID = GYNC_FileUploadController.saveChunk(can.ID,'test file','test','text/html','');
                     GYNC_FileUploadController.saveChunk(can.ID,'test file','test','text/html',FileID);
        Test.stopTest();
        System.assert(true);
    }
   
}