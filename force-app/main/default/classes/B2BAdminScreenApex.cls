public with sharing class B2BAdminScreenApex {
 @AuraEnabled
    public static AdminWrappedList getConfiguration(String SystemId){
        List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
        ConfigList =[SELECT Id,Name,GYNCF_Service_URL__c,GYNCF_System_Id__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:SystemId];
        AdminWrappedList wrap = new AdminWrappedList();
        for(GYNCO_Configuration__c config:ConfigList){
            // config.GYNCF_System_Id__c GYNCF_System_Id__c =:SystemId
            if(config.Name =='Customer')
                wrap.Customer =  config.GYNCF_Service_URL__c;
            
            if(config.Name =='Quotation')
                wrap.Quotation = config.GYNCF_Service_URL__c;
            if(config.Name =='Materials')
                wrap.Materials=config.GYNCF_Service_URL__c;
            if(config.Name =='Equipment')
                wrap.Equipment=config.GYNCF_Service_URL__c;
            if(config.Name =='Expense')
                wrap.Expense=config.GYNCF_Service_URL__c;
            if(config.Name =='Invoice')
                wrap.Invoice=config.GYNCF_Service_URL__c;
            if(config.Name =='Sales Order')
                wrap.SalesOrder=config.GYNCF_Service_URL__c;
            if(config.Name =='Project')
                wrap.Project=config.GYNCF_Service_URL__c;
            
        }
        
        GYNCS_AuthorizationSetting__c authorizationSetting = [select id,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId];
        //GYNCS_AuthorizationSetting__c.getOrgDefaults();
        
        wrap.ClientId=authorizationSetting.GYNCF_Client_Id__c;
        wrap.ClientSecret=authorizationSetting.GYNCF_Client_Secret__c;
        wrap.LoginUrl=authorizationSetting.GYNCF_oAuth_Login_URL__c;
        wrap.Password=authorizationSetting.GYNCF_Password__c;
        wrap.Username=authorizationSetting.GYNCF_User_Name__c;
        wrap.SystemData=Systemdata();
        return wrap;
        
    }
    @AuraEnabled
    public static void updateauth(AdminWrappedList wrap,String systemId){
        updateConfiguration(wrap,systemId);
        updateAuthorization(wrap,systemId);
    }
    public static void updateConfiguration(AdminWrappedList wrap,String systemID){
        List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
        ConfigList =[SELECT Id,Name,GYNCF_Service_URL__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:systemID];
        
        for(GYNCO_Configuration__c config:ConfigList){
            
            if(config.Name =='Customer')
                config.GYNCF_Service_URL__c=wrap.Customer;
            if(config.Name =='Quotation')
                config.GYNCF_Service_URL__c=wrap.Quotation;
            if(config.Name =='Materials')
                config.GYNCF_Service_URL__c=wrap.Materials;
            if(config.Name =='Equipment')
                config.GYNCF_Service_URL__c=wrap.Equipment;
            if(config.Name =='Expense')
                config.GYNCF_Service_URL__c=wrap.Expense;
            if(config.Name =='Invoice')
                config.GYNCF_Service_URL__c=wrap.Invoice;
            if(config.Name =='Sales Order')
                config.GYNCF_Service_URL__c=wrap.SalesOrder;
            if(config.Name =='Project')
                config.GYNCF_Service_URL__c=wrap.Project;
            
        }
        update ConfigList;
        
    }
    public static void updateAuthorization(AdminWrappedList wrap,String SystemId){
        //GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        //authorizationSetting=[select id,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId];
        GYNCS_AuthorizationSetting__c authorizationSetting = [select id,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId];
        
        if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Client_Id__c.isUpdateable() || Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Client_Id__c.isCreateable()){ 
            authorizationSetting.GYNCF_Client_Id__c=wrap.ClientId;
        }
        if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Client_Secret__c.isUpdateable() || Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Client_Secret__c.isCreateable()){
            authorizationSetting.GYNCF_Client_Secret__c=wrap.ClientSecret;    
        }
        if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_oAuth_Login_URL__c.isUpdateable() || Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_oAuth_Login_URL__c.isCreateable()){
            authorizationSetting.GYNCF_oAuth_Login_URL__c=wrap.LoginUrl;    
        }
        if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Password__c.isUpdateable() || Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Password__c.isCreateable()){
            authorizationSetting.GYNCF_Password__c=wrap.Password;    
        }
        if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_User_Name__c.isUpdateable() || Schema.sObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_User_Name__c.isCreateable()){
            authorizationSetting.GYNCF_User_Name__c=wrap.Username;    
        }        
        
        upsert authorizationSetting;
        
        
    }
    
    @AuraEnabled
    public static String Systemdata(){
        //return '';
        return JSON.serialize(GYNC_UtilityClass.findSystem());
    }
    @AuraEnabled
    public static String createSetting(String Name,String BaseUrl){
        //String NewRecID;
        GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        
        if(Schema.SObjectType.GYNCS_AuthorizationSetting__c.fields.Name.isCreateable() && Schema.SObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Authorization_Type__c.isCreateable() && Schema.SObjectType.GYNCS_AuthorizationSetting__c.fields.GYNCF_Base_URL__c.isCreateable()){
        authorizationSetting.Name=Name;
        authorizationSetting.GYNCF_Authorization_Type__c='Basic';
        authorizationSetting.GYNCF_Base_URL__c=BaseUrl;
        //authorizationSetting.SetupOwnerId=UserInfo.getUserId();
        if(Schema.SObjectType.GYNCS_AuthorizationSetting__c.isAccessible() && Schema.SObjectType.GYNCS_AuthorizationSetting__c.isCreateable())
        insert authorizationSetting;
        }
        List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
        List<GYNCO_Configuration__c> NewConfigList= new List<GYNCO_Configuration__c>();
        ConfigList =[select Name,GYNCF_Time__c,GYNCF_Synced__c,GYNCF_To_Be_Synced__c,GYNCF_SFDC_Child_Object_Name__c,Scheduler_information__c,GYANF_SAP_Object_API__c,GYNCF_Operation_Type__c,GYNCF_SalesOrder_Quote_Filter__c,GYNCF_LineItemBodyTitle__c,GYNCF_Nodes_for_SAP_API__c,GYNCF_Monthly_Number_Option__c,GYNCF_Monthly_Date_Options__c,GYNCF_Mass_Sync_Live__c,GYNCF_LineItem_Identifier_SAP__c,GYNF_Object_Icon__c,GYNCF_DyanamicChildItemQuery__c,GYNCF_Default_Quote_Opportunity__c,GYNCF_Available_Fileters__c,GYNCF_SAP_API_Fields__c,GYNCF_Identifier_SAP__c,GYNCF_Create__c,GYNCF_Account_Group__c,GYNCF_Bill_To__c,GYNCF_Billing_Block__c,GYNCF_Company_Code__c,GYNCF_Customer_Number__c,GYNCF_Date_Range_From__c,
                     GYNCF_Date_Range_To__c,GYNCF_Delivery_Block__c,GYNCF_Distribution_Channel__c,GYNCF_Division__c,GYNCF_Document_Type__c,GYNCF_Equipment_Category__c,GYNCF_Field_Maping__c,
                     GYNCF_Mass_Sync__c,GYNCF_Mass_Sync_Frequency__c,GYNCF_Material_Group__c,GYNCF_Material_Type__c,GYNCF_Quote_Id__c,GYNCF_Sales_Org__c,GYNCF_SAP_Condition_Type__c,
                     GYNCF_Search__c,GYNCF_Service_URL__c,GYNCF_SFDC_Object_Name__c,GYNCF_System_Status__c,GYNCF_Document_Status__c,GYNCF_Archived__c,GYNCF_Billing_Start_Date__c,
                     GYNCF_Billing_End_Date__c,GYNCF_Fiscal_Year__c,GYNCF_Billing_Type__c,GYNCF_CRON_Expression__c,Sync_Only_DELTA__c,GYNCF_Default_Order_Status__c,GYNCF_Identifier_SFDC__c,
                     GYNCF_LineItemApi_Name__c,GYNCF_LineItem_Identifier_SFDC__c,GYNCF_LineItem_ParentField_Api__c,GYNCF_PricebookEntry_Field_API_Name__c,GYNCF_PricebookApi_Name__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:[select Id,name from GYNCS_AuthorizationSetting__c where name='Default' limit 1].Id];
        //SELECT Id,Name,GYNCF_Service_URL__c,GYNCF_System_Id__c 
        System.debug('data'+ConfigList.size());
        
        for(GYNCO_Configuration__c con:ConfigList){
            if(con.Name =='Sales Order' || con.Name=='Invoice' || con.Name=='Equipment' || con.Name=='Materials' || con.Name=='Quotation' || con.Name=='Customer'){
                GYNCO_Configuration__c data=con.clone(false, true, false, false);
                if(Schema.SObjectType.GYNCO_Configuration__c.fields.GYNCF_System_Id__c.isCreateable()){
                data.GYNCF_System_Id__c=authorizationSetting.Id;
                }
                System.debug('dataURL'+con.GYNCF_Service_URL__c);
                System.debug('Name'+con.Name);
                if(con.GYNCF_Service_URL__c !=null && Schema.SObjectType.GYNCO_Configuration__c.fields.GYNCF_Service_URL__c.isCreateable()){
                    
                    data.GYNCF_Service_URL__c=BaseUrl+con.GYNCF_Service_URL__c.replace('http://ec2-18-215-72-123.compute-1.amazonaws.com:8080','');
                }
                System.debug('');
                NewConfigList.add(data);
            }
        }
        System.debug('dataq1'+NewConfigList);
        if(Schema.SObjectType.GYNCO_Configuration__c.isAccessible() && Schema.SObjectType.GYNCO_Configuration__c.isCreateable()){
        insert NewConfigList;
        }
        return authorizationSetting.Id;
    }
        
    public class AdminWrappedList{
        @AuraEnabled public string Customer{get;set;}
        @AuraEnabled public string Quotation{get;set;}
        @AuraEnabled public string Materials{get;set;}
        @AuraEnabled public string Equipment{get;set;}
        @AuraEnabled public string Expense{get;set;}
        @AuraEnabled public string Invoice{get;set;}
        @AuraEnabled public string SalesOrder{get;set;}
        @AuraEnabled public string Project{get;set;}
        @AuraEnabled public string ClientId{get;set;}
        @AuraEnabled public string ClientSecret{get;set;}
        @AuraEnabled public string LoginUrl{get;set;}
        @AuraEnabled public string Password{get;set;}
        @AuraEnabled public string Username{get;set;}
        @AuraEnabled public string SystemData{get;set;}
        
    }
    @AuraEnabled
    public static string DeleteSystemRec(String systemId){
        //system.debug('CheckEnter');
        if(systemId != null){
            //if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.isAccessible() && Schema.sObjectType.GYNCS_AuthorizationSetting__c.isDeletable()){
            list<GYNCS_AuthorizationSetting__c> DelSys = new list<GYNCS_AuthorizationSetting__c>([select id,Name from GYNCS_AuthorizationSetting__c where id=:systemId]);
            //System.debug('157DelSYs==='+DelSys);
            //if(Schema.sObjectType.GYNCS_AuthorizationSetting__c.isAccessible() && Schema.sObjectType.GYNCS_AuthorizationSetting__c.isDeletable()){
            if(Schema.getGlobalDescribe().get('GYNCS_AuthorizationSetting__c')!=null && Schema.getGlobalDescribe().get('GYNCS_AuthorizationSetting__c').getDescribe().isDeletable()){
            Delete DelSys;
            }
            Return DelSys[0].Name;
        }
        else{
            Return 'Error';
        }
    }
    
    @AuraEnabled
    public static Boolean FeatureParameterVal(String feature){
        Boolean masterDataFlagInstance = true; //As Ashis suggested, to make all features availale by default.
        try {
            masterDataFlagInstance = System.FeatureManagement.checkPackageBooleanValue(feature);
            
        }
        catch(exception ex) {
            //System.debug('You do not have access.');
        }
        return masterDataFlagInstance;
        
    }
    @AuraEnabled
    public static String LandingFeatureParameterVal(){
        String feature1='masterDataFlag';
        String feature2='salesConnectFlag';
        Boolean feature1Check = true; //As Ashis suggested, to make all features availale by default.
        Boolean feature2Check=true;
        try {
            feature1Check = System.FeatureManagement.checkPackageBooleanValue(feature1);
            feature2Check = System.FeatureManagement.checkPackageBooleanValue(feature2);
        }
        catch(exception ex) {
            //System.debug('You do not have access.');
        }
        return feature1Check+'.'+feature2Check;
        
    }
}