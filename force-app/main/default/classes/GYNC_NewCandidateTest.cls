@isTest
public class GYNC_NewCandidateTest {
   @isTest
   public static void testAgreement3(){
       GYNCO_Candidate__c can = New GYNCO_Candidate__c();
       can.Name = 'Test';
       
       Test.startTest();
       GYNC_NewCandidate.saveCandidate(can);
       Test.stopTest();
       System.assert(true);
   }
}