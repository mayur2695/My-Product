/* Handler class for the Apex trigger GYNT_createInterviewTrigger
* Developer Name: Debraj Mondal
* Created On:05/12/2020
*/ 

public with sharing class GYNC_createInterview {
    
    /* The createNew() function is used to a create a new Interview record 
     * populated with values from Position, Candidate and Interview Panel records
     * when Status of Position is updated to 'Interview'*/
    public static List<GYNCO_Interview__c> createNew(LIST<GYNCO_Position__c> pos)
    {   
        Map<Id, GYNCO_Position__c> posMap = new Map<Id, GYNCO_Position__c>(pos);
        List<Id> ids = New List<Id>(); 
          For(GYNCO_Position__c ev :pos)
          {
           Ids.add(Ev.Id);
          }
        //cn is a list of Candidates related to the Position record
        list<GYNCO_candidate__c> cn= new List<GYNCO_candidate__c>();
        
        cn=[select id,name,GYNCF_Position__c,GYNCF_Location__c,GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c,GYNCF_Position__r.GYNCF_Meeting_Link__c,(Select Id From Attachments) from GYNCO_Candidate__c where GYNCF_Position__c IN: Ids];


        /*for var discountData = ('{"id":"", "name":"", "GYNCF_Position__c":"", "GYNCF_Location__c":"", "GYNCF_Position__r":"","GYNCF_Meeting_Link__c":"","Id":""}');*/
         
         //olt stores the queried Active Offer Letter Template 
        GYNCO_Offer_Letter_Template__c olt=new GYNCO_Offer_Letter_Template__c();
        if(
            GYNCO_Offer_Letter_Template__c.SObjectType.getDescribe().isAccessible() &&
				Schema.SObjectType.GYNCO_Offer_Letter_Template__c.fields.Id.isAccessible() &&
				Schema.SObjectType.GYNCO_Offer_Letter_Template__c.fields.Name.isAccessible() &&
				Schema.SObjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Template__c.isAccessible() 
                
         ) {
        olt=[select Id,Name,GYNCF_Template__c from GYNCO_Offer_Letter_Template__c where GYNCF_Active__c=True limit 1];
            }
        //inpl is a list of Interview Panels related to the Position record
        List<GYNCO_Interview_Panel__c> inpl=new List<GYNCO_Interview_Panel__c>();
        
        inpl=[select id,GYNCF_Interviewer__c,GYNCF_Interview_round__c,GYNCF_Interview_Date__c,GYNCF_Position__C 
              from GYNCO_Interview_Panel__c where GYNCF_Position__C IN: Ids];
         
        //intv is a list of Interview records corresponding to each Candidate record that will be returned
        List<GYNCO_Interview__c> intv=new List<GYNCO_Interview__c>();
        //Loop iterates each Candidate record and populates fields of corresponding Interview record to be created
      	/*String rectypeid=Schema.getGlobalDescribe().get('GYNCO_Interview__c').getDescribe().getRecordTypeInfosByDeveloperName().get('With_button_record_type').getRecordTypeId();;
          rectypeid = Schema.getGlobalDescribe().get('GYNCO_Interview__c').getDescribe().getRecordTypeInfosByDeveloperName().get('With_button_record_type').getRecordTypeId();
          system.debug(rectypeid);*/
        List<RecordType> rectypeid=new List<RecordType>();
        
        rectypeid=[SELECT Id FROM RecordType WHERE DeveloperName = 'With_button_record_type' AND SobjectType = 'GYNCO_Interview__c' limit 1];
         
        
        for(GYNCO_candidate__c cnd:cn)
        {    
            GYNCO_Interview__c it=new GYNCO_Interview__c();
            it.name=cnd.name;
            it.GYNCF_Final_offer_amount__c = posMap.get(cnd.GYNCF_Position__c).GYNCF_Final_offer_amount__c;
            it.GYNCF_Offer_Letter_Template__c=olt.Id;
            it.GYNCF_Template__c=olt.GYNCF_Template__c.replace('&Candidate Name&',cnd.name)
                .replace('&Designation&', posMap.get(cnd.GYNCF_Position__c).GYNCF_Designation__c).replace('&Location&',cnd.GYNCF_Location__c)
                .replace('&Joining Date&', String.valueOf(posMap.get(cnd.GYNCF_Position__c).GYNCF_Joining_Date__c))
                .replace('&Final Compensation&', String.valueOf(posMap.get(cnd.GYNCF_Position__c).GYNCF_Final_offer_amount__c))
                .replace('&Company&', posMap.get(cnd.GYNCF_Position__c).GYNCF_Company__c);
            
            it.GYNCF_status__c='Round 1';
            it.GYNCF_Position__c=cnd.GYNCF_Position__c;
            it.GYNCF_Use_Salesforce_Event__c = cnd.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
            it.GYNCF_Meeting_Link__c = cnd.GYNCF_Position__r.GYNCF_Meeting_Link__c;
            it.GYNF_Candidate_Resume_Id__c = cnd.Attachments[0].Id;
            if(!rectypeid.isEmpty())
            {
            	it.GYNCF_Rec_Type_Id__c=rectypeid[0].id;
            }
            /*If & else-if block to populate the Interviewer and RoundxDate 
            fields on the basis of Number of Rounds field in related Position record*/
            if(posMap.get(cnd.GYNCF_Position__c).GYNCF_Number_Of_Rounds__c=='1')
            {    
                for(GYNCO_Interview_Panel__c ip:inpl)
                {
                    if(ip.GYNCF_Interview_round__c=='Round 1' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer1__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round1Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    
                }
            }
            else if(posMap.get(cnd.GYNCF_Position__c).GYNCF_Number_Of_Rounds__c=='2')
            {    
                for(GYNCO_Interview_Panel__c ip:inpl)
                {
                    if(ip.GYNCF_Interview_round__c=='Round 1' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer1__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round1Date__c=ip.GYNCF_Interview_Date__c;
                        
                    }
                    
                    if(ip.GYNCF_Interview_round__c=='Round 2' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer2__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round2Date__c=ip.GYNCF_Interview_Date__c;
                    }
                }
            }
            else if(posMap.get(cnd.GYNCF_Position__c).GYNCF_Number_Of_Rounds__c=='3')
            {    
                for(GYNCO_Interview_Panel__c ip:inpl)
                {
                    if(ip.GYNCF_Interview_round__c=='Round 1' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer1__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round1Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 2' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer2__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round2Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 3' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer3__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round3Date__c=ip.GYNCF_Interview_Date__c;
                    }
                }
            }
            else if(posMap.get(cnd.GYNCF_Position__c).GYNCF_Number_Of_Rounds__c=='4')
            {    
                for(GYNCO_Interview_Panel__c ip:inpl)
                {
                    if(ip.GYNCF_Interview_round__c=='Round 1' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer1__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round1Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 2' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer2__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round2Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 3' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer3__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round3Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 4' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer4__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round4Date__c=ip.GYNCF_Interview_Date__c;
                    }
                }
            }
            else if(posMap.get(cnd.GYNCF_Position__c).GYNCF_Number_Of_Rounds__c=='5')
            {    
                for(GYNCO_Interview_Panel__c ip:inpl)
                {
                    if(ip.GYNCF_Interview_round__c=='Round 1' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer1__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round1Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 2' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer2__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round2Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 3' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer3__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round3Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 4' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer4__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round4Date__c=ip.GYNCF_Interview_Date__c;
                    }
                    if(ip.GYNCF_Interview_round__c=='Round 5' && ip.GYNCF_Position__C == cnd.GYNCF_Position__c )
                    {
                        it.GYNCF_Interviewer5__c=ip.GYNCF_Interviewer__c;
                        it.GYNCF_Round5Date__c=ip.GYNCF_Interview_Date__c;
                    }
                }
            }
            intv.add(it);
        }
        return intv;
    }
    
}