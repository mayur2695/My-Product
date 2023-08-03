public class GYNC_meetingClass 
{
    public static GYNCO_Position__c tickboxes(GYNCO_Salesforce_Event_Meeting_Link__c obj)
    {

        GYNCO_Position__c pos= new GYNCO_Position__c();
        pos.GYNCF_Use_Salesforce_Event__c= obj.GYNCF_Use_Salesforce_Event__c;
        pos.GYNCF_Send_Direct_Meeting_lnvite__c=obj.GYNCF_Use_Direct_Meeting_Invite__c;
        return pos;
    }
    

}