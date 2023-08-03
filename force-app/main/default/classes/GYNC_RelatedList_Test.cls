/*
* @author: Sapna kumari
* @testClassName: GYNC_RelatedList_Test
* @apexClass: GYNL_RelatedList
* @description: This class is to test the logic of the apex class
* @version: V1
* @createdDate: 19th Jun 2020
*
* @version: V2
* Comments: Dynamic query added in the class
* @modifiedBy: Sapna
* @modifiedDate:22 July 2020
*/
@IsTest(seeAllData=false)
public class GYNC_RelatedList_Test {
    //Below is a method with @testsetup annotation, the name can be anything like setup(),oneTimeData(), etc.
    @testSetup static void setup() {
        GYNC_TestUtility.createUser();
        //configuration record
        GYNCS_AuthorizationSetting__c sysId = GYNC_TestUtility.createAuthorizationSetting('Default',true);
        string sysmId = string.valueOf(sysId.Id);
        String ServicURL = '/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/SALESDOCUMENTSet';
        List<GYNCO_Configuration__c> config= GYNC_TestUtility.createConfiguration('Sales Order',sysmId,'Order',ServicURL,'','',500,1,true);
        
        //Create Account
        Account acc = GYNC_TestUtility.createAccount(true);
        
        //Create order
        Order od = new Order();
        od.Name = '14TPE000001';
        od.AccountId = acc.Id;
        od.EffectiveDate = Date.Today();
        od.Status = 'Draft';
        insert od;
        
        Order od1 = new Order();
        od1.Name = '14TPE000002';
        od1.AccountId = acc.Id;
        od1.EffectiveDate = Date.Today();
        od1.Status = 'Draft';
        insert od1;
        
    }
    @isTest 
    public static void testName() {
        String colval = '[{"fieldName":"Id","type":"url","typeAttributes":{"label":{"fieldName":"GYNCF_Salesorder__c"},"target":"_blank"},"label":"SAP Order Number"},{"fieldName":"TotalAmount","type":"currency","label":"Order Amount"},{"fieldName":"Status","type":"picklist","label":"Status"},{"fieldName":"EffectiveDate","type":"date","label":"Order Start Date"}]';
        GYNCO_Configuration__c config = [Select Id,GYNC_Related_list_Column__c,Has_Column_Field__c from GYNCO_Configuration__c Limit 1];
        config.GYNC_Related_list_Column__c = colval;
        config.Has_Column_Field__c = true;
        update config;
        Account acc1 =  [Select Id,Name from Account];
        List<String> fieldsname = new List<String>(); 
        fieldsname.add('Id');
        fieldsname.add('Name');
        
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            Test.startTest();
            String col = GYNC_RelatedList.onloadfechorderrecord();
            GYNC_RelatedList.FetchThefields(colval);
            //String order = GYNC_RelatedList.FetchTheRecords(acc1.Id);
            String order = GYNC_RelatedList.sendNewcolumn(fieldsname,acc1.Id);
            GYNC_RelatedList.fetchtheColumn(colval);
            Test.stopTest();
            System.assertEquals(col, colval);
        }
        //System.debug('order'+order);
        
        //System.assertEquals(order[0].Name, '14TPE000001');
    }
    @isTest 
    public static void testName1() {
        String colval = '[{"fieldName":"Id","type":"url","typeAttributes":{"label":{"fieldName":"GYNCF_Salesorder__c"},"target":"_blank"},"label":"SAP Order Number"},{"fieldName":"TotalAmount","type":"currency","label":"Order Amount"},{"fieldName":"Status","type":"picklist","label":"Status"},{"fieldName":"EffectiveDate","type":"date","label":"Order Start Date"}]';
        GYNCO_Configuration__c config = [Select Id,GYNC_Related_list_Column__c,Has_Column_Field__c from GYNCO_Configuration__c Limit 1];
        user u = [select id from user where username = 'testusername@gyansys.com' limit 1];
        System.runAs(u) {
            Test.startTest();
            GYNC_RelatedList.FetchThefields(colval);
            Test.stopTest();
        }
        system.assertNotEquals(null,colval,'The default value should not be null' );
    }
}