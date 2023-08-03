/*
This class is a server side controller of GYNC_MeetingLink component.
Created by - Arnab Dey
*/

public with sharing class GYNC_UpdateMeetingLink {
    @AuraEnabled
   // UpdateRecord method is created to update the custom meeting link in position record.
   
       public Static void updateRecord(Id recordId, String link){
           if(GYNCO_Position__c.SObjectType.getDescribe().isCreateable() && Schema.sObjectType.GYNCO_Position__c.fields.GYNCF_Meeting_Link__c.isUpdateable())
   {
       GYNCO_Position__c pos = New GYNCO_Position__c();
       //if(GYNCO_Position__c.isQuerryable())
       //{
           pos= [Select Id, Name, GYNCF_Meeting_Link__c From GYNCO_Position__c Where Id =:recordId];//Querying position to update the meeting link
   
       //}
       if(pos!=Null)
       {
           Pos.GYNCF_Meeting_Link__c = Link;
           Update pos;
       }
   }
          
       }
       @AuraEnabled
   // IfMeetingLink method is created to display previously uploaded meeting link and also controls the visibility of the GYNC_MeetingLink
   // component
       public Static GYNCO_Position__c ifMeetingLink(Id recordId)
       {
           //if(GYNCO_Position__c.SObjectType.getDescribe.isAcessable())
           //{
               GYNCO_Position__c pos = New GYNCO_Position__c();
           //Querying position record to controll the component visibility
           
           Pos = [Select Id, Name, GYNCF_Status__c,GYNCF_Meeting_Link__c, GYNCF_Send_Direct_Meeting_lnvite__c From GYNCO_Position__c Where Id =:recordId];
           //component will be visible if the condition is true
            If((pos.GYNCF_Status__c == 'Open' || pos.GYNCF_Status__c == 'Recruitment screening') && pos.GYNCF_Send_Direct_Meeting_lnvite__c == True)
            {
                return pos;
            }
            else
            {
                GYNCO_Position__c pos2 = New GYNCO_Position__c();
                return pos2;
            }
           }
           
       }