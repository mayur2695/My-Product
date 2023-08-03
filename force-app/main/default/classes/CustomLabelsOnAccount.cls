public with sharing class CustomLabelsOnAccount {
    public CustomLabelsOnAccount(){
        optQual = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Qualification' LIMIT 15];
        optNA = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Needs Analysis' LIMIT 15];
        optPQ = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Proposal/Price Quote' LIMIT 15];
        optCW = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Closed Won' LIMIT 15];
        optCL = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Closed Lost' LIMIT 15];
        optPR = [select Name, Account.Name, StageName, Amount, CloseDate, CurrencyIsoCode, OwnerId, Probability from Opportunity where StageName='Prospecting' LIMIT 15];
    }
    
    public List<Opportunity> optQual{set; get;}
    public List<Opportunity> optNA{set; get;}
    public List<Opportunity> optPQ{set; get;}
    public List<Opportunity> optCW{set; get;}
    public List<Opportunity> optCL{set; get;}
    public List<Opportunity> optPR{set; get;}
    
    
    public Account acc {get;set;}
    public CustomLabelsOnAccount (ApexPages.StandardController stdController) 
    {
        this.acc = (Account)stdController.getRecord();
    }
    public PageReference customSave()
    {
        PageReference pr;
        try{
            database.upsert(acc);
            pr = new PageReference('/'+acc.Id );
        }catch( Exception e ){
            ApexPages.addMessages(e);
        }
        return pr;        
    }
}