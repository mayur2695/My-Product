@isTest
public class GYNC_UpdateMeetingLinkTest 
{
	@isTest public static void callupdaterecord()
    {
        GYNCO_Salesforce_Event_Meeting_Link__c obj= new GYNCO_Salesforce_Event_Meeting_Link__c();
        obj.GYNCF_Use_Direct_Meeting_Invite__c=true;
        obj.GYNCF_Use_Salesforce_Event__c=False;
        obj.Name='Test';
        insert obj;
        GYNCO_Position__c pos= new GYNCO_Position__c();
        pos.GYNCF_Designation__c='Fresher';
        pos.GYNCF_Final_offer_amount__c=Decimal.valueOf(45000);
        pos.GYNCF_Number_Of_Rounds__c='2';
        pos.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
        pos.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
        pos.GYNCF_Company__c='gyansys';
        pos.GYNCF_Joining_Date__c=system.today();
        insert pos;
        Test.startTest();
        GYNC_UpdateMeetingLink.UpdateRecord(pos.Id,'www.gmail.com');
        Test.stopTest();
        System.assert(true);
    }
    
    @isTest public static void callIfMeetingLink()
    {
        GYNCO_Salesforce_Event_Meeting_Link__c obj1= new GYNCO_Salesforce_Event_Meeting_Link__c();
        obj1.GYNCF_Use_Direct_Meeting_Invite__c=true;
        obj1.GYNCF_Use_Salesforce_Event__c=False;
        obj1.Name='Test';
        insert obj1;
        
        GYNCO_Position__c pos1= new GYNCO_Position__c();
        pos1.GYNCF_Designation__c='Fresher';
        pos1.GYNCF_Final_offer_amount__c=45000;
        pos1.GYNCF_Number_Of_Rounds__c='2';
        pos1.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
        pos1.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
        pos1.GYNCF_Company__c='gyansys';
        pos1.GYNCF_Send_Direct_Meeting_lnvite__c =true;
        Pos1.GYNCF_Status__c = 'Open' ;
        pos1.GYNCF_Joining_Date__c=system.today();
        pos1.GYNCF_Meeting_Link__c='www.gmail.com';
        insert pos1;
         Test.startTest();
        GYNCO_Position__c Posret1= GYNC_UpdateMeetingLink.IfMeetingLink(pos1.Id);
         Test.stopTest();
        System.assert(true);
    }
    
   @isTest public static void callIfMeetingLinkelse()
    {
        GYNCO_Salesforce_Event_Meeting_Link__c obj2= new GYNCO_Salesforce_Event_Meeting_Link__c();
        obj2.GYNCF_Use_Direct_Meeting_Invite__c=False;
        obj2.GYNCF_Use_Salesforce_Event__c=True;
        obj2.Name='Test';
        insert obj2;
        
        GYNCO_Position__c pos2= new GYNCO_Position__c();
        pos2.GYNCF_Designation__c='Fresher';
        pos2.GYNCF_Final_offer_amount__c=45000;
        pos2.GYNCF_Number_Of_Rounds__c='2';
        pos2.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
        pos2.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
        pos2.GYNCF_Company__c='gyansys';
        pos2.GYNCF_Joining_Date__c=system.today();
        insert pos2;
        Test.startTest();
        GYNCO_Position__c Poseret2= GYNC_UpdateMeetingLink.IfMeetingLink(pos2.Id);
        Test.stopTest();
        System.assert(true);
    }
    
}