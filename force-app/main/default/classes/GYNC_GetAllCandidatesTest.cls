@isTest
public class GYNC_GetAllCandidatesTest {
    @isTest
    public static void testAgreement2(){
        
        GYNCO_Salesforce_Event_Meeting_Link__c obj2= new GYNCO_Salesforce_Event_Meeting_Link__c();
        obj2.GYNCF_Use_Direct_Meeting_Invite__c=true;
        obj2.GYNCF_Use_Salesforce_Event__c=False;
        obj2.Name='Test';
        insert obj2;
        
        
        GYNCO_Position__c pos= New  GYNCO_Position__c();
        
        pos.GYNCF_Designation__c='Fresher';
        pos.GYNCF_Final_offer_amount__c=45000;
        pos.GYNCF_HR_Owner__c=pos.CreatedById;
        pos.GYNCF_Number_Of_Rounds__c='2';
        pos.GYNCF_Recruitment_owner__c=pos.CreatedById;
        pos.GYNCF_Position_Sponsor__c=pos.CreatedById;
        pos.GYNCF_Company__c='gyansys';
        pos.GYNCF_Joining_Date__c=system.today();
        insert pos;
        
        GYNCO_Candidate__c can = New GYNCO_Candidate__c();
        can.Name = 'Test';
        can.GYNCF_Position__c=pos.Id;
        Insert can;
        
        String Body ='This is a dummy attachment.';
        Blob txt = Blob.valueOf(Body);
        Attachment attach = new Attachment();
        attach.ParentId = can.Id;
        attach.Name = 'dummy attachment';
        attach.Body = txt;        
        insert attach;
        
        GYNCO_Candidate__c can2 = New GYNCO_Candidate__c();
        can.Name = 'Test2';
        can.GYNCF_Position__c=pos.Id;
        Insert can2;
        
        
        Attachment attach2 = new Attachment();
        attach2.ParentId = can2.Id;
        attach2.Name = 'dummy attachment2';
        attach2.Body = txt;        
        insert attach2;
        
        
    Test.startTest();
    
    GYNC_GetAllCandidates.getCandidateRecords(1,pos.Id);
    GYNC_GetAllCandidates.loadCandidateRecords(1,0,pos.Id);
        
    Test.stopTest();
    System.assert(true);
    }

}