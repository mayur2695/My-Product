/*
* @author: Abhijeet Bhatt
* @testClassName: GYNC_syncParameterClass_Test
* @apexClass: GYNC_syncParamterClass
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 19th Jun 2020
*/
@isTest(seeAllData = false)
public class GYNC_syncParameterClass_Test {
    
    @testSetup 
    static void setup(){
        GYNC_TestUtility.createUser();
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        
        String FieldMapping='[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]';
        String Filters='[{"configApiName": "GYNCF_Billing_End_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Billing_Start_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Date_Range_From__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Date_Range_To__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Archived__c","sapApiName": "DeletionIndicator","type": "Boolean"},{"configApiName": "Sync_Only_DELTA__c","sapApiName": "Delta","type": "DeltaSync"},{"configApiName": "GYNCF_Last_Synced__c","sapApiName": "Lastrundate","type": "DeltaSync"},{"configApiName": "GYNCF_Sales_Org__c","sapApiName": "SalesOrganization"},{"configApiName": "GYNCF_Billing_Type__c","sapApiName": "BillingType"},{"configApiName": "GYNCF_Company_Code__c","sapApiName": "CompanyCode"},{"configApiName": "GYNCF_Fiscal_Year__c","sapApiName": "FiscalYear"}]';
        String ServiceUrl='https://gyansyspartners-dev-ed.my.salesforce.com/servlet/servlet.ExternalRedirect?url=http%3A%2F%2Fec2-18-215-72-123.compute-1.amazonaws.com%3A8080%2Fsap%2Fopu%2Fodata%2FGCONNECT%2FSF_INVOICE_SRV%2FINVOICESet';
        
        List<GYNCO_Configuration__c> configRecordList = GYNC_TestUtility.createConfiguration('Invoice', authSetting.Id, 'GYNCO_Invoice__c',ServiceUrl , FieldMapping, Filters, 200, 1, true);
        
        Schedule__c schRecord = GYNC_TestUtility.createScheduleRecord('Test Batch 1', '0 0 12 * * ?', authSetting.Id, configRecordList[0].Id, true);
        GYNCO_Error_Logs__c logs = new GYNCO_Error_Logs__c();
        logs.GYNCF_Business_Object_Name__c=configRecordList[0].Name;
        logs.GYNCF_System_Id__c=authSetting.Id;
        logs.GYNCF_Coment__c='';
        logs.GYNCF_Apex_Job_Status__c='';
        logs.GYNCF_Success_Record__c='';
        insert logs;
        
    }
    
