public with sharing class GYNC_singleRecordSyncApex {
    
    public class searchResult {
        @AuraEnabled Public String key{get; set;}
        @AuraEnabled Public String value{get; set;}
        public searchResult(String key, String value) {
            
            this.value = value;
            this.key = key;
        }
    }
    
    @AuraEnabled
    public static String syncSingleRecord(String objNameSAP, String systemId, String searchPara) {
        String statusMsg = 'Success';
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        configRec = GYNC_massSyncTabClass.findConfigRec(objNameSAP, systemId);
        if(configRec.GYNCF_Mass_Sync_Live__c) return 'Mass Sync is going on. Please try later.';
        
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_To_Be_Synced__c.IsUpdateable()){
            configRec.GYNCF_To_Be_Synced__c = 1;
        }
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Synced__c.IsUpdateable()){
            configRec.GYNCF_Synced__c = 0;
        }
        UPDATE configRec;
        
        String endPoint = configRec.GYNCF_Service_URL__c;
        //endPoint += '?$filter='
        String customerURL = '';
        if(configRec.GYNCF_Identifier_SAP__c == 'Customer') {
            customerURL = EncodingUtil.urlEncode(' and PartnerFunction eq \'SP\' and ReferenceCustomer eq \''+searchPara+'\'','UTF-8');
        }
        customerURL += ')';
      	System.debug('Checkpoint999 0: '+ endPoint);
        endPoint += '?$filter=(';
        System.debug('Checkpoint999 1: '+ endPoint);
        endPoint +=+configRec.GYNCF_Identifier_SAP__c+EncodingUtil.urlEncode(' eq \''+searchPara+'\'', 'UTF-8')+customerURL+'&$format=json';
        System.debug('Checkpoint999 2: '+ endPoint);
        //System.debug('Checkpoint 3: '+ endPoint);
        List<String> batchSizeList  = new List<String>();
        batchSizeList.add('One');
             
        GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
        massSyncBatch.batchIterator = batchSizeList;
        massSyncBatch.top = Integer.valueOf(configRec.GYNCF_Batch_Size__c);
        massSyncBatch.configRec = configRec;
        massSyncBatch.systemId = systemId;
        massSyncBatch.singleRecordSync = true;
        massSyncBatch.endPointSingle = endPoint;
        massSyncBatch.executeThisBatch();
        
        
        
        return statusMsg;
    }
    
    @AuraEnabled
    public static GYNCO_Configuration__c findConfigRec(String objNameSAP, String systemId) {
        return GYNC_massSyncTabClass.findConfigRec(objNameSAP, systemId);
        
    }
    
    @AuraEnabled
    public static List<searchResult> searchRecord(String searchPara, String objNameSAP, String systemId) {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        configRec = GYNC_massSyncTabClass.findConfigRec(objNameSAP, systemId);
        String endPoint = configRec.GYNCF_Service_URL__c;
        System.debug('Checkpoint999 0: '+ endPoint);
        
        String customerURL = '';
        if(configRec.GYNCF_Identifier_SAP__c == 'Customer') {
            customerURL = ',PartnerFunction=\'SP\',ReferenceCustomer=\''+searchPara+'\'';
        }
        customerURL += ')';
        //endPoint += '?filter=';
        endPoint += '('+configRec.GYNCF_Identifier_SAP__c+'=\''+searchPara+'\''+customerURL+'?$format=json';
        System.debug('Check end point: '+ endPoint);
        Map<String, String> apiHeaderMap = new Map<String, String>();
        
        //Calling api
        GYNC_API_Dispatcher.systemId = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
        List<searchResult> results = new List<searchResult>();
        if(apiResponse.getStatusCode() == 200) {
            Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
            Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
            System.debug('Check: '+ responseBodyResults.keyset());
            for(String key : responseBodyResults.keyset()) {
                //System.debug('Check: '+ responseBodyResults.get(key));
                results.add(new searchResult(key, String.valueOf(responseBodyResults.get(key))));
            }
        }
         
        /*String searchQuery = 'find {'+searchPara+'} IN ALL FIELDS RETURNING '+configRec.GYNCF_SFDC_Object_Name__c+'(Id, Name,'+configRec.GYNCF_Identifier_SFDC__c+',lastmodifieddate),GYNCO_Configuration__c';
		List<Sobject> searchResult = new List<Sobject>();
        searchResult = (List<sObject>)search.query(String.escapeSingleQuotes(searchQuery))[0];
       
        for(sObject obj : searchResult) {
            searchResult record = new searchResult();
            record.value = String.valueOf(obj.get('Name'));
            record.description = 'SAP Number: '+ String.valueOf(obj.get(configRec.GYNCF_Identifier_SFDC__c))+' Last Modify on '+String.valueOf(obj.get('lastmodifieddate'));
            results.add(record);
        }*/
        return results;
    }
}