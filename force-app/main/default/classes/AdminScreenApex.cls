public  with sharing class AdminScreenApex {
    
    @AuraEnabled
    public static String getConfiguration(String SystemId){
        List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
        ConfigList =[SELECT Id,Name,GYNCF_Service_URL__c,GYNCF_System_Id__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:SystemId WITH SECURITY_ENFORCED];
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
        System.debug('dTA'+SystemId);
        GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        authorizationSetting=[select id,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId WITH SECURITY_ENFORCED];
        //GYNCS_AuthorizationSetting__c.getOrgDefaults();
        
        wrap.ClientId=authorizationSetting.GYNCF_Client_Id__c;
        wrap.ClientSecret=authorizationSetting.GYNCF_Client_Secret__c;
        wrap.LoginUrl=authorizationSetting.GYNCF_oAuth_Login_URL__c;
        wrap.Password=authorizationSetting.GYNCF_Password__c;
        wrap.Username=authorizationSetting.GYNCF_User_Name__c;
        wrap.SystemData=Systemdata();
        
        return JSON.serialize(wrap);
        
    }
    @AuraEnabled
    public static string updateauth(String wrap,String systemId){
        AdminWrappedList wrapData =(AdminWrappedList)JSON.deserialize(wrap, AdminWrappedList.class);
        String cofigStatus = updateConfiguration(wrapData,systemId);
        String authStatus = updateAuthorization(wrapData,systemId);
        return 'Config: '+cofigStatus+' Auth: '+authStatus;
    }
    public static String updateConfiguration(AdminWrappedList wrap,String systemID){
        try{
            List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
            ConfigList =[SELECT Id,Name,GYNCF_Service_URL__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:systemID WITH SECURITY_ENFORCED];
            
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
            if(Schema.SObjectType.GYNCO_Configuration__c.isUpdateable() && Schema.SObjectType.GYNCO_Configuration__c.fields.GYNCF_Service_URL__c.isUpdateable()){
                update ConfigList;
            }
        }
        catch(exception ex) {
            return ex.getMessage();
        }
        return 'success';
    }
    public static String updateAuthorization(AdminWrappedList wrap,String SystemId){
        //GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        //authorizationSetting=[select id,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId];
        try{
            GYNCS_AuthorizationSetting__c authorizationSetting = [select id,GYNCF_Base_URL__c,GYNCF_Client_Id__c,GYNCF_Client_Secret__c,GYNCF_oAuth_Login_URL__c,GYNCF_Password__c,GYNCF_User_Name__c from GYNCS_AuthorizationSetting__c where id=:SystemId WITH SECURITY_ENFORCED];
            
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
            //system.debug('authorizationSetting.GYNCF_Base_URL__c' +authorizationSetting.GYNCF_Base_URL__c);
            if(authorizationSetting.GYNCF_Base_URL__c== null ){
                String baseUrlVal='';
                if(wrap.Customer !=''){
                    baseUrlVal=wrap.Customer.split('/sap/')[0];
                }
                else if(wrap.Quotation !=''){
                    baseUrlVal=wrap.Quotation.split('/sap/')[0];
                }
                else if(wrap.Materials !=''){
                    baseUrlVal=wrap.Materials.split('/sap/')[0];
                }
                else if(wrap.Equipment !=''){
                    baseUrlVal=wrap.Equipment.split('/sap/')[0];
                }
                else if(wrap.SalesOrder !=''){
                    baseUrlVal=wrap.SalesOrder.split('/sap/')[0];
                }
                else if(wrap.Invoice !=''){
                    baseUrlVal=wrap.Invoice.split('/sap/')[0];
                }
            
                authorizationSetting.GYNCF_Base_URL__c=baseUrlVal;
            }
            
            upsert authorizationSetting;
        }
        catch(exception ex) {
            return ex.getMessage();
        }
        return 'Success';
        
    }
    
    @AuraEnabled
    public static String Systemdata(){
        //return '';
        System.debug('Check: '+ JSON.serialize(GYNC_UtilityClass.findSystem()) );
        return JSON.serialize(GYNC_UtilityClass.findSystem());
    }
    @AuraEnabled
    public static String createSetting(String Name,String BaseUrl){
        //String NewRecID;
        GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        authorizationSetting.Name=Name;
        authorizationSetting.GYNCF_Authorization_Type__c='Basic';
        authorizationSetting.GYNCF_Base_URL__c=BaseUrl;
        //authorizationSetting.SetupOwnerId=UserInfo.getUserId();
        insert authorizationSetting;
        List<GYNCO_Configuration__c> ConfigList= new List<GYNCO_Configuration__c>();
        List<GYNCO_Configuration__c> NewConfigList= new List<GYNCO_Configuration__c>();
        ConfigList =[select Name,GYNCF_Time__c,GYNCF_Synced__c,GYNCF_To_Be_Synced__c,GYNCF_SFDC_Child_Object_Name__c,Scheduler_information__c,GYANF_SAP_Object_API__c,GYNCF_Operation_Type__c,GYNCF_SalesOrder_Quote_Filter__c,GYNCF_LineItemBodyTitle__c,GYNCF_Nodes_for_SAP_API__c,GYNCF_Monthly_Number_Option__c,GYNCF_Monthly_Date_Options__c,GYNCF_Mass_Sync_Live__c,GYNCF_LineItem_Identifier_SAP__c,GYNF_Object_Icon__c,GYNCF_DyanamicChildItemQuery__c,GYNCF_Default_Quote_Opportunity__c,GYNCF_Available_Fileters__c,GYNCF_SAP_API_Fields__c,GYNCF_Identifier_SAP__c,GYNCF_Create__c,GYNCF_Account_Group__c,GYNCF_Bill_To__c,GYNCF_Billing_Block__c,GYNCF_Company_Code__c,GYNCF_Customer_Number__c,GYNCF_Date_Range_From__c,
                     GYNCF_Date_Range_To__c,GYNCF_Delivery_Block__c,GYNCF_Distribution_Channel__c,GYNCF_Division__c,GYNCF_Document_Type__c,GYNCF_Equipment_Category__c,GYNCF_Field_Maping__c,
                     GYNCF_Mass_Sync__c,GYNCF_Mass_Sync_Frequency__c,GYNCF_Material_Group__c,GYNCF_Material_Type__c,GYNCF_Quote_Id__c,GYNCF_Sales_Org__c,GYNCF_SAP_Condition_Type__c,
                     GYNCF_Search__c,GYNCF_Service_URL__c,GYNCF_SFDC_Object_Name__c,GYNCF_System_Status__c,GYNCF_Document_Status__c,GYNCF_Archived__c,GYNCF_Billing_Start_Date__c,
                     GYNCF_Billing_End_Date__c,GYNCF_Fiscal_Year__c,GYNCF_Billing_Type__c,GYNCF_CRON_Expression__c,Sync_Only_DELTA__c,GYNCF_Default_Order_Status__c,GYNCF_Identifier_SFDC__c,
                     GYNCF_LineItemApi_Name__c,GYNCF_LineItem_Identifier_SFDC__c,GYNCF_LineItem_ParentField_Api__c,GYNCF_PricebookEntry_Field_API_Name__c,GYNCF_PricebookApi_Name__c FROM GYNCO_Configuration__c where GYNCF_System_Id__c=:[select Id,name from GYNCS_AuthorizationSetting__c where name='Default' limit 1].Id WITH SECURITY_ENFORCED];
        //SELECT Id,Name,GYNCF_Service_URL__c,GYNCF_System_Id__c 
        System.debug('data'+ConfigList.size());
        String baseValUrl=[select id,GYNCF_Base_URL__c from GYNCS_AuthorizationSetting__c where name='Default' limit 1].GYNCF_Base_URL__c ;
        for(GYNCO_Configuration__c con:ConfigList){
            if(con.Name =='Sales Order' || con.Name=='Invoice' || con.Name=='Equipment' || con.Name=='Materials' || con.Name=='Quotation' || con.Name=='Customer'){
                GYNCO_Configuration__c data=con.clone(false, true, false, false);
                data.GYNCF_System_Id__c=authorizationSetting.Id;
                System.debug('dataURL'+con.GYNCF_Service_URL__c);
                System.debug('Name'+con.Name);
                if(con.GYNCF_Service_URL__c !=null){
                    data.GYNCF_Service_URL__c=BaseUrl+con.GYNCF_Service_URL__c.replace(baseValUrl,'');
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
            list<GYNCS_AuthorizationSetting__c> DelSys = new list<GYNCS_AuthorizationSetting__c>([select id,Name from GYNCS_AuthorizationSetting__c where id=:systemId]);
            //System.debug('157DelSYs==='+DelSys);
            if(GYNCS_AuthorizationSetting__c.SObjectType.getDescribe().isDeletable())
                Delete DelSys;
            Return DelSys[0].Name;
        }else{
            Return 'Error';
        }
    }
    
    @AuraEnabled
    public static Boolean FeatureParameterVal(String feature,String fieldName){
        Boolean masterDataFlagInstance = true; //As Ashis suggested, to make all features availale by default.
        try {
            masterDataFlagInstance = System.FeatureManagement.checkPackageBooleanValue(feature);
            if(masterDataFlagInstance){
                masterDataFlagInstance=checkField(fieldName);
            }
            
        }
        catch(exception ex) {
            System.debug('You do not have access.'+ex);
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
            if(feature1Check){
                feature1Check=checkField('GYNPS_masterDataPermission__c');
            }
            feature2Check = System.FeatureManagement.checkPackageBooleanValue(feature2);
            if(feature2Check){
                feature2Check=checkField('GYNPS_salesConnectPermission__c');
            }
        }
        catch(exception ex) {
            System.debug('You do not have access.'+ex);
        }
        return feature1Check+'.'+feature2Check;
        
    }
    
    // Method to check connection 
    @AuraEnabled
    public static integer checkConnection(String username, String pw){
        System.debug('username->'+username);
        System.debug('pw->'+pw);
       // System.debug('oA->'+oA);
        //System.debug('up->'+up);
        String endpointList=[select GYNCF_Service_URL__c from GYNCO_Configuration__c where Name= 'Customer' limit 1].GYNCF_Service_URL__c;
        Integer resp;
        String endpoint= endpointList;
        String userID=username;
        String password=pw;
       // string systemId= sysID;
       // if(up==true){
            
         //   GYNC_API_Dispatcher.systemId = systemId;
            
            Blob headerValue = Blob.valueOf(userID + ':' + pw);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            Map<String,String> apiHeader= new Map<String,String>();
            apiHeader.put('Authorization', authorizationHeader );
            resp=GYNC_API_Dispatcher.callSAP('GET', endPoint, apiHeader, '').getStatusCode();
            System.debug('resp->'+resp);
    //    }
       /* if(oA== true){
            Map<String, String> apiHeader = new Map<String, String>();
            apiHeader.put('Content-Type','application/x-www-form-urlencoded');
            Blob headerValue = Blob.valueOf(username+ ':' + pw );
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            apiHeader.put('authorization',authorizationHeader);
            String requestBody = 'grant_type=client_credentials';   
            HTTPResponse apiResponse = callSAP('POST',authorizationSetting.GYNCF_oAuth_Login_URL__c,apiHeader, requestBody);
            oautResponseClass oauthRes = new oautResponseClass().parse(apiResponse.getBody());
            String authorizationHeaderBearer = 'Bearer ' + oauthRes.access_token;
            authBody = new authorizationBody(endpoint, authorizationHeaderBearer);
        }*/
        return resp;
    }
    
    
    
    public static Boolean checkField(String fieldName){
        return Schema.getGlobalDescribe().get('GYNCO_Configuration__c').getDescribe().fields.getMap().get(fieldName).getDescribe().isAccessible();
    }
}