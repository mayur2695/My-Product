/*
* @author: Abhijeet Bhatt
* @testClassName: GYNC_SchedularRecordClass_Test
* @apexClass: GYNC_SchedularRecordClass
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 19th Jun 2020
*/
@isTest(SeeAllData=false)
public class GYNC_SchedularRecordClass_Test {

     @testSetup 
    static void setup(){
        GYNC_TestUtility.createUser();
        GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        
        String FieldMapping='[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]';
        String Filters='[{"configApiName": "GYNCF_Billing_End_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Billing_Start_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Date_Range_From__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Date_Range_To__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Archived__c","sapApiName": "DeletionIndicator","type": "Boolean"},{"configApiName": "Sync_Only_DELTA__c","sapApiName": "Delta","type": "DeltaSync"},{"configApiName": "GYNCF_Last_Synced__c","sapApiName": "Lastrundate","type": "DeltaSync"},{"configApiName": "GYNCF_Sales_Org__c","sapApiName": "SalesOrganization"},{"configApiName": "GYNCF_Billing_Type__c","sapApiName": "BillingType"},{"configApiName": "GYNCF_Company_Code__c","sapApiName": "CompanyCode"},{"configApiName": "GYNCF_Fiscal_Year__c","sapApiName": "FiscalYear"}]';
        String ServiceUrl='https://gyansyspartners-dev-ed.my.salesforce.com/servlet/servlet.ExternalRedirect?url=http%3A%2F%2Fec2-18-215-72-123.compute-1.amazonaws.com%3A8080%2Fsap%2Fopu%2Fodata%2FGCONNECT%2FSF_INVOICE_SRV%2FINVOICESet';
        
        List<GYNCO_Configuration__c> configRecordList = GYNC_TestUtility.createConfiguration('Invoice', authSetting.Id, 'GYNCO_Invoice__c',ServiceUrl , FieldMapping, Filters, 200, 1, true);
        
        Schedule__c schRecord = GYNC_TestUtility.createScheduleRecord('Test Batch 1', '0 0 12 * * ?', authSetting.Id, configRecordList[0].Id, true);
    	
    }
    
    static testMethod void scheduleMethods(){
        GYNCS_AuthorizationSetting__c Setting =	GYNCS_AuthorizationSetting__c.getValues('Default');  
        System.debug('Setting'+Setting);
        GYNCO_Configuration__c configRec = [SELECT Id,Name,GYNCF_Identifier_SFDC__c,GYNCF_SFDC_Object_Name__c,GYNCF_Service_URL__c,GYNCF_Available_Fileters__c,GYNCF_Field_Maping__c,GYNCF_Batch_Size__c,GYNCF_System_Id__c FROM GYNCO_Configuration__c WHERE Name='Invoice'];
        configRec.GYNCF_CRON_Expression__c='';
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
        User thisUser = [Select id from User where username = 'testusername@gyansys.com' ];
        System.runAs(thisUser){
            Test.startTest();
            try{
                GYNL_SchedularRecordClass.createSchedularRecord(schRecord.Cron_Exp__c, schRecord.name);
            }
            catch(exception ex) {
                System.debug('There is exception');
            }
            try{
                GYNL_SchedularRecordClass.getSchedulatList(configRec.Name, Setting.Id);
            }
            catch(exception ex) {
                System.debug('There is exception');
            }
            
            try{
                GYNL_SchedularRecordClass.sendCronToSchedule(schRecord.Id,configRec.Name,Setting.Id);
            }
            catch(exception ex) {
                System.debug('There is exception');
            }
            Test.stopTest();
            System.assertEquals(1,[select count() from Schedule__c]);
        }
    }
    
}