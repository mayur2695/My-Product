// This is a server side controller of GYNC_NewCandidateForm component
// It is created to insert candidate record
// created by - Arnab Dey

public with sharing class GYNC_NewCandidate 
{
    @AuraEnabled
    // saveCandidate method inserts a candidate record and returns the record's id
    public static Id saveCandidate(GYNCO_Candidate__c candidate)

    {

        Id candidateId;
        INSERT Candidate;
        CandidateId=Candidate.Id;
        return CandidateId;
        
        }
}