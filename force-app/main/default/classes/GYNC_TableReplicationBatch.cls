public with sharing class GYNC_TableReplicationBatch implements Database.Batchable<String>, Database.Stateful,Database.AllowsCallouts {
    public List<String> batchIterator; 
    public String systemId;
	public Integer top;
    public Integer skip; 
    public GYNCO_Configuration__c configRec;
    datetime batchStartTime;   
    public String jobId;
    public String logRecId;
     public GYNC_TableReplicationBatch() {
        jobId = '';
        batchStartTime = datetime.now(); 
        configRec = new GYNCO_Configuration__c();
        batchIterator = new List<String>();
        
        
        skip =  0;
        top = 0;
    }
    
    public void executeThisBatch() {
        jobId = Database.executeBatch(this, 1);
        
    }
    
    
    //Batch start - return records depending upon the batch size
    public Iterable<String> start(Database.BatchableContext BC) {
        jobId = bc.getJobId();
        GYNCO_Error_Logs__c errorRecord = new GYNCO_Error_Logs__c();
        if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Apex_Job_Id__c.isCreateable()){
            errorRecord.GYNCF_Apex_Job_Id__c = jobId;
        }
        if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Business_Object_Name__c.isCreateable()){
        	errorRecord.GYNCF_Business_Object_Name__c = configRec.Name;    
        } 
        //errorRecord.Name = 'MassSync for ' + configRec.Name +' '+ String.valueOf(batchStartTime);
        INSERT errorRecord;
        logRecId =  errorRecord.id;
        
        return batchIterator;
    }
    
    public void execute(Database.BatchableContext info, List<String> iterator) {
        String requestBody = GYNC_UtilityClass.buildRequestBody(configRec,top,skip,false);
        //String requestBody = '{"Table": "VBAK","ToFilters": [{"FieldName": "$top","ValueLow": "'+top+'","Operation": "EQ"},{"FieldName": "$skip","ValueLow": "'+skip+'","Operation": "EQ"},{"FieldName": "$inlinecount","ValueLow": "","Operation": "EQ"}],"ToFields": [{ "FieldName": "VBELN" },{ "FieldName": "ERDAT" }]}';
        System.debug('Check systemId 47: '+systemId);
        system.debug('requestBody48' +requestBody);
        GYNC_UtilityClass.systemId = systemId;
        HTTPResponse apiResponse = GYNC_UtilityClass.findTableReplicationData(configRec.GYNCF_Service_URL__c, requestBody);
        Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
         System.debug('Check 52responseBodyD: ' + responseBodyD);
        Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
        System.debug('Check 48: ' + responseBodyResults);
        Map<String, Object> responseBodyToFilters=  (Map<String, Object>)responseBodyResults.get('ToFields');
        system.debug('responseBodyToFilters56 '+responseBodyToFilters);
        List<Object> responseBodyFilterResult =  (List<Object>)responseBodyToFilters.get('results');
        system.debug('responseBodyFilterResult '+responseBodyFilterResult);
        List<sObject> sobjListToUpsert = new List<sObject>();
        
        GYNC_UtilityClass.systemId = systemId;
        sobjListToUpsert = GYNC_UtilityClass.processTableReplicationResponse(responseBodyFilterResult, configRec.GYNCF_Field_Maping__c, configRec.GYNCF_SFDC_Object_Name__c);
        System.debug('Check 54: '+ sobjListToUpsert);
        if(sobjListToUpsert.size() > 0) {
            INSERT sobjListToUpsert;
        }
        skip += Integer.valueOf(configRec.GYNCF_Batch_Size__c);
        if(skip > configRec.GYNCF_To_Be_Synced__c) {
            configRec.GYNCF_Synced__c = Integer.valueOf(configRec.GYNCF_To_Be_Synced__c);
        }
        else {
            if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Synced__c.isUpdateable()){
                configRec.GYNCF_Synced__c = skip;
            }
        }
        
        UPDATE configRec;
        
        
    }
    
    
    //After the operation is ended, update configuration object
    //Send notification with log file - yet to implement
    public void finish(Database.BatchableContext info) {
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable()) {
            configRec.GYNCF_Mass_Sync_Live__c = False;
        }
        
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Last_Synced__c.isUpdateable()){
            configRec.GYNCF_Last_Synced__c = batchStartTime;
        }
        /*if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable() || Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Last_Synced__c.isUpdateable()){
            configRec.GYNCF_Mass_Sync_Live__c = False;
            configRec.GYNCF_Last_Synced__c = batchStartTime;
            UPDATE configRec;
        }*/
        UPDATE configRec;
    }
    
}