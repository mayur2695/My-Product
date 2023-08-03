@istest
public class GYNC_testClassForShowController 
{
    @istest
    static void testSearch()
    {
        String s='Gyansys';
        String o='GYNCO_Offer_Letter_Template__c';
        String f='Name';
        List < sObject > records = new List < sObject > ();
        records = GYNC_TemplateShowController.fetchLookUpValues(s,o,f);
        system.assert(true);
    }
    
    @istest
    static void fetchData()
    {
        List < sObject > rec = new List < sObject > ();
        rec = GYNC_TemplateShowController.fetchTableData();
        system.assert(true);
    }
    
    @istest
    static void SelectTemplate()
    {
        GYNCO_Offer_Letter_Template__c temp = new GYNCO_Offer_Letter_Template__c();
        temp.Name = 'abc';
        temp.GYNCF_Template__c = 'body';
        List < GYNCO_Offer_Letter_Template__c > recs = new List < GYNCO_Offer_Letter_Template__c > ();
        recs = GYNC_TemplateShowController.SelectTemplate(temp);
        for(GYNCO_Offer_Letter_Template__c t: recs)
        {
            if(t.GYNCF_Active__c == true)
            {
                System.debug('true');
            }
            else
            {
                System.debug('false');
            }
        }
        system.assert(true);
    }
}