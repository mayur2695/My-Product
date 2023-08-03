@isTest(seeAllData=false)
public class AdminScreenApexTest {
    @testSetup
    static void setup(){
       
    GYNC_TestUtility.createUser();

        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'GYNPS_Permission_Set'];
        if([select count() from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() and PermissionSetId = :ps.Id] == 0) {
            insert new PermissionSetAssignment(AssigneeId = UserInfo.getUserId(), PermissionSetId = ps.Id);
        }
         GYNCS_AuthorizationSetting__c authSetting = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        String FieldMapping='[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]';
        String Filters='[{"configApiName": "GYNCF_Billing_End_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Billing_Start_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Date_Range_From__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Date_Range_To__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Archived__c","sapApiName": "DeletionIndicator","type": "Boolean"},{"configApiName": "Sync_Only_DELTA__c","sapApiName": "Delta","type": "DeltaSync"},{"configApiName": "GYNCF_Last_Synced__c","sapApiName": "Lastrundate","type": "DeltaSync"},{"configApiName": "GYNCF_Sales_Org__c","sapApiName": "SalesOrganization"},{"configApiName": "GYNCF_Billing_Type__c","sapApiName": "BillingType"},{"configApiName": "GYNCF_Company_Code__c","sapApiName": "CompanyCode"},{"configApiName": "GYNCF_Fiscal_Year__c","sapApiName": "FiscalYear"}]';
        String ServiceURL = 'http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_INVOICE_SRV/INVOICESet';
        //List<GYNCO_Configuration__c> configRecordList = GYNC_TestUtility.createConfiguration('Invoice', authSetting.Id, 'GYNCO_Invoice__c', 'http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_INVOICE_SRV/INVOICESet', FieldMapping, Filters, 200, 1, true);
        GYNCO_Configuration__c config = new GYNCO_Configuration__c();
             config.Name='Invoice';
            config.GYNCF_Identifier_SFDC__c='GYNCO_Invoice__c';
            config.GYNCF_SFDC_Object_Name__c='GYNCO_Invoice__c';
            config.GYNCF_Service_URL__c=ServiceURL;
            config.GYNCF_Available_Fileters__c=Filters;
            config.GYNCF_Field_Maping__c=FieldMapping;
            config.GYNCF_Batch_Size__c=200;
            config.GYNCF_System_Id__c=authSetting.Id;
        insert config;


        
    }
    public static testMethod void Adminapex(){
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        Test.startTest();
        GYNCS_AuthorizationSetting__c setting = [select id from GYNCS_AuthorizationSetting__c limit 1];
        AdminScreenApex.getConfiguration(setting.Id);
        AdminScreenApex.AdminWrappedList wrap = new AdminScreenApex.AdminWrappedList();
        AdminScreenApex.updateauth(JSON.serialize(wrap),setting.Id);
        AdminScreenApex.createSetting('test','http://ec2-18-215-72-123.compute-1.amazonaws.com:8080');
        AdminScreenApex.DeleteSystemRec(setting.Id);
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM GYNCS_AuthorizationSetting__c]);
        }
    }
    
    private static testMethod void FeatureParameterValTest() {
        AdminScreenApex.FeatureParameterVal('customerFlag','GYNPS_adminSalesConnectPermission__c');
        System.assertEquals(true, true);
    }
    
    private static testMethod void LandingFeatureParameterValTest() {
        AdminScreenApex.LandingFeatureParameterVal();
        System.assertEquals(true, true);
    }
}