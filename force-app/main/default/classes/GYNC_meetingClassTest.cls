@istest
public class GYNC_meetingClassTest 
{
    @istest
	 public static void checktickboxes()
     {
         GYNCO_Salesforce_Event_Meeting_Link__c obj = new GYNCO_Salesforce_Event_Meeting_Link__c();
         obj.Name='Test';
         obj.GYNCF_Use_Direct_Meeting_Invite__c=true;
         obj.GYNCF_Use_Salesforce_Event__c=False;
         GYNCO_Position__c pos= GYNC_meetingClass.tickboxes(obj);
         Test.startTest();
         System.assertEquals(false,pos.GYNCF_Use_Salesforce_Event__c);
         Test.stopTest() ;
     }
}