    static testMethod void coverAllConfig(){
        
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        User thisUser = [Select id from User where Id =: UserInfo.getUserId()];
        
        GYNCS_AuthorizationSetting__c Setting =	GYNCS_AuthorizationSetting__c.getValues('Default');  
        System.debug('Setting'+Setting);
        
            GYNCO_Configuration__c configRec = [SELECT Id,Name,GYNCF_Identifier_SFDC__c,GYNCF_SFDC_Object_Name__c,GYNCF_Service_URL__c,GYNCF_Available_Fileters__c,GYNCF_Field_Maping__c,GYNCF_Batch_Size__c,GYNCF_System_Id__c FROM GYNCO_Configuration__c WHERE Name='Invoice'];
            configRec.GYNCF_CRON_Expression__c='';
            configRec.GYNCF_SAP_API_Fields__c='CompanyCode,Delta,Invoice,Lastrundate,SoldTo,SoldToName,BillTo,BillToName,BillingType,CreationDate,BillingDate,FiscalYear,CrossReference,PurchaseOrder,PaymentTerms,SalesOrganization,DistributionChannel,Division,NetValue,Currency,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,test invoice 1';
            configRec.GYNCF_Identifier_SFDC__c='GYNCF_Invoice__c';
            configRec.GYNCF_Identifier_SAP__c='Invoice';
            configRec.GYNCF_Availability_Of_Objects__c=true;
            configRec.GYNCF_LineItemApi_Name__c='GYNCO_Invoice_Line_Item__c';
            configRec.GYNCF_PricebookApi_Name__c='PriceBookForMapping';
            configRec.Sync_Only_DELTA__c=true;
            configRec.GYNCF_Nodes_for_SAP_API__c='INVOICE,INVOICEITEM';	
            configRec.GYNCF_LineItem_Identifier_SAP__c='InvoiceItemNumber';
        	configRec.GYNCF_LineItem_Identifier_SFDC__c='GYNCF_InvoiceItemNumber__c';
            configRec.GYNCF_DyanamicChildItemQuery__c='Invoice__c';
            configRec.GYNCF_LineItemBodyTitle__c='INVOICEITEMSet';
            configRec.GYNCF_LineItem_ParentField_Api__c='Invoice__c';
            configRec.GYNCF_PricebookEntry_Field_API_Name__c='GYNCF_PricebookEntryId__c';
            configRec.GYNCF_Operation_Type__c='Business Object Sync';
            configRec.GYANF_SAP_Object_API__c='SF_INVOICE_SRV';
            configRec.GYNCF_Mass_Sync__c=true;
            configRec.GYNCF_Customer_Number__c='0051873304';
            configRec.GYNCF_Company_Code__c='3C7B';
            configRec.GYNCF_Bill_To__c='0102313052';
            configRec.GYNCF_Billing_End_Date__c=date.parse('5/5/2020');
            configRec.GYNCF_Billing_Start_Date__c=date.parse('4/19/2020');
            configRec.GYNCF_Monthly_Date_Options__c='1';
            //configRec
            //configRec
            update configRec;
        system.debug('configRec '+configRec);
        
        Schedule__c schRecord = [SELECT Id,Name,Cron_Exp__c,GYNCF_Configuration_Record__c,GYNCF_System_Id__c FROM Schedule__c WHERE Name='Test Batch 1'];
        schRecord.GYNC_Batch_Variant__c=true;
        //schRecord.GYNCF_Day_of_Month_Selected__c='';
        //schRecord.GYNCF_Days_Selected__c='';
        schRecord.GYNCF_Everyday_Selected__c=true;
        schRecord.GYNCF_Frequency_Selected__c='W';
        schRecord.GYNCF_Time_Selected__c='12';
        schRecord.GYNCF_System_Id__c=Setting.Id;
        schRecord.GYNCF_Configuration_Record__c=configRec.Id;
        update schRecord;
        configRec.Scheduler_information__c=schRecord.Name;
        update configRec;
        system.debug('batch'+schRecord);
        GYNCO_Error_Logs__c logs=[SELECT ID,Name,GYNCF_Business_Object_Name__c,GYNCF_System_Id__c,GYNCF_Coment__c,GYNCF_Apex_Job_Status__c,GYNCF_Success_Record__c FROM GYNCO_Error_Logs__c WHERE GYNCF_Business_Object_Name__c='Invoice'];
        
        
        //System.RunAs(thisUser){
        System.RunAs(u){
            Test.startTest();
            GYNC_syncParamterClass.GetRecords(Setting.Id);
            GYNC_syncParamterClass.ConfigRecordUpdate(JSON.serialize(configRec));
            GYNC_syncParamterClass.OrderStatusValues();
            GYNC_syncParamterClass.listAllObject();
            try{
            GYNC_syncParamterClass.fetchScheduleRecord(configRec.Name, Setting.Id);
            }
            catch(exception ex) {
                system.debug('Exception');
            }
            System.assertEquals(schRecord, (Schedule__c)JSON.deserialize(GYNC_syncParamterClass.fetchScheduleRecord(configRec.Name, Setting.Id), Schedule__c.class));
           // MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
       		//mockClass.mockResponseBody = '{"d":{"__count":10}}';
       		//Test.setMock(HttpCalloutMock.class, mockClass);
           // GYNC_syncParamterClass.scheduleBatch(configRec.Name, schRecord.Cron_Exp__c, Setting.Id, schRecord.Name, schRecord.GYNCF_Frequency_Selected__c, schRecord.GYNCF_Day_of_Month_Selected__c, schRecord.GYNCF_Everyday_Selected__c, schRecord.GYNCF_Time_Selected__c, schRecord.GYNCF_Days_Selected__c, schRecord.GYNC_Batch_Variant__c);
            GYNC_syncParamterClass.batchLogs(logs.GYNCF_Business_Object_Name__c, Setting.Id) ; 
            
            GYNC_syncParamterClass.AddGroupMemberfromSAP(configRec.Name,'VKORG','',Setting.Id);
            Test.stopTest();    
        }
        
        
    }
    static testMethod void schedulesOnly(){
        User thisUser = [Select id from User where username = 'testusername@gyansys.com'];
        
        GYNCS_AuthorizationSetting__c Setting =	GYNCS_AuthorizationSetting__c.getValues('Default');  
        System.debug('Setting'+Setting);
        
            GYNCO_Configuration__c configRec = [SELECT Id,Name,GYNCF_Identifier_SFDC__c,GYNCF_SFDC_Object_Name__c,GYNCF_Service_URL__c,GYNCF_Available_Fileters__c,GYNCF_Field_Maping__c,GYNCF_Batch_Size__c,GYNCF_System_Id__c FROM GYNCO_Configuration__c WHERE Name='Invoice'];
            configRec.GYNCF_CRON_Expression__c='';
            configRec.GYNCF_SAP_API_Fields__c='CompanyCode,Delta,Invoice,Lastrundate,SoldTo,SoldToName,BillTo,BillToName,BillingType,CreationDate,BillingDate,FiscalYear,CrossReference,PurchaseOrder,PaymentTerms,SalesOrganization,DistributionChannel,Division,NetValue,Currency,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,test invoice 1';
            configRec.GYNCF_Identifier_SFDC__c='GYNCF_Invoice__c';
            configRec.GYNCF_Identifier_SAP__c='Invoice';
            configRec.GYNCF_Availability_Of_Objects__c=true;
            configRec.GYNCF_LineItemApi_Name__c='GYNCO_Invoice_Line_Item__c';
            configRec.GYNCF_PricebookApi_Name__c='PriceBookForMapping';
            configRec.Sync_Only_DELTA__c=true;
            configRec.GYNCF_Nodes_for_SAP_API__c='INVOICE,INVOICEITEM';	
            configRec.GYNCF_LineItem_Identifier_SAP__c='InvoiceItemNumber';
        	configRec.GYNCF_LineItem_Identifier_SFDC__c='GYNCF_InvoiceItemNumber__c';
            configRec.GYNCF_DyanamicChildItemQuery__c='Invoice__c';
            configRec.GYNCF_LineItemBodyTitle__c='INVOICEITEMSet';
            configRec.GYNCF_LineItem_ParentField_Api__c='Invoice__c';
            configRec.GYNCF_PricebookEntry_Field_API_Name__c='GYNCF_PricebookEntryId__c';
            configRec.GYNCF_Operation_Type__c='Business Object Sync';
            configRec.GYANF_SAP_Object_API__c='SF_INVOICE_SRV';
            configRec.GYNCF_Mass_Sync__c=true;
            configRec.GYNCF_Customer_Number__c='0051873304';
            configRec.GYNCF_Company_Code__c='3C7B';
            configRec.GYNCF_Bill_To__c='0102313052';
            configRec.GYNCF_Billing_End_Date__c=date.parse('5/5/2020');
            configRec.GYNCF_Billing_Start_Date__c=date.parse('4/19/2020');
            configRec.GYNCF_Monthly_Date_Options__c='1';
            //configRec
            //configRec
            update configRec;
        system.debug('configRec '+configRec);
        
        Schedule__c schRecord = [SELECT Id,Name,Cron_Exp__c,GYNCF_Configuration_Record__c,GYNCF_System_Id__c FROM Schedule__c WHERE Name='Test Batch 1'];
        schRecord.GYNC_Batch_Variant__c=true;
        schRecord.GYNCF_Day_of_Month_Selected__c='';
        schRecord.GYNCF_Days_Selected__c='';
        schRecord.GYNCF_Everyday_Selected__c=true;
        schRecord.GYNCF_Frequency_Selected__c='W';
        schRecord.GYNCF_Time_Selected__c='12';
        schRecord.GYNCF_System_Id__c=Setting.Id;
        schRecord.GYNCF_Configuration_Record__c=configRec.Id;
        update schRecord;
        configRec.Scheduler_information__c=schRecord.Name;
        update configRec;
        system.debug('batch'+schRecord);
        GYNCO_Error_Logs__c logs=[SELECT ID,Name,GYNCF_Business_Object_Name__c,GYNCF_System_Id__c,GYNCF_Coment__c,GYNCF_Apex_Job_Status__c,GYNCF_Success_Record__c FROM GYNCO_Error_Logs__c WHERE GYNCF_Business_Object_Name__c='Invoice'];
        
        
        System.RunAs(thisUser){
            Test.startTest();
          
            MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
       		mockClass.mockResponseBody = '{"d":{"__count":10}}';
       		Test.setMock(HttpCalloutMock.class, mockClass);
            GYNC_syncParamterClass.scheduleBatch(configRec.Name, schRecord.Cron_Exp__c, Setting.Id, schRecord.Name, schRecord.GYNCF_Frequency_Selected__c, schRecord.GYNCF_Day_of_Month_Selected__c, schRecord.GYNCF_Everyday_Selected__c, schRecord.GYNCF_Time_Selected__c, schRecord.GYNCF_Days_Selected__c, schRecord.GYNC_Batch_Variant__c);
            Test.stopTest();  
            system.assertEquals(0, [select count() from GYNCO_Invoice__c]);
        }
        
    
    }
}