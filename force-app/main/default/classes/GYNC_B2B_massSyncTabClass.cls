public with sharing class GYNC_B2B_massSyncTabClass {
 @AuraEnabled
    public static Wrapper getObjectName(){
        
       String TimeZone;
       //systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
       List<GYNCO_Configuration__c> ConfigObjVal = new list<GYNCO_Configuration__c>();
       ConfigObjVal = [select name,Id,GYNCF_SFDC_Object_Name__c, GYNCF_Mass_Sync__c,GYNCF_System_Id__c,GYNCF_Mass_Sync_Live__c,GYNF_Object_Icon__c,GYNCF_Last_Synced__c,GYNCF_To_Be_Synced__c,GYNCF_Synced__c,GYNCF_Availability_Of_Objects__c from   GYNCO_Configuration__c   where GYNCF_Availability_Of_Objects__c = true  ORDER BY Name asc];
        Wrapper objWrapper = new Wrapper();
            objWrapper.Timezone =string.ValueOf(UserInfo.getTimezone());
            
            objWrapper.ConfigObjVal  =ConfigObjVal;
        
        return objWrapper;
    }
    public static GYNCO_Configuration__c findConfigRec(String objNameSAP) {
        return [SELECT Id, Name,GYNCF_Date_Range_From__c,GYNCF_Date_Range_To__c,GYNCF_Fiscal_Year__c,GYNCF_Company_Code__c,GYNCF_Available_Fileters__c,GYNCF_Billing_Type__c, GYNCF_SFDC_Object_Name__c, GYNCF_Field_Maping__c, GYNCF_Service_URL__c, 
                            GYNCF_Identifier_SFDC__c, GYNCF_Identifier_SAP__c,GYNCF_Batch_Size__c, GYNCF_To_Be_Synced__c,GYNCF_Account_Group__c, GYNCF_Sales_Org__c, GYNCF_Distribution_Channel__c, GYNCF_LineItemApi_Name__c,
                     		GYNCF_Division__c, GYNCF_Archived__c,GYNCF_Material_Group__c,GYNCF_Material_Type__c,GYNCF_Billing_Start_Date__c,GYNCF_Billing_End_Date__c,GYNCF_SalesOrder_Quote_Filter__c, GYNCF_PricebookApi_Name__c,
                			GYNCF_LineItem_Identifier_SAP__c, GYNCF_LineItem_Identifier_SFDC__c, GYNCF_Default_Order_Status__c, GYNCF_Default_Quote_Opportunity__c, GYNCF_LineItem_ParentField_Api__c, GYNCF_PricebookEntry_Field_API_Name__c,
                			Sync_Only_DELTA__c, GYNCF_Last_Synced__c,GYNCF_System_Status__c, GYNCF_Mass_Sync_Live__c, GYNCF_isFLSActive__c
                            FROM GYNCO_Configuration__c WHERE Name = :objNameSAP LIMIT 1];
    }
    public static GYNCO_Configuration__c findConfigRec(String objNameSAP,String systemId) {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        return [SELECT Id, Name,GYNCF_Date_Range_From__c,GYNCF_Date_Range_To__c,GYNCF_Fiscal_Year__c,GYNCF_Company_Code__c,GYNCF_Document_Type__c,GYNCF_Billing_Type__c,GYNCF_Document_Status__c,GYNCF_Available_Fileters__c, GYNCF_SFDC_Object_Name__c, GYNCF_Field_Maping__c, GYNCF_Service_URL__c, 
                            GYNCF_Identifier_SFDC__c, GYNCF_Identifier_SAP__c,GYNCF_Batch_Size__c, GYNCF_To_Be_Synced__c,GYNCF_Account_Group__c, GYNCF_Sales_Org__c, GYNCF_Distribution_Channel__c, GYNCF_LineItemApi_Name__c,
                     		GYNCF_Division__c, GYNCF_Archived__c,GYNCF_Material_Group__c,GYNCF_Material_Type__c,GYNCF_Billing_Start_Date__c,GYNCF_Billing_End_Date__c,GYNCF_SalesOrder_Quote_Filter__c, GYNCF_PricebookApi_Name__c,
                			GYNCF_LineItem_Identifier_SAP__c, GYNCF_LineItem_Identifier_SFDC__c, GYNCF_Default_Order_Status__c, GYNCF_Default_Quote_Opportunity__c, GYNCF_LineItem_ParentField_Api__c, GYNCF_PricebookEntry_Field_API_Name__c,
                			Sync_Only_DELTA__c, GYNCF_Last_Synced__c,GYNCF_System_Status__c, GYNCF_Mass_Sync_Live__c, GYNCF_isFLSActive__c
                            FROM GYNCO_Configuration__c WHERE Name = :objNameSAP and GYNCF_System_Id__c = :systemId LIMIT 1];
    }
    
    @AuraEnabled
    public static String startMassSync(String objNameSAP, String systemId){
        system.debug('systemId++++='+systemId);
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        System.debug('Check objNameSAP: '+objNameSAP);
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        configRec = findConfigRec(objNameSAP, systemId);
        system.debug('checkTestConfigRec======'+configRec);
        String status = GYNC_MassSyncUtility.callMassSync(configRec, systemId);
        system.debug('SytemId2++'+systemId);
        System.debug('Check Ststue: '+status);
        if(status == 'Success' && Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable()) {
            configRec.GYNCF_Mass_Sync_Live__c = True;
            UPDATE configRec;
            return status;
        }
        return 'Error';
    }
    public class Wrapper{
        @AuraEnabled public list<GYNCO_Configuration__c> ConfigObjVal{get;set;}
        @AuraEnabled public string Timezone{get;set;}
        /*public Wrapper(list<GYNCO_Configuration__c> ConfigObjVal,string Timezone){
            this.ConfigObjVal = ConfigObjVal;
            this.Timezone = Timezone;
        }*/
    }
}