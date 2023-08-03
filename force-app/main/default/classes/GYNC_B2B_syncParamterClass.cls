public with sharing class GYNC_B2B_syncParamterClass {
    @AuraEnabled
    public static list<GYNCO_Configuration__c> GetRecords(String systemId){
        //systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        return [select Name,GYNCF_Create__c,GYNCF_Account_Group__c,GYNCF_Bill_To__c,GYNCF_Billing_Block__c,GYNCF_Company_Code__c,GYNCF_Customer_Number__c,GYNCF_Date_Range_From__c,
                GYNCF_Date_Range_To__c,GYNCF_Delivery_Block__c,GYNCF_Distribution_Channel__c,GYNCF_Division__c,GYNCF_Document_Type__c,GYNCF_Equipment_Category__c,GYNCF_Field_Maping__c,
                GYNCF_Mass_Sync__c,GYNCF_Mass_Sync_Frequency__c,GYNCF_Material_Group__c,GYNCF_Material_Type__c,GYNCF_Quote_Id__c,GYNCF_Sales_Org__c,GYNCF_SAP_Condition_Type__c,
                GYNCF_Search__c,GYNCF_Service_URL__c,GYNCF_SFDC_Object_Name__c,GYNCF_System_Status__c,GYNCF_Document_Status__c,GYNCF_Archived__c,GYNCF_Billing_Start_Date__c,
                GYNCF_Billing_End_Date__c,GYNCF_Fiscal_Year__c,GYNCF_Billing_Type__c,GYNCF_CRON_Expression__c,Sync_Only_DELTA__c,GYNCF_Default_Order_Status__c,GYNCF_Identifier_SFDC__c,
                GYNCF_LineItemApi_Name__c,GYNCF_LineItem_Identifier_SFDC__c,GYNCF_LineItem_ParentField_Api__c,GYNCF_PricebookEntry_Field_API_Name__c,GYNCF_PricebookApi_Name__c FROM GYNCO_Configuration__c WHERE GYNCF_Operation_Type__c = 'Business Object Sync' and GYNCF_System_Id__c = :systemId];
    }
    @AuraEnabled
    public static List<String> listAllObject(){
        List<String> objectList = new List<String>();
        for(Schema.sObjectType sobj: schema.getGlobalDescribe().values()){
            if(sobj.getDescribe().isAccessible())
                objectList.add(sobj.getDescribe().getName()+'####'+sobj.getDescribe().getLabel());
        }
        objectList.sort();
        return objectList;
    }
    @AuraEnabled
    public static List<String> OrderStatusValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        System.debug('status'+pickListValuesList);
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static void ConfigRecordUpdate(string configRec){
        GYNCO_Configuration__c configRecord =(GYNCO_Configuration__c)JSON.deserialize(configRec,GYNCO_Configuration__c.class);
        System.debug('tab value'+configRecord.GYNCF_CRON_Expression__c);
        if(Schema.SObjectType.GYNCO_Configuration__c.Fields.GYNCF_CRON_Expression__c.isAccessible() && Schema.SObjectType.GYNCO_Configuration__c.Fields.GYNCF_CRON_Expression__c.isUpdateable()){
            if(configRecord.GYNCF_CRON_Expression__c == null || configRecord.GYNCF_CRON_Expression__c == ''){
                configRecord.GYNCF_CRON_Expression__c = '';
                System.debug('Enter if');
                update configRecord;
                System.debug('Record Saved Successfully');   
                
            }
            else{
                system.debug('enter else');
                update configRecord;
                //scheduleBatch(configRecord);       
            }
        }  
        
    }
    
    @AuraEnabled
    public static Schedule__c fetchScheduleRecord(String ObjectName,String systemId){
        
        return [SELECT Id,Name,GYNC_Batch_Variant__c,GYNCF_Configuration_Record__c,GYNCF_Day_of_Month_Selected__c,GYNCF_Days_Selected__c,
                GYNCF_Everyday_Selected__c,GYNCF_Frequency_Selected__c,GYNCF_System_Id__c,GYNCF_Time_Selected__c,Cron_Exp__c FROM Schedule__c 
                WHERE GYNCF_Configuration_Record__r.Name =: ObjectName AND GYNCF_Configuration_Record__r.GYNCF_System_Id__c=:systemId ORDER BY LastModifiedDate DESC LIMIT 1];
    }
    @AuraEnabled
    public static String scheduleBatch(String ObjectName,String CronExpression,String systemId,String batchName,String frequency,String dayOfMonth,Boolean everydayCheck,String startTime,String selectedDays,Boolean isVariant){
        System.debug('batch detaiuls'+ObjectName+' '+CronExpression+' '+systemId+' '+batchName);
        String ScheduledRecordId='';
        GYNCO_Configuration__c gc=[SELECT ID, Name,GYNCF_System_Id__c,Scheduler_information__c from GYNCO_Configuration__c where Name=:ObjectName AND  GYNCF_System_Id__c=:systemId];
        if(batchName!=null && batchName!=''){
            try{
                Schedule__c sch= new Schedule__c();
                if(Schema.SObjectType.Schedule__c.fields.name.isCreateable() && Schema.SObjectType.Schedule__c.fields.Cron_Exp__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNC_Batch_Variant__c.isCreateable() && Schema.SObjectType.Schedule__c.fields.GYNCF_Day_Of_Month_Selected__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNCF_Days_Selected__c.isCreateable() && Schema.SObjectType.Schedule__c.fields.GYNCF_Everyday_Selected__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNCF_Frequency_Selected__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNCF_Time_Selected__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNCF_System_Id__c.isCreateable()
                  && Schema.SObjectType.Schedule__c.fields.GYNCF_Configuration_Record__c.isCreateable())
                {
                sch.name= batchName;
                sch.Cron_Exp__c= CronExpression;
                sch.GYNC_Batch_Variant__c=isVariant;
                sch.GYNCF_Day_of_Month_Selected__c=dayOfMonth;
                sch.GYNCF_Days_Selected__c=selectedDays;
                sch.GYNCF_Everyday_Selected__c=everydayCheck;
                sch.GYNCF_Frequency_Selected__c=frequency;
                sch.GYNCF_Time_Selected__c=startTime;
                sch.GYNCF_System_Id__c=systemId;
                sch.GYNCF_Configuration_Record__c=gc.Id;
                }
                if ( Schema.SObjectType.Schedule__c.isAccessible() && Schema.SObjectType.Schedule__c.isCreateable()){
                    insert sch;
                }
                if(sch.GYNC_Batch_Variant__c == true){
                    ScheduledRecordId=sch.Id;
                    
                    if (Schema.SObjectType.GYNCO_Configuration__c.isUpdateable() && Schema.sObjectType.GYNCO_Configuration__c.fields.Scheduler_information__c.isUpdateable()) {
                    gc.Scheduler_information__c=sch.Name;
                    update gc; 
                        
                    }
                }
                else{
                    ScheduledRecordId=''; 
                }
                
            }catch (Exception e) {
                throw new AuraHandledException('Something went wrong: '
                                               + e.getMessage());    
            }
            
        }
        runBatch(ObjectName,CronExpression,systemId);
        return ScheduledRecordId;
    }
    public static void runBatch(String objname, String crnExp, String sysId){
        
        Datetime now = Datetime.now(); 
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        GYNC_ScheduleMassSync batch = new GYNC_ScheduleMassSync(objname,sysId);
        String sch = crnExp;
        System.debug('CRON Expression'+sch);
        String batchJobId = system.schedule(objname+' '+'Mass Sync Scheduled'+' '+'at'+' '+local , sch, batch);
    }
    /* 
@AuraEnabled
public static List<String> getBatchRecords(String JobId,String batchName){
List<CronTrigger> batchList = new List<CronTrigger>([SELECT Id, CronJobDetail.Name,CronJobDetailId,NextFireTime,PreviousFireTime,State FROM CronTrigger]); 
List<String>batchDataList = new List<String>(); 
for(CronTrigger cron:batchList){

batchDataList.add(batchName+' '+'Mass Sync Scheduled'+' '+'on'+' '+String.valueOf(cron.NextFireTime.date())+' '+'at'+' '+String.valueOf(cron.NextFireTime.time()));				    
}
System.debug('datalist'+batchDataList);
return batchDataList;
}
*/
    @AuraEnabled
    public static List<GYNCO_Error_Logs__c> batchLogs(String bussObjectName,String systemId){
        //systemId = GYNC_UtilityClass.findDefultSystemId(systemId); 
        dateTime lastrundate=System.today()-30;
        List<GYNCO_Error_Logs__c> batchLogsList = new List<GYNCO_Error_Logs__c>([SELECT ID,Name,GYNCF_Apex_Job_Status__c,GYNCF_Coment__c ,GYNCF_Business_Object_Name__c,CreatedDate,GYNCF_Success_Record__c,GYNCF_Comments__c  FROM GYNCO_Error_Logs__c WHERE CreatedDate >=:lastrundate AND GYNCF_Business_Object_Name__c =:bussObjectName order by CreatedDate desc/*&& GYNCF_System_Id__c=:systemId*/]);  
        system.debug('list'+batchLogsList);
        return batchLogsList;
    }
    
    @AuraEnabled
    public static String AddGroupMemberfromSAP(String Objname,String FieldName,String indicator,Id SySId){
        System.debug('Objname'+Objname + '  FieldName'+FieldName+ '   indicator'+indicator);
        GYNCS_AuthorizationSetting__c getdata = [select ID,GYNCF_Base_URL__c from GYNCS_AuthorizationSetting__c where Id=:SysId];
        String xml;
        String url=getdata.GYNCF_Base_URL__c+'/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHPICKLIST?BusinessObject=\''+Objname+'\'&PickListField=\''+FieldName+'\'&PickListIndicator=\''+indicator+'\'';
        System.debug(url);
        GYNC_API_Dispatcher.systemId = SysId;
        //HTTPResponse resResult = GYNC_createCustomfieldController.callout(url);
        if(!Test.isRunningTest()){
            Map<String, String> apiHeaderMap = new Map<String, String>();
            HTTPResponse resResult = GYNC_API_Dispatcher.makeCallOut('GET',url,apiHeaderMap,'');
            xml = resResult.getBody();
            if(resResult.getStatusCode()!=200){
                throw new AuraHandledException('No Data available');  
            }    
        }
        else{
            MockHttpResponseGenerator mockClass = new MockHttpResponseGenerator();
            mockClass.mockResponseBody = ' <feed xmlns="http://www.w3.org/2005/Atom" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xml:base="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/"><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHEXTENSIONFIELDS</id><title type="text">EXTENSIONFIELDSSet</title><updated>2020-06-22T16:00:32Z</updated><author><name/></author><link href="FETCHEXTENSIONFIELDS" rel="self" title="EXTENSIONFIELDSSet"/><entry><id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/EXTENSIONFIELDSSet(\'ZZDATE\')</id><title type="text">EXTENSIONFIELDSSet(\'ZZDATE\')</title><updated>2020-06-22T16:00:32Z</updated><category term="GCONNECT.SF_PICK_LIST_SRV.EXTENSIONFIELDS" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/><link href="EXTENSIONFIELDSSet(\'ZZDATE\')" rel="self" title="EXTENSIONFIELDS"/><content type="application/xml"><m:properties xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"><d:Field>ZZDATE</d:Field><d:Key>false</d:Key><d:EdmCoreType>Edm.DateTime</d:EdmCoreType><d:EdmPrecision>0</d:EdmPrecision><d:EdmScale>0</d:EdmScale><d:EdmMaxLength>10</d:EdmMaxLength></m:properties></content></entry></feed>';
            Test.setMock(HttpCalloutMock.class, mockClass);
            xml=mockClass.mockResponseBody;
        }
        
        String jsonContent = GYNC_XML_Parser.xmlToJson(xml);
        System.debug('jsonContent'+jsonContent);
        return jsonContent;
    }
}