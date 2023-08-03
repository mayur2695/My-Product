public with sharing class GYNC_GetAllCandidates {

    //To return initial account records
    @AuraEnabled
    public static CandidateWrapper getCandidateRecords(Integer initialRows, string positionId){
            CandidateWrapper candidateWrapper= new CandidateWrapper();
            List<GYNCO_Candidate__c> can = NEW List<GYNCO_Candidate__c>();
            if(GYNCO_Candidate__c.SObjectType.getDescribe().isAccessible() && 
                /*Attachments.SObjectType.getDescribe().isAccessible() && 
                Schema.SObjectType.Attachments.fields.Name.isAccessible() &&
                Schema.SObjectType.Attachments.fields.Id.isAccessible()
                Schema.SObjectType.GYNCO_Candidate__c.fields.Id.isAccessible() &&*/
                Schema.SObjectType.GYNCO_Candidate__c.fields.Name.isAccessible() &&
                Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Email__c.isAccessible() &&
                Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Phone_Number__c.isAccessible() &&
                Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Has_Resume__c.isAccessible() &&
                Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Location__c.isAccessible()){
                    can = [SELECT Id, Name, GYNCF_Email__c, GYNCF_Phone_Number__c,GYNCF_Has_Resume__c, GYNCF_Location__c, (SELECT Id, Name FROM Attachments LIMIT 1)
                        FROM GYNCO_Candidate__c WHERE GYNCF_Position__c = :PositionId ORDER BY CreatedDate DESC LIMIT :initialRows OFFSET 0 ];
        // System.debug(Can);
                for(GYNCO_Candidate__c candidate:can)
                {
                    if(candidate.Attachments.Size() > 0)
                    {
                        candidate.GYNCF_Has_Resume__c = True;
                    }
                
                }
        //               try{
            candidateWrapper.candidateList= can;
            candidateWrapper.totalRecords = [SELECT COUNT() FROM GYNCO_Candidate__c WHERE GYNCF_Position__c = :PositionId];
            candidateWrapper.message = 'Candidate records are loaded';
            candidateWrapper.success = true;
        //  }
        //  catch(Exception e){
            //  CandidateWrapper.message = e.getMessage();
            //   CandidateWrapper.success = false;
        //  }
        }
        return candidateWrapper;
    }
    //To return additional records based on offset
    @AuraEnabled
    public static List<GYNCO_Candidate__c> loadCandidateRecords(Integer rowLimit,Integer rowOffset,string positionId){
        List<GYNCO_Candidate__c> can = NEW List<GYNCO_Candidate__c>();
        if(GYNCO_Candidate__c.SObjectType.getDescribe().isAccessible() && 
            /*Attachments.SObjectType.getDescribe().isAccessible() && 
            Schema.SObjectType.Attachments.fields.Name.isAccessible() &&
            Schema.SObjectType.Attachments.fields.Id.isAccessible()
            Schema.SObjectType.GYNCO_Candidate__c.fields.Id.isAccessible() &&*/
            Schema.SObjectType.GYNCO_Candidate__c.fields.Name.isAccessible() &&
            Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Email__c.isAccessible() &&
            Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Phone_Number__c.isAccessible() &&
            Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Has_Resume__c.isAccessible() &&
            Schema.SObjectType.GYNCO_Candidate__c.fields.GYNCF_Location__c.isAccessible())
        {
            can = [SELECT Id, Name, GYNCF_Email__c, GYNCF_Phone_Number__c,GYNCF_Has_Resume__c, GYNCF_Location__c, (SELECT Id, Name FROM Attachments LIMIT 1)
                            FROM GYNCO_Candidate__c WHERE GYNCF_Position__c = :PositionId ORDER BY CreatedDate DESC LIMIT :rowLimit OFFSET :rowOffset];
        
        // System.debug(Can);
            for(GYNCO_Candidate__c candidate:can)
            {
                if(candidate.Attachments.Size() > 0)
                {
                    candidate.GYNCF_Has_Resume__c = True;
                }
            }
        //  system.debug(Can2);
        }
    
        Return can;
    }
    // wrapper class
    public with sharing class CandidateWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<GYNCO_Candidate__c> candidateList = new List<GYNCO_Candidate__c>();
        //@AuraEnabled
        //Public List<GYNCO_Candidate__c> cdlist = new List<GYNCO_Candidate__c>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }
    }