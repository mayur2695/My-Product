/*
 * @author: Sushri
 * @testClassName: GYNC_mappingScreenClass_Test
 * @apexClass: GYNC_mappingScreenClass
 * @description: This class is to test the logic of the apex class
 * @version: V1
 * @createdDate: 22th Jun 2020
 *
 * @version: V2
 * Comments: Why modification needed
 * @modifiedBy:
 * @modifiedDate:
 */
@isTest
private class GYNC_mappingScreenClass_Test {
    @testSetup static void setup(){
    	GYNCS_AuthorizationSetting__c authSetting = new GYNCS_AuthorizationSetting__c();
        
        authSetting.GYNCF_Authorization_Type__c='Basic';
        authSetting.GYNCF_Base_URL__c='http://ec2-18-215-72-123.compute-1.amazonaws.com:8080';
        authSetting.GYNCF_Client_Id__c='324ce91c-f435-3bd8-b0e9-2b13d4b156a3';
        authSetting.GYNCF_Client_Secret__c='Starlight1$';
        authSetting.GYNCF_oAuth_Login_URL__c='https://oauthasservices-s0008805481trial.hanatrial.ondemand.com/oauth2/api/v1/token';
        authSetting.GYNCF_Password__c='init1234';
        authSetting.Name='Default';
        authSetting.GYNCF_User_Name__c='DSingh';
        insert authSetting;
        
        GYNCO_Configuration__c con = new GYNCO_Configuration__c();
        con.Name='Test_SAP';
        con.GYNCF_Operation_Type__c = 'Business Object Sync';
        con.GYANF_SAP_Object_API__c ='Invoice';
        con.GYNCF_SAP_API_Fields__c = 'CompanyCode,Delta,Invoice,Lastrundate,SoldTo,SoldToName,BillTo,BillToName,BillingType,CreationDate,BillingDate,FiscalYear,CrossReference,PurchaseOrder,PaymentTerms,SalesOrganization,DistributionChannel,Division,NetValue,Currency,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,MaterialDescription,Invoice,InvoiceItemNumber,Material,BilledQuantity,UnitOfMeasure,ItemNetValue,ItemTax,ItemFreight,test invoice 1';
        con.GYNCF_SFDC_Object_Name__c ='GYNCO_Invoice__c';
        con.GYNCF_Field_Maping__c = '[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]';
        con.GYNCF_LineItemApi_Name__c = 'GYNCO_Invoice_Line_Item__c';
        con.GYNCF_System_Id__c = authSetting.id;
        insert con;
       }
    
        static testMethod void mapScreen(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        id systemId = [Select id from GYNCS_AuthorizationSetting__c].id;
        GYNC_mappingScreenClass.fetchObjectNames(systemId);
        GYNC_mappingScreenClass.fetchDependantPickListValues('Test_SAP', systemId);
        String selectedOption = 'Test_SAP';
        GYNC_mappingScreenClass.saveMappingList('[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]', SelectedOption, systemId);
        list<GYNCO_Configuration__c>mapValue = [select GYNCF_Field_Maping__c from GYNCO_Configuration__c limit 1];
            string assertValue = mapValue[0].GYNCF_Field_Maping__c;
            Test.stopTest();
            System.assertEquals('[{"sapField":"Invoice","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_Invoice__c\"}"},{"sapField":"SoldTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldTo__c\"}"},{"sapField":"SoldToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_SoldToName__c\"}"},{"sapField":"BillTo","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillTo__c\"}"},{"sapField":"BillToName","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillToName__c\"}"},{"sapField":"BillingType","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingType__c\"}"},{"sapField":"CreationDate","SFDCField":"{\"sfdcFieldType\":\"DATE\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_CreationDate__c\"}","SFDCType":"DateTime"},{"sapField":"BillingDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_BillingDate__c\"}","SFDCType":"DateTime"},{"sapField":"FiscalYear","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_FiscalYear__c\"}"},{"sapField":"CrossReference","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"GYNCF_CrossReference__c\"}"},{"sapField":"SalesOrganization","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_SalesOrganization__c\"}"},{"sapField":"DistributionChannel","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_DistributionChannel__c\"}","SFDCType":"Decimal"},{"sapField":"BilledQuantity","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_BilledQuantity__c\"}","SFDCType":"Decimal"},{"sapField":"Division","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_Division__c\"}","Type":"","RelatedTo":""},{"sapField":"InvoiceItemNumber","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_InvoiceItemNumber__c\"}"},{"sapField":"MaterialDescription","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_MaterialDescription__c\"}"},{"sapField":"UnitOfMeasure","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_UnitOfMeasure__c\"}"},{"sapField":"Material","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_PricebookEntryId__c\"}"},{"sapField":"ItemTax","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemTax__c\"}"},{"sapField":"ItemFreight","SFDCField":"{\"sfdcFieldType\":\"DOUBLE\",\"relatedTo\":\"GYNCO_Invoice__c\",\"fieldValue\":\"GYNCO_Invoice_Line_Item__c.GYNCF_ItemFreight__c\"}"},{"sapField":"CompanyCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"User\",\"fieldValue\":\"Company_Code__c\"}"},{"sapField":"PurchaseOrder","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PurchaseOrder__c\"}"},{"sapField":"PaymentTerms","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Pricebook2\",\"fieldValue\":\"GYNCF_PaymentTerms__c\"}"},{"sapField":"Currency","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"User\",\"fieldValue\":\"CurrencyIsoCode\"}"}]',assertValue);
      }
}