/* Class Name: GYNC_RelatedList
* This is to show all the custom realted list of Account
* Created by: Sapna kumari
*/

public with sharing class GYNC_RelatedList {    
    @AuraEnabled
    public static String sendNewcolumn(List<String> newcolumn,String AccountId){
        System.debug('newcolumn='+newcolumn);
        String query = 'select GYNCF_Salesorder__c,';
        for(Integer i = 0;i<newcolumn.size();i++){
            if(i!=newcolumn.size()-1){
                query = query+newcolumn[i]+',';
            }
            else{
                query = query+newcolumn[i];
            }
        }
        query = query + ' from Order where AccountId =\'' + String.escapeSingleQuotes(AccountId) + '\'';  
            //\'' + String.escapeSingleQuotes(strText) + '\''
            //: AccountId';
            //\''+AccountId+ '\'';
        System.debug('query'+query);
        List<Order> OrderList = Database.query(query);
        
        return JSON.serialize(OrderList);
    }
    
    @AuraEnabled
    public static void fetchtheColumn(String colval){
        //check the access of the fields
        String [] expenseAccessFields = new String [] {'Name',
            'Has_Column_Field__c',
            'GYNC_Related_list_Column__c'
            };
                Map<String,Schema.SObjectField> m = Schema.SObjectType.GYNCO_Configuration__c.fields.getMap();
        
        for (String fieldToCheck : expenseAccessFields) {
            
            // Check if the user has access to view field
            if (!Test.isRunningTest() && !m.get(fieldToCheck).getDescribe().isCreateable()) {
                // Pass error to client
                throw new System.NoAccessException();
            }
        }
        System.debug('colval'+colval);
        //to store the column valaue in Sales order record
        GYNCO_Configuration__c config = [select Name,GYNC_Related_list_Column__c,Has_Column_Field__c from GYNCO_Configuration__c where Name =  'Sales Order' and Has_Column_Field__c = True WITH SECURITY_ENFORCED LIMIT 1];
        if(config.Name != ''){
            config.Has_Column_Field__c = true;
            config.GYNC_Related_list_Column__c = colval;
            if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNC_Related_list_Column__c.isUpdateable()){
                update config;
            }
        }
        
        //To update the UI table data with the dynamic query for new fields selected in the column
        
    }
    
    @AuraEnabled
    public static String onloadfechorderrecord(){
        String colmn = '';
        GYNCO_Configuration__c config = [select Name,GYNC_Related_list_Column__c,Has_Column_Field__c from GYNCO_Configuration__c where Name =  'Sales Order' and Has_Column_Field__c = True WITH SECURITY_ENFORCED limit 1];
        if(config.GYNC_Related_list_Column__c != null){
            colmn = config.GYNC_Related_list_Column__c;
        }
        System.debug('colmn'+colmn);
        return colmn;
    }
    
    //To get the fields of all the selected object
    @AuraEnabled
    public static String FetchThefields(String defaultfield){
        String [] expenseAccessFields = new String [] {'Name',
            'Has_Column_Field__c',
            'GYNC_Related_list_Column__c'
            };
                Map<String,Schema.SObjectField> m = Schema.SObjectType.GYNCO_Configuration__c.fields.getMap();
        //System.debug('Check 70: '+defaultfield);
        for (String fieldToCheck : expenseAccessFields) {
            
            System.debug('Check 72: '+fieldToCheck);
            // Check if the user has access to view field
            if (!Test.isRunningTest() && !m.get(fieldToCheck).getDescribe().isCreateable()) {
                
                // Pass error to client
                throw new System.NoAccessException();
            }
        }
        //To store the column value in a sales order record of configuration object
        if(defaultfield != ''){
            GYNCO_Configuration__c config = [select Name,Has_Column_Field__c,GYNC_Related_list_Column__c from GYNCO_Configuration__c where Name =  'Sales Order' WITH SECURITY_ENFORCED limit 1];
            if(!config.Has_Column_Field__c){
                config.Has_Column_Field__c = true;
                config.GYNC_Related_list_Column__c = defaultfield;
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNC_Related_list_Column__c.isUpdateable()){
                    update config;
                }
            }
            system.debug('ObjName'+config);
        }
        
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Order').getDescribe().fields.getMap();
        List<WrapperListforfields> wrapfieldsList = new List<WrapperListforfields>();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            WrapperListforfields wrapfields = new WrapperListforfields();
            schema.describefieldresult dfield = sfield.getDescribe();
            Schema.DisplayType FldType = sfield.getDescribe().getType();
            wrapfields.fieldsName = dfield.getLabel ();
            wrapfields.FieledAPIName = dfield.getname();
            wrapfields.FieldType = String.ValueOf(FldType);
            wrapfieldsList.add(wrapfields);
        }
        System.debug('wrapfieldsList = '+wrapfieldsList);
        return JSON.serialize(wrapfieldsList);
    }
    public class WrapperListforfields {
        @AuraEnabled public String fieldsName{get;set;}
        @AuraEnabled public String FieledAPIName{get;set;}
        @AuraEnabled public String FieldType{get;set;} 
    }
}