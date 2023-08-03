/*
* @author: Debiprasad
* @testClassName: GYNC_massSyncTabClass_Test
* @apexClass: GYNC_massSyncTabClass
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 19th Jun 2020
*/
@isTest(seeAllData = false)
public class GYNC_massSyncTabClass_Test {
    @testSetup static void setup(){
        GYNC_TestUtility.createUser();
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        string ServiceURL = 'http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_CUSTOMER_SRV/CUSTOMERSet';
        string FieldMapping = '[{"sapField":"Name1","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"Name\"}"},{"sapField":"Customer","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Number__c\"}"},{"sapField":"City","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCity\"}"},{"sapField":"Country","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCountry\"}"},{"sapField":"PostalCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingPostalCode\"}"},{"sapField":"Region","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingState\"}"},{"sapField":"Street","SFDCField":"{\"sfdcFieldType\":\"TEXTAREA\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingStreet\"}"},{"sapField":"Telephone","SFDCField":"{\"sfdcFieldType\":\"PHONE\",\"relatedTo\":\"Account\",\"fieldValue\":\"Phone\"}"},{"sapField":"Industry","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"Account\",\"fieldValue\":\"Industry\"}"},{"sapField":"UriAddress","SFDCField":"{\"sfdcFieldType\":\"URL\",\"relatedTo\":\"Account\",\"fieldValue\":\"Website\"}"},{"sapField":"DeletionIndicator","SFDCField":"{\"sfdcFieldType\":\"BOOLEAN\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_Active__c\"}"},{"sapField":"Name2","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_Name2__c\"}"},{"sapField":"CreatedDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Created_Date__c\"}","Type":"","RelatedTo":""},{"sapField":"AccountGroup","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_AccountGroup__c\"}"},{"sapField":"Name1","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"Name\"}"},{"sapField":"Customer","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Number__c\"}"},{"sapField":"City","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCity\"}"},{"sapField":"PostalCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingPostalCode\"}"},{"sapField":"Street","SFDCField":"{\"sfdcFieldType\":\"TEXTAREA\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingStreet\"}"},{"sapField":"Telephone","SFDCField":"{\"sfdcFieldType\":\"PHONE\",\"relatedTo\":\"Account\",\"fieldValue\":\"Phone\"}"},{"sapField":"Industry","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"Account\",\"fieldValue\":\"Industry\"}"},{"sapField":"UriAddress","SFDCField":"{\"sfdcFieldType\":\"URL\",\"relatedTo\":\"Account\",\"fieldValue\":\"Website\"}"},{"sapField":"Name1","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"Name\"}"},{"sapField":"Customer","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Number__c\"}"},{"sapField":"City","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCity\"}"},{"sapField":"Country","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCountry\"}"},{"sapField":"PostalCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingPostalCode\"}"},{"sapField":"Region","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingState\"}"},{"sapField":"Street","SFDCField":"{\"sfdcFieldType\":\"TEXTAREA\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingStreet\"}"},{"sapField":"Telephone","SFDCField":"{\"sfdcFieldType\":\"PHONE\",\"relatedTo\":\"Account\",\"fieldValue\":\"Phone\"}"},{"sapField":"Industry","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"Account\",\"fieldValue\":\"Industry\"}"},{"sapField":"UriAddress","SFDCField":"{\"sfdcFieldType\":\"URL\",\"relatedTo\":\"Account\",\"fieldValue\":\"Website\"}"},{"sapField":"DeletionIndicator","SFDCField":"{\"sfdcFieldType\":\"BOOLEAN\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_Active__c\"}"},{"sapField":"Name2","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_Name2__c\"}"},{"sapField":"CreatedDate","SFDCField":"{\"sfdcFieldType\":\"DATETIME\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Created_Date__c\"}","Type":"","RelatedTo":""},{"sapField":"AccountGroup","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_AccountGroup__c\"}"},{"sapField":"Name1","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"Name\"}"},{"sapField":"Customer","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"DandBCompany\",\"fieldValue\":\"GYNCF_SAP_Number__c\"}"},{"sapField":"City","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingCity\"}"},{"sapField":"PostalCode","SFDCField":"{\"sfdcFieldType\":\"STRING\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingPostalCode\"}"},{"sapField":"Street","SFDCField":"{\"sfdcFieldType\":\"TEXTAREA\",\"relatedTo\":\"Account\",\"fieldValue\":\"BillingStreet\"}"},{"sapField":"Telephone","SFDCField":"{\"sfdcFieldType\":\"PHONE\",\"relatedTo\":\"Account\",\"fieldValue\":\"Phone\"}"},{"sapField":"Industry","SFDCField":"{\"sfdcFieldType\":\"PICKLIST\",\"relatedTo\":\"Account\",\"fieldValue\":\"Industry\"}"},{"sapField":"UriAddress","SFDCField":"{\"sfdcFieldType\":\"URL\",\"relatedTo\":\"Account\",\"fieldValue\":\"Website\"}"}]';
        string Filters = '[{"configApiName": "GYNCF_Billing_End_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Billing_Start_Date__c","sapApiName": "BillingDate"},{"configApiName": "GYNCF_Date_Range_From__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Date_Range_To__c","sapApiName": "CreationDate"},{"configApiName": "GYNCF_Archived__c","sapApiName": "DeletionIndicator","type": "Boolean"},{"configApiName": "Sync_Only_DELTA__c","sapApiName": "Delta","type": "DeltaSync"},{"configApiName": "GYNCF_Last_Synced__c","sapApiName": "Lastrundate","type": "DeltaSync"},{"configApiName": "GYNCF_Sales_Org__c","sapApiName": "SalesOrganization"},{"configApiName": "GYNCF_Billing_Type__c","sapApiName": "BillingType"},{"configApiName": "GYNCF_Company_Code__c","sapApiName": "CompanyCode"},{"configApiName": "GYNCF_Fiscal_Year__c","sapApiName": "FiscalYear"}]';
        Double BatchSize = 2000;
        integer Count = 1;
        Boolean doInsert = true;
        string SAPObjectName = 'Customer';
        string SFDCObjectName = 'Account';
        list<GYNCO_Configuration__c> config = GYNC_TestUtility.createConfiguration(SAPObjectName, sysmId, SFDCObjectName, ServiceURL, FieldMapping, Filters, BatchSize, Count, doInsert);
        //GYNCO_Configuration__c conf = new GYNCO_Configuration__c();
        system.debug('config'+config);
        config[0].GYNCF_Date_Range_From__c = Date.today();
        config[0].GYNCF_Date_Range_To__c  =  Date.today();
        config[0].GYNCF_Billing_End_Date__c= Date.today();
        config[0].GYNCF_Billing_Start_Date__c = Date.today();
        config[0].GYNCF_Archived__c   =true;
        config[0].Sync_Only_DELTA__c  = true;
        config[0].GYNCF_Last_Synced__c = system.now();
        config[0].GYNCF_Availability_Of_Objects__c = True;
        update config[0];
        system.debug('config'+config[0]);
        
    }
    @isTest static void testMethod1() {
        //perform query to get the data from the setup
        GYNCO_Configuration__c ConfigRec = [select id,Name,GYNCF_System_Id__c from GYNCO_Configuration__c];
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
        Test.startTest();
        //perform the logic to test the appropriate class
        GYNC_massSyncTabClass.getObjectName();
        GYNC_massSyncTabClass.findConfigRec(ConfigRec.Name);
        GYNC_massSyncTabClass.startMassSync(ConfigRec.Name, ConfigRec.GYNCF_System_Id__c);
        Test.stopTest();
        // Perform System.assert
        System.assertEquals('Customer', ConfigRec.Name);
        }
        //System.assertEquals('a003h000004KBtFAAW', ConfigRec.GYNCF_System_Id__c);
    }
}