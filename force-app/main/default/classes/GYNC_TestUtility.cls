@isTest
public with sharing class GYNC_TestUtility {
	public static void createUser(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='testusername@gyansys.com');
        insert u;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GYNPS_Permission_Set'];
        if([select count() from PermissionSetAssignment where AssigneeId = :u.id and PermissionSetId = :ps.Id] == 0) {
            updatePermissionset(u.Id, ps.Id);
        }
    }
    @future
    public static void updatePermissionset( Id userId, Id PermissionSetId) {
        insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = PermissionSetId);
    }
     public static Account createAccount(Boolean doInsert)
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        if(doInsert){
            insert acc;
        }
        return acc;
    }
    
    public static GYNCS_AuthorizationSetting__c createAuthorizationSetting(String Name,Boolean doInsert){
        GYNCS_AuthorizationSetting__c newSetting =  new GYNCS_AuthorizationSetting__c();    
        newSetting.Name=Name;
        newSetting.GYNCF_Authorization_Type__c='Basic';
        newSetting.GYNCF_Base_URL__c='https://gyansyspartners-dev-ed.my.salesforce.com/servlet/servlet.ExternalRedirect?url=http%3A%2F%2Fec2-18-215-72-123.compute-1.amazonaws.com%3A8080';
            newSetting.GYNCF_Client_Id__c='324ce91c-f435-3bd8-b0e9-2b13d4b156a3';
            newSetting.GYNCF_Client_Secret__c='Starlight1$';
            newSetting.GYNCF_oAuth_Login_URL__c='https://gyansyspartners-dev-ed.my.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Foauthasservices-s0008805481trial.hanatrial.ondemand.com%2Foauth2%2Fapi%2Fv1%2Ftoken';
            newSetting.GYNCF_User_Name__c='DSingh';
            newSetting.GYNCF_Password__c='init1234';
        if(doInsert){
           insert newSetting; 
        }
        return newSetting;    
    }
    
    public static List<GYNCO_Configuration__c> createConfiguration(String SAPObjectName, String SystemId, String SFDCObjectName,String ServiceURL,String FieldMapping, String Filters, Double BatchSize, Integer Count,Boolean doInsert){
        List<GYNCO_Configuration__c> configList = new List<GYNCO_Configuration__c>();
        for(Integer i=1; i<= count; i++ ){
            GYNCO_Configuration__c config = new GYNCO_Configuration__c();
             config.Name=SAPObjectName;
            config.GYNCF_Identifier_SFDC__c=SFDCObjectName;
            config.GYNCF_SFDC_Object_Name__c=SFDCObjectName;
            config.GYNCF_Service_URL__c=ServiceURL;
            config.GYNCF_Available_Fileters__c=Filters;
            config.GYNCF_Field_Maping__c=FieldMapping;
            config.GYNCF_Batch_Size__c=BatchSize;
            config.GYNCF_System_Id__c=SystemId;
            configList.add(config);
        }
        if(doInsert){
            insert configList;      
        }
        return configList;
    }
    
    public static GYNCO_Custom_Field__c createCustomField( String Label,String Name,String configId,String systemId, String type,String SAPObjName, String SFDCObjName, Boolean doInsert){
        
        GYNCO_Custom_Field__c cusField = new GYNCO_Custom_Field__c();
        cusField.Name=Name;
        cusField.Configuration__c=configId;
            cusField.GYNF_System_ID__c=systemId;
            cusField.SFDC_Object_Name__c=SFDCObjName;
            cusField.SAP_Object_Name__c=SAPObjName;
            cusField.Property__c=type;
            cusfield.Label__c=Label;
        if(doInsert){
            insert cusField;
        }
          return cusField;  
    }
    
    public static Schedule__c createScheduleRecord(String batchName,String cronExp,String SystemId, String configId,Boolean doInsert){
        
       Schedule__c sch = new Schedule__c();
        sch.Name=batchName;
        sch.Cron_Exp__c=cronExp;
        sch.GYNCF_Configuration_Record__c=configId;
        sch.GYNCF_System_Id__c=SystemId;
        if(doInsert){
            insert sch;   
        }
        return sch;
    }
    
    public static Contact createContact(Boolean doInsert)
    {
        return createContact(doInsert, createAccount(true).Id);
    }
    
    public static Contact createContact(Boolean doInsert, Id accId)
    {
        Contact con = new Contact();
        con.AccountId = accId;
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'FirstName'+ Math.floor(Math.random() * 1000)+'@test.com';
        if(doInsert)
        {
            insert con;
        }
        return con;
    }
    public static Product2 createProduct(Boolean doInsert)
    {
        Product2 prod = new Product2();
        prod.Name = 'Test Product'+Math.floor(Math.random() * 100);
        prod.isActive =true;
        if(UserInfo.isMultiCurrencyOrganization() ) prod.put('CurrencyIsoCode', 'USD');
        if(doInsert){
            insert prod;
        }
        return prod;
    }
    
    public static Asset createAsset(Boolean doInsert)
    {
        return createAsset(doInsert, createAccount(true).Id,createContact(true).Id,createProduct(true).Id);
    }
    
    public static Asset createAsset(Boolean doInsert, Id accId,Id conId,Id prodId)
    {
        Asset asst = new Asset();
        asst.Name='Test Asset'+Math.floor(Math.random() * 100);
        asst.AccountId = accId;
        asst.ContactId = conId;
        asst.Product2Id=prodId;
        if(UserInfo.isMultiCurrencyOrganization() ) asst.put('CurrencyIsoCode', 'USD');
        if(doInsert)
        {
            insert asst;
        }
        return asst;
    }
    
    
    
}