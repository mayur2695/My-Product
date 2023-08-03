/*This is a server side controller of GYNC_Mode_Of_Mail component.
  Created by - Arnab Dey
*/

public with sharing class GYNC_UpdateModeOfMail 
{
     @AuraEnabled
    /*
     UpdateRecord method is created to update one and only record of GYNCO_Salesforce_Event_Meeting_Link__c object when 'Mode of Mail'
     radio button is changed in GYNC_Mode_Of_Mail component.
    */
    public Static void UpdateRecord(String value)
    {
     List<GYNCO_Salesforce_Event_Meeting_Link__c> Record = New List<GYNCO_Salesforce_Event_Meeting_Link__c>();
                                           Record =     [Select Id,Name,GYNCF_Use_Direct_Meeting_Invite__c,  
                                                        GYNCF_Use_Salesforce_Event__c	From GYNCO_Salesforce_Event_Meeting_Link__c
                                                        Where Name = 'Test' limit 1];//Querying fields to update in position object.
        If(Record.Size()==0 && value == 'SalesforceEvent'){
            if(Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.Name.isCreateable()&&Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.GYNCF_Use_Direct_Meeting_Invite__c.isCreateable()&&Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.GYNCF_Use_Salesforce_Event__c.isCreateable()){   
          GYNCO_Salesforce_Event_Meeting_Link__c A = New GYNCO_Salesforce_Event_Meeting_Link__c();
            A.Name ='Test';
            A.GYNCF_Use_Direct_Meeting_Invite__c=False;
            A.GYNCF_Use_Salesforce_Event__c=True;
            Insert A;
            Record.add(A);
            }
        }
        if(Record.Size()==0 && value == 'DirectMeetingLink'){
          if(Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.Name.isCreateable()&&Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.GYNCF_Use_Direct_Meeting_Invite__c.isCreateable()&&Schema.sObjectType.GYNCO_Salesforce_Event_Meeting_Link__c.fields.GYNCF_Use_Salesforce_Event__c.isCreateable()){   
            GYNCO_Salesforce_Event_Meeting_Link__c A = New GYNCO_Salesforce_Event_Meeting_Link__c();
            A.Name ='Test';
            A.GYNCF_Use_Direct_Meeting_Invite__c=True;
            A.GYNCF_Use_Salesforce_Event__c=False;
            Insert A;
            Record.add(A);
          }
        }
        
            If( Record.size()>0 && value == 'SalesforceEvent')
            {
                Record[0].GYNCF_Use_Salesforce_Event__c = True;
                Record[0].GYNCF_Use_Direct_Meeting_Invite__c = False;
            }
            else If(Record.size()>0 && value == 'DirectMeetingLink')
            {
                
                Record[0].GYNCF_Use_Direct_Meeting_Invite__c = True;
                Record[0].GYNCF_Use_Salesforce_Event__c = False;
            }
        
        System.debug(Record);
       Update Record;
    }
    @AuraEnabled
    /*
     ReturnDefault method is created to show last selected option of 'Mode of Mail' radio button when the component loads
   */
    public Static string ReturnDefault()
    {
        String def;
     GYNCO_Salesforce_Event_Meeting_Link__c[] Record = [Select Id,Name,GYNCF_Use_Direct_Meeting_Invite__c,
                                                        GYNCF_Use_Salesforce_Event__c	
                                                        From GYNCO_Salesforce_Event_Meeting_Link__c
                                                        where Name = 'Test' limit 1];//Querying fields to fetch previously selected option
        //returning the value needed to show the previously selected option
        
            If(Record.size()>0 && Record[0].GYNCF_Use_Direct_Meeting_Invite__c == True && Record[0].GYNCF_Use_Salesforce_Event__c == False)
            {
                def='DirectMeetingLink';
            } 
            else If(Record.size()>0 && Record[0].GYNCF_Use_Direct_Meeting_Invite__c == False && Record[0].GYNCF_Use_Salesforce_Event__c == True)
            {
                def='SalesforceEvent';
            }
            else
            {
                def= Null;
            }
        
        System.debug(def);
        return def;
    }
}