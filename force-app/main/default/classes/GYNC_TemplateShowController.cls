/* This class is a server side controller of the custom component named GYNL_searchBar which
 * queries records to be displayed in the Search Bar in Admin Screen.
   Created by - Debraj Mondal  */

   public with sharing class GYNC_TemplateShowController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String objectName, String fieldName) {
        system.debug('ObjectName-->' + objectName);
        String searchKey = searchKeyWord + '%';
    
        List < sObject > returnList = new List < sObject > ();


      // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name,GYNCF_Template__c    from ' +objectName + ' where '+fieldName+' LIKE: searchKey order by createdDate DESC limit 5' ;
    

        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug(lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    @AuraEnabled
    public static List < sObject > fetchTableData(){
        LIST <GYNCO_Offer_Letter_Template__c> temps = New List<GYNCO_Offer_Letter_Template__c>();

        if(
            GYNCO_Offer_Letter_Template__c.SObjectType.getDescribe().isAccessible()&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.Id.isAccessible()&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.Name.isAccessible()&&
          //  Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Active__c.isAccessible&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Template__c.isAccessible()
        ){


        temps = [SELECT Id,Name,GYNCF_Active__c,GYNCF_Template__c FROM GYNCO_Offer_Letter_Template__c];
    }
        return temps;
    }
    @AuraEnabled
    public static List < sObject > selectTemplate(GYNCO_Offer_Letter_Template__c temp){
        // system.debug(Temp.GYNCF_Company_Name__c+'-----'+Temp.Id);
        LIST <GYNCO_Offer_Letter_Template__c> templates = New List<GYNCO_Offer_Letter_Template__c>();



        if(
            GYNCO_Offer_Letter_Template__c.SObjectType.getDescribe().isAccessible()&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.Id.isAccessible()&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.Name.isAccessible()&&
            //Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Active__c.isAccessible&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Template__c.isAccessible()
        ){

        templates = [SELECT Id,Name,GYNCF_Active__c,GYNCF_Template__c FROM GYNCO_Offer_Letter_Template__c];
        }
        System.debug(templates);
        
        if(
            GYNCO_Offer_Letter_Template__c.SObjectType.getDescribe().isUpdateable()&&
            Schema.SobjectType.GYNCO_Offer_Letter_Template__c.fields.GYNCF_Active__c.isUpdateable()
        ){
        For(GYNCO_Offer_Letter_Template__c t :templates){
            If(t.Id == temp.Id){
                t.GYNCF_Active__c = True;
            }
            else{
                t.GYNCF_Active__c = False;
            }
        }
        
    }

        Update templates;
        Return templates;
    }
}