public  with sharing class TestEmailController
{
    public Id accountId {get;set;}
    public List<Opportunity> getopptys()
    {
        List<Opportunity> oppty;
        oppty = [SELECT Name, StageName FROM Opportunity WHERE Accountid =: accountId];
        return oppty;
    }
}