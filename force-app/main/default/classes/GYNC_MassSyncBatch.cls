/* Class Name: GYNC_MassSyncBatch
* This is a batch class used to insert records in batches so that it will not hit the governer limit.
* Created by: Nitish
*/
public with sharing class GYNC_MassSyncBatch implements Database.Batchable<String>, Database.Stateful,Database.AllowsCallouts {
    public List<String> batchIterator;       //the List<sObject> to INSERT or UPDATE
    
    public Boolean singleRecordSync;
    public String systemId;
    public Integer successCount;
    public Integer errorCount;
    public Integer top;
    public Integer skip; 
    public GYNCO_Configuration__c configRec;  
    datetime batchStartTime;   
    public String jobId;
    public String logRecId;
    public String endPointSingle;
    public GYNC_MassSyncBatch() {
        successCount = 0;
        errorCount = 0;
        jobId = '';
        batchStartTime = datetime.now(); 
        configRec = new GYNCO_Configuration__c();
        batchIterator = new List<String>();
        singleRecordSync = false;
        endPointSingle = '';
        
        skip =  0;
        top = 0;
    }
    public void executeThisBatch() {
        jobId = Database.executeBatch(this, 1);
        
    }
    //public static void
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
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable()){
            configRec.GYNCF_Mass_Sync_Live__c = True;
        }
        UPDATE configRec;
        return batchIterator;
    }
    
    //Execute - perform the DML Operation 
    //Check for existing records(if exist then UPDATE else INSERT) - yet to implement
    public void execute(Database.BatchableContext info, List<String> iterator) {
            
            // Check if the user has access to view field
            if (!Test.isRunningTest() && (!Schema.SObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isCreateable() || !Schema.SObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isUpdateable())) {
                
                // Pass error to client
                throw new System.NoAccessException();
            }
        
        List<Object> lineItemResponseList = new List<Object>();
        List<GYNC_ResponseDeserializeClass.logItem> errLogList = new List<GYNC_ResponseDeserializeClass.logItem>();
        Set<Id> uniqueIdSet = new Set<Id>();
        String endPoint = GYNC_CreationEndpoint.EndPoint(configRec,top,skip,false);//new added
        
        //check for line item and expand
        if(configRec.GYNCF_LineItemApi_Name__c != null && configRec.GYNCF_LineItemApi_Name__c != '') {
            endPoint += '&$expand=ToItems';
        }
        System.debug('Check endpoint: '+ endPoint);
        
        
        //creating headermap if any
        Map<String, String> apiHeaderMap = new Map<String, String>();
        
        //Calling api
        GYNC_API_Dispatcher.systemId  = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
        System.debug('check status code: '+apiResponse.getStatusCode());
        System.debug('Check53:'+apiResponse.getBody());
        if(apiResponse.getStatusCode() == 200) {
            Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
            Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
            List<Object> responseList = (List<Object>)responseBodyResults.get('results');
            List<Object> responseListForItem = new List<Object>(responseList);
            
            system.debug('configRec.GYNCF_SFDC_Object_Name__c:92 '+configRec.GYNCF_SFDC_Object_Name__c);
            system.debug('responseList:93 '+responseList);
            system.debug('configRec.GYNCF_Field_Maping__c:94 '+configRec.GYNCF_Field_Maping__c);
            system.debug('configRec.GYNCF_Identifier_SAP__c:95 '+configRec.GYNCF_Identifier_SAP__c);
            system.debug('configRec.GYNCF_Identifier_SFDC__c:96 '+configRec.GYNCF_Identifier_SFDC__c);
            
            GYNC_ResponseDeserializeClass.mappingResponseWrapper parentMapptingWrapper= GYNC_ResponseDeserializeClass.createFieldMapping(configRec.GYNCF_SFDC_Object_Name__c, responseList, configRec.GYNCF_Field_Maping__c, configRec.GYNCF_Identifier_SAP__c, configRec.GYNCF_Identifier_SFDC__c, false, '');
            List<sObject> sobjListToUpsert = parentMapptingWrapper.sobjListToUpsert;
            system.debug('sobjListToUpsert:'+parentMapptingWrapper);
            //responseList = null; //to decrease heap size
            List<GYNCO_Configuration__c> allParentConfig = new List<GYNCO_Configuration__c>();
            allParentConfig = [SELECT Id,Name, GYNCF_SFDC_Object_Name__c, GYNCF_Identifier_SFDC__c FROM GYNCO_Configuration__c WHERE GYNCF_SFDC_Object_Name__c IN :GYNC_ResponseDeserializeClass.parentObjMap.values()];
            Map<String, String> objIdentifierMap= new Map<String, String>();
            for(GYNCO_Configuration__c conElement : allParentConfig) {
                objIdentifierMap.put(conElement.GYNCF_SFDC_Object_Name__c, conElement.GYNCF_Identifier_SFDC__c);
            }
            Map<String, String> parentIdMap = new Map<String, String>();
            for(String apiField : GYNC_ResponseDeserializeClass.parentIdentifierMap.keySet()) {
                List<String> allIdentifierList = GYNC_ResponseDeserializeClass.parentIdentifierMap.get(apiField);
                String query = 'SELECT Id, '+objIdentifierMap.get(GYNC_ResponseDeserializeClass.parentObjMap.get(apiField)) + ' FROM ' + GYNC_ResponseDeserializeClass.parentObjMap.get(apiField) + ' WHERE '+ objIdentifierMap.get(GYNC_ResponseDeserializeClass.parentObjMap.get(apiField)) +' IN :allIdentifierList';
                List<Sobject> allParentList = Database.query(String.escapeSingleQuotes(query));
                for(sobject obj : allParentList) {
                    //System.debug('Check66: '+ String.valueOf(obj.get('Id')));
                    parentIdMap.put(String.valueOf(obj.get(objIdentifierMap.get(GYNC_ResponseDeserializeClass.parentObjMap.get(apiField)))), String.valueOf(obj.get('Id')));
                    
                }
                
            }
            
            List<sObject> sobjListToInsert = new List<sObject>();
            List<sObject> sobjListToUpdate = new List<sObject>();
            Set<String> allSAPIdentifier = new Set<String>();
            for(Sobject obj : sobjListToUpsert)  {
                
                allSAPIdentifier.add(String.valueOf(obj.get(configRec.GYNCF_Identifier_SFDC__c)));
            }
            List<Sobject> existingRecords = new List<SObject>();
            String queryExisting = 'SELECT Id, ' + configRec.GYNCF_Identifier_SFDC__c +' FROM ' + configRec.GYNCF_SFDC_Object_Name__c + ' WHERE ' + configRec.GYNCF_Identifier_SFDC__c +' IN :allSAPIdentifier';
            existingRecords = Database.query(String.escapeSingleQuotes(queryExisting));
            Map<String, String> existingRecordMap = new Map<String, String>();
            
            for(SObject obj : existingRecords) {
                existingRecordMap.put(String.valueOf(obj.get(configRec.GYNCF_Identifier_SFDC__c)), String.valueOf(obj.Id));
            }
            
            SObjectType accountType = Schema.getGlobalDescribe().get(configRec.GYNCF_SFDC_Object_Name__c);
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
            Id pbId;
            if(configRec.Name == 'Sales Order') pbId = [SELECT Id, Name FROM Pricebook2 WHERE Name =:configRec.GYNCF_PricebookApi_Name__c].Id;
            for(Sobject obj : sobjListToUpsert)  {
                if(System.Label.GYNCL_Namespace == 'c' && mfields.containskey('GYNCF_Source__c')) {
                    
                    obj.put('GYNCF_Source__c', systemId);
                   
                }
                else if(System.Label.GYNCL_Namespace != 'c' && mfields.containskey(System.Label.GYNCL_Namespace+'__GYNCF_Source__c')) {
                    obj.put('GYNCF_Source__c', systemId);
                }
                
                
                //for testing only
                //System.debug('Check id: '+configRec.GYNCF_Identifier_SFDC__c+ ' : ' +obj.get(configRec.GYNCF_Identifier_SFDC__c));
                for(String apiField : GYNC_ResponseDeserializeClass.parentIdentifierMap.keySet()) {
                    //System.debug('Check 91: '+ apiField + ' : ' +parentIdMap.get(apiField));
                    String sapValue = String.valueOf(obj.get(apiField));
                    obj.put(apiField, parentIdMap.get(sapValue));
                }
                
                
                
                /******************Object Specific Logic Before UPSERT(START)************/
                if(configRec.Name == 'Materials' && UserInfo.isMultiCurrencyOrganization()) {
                    if(obj.get('CurrencyIsoCode') == '') {
                        obj.put('CurrencyIsoCode', 'USD') ;
                    }
                    
                    
                }
                if(configRec.Name == 'Sales Order') {
                    obj.put('Status',configRec.GYNCF_Default_Order_Status__c);
                    
                    obj.put('pricebook2Id',pbId);
                    
                }
                
                
                
                
                
                
                
                /******************Object Specific Logic Before UPSERT(END)************/
                //System.debug('Check existing: '+ existingRecordMap);
                if(Schema.SObjectType.GYNCO_Configuration__c.isUpdateable() && Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isUpdateable() && Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isCreateable()){
                if(existingRecordMap.containsKey(String.valueOf(obj.get(configRec.GYNCF_Identifier_SFDC__c)))) {
                    if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isUpdateable() && Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isCreateable() ) {
                        obj.put('ID', Id.valueOf(existingRecordMap.get(String.valueOf(obj.get(configRec.GYNCF_Identifier_SFDC__c)))));
                    }
                    if(uniqueIdSet.contains(obj.Id)) {
                        GYNC_ResponseDeserializeClass.logItem errLog = new GYNC_ResponseDeserializeClass.logItem(); 
                        errLog.status = 'Warning';
                        errLog.errorMsg = 'Already processed this '+ configRec.GYNCF_Identifier_SAP__c+' : '+JSON.serialize(obj); 
                        //errLogList.add(errLog);
                    }
                    else {
                        uniqueIdSet.add(obj.Id);
                        if(Schema.SObjectType.GYNCO_Configuration__c.isCreateable() && Schema.SObjectType.GYNCO_Configuration__c.isUpdateable()){
                        sobjListToUpdate.add(obj);
                        }
                    }
                    
                }
                else {
                    sobjListToInsert.add(obj);
                }
                
                }
                
            }
            system.debug('sobjListToUpdate:'+sobjListToUpdate);
            system.debug('sobjListToInsert:'+sobjListToInsert);
            //try {
            
            if(sobjListToInsert.size() > 0 && Schema.SObjectType.GYNCO_Configuration__c.isCreateable()) {
                //Database.insert(sobjListToInsert, False);
               
                Database.SaveResult[] insertResult = Database.insert(sobjListToInsert, false);
                
                // Iterate through each returned result
                for (Integer index = 0; index < insertResult.size(); index++) {
                    if (!insertResult[index].isSuccess()) {
                        errorCount++;
                        // Operation failed, so get all errors                
                        for(Database.Error err : insertResult[index].getErrors()) {
                            
                            GYNC_ResponseDeserializeClass.logItem errLog = new GYNC_ResponseDeserializeClass.logItem(); 
                            errLog.recId = string.ValueOf(sobjListToInsert[index].get(configRec.GYNCF_Identifier_SFDC__c));
                            errLog.status = 'Error';
                            errLog.errorMsg = err.getStatusCode() + ': ' + err.getMessage(); 
                            errLogList.add(errLog);
                            
                        }
                    }
                    
                    
                }
                //sobjListToInsert = null;    //to decrease heap size
                System.debug('Check log: '+ errLogList);
            }
            //System.debug('Check98:'+sobjListToUpdate);
            if(sobjListToUpdate.size() > 0 && Schema.SObjectType.GYNCO_Configuration__c.isUpdateable() && Schema.SObjectType.GYNCO_Configuration__c.isCreateable()) {
                //update sobjListToUpdate;
                Database.SaveResult[] updateResult = Database.update(sobjListToUpdate, False);
                //sobjListToUpdate = null; //to decrease heap size
                //System.debug('Check98');
                //List<GYNC_ResponseDeserializeClass.logItem> errLogList = new List<GYNC_ResponseDeserializeClass.logItem>(); 
                // Iterate through each returned result
                for (Integer index = 0; index < updateResult.size(); index++) {
                    if (!updateResult[index].isSuccess()) {
                        errorCount++;
                        for(Database.Error err : updateResult[index].getErrors()) {
                            GYNC_ResponseDeserializeClass.logItem errLog = new GYNC_ResponseDeserializeClass.logItem(); 
                            errLog.status = 'Error';
                            errLog.errorMsg = err.getStatusCode() + ': ' + err.getMessage(); 
                            errLog.recId = sobjListToUpdate[index].Id;
                            errLogList.add(errLog);
                            
                        }
                    }
                    else {
                        GYNC_ResponseDeserializeClass.logItem successLog = new GYNC_ResponseDeserializeClass.logItem(); 
                        successLog.status = 'Success';
                        //errLog.errorMsg = err.getStatusCode() + ': ' + err.getMessage(); 
                        successLog.recId =updateResult[index].getId();
                        //errLogList.add(successLog);
                    }
                    
                }
                //sobjListToInsert = null;    //to decrease heap size
                //System.debug('Check log: '+ errLogList);
            }
            
            
            //adding log code
            //list<GYNCO_Error_Logs__c Logs = new GYNCO_Error_Logs__c([select id,Name from GYNCO_Error_Logs__c where GYNCF_Apex_Job_Id__c=:jobId limit 1]);
            list<Attachment>insertAttch = new list<Attachment>();
            string csvColumnHeader = 'SalesforceId,RecordId, Status, Error Message\n';
            string generatedCSVFile = csvColumnHeader;
            for(GYNC_ResponseDeserializeClass.logItem Err : errLogList){
                String fileRow = '';
                fileRow = fileRow +','+ '';
                fileRow = fileRow +','+ Err.recId;
                fileRow = fileRow +','+ Err.status;
                fileRow = fileRow +','+ Err.errorMsg;
                fileRow = fileRow.replaceFirst(',','');
                generatedCSVFile = generatedCSVFile+'\n' + fileRow ;
            }
            Attachment attachmentCsv = new Attachment();
            if(Schema.sObjectType.Attachment.fields.parentId.isCreateable()) {
                attachmentCsv.parentId = logRecId;    
            }
            if(Schema.sObjectType.Attachment.fields.name.isCreateable()){
                attachmentCsv.name =  'Error'+String.valueOf(skip)+'.csv';    
            } 
            if(Schema.sObjectType.Attachment.fields.body.isCreateable()){
                attachmentCsv.body = blob.valueof(generatedCSVFile);    
            }
            
            insertAttch.add(attachmentCsv);
            insert insertAttch;
            //System.debug('Check attachment111: '+ insertAttch);
            //LoG code end
            
            /***********Object specific logic after UPSERT(START)***********/
            
            if(configRec.Name == 'Materials') {
                Map<String, Decimal> sapCodeListPriceMap = new Map<String, Decimal>();
                for(object rec : responseList) {
                    Map<String, Object> recMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec));
                    sapCodeListPriceMap.put(String.valueOf(recMap.get(configRec.GYNCF_Identifier_SAP__c)),Decimal.valueOf(String.valueOf(recMap.get('Price'))));
                    
                }
                Set<Id> existingProdId = new Set<Id>();
                for(Product2 existingProd :(List<Product2>)sobjListToUpdate) {
                    existingProdId.add(existingProd.Id);
                }
                Id stdPriceBookId;
                
                stdPriceBookId = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Standard Price Book'].Id;
                List<PricebookEntry> existingPriceBook = new List<PricebookEntry>();
                existingPriceBook = [SELECT Id, IsActive, Pricebook2Id, Product2Id, ProductCode 
                                     FROM PricebookEntry WHERE Product2Id IN :existingProdId AND Pricebook2Id = :stdPriceBookId and isActive= true];
                Map<String, Id> existingProductCodePBEId = new Map<String, Id>();
                for(PricebookEntry pbe : existingPriceBook) {
                    existingProductCodePBEId.put(pbe.ProductCode, pbe.Id);
                }
                List<Product2> allProductList = new List<Product2>();
                List<PricebookEntry> pricebookEntryToBeUpsert = new List<PricebookEntry>();
                allProductList.addAll((List<Product2>)sobjListToInsert);
                allProductList.addAll((List<Product2>)sobjListToUpdate);
                
                
                for(Product2 prod : allProductList) {
                    PricebookEntry pbEntry = new PricebookEntry();
                    if(Schema.SObjectType.PricebookEntry.fields.IsActive.isUpdateable()|| Schema.SObjectType.PricebookEntry.fields.IsActive.isCreateable()){
                            pbEntry.IsActive = true;
                        }
                    if(Schema.SObjectType.PricebookEntry.fields.Product2Id.isUpdateable()|| Schema.SObjectType.PricebookEntry.fields.Product2Id.isCreateable()){
                            pbEntry.Product2Id = prod.Id;
                        }
                    if(configRec.GYNCF_PricebookApi_Name__c == 'Standard Price Book' && (Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isCreateable())) {
                        pbEntry.UseStandardPrice = true;
                    }
                    else {
                        if(Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isCreateable()){
                            pbEntry.UseStandardPrice = false;
                        }
                        if(Schema.SObjectType.PricebookEntry.fields.Pricebook2Id.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.Pricebook2Id.isCreateable()){
                            pbEntry.Pricebook2Id = stdPriceBookId;    
                        }
                        
                    }
                    if(Schema.SObjectType.PricebookEntry.fields.UnitPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UnitPrice.isCreateable()){
                            pbEntry.UnitPrice = sapCodeListPriceMap.get(prod.ProductCode);
                        }
                    if(existingProductCodePBEId.containskey(prod.ProductCode) &&(Schema.SObjectType.PricebookEntry.fields.Id.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.Id.isCreateable())) {
                        pbEntry.Id = existingProductCodePBEId.get(prod.ProductCode);
                    }
                    pricebookEntryToBeUpsert.add(pbEntry);
                    
                }
                //System.debug('Check pricebookentry 1: '+ pricebookEntryToBeUpsert[0]);
                List<GYNC_ResponseDeserializeClass.logItem> pricebookEntryError = new List<GYNC_ResponseDeserializeClass.logItem>();
                Database.UpsertResult[] upsertResult = Database.upsert(pricebookEntryToBeUpsert, false);
                
                if(configRec.GYNCF_PricebookApi_Name__c != 'Standard Price Book') {            
                    Id priceBookId = [SELECT Id, Name FROM Pricebook2 WHERE Name =:configRec.GYNCF_PricebookApi_Name__c].Id;
                    List<PricebookEntry> existingPriceBookCustom = new List<PricebookEntry>();
                    existingPriceBookCustom = [SELECT Id, IsActive, Pricebook2Id, Product2Id, ProductCode 
                                               FROM PricebookEntry WHERE Product2Id IN :existingProdId AND Pricebook2Id = :priceBookId and isActive= true];
                    Map<String, Id> existingProductCodePBEIdCus = new Map<String, Id>();
                    for(PricebookEntry pbe : existingPriceBookCustom) {
                        existingProductCodePBEIdCus.put(pbe.ProductCode, pbe.Id);
                    }
                    //List<Product2> allProductListCus = new List<Product2>();
                    List<PricebookEntry> pricebookEntryToBeUpsertCus = new List<PricebookEntry>();
                    //allProductList.addAll((List<Product2>)sobjListToInsert);
                    //allProductList.addAll((List<Product2>)sobjListToUpdate);
                    
                    
                    for(Product2 prod : allProductList) {
                        PricebookEntry pbEntry = new PricebookEntry();
                        if(Schema.SObjectType.PricebookEntry.fields.IsActive.isUpdateable()|| Schema.SObjectType.PricebookEntry.fields.IsActive.isCreateable()){
                            pbEntry.IsActive = true;
                        }
                        if(Schema.SObjectType.PricebookEntry.fields.Product2Id.isUpdateable()|| Schema.SObjectType.PricebookEntry.fields.Product2Id.isCreateable()){
                            pbEntry.Product2Id = prod.Id;
                        }
                        if(configRec.GYNCF_PricebookApi_Name__c == 'Standard Price Book' && (Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isCreateable())) {
                            pbEntry.UseStandardPrice = true;
                        }
                        else {
                            if(Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UseStandardPrice.isCreateable()){
                                pbEntry.UseStandardPrice = false;
                            }
                            if(Schema.SObjectType.PricebookEntry.fields.Pricebook2Id.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.Pricebook2Id.isCreateable()){
                                pbEntry.Pricebook2Id = priceBookId;    
                            }
                        }
                        if(Schema.SObjectType.PricebookEntry.fields.UnitPrice.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.UnitPrice.isCreateable()){
                            pbEntry.UnitPrice = sapCodeListPriceMap.get(prod.ProductCode);
                        }
                        if(existingProductCodePBEIdCus.containskey(prod.ProductCode) &&(Schema.SObjectType.PricebookEntry.fields.Id.isUpdateable() || Schema.SObjectType.PricebookEntry.fields.Id.isCreateable())) {
                            
                            pbEntry.Id = existingProductCodePBEIdCus.get(prod.ProductCode);
                        }
                        pricebookEntryToBeUpsertCus.add(pbEntry);
                        
                    }
                    //System.debug('Check pricebookentry 1: '+ pricebookEntryToBeUpsert[0]);
                    List<GYNC_ResponseDeserializeClass.logItem> pricebookEntryErrorCus = new List<GYNC_ResponseDeserializeClass.logItem>();
                    Database.UpsertResult[] upsertResultCus = Database.upsert(pricebookEntryToBeUpsertCus, false);
                    for (Integer index = 0; index < upsertResultCus.size(); index++) {
                        if (!upsertResultCus[index].isSuccess()) {
                            for(Database.Error err : upsertResultCus[index].getErrors()) {
                                GYNC_ResponseDeserializeClass.logItem errLog = new GYNC_ResponseDeserializeClass.logItem(); 
                                errLog.status = 'Error';
                                errLog.errorMsg = err.getStatusCode() + ': ' + err.getMessage(); 
                                errLog.recId = pricebookEntryToBeUpsertCus[index].Product2Id;
                                pricebookEntryErrorCus.add(errLog);
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
            
            
            /***********Object specific logic after UPSERT(END)***********/
            
            //***********for line item and expand(START)***********/
            if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_LineItemApi_Name__c.isUpdateable()){
            if(configRec.GYNCF_LineItemApi_Name__c != null && configRec.GYNCF_LineItemApi_Name__c != '') {
                List<Sobject> allParentList = new List<Sobject>();
                if(Schema.SObjectType.GYNCO_Configuration__c.isCreateable() && Schema.SObjectType.GYNCO_Configuration__c.isUpdateable()){
                allParentList.addAll((List<Sobject>)sobjListToInsert);
                allParentList.addAll((List<Sobject>)sobjListToUpdate);
                }
                Map<String, String> parentIdentifierIdMap = new Map<String, String>();
                for(Sobject sobj : allParentList ) {
                    if(sobj.get('Id') != '' && sobj.get('Id') != null && Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Identifier_SFDC__c.isCreateable()) {
                        parentIdentifierIdMap.put(String.valueOf(sobj.get(configRec.GYNCF_Identifier_SFDC__c)), String.valueOf(sobj.get('Id')));
                    }
                }
                System.debug('check parent identifier map: '+ parentIdentifierIdMap);
                System.debug('Check responselist: '+responseListForItem);
                for(object rec : responseListForItem) {
                    Map<String, Object> lineItemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec));
                    //System.debug('Check lineitem map: '+lineItemMap);
                    //Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
                    Map<String, Object> lineItemBodyResults =  (Map<String, Object>)lineItemMap.get('ToItems');
                    //System.debug('Check lineitem map: '+lineItemBodyResults);
                    List<Object> lineItemList = (List<Object>)lineItemBodyResults.get('results');
                    //System.debug('Check lineitem: '+lineItemList[0]);
                    if(lineItemList != null) lineItemResponseList.addAll(lineItemList);
                    
                }
                
                
                
                GYNC_ResponseDeserializeClass.mappingResponseWrapper innerWrapper= GYNC_ResponseDeserializeClass.createFieldMapping(configRec.GYNCF_LineItemApi_Name__c, lineItemResponseList, JSON.serialize(parentMapptingWrapper.itemMappingList),configRec.GYNCF_LineItem_Identifier_SAP__c,configRec.GYNCF_LineItem_Identifier_SFDC__c, true,configRec.GYNCF_Identifier_SAP__c);
                Map<String, String> itemLineItemMap = new Map<String, String>();
                itemLineItemMap = innerWrapper.itemLineItemMap;
                System.debug('Check itemLineItemMap: '+ itemLineItemMap);
                List<sObject>lineItemToUpsert = new List<Sobject>();
                lineItemToUpsert = innerWrapper.sobjListToUpsert;
                System.debug('Check itemLineItemMap: '+ lineItemToUpsert);
                List<sObject>lineItemToInsert = new List<sObject>();
                List<sObject>lineItemToUpdate = new List<sObject>();
                Map<String, String> prodPriceBookIdMap = new Map<String, String>();
                Set<String> allProdCode = new Set<String>();
                for(sobject sobj : lineItemToUpsert) {
                    allProdCode.add(String.valueOf(sobj.get(configRec.GYNCF_PricebookEntry_Field_API_Name__c)));
                }
                //System.debug('Check all prod code: '+ allProdCode);
                List<Pricebookentry> allPBentry = new List<Pricebookentry>();
                allPBentry = [select id,ProductCode from pricebookentry where ProductCode in :allProdCode and Pricebook2.Name =  :configRec.GYNCF_PricebookApi_Name__c];
                for(pricebookentry pbE: allPBentry) {
                    prodPriceBookIdMap.put(pbE.ProductCode, pbE.Id);
                }
                //System.debug('Pricebook entry map: ' +prodPriceBookIdMap);
                Map<string, String> existingLineItemMap = new Map<String, String>();
                Set<String> itemLineItemKeySet = new Set<String>();
                itemLineItemKeySet = itemLineItemMap.keySet();
                String lineItemQuery = 'SELECT Id, ' + configRec.GYNCF_LineItem_Identifier_SFDC__c + ' FROM '+ configRec.GYNCF_LineItemApi_Name__c + ' WHERE ' + configRec.GYNCF_LineItem_Identifier_SFDC__c +' IN :itemLineItemKeySet';
                System.debug('Check lineItemQuery: '+ lineItemQuery);
                for(sobject obj : Database.query(String.escapeSingleQuotes(lineItemQuery))) {
                    existingLineItemMap.put(String.valueOf(obj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c)),String.valueOf(obj.get('Id')));
                }
                System.debug('Check lineItemQuery: '+ existingLineItemMap);
                for(sobject sobj : lineItemToUpsert) {
                    //System.debug('Check map: '+parentIdentifierIdMap.get(String.valueOf(itemLineItemMap.get(String.valueOf(sobj.get('GYNCF_SalesDocumentItem__c'))))));
                    //System.debug('Check map key : '+ String.valueOf(itemLineItemMap.get(String.valueOf(sobj.get('GYNCF_SalesDocumentItem__c')))));
                    //System.debug('check key key: '+ sobj.get('GYNCF_SalesDocumentItem__c'));
                    if (Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_LineItem_Identifier_SFDC__c.isCreateable()){
                    if(itemLineItemMap.containsKey(String.valueOf(sobj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c)))) {
                        if(parentIdentifierIdMap.containskey(itemLineItemMap.get(String.valueOf(sobj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c))))) {
                            if(prodPriceBookIdMap.containskey(String.valueOf(sobj.get(configRec.GYNCF_PricebookEntry_Field_API_Name__c)))) {
                                
                                sobj.put(configRec.GYNCF_PricebookEntry_Field_API_Name__c,String.valueOf(prodPriceBookIdMap.get(String.valueOf(sobj.get(configRec.GYNCF_PricebookEntry_Field_API_Name__c)))));
                                sobj.put(configRec.GYNCF_LineItem_ParentField_Api__c,parentIdentifierIdMap.get(String.valueOf(itemLineItemMap.get(String.valueOf(sobj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c))))));
                                if(existingLineItemMap.containskey(String.valueOf(sobj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c)))) {
                                    sobj.put('Id', String.valueOf(existingLineItemMap.get(String.valueOf(sobj.get(configRec.GYNCF_LineItem_Identifier_SFDC__c)))));
                                    lineItemToUpdate.add(sobj);
                                }
                                else {
                                    if(Schema.SObjectType.GYNCO_Configuration__c.isCreateable()){
                                    lineItemToInsert.add(sobj);
                                    }
                                }
                                
                            }
                        }
                    }
                    }
                }
                System.debug('check insert: '+ lineItemToInsert);
                if(lineItemToInsert.size() > 0 && Schema.SObjectType.GYNCO_Configuration__c.isCreateable()) {
                    Database.SaveResult[] upsertResultline = Database.insert(lineItemToInsert, false);
                    for (Integer index = 0; index < upsertResultline.size(); index++) {
                        if (!upsertResultline[index].isSuccess()) {
                            for(Database.Error err : upsertResultline[index].getErrors()) {
                                System.debug('Error: '+ err.getMessage());
                                
                            }
                        }
                        
                        
                    }
                }
                System.debug('check update: '+ lineItemToUpdate);
                if(lineItemToUpdate.size() > 0) {
                    Database.SaveResult[] upsertResultline = Database.update(lineItemToUpdate, false);
                    for (Integer index = 0; index < upsertResultline.size(); index++) {
                        if (!upsertResultline[index].isSuccess()) {
                            for(Database.Error err : upsertResultline[index].getErrors()) {
                                System.debug('Error: '+ err.getMessage());
                                
                            }
                        }
                        
                        
                    }
                    
                }
                ///List<sObject> sobjListToUpsert = parentMapptingWrapper.sobjListToUpsert;
                
            }
            }
            
            //***********for line item and expand(END)***********/
            
            
            
            
            //}
            //catch(Exception ex) {
            //    System.debug('Error84: '+ex.getMessage());
            //}
            
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
        //if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable()) configRec.GYNCF_Mass_Sync_Live__c = True;
        UPDATE configRec;
        //errorRecord.GYNCF_All_Logs__c = JSON.serialize(errLogList);
        //UPSERT errorRecord;
        
        
    }
    
    //After the operation is ended, update configuration object
    //Send notification with log file - yet to implement
    public void finish(Database.BatchableContext info) {
        System.debug('Check JobId inside finish: '+ logRecId);
        System.debug('Check error count: '+ errorCount);
        GYNCO_Error_Logs__c logRec = new GYNCO_Error_Logs__c(Id=logRecId );
        if(errorCount >0) {
            if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Comments__c.isUpdateable()) {
                logRec.GYNCF_Comments__c = String.valueOf(configRec.GYNCF_To_Be_Synced__c - errorCount)+ ' Records Successfully Synced. '+String.valueOf(errorCount) +' Records Failed.';  
            }
            /*if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Coment__c.isUpdateable()) {
                logRec.GYNCF_Coment__c = String.valueOf(configRec.GYNCF_To_Be_Synced__c - errorCount)+ ' Records Successfully Synced.'+String.valueOf(errorCount) +' Records Failed.';  
            }*/
            if(errorCount == configRec.GYNCF_To_Be_Synced__c && Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Apex_Job_Status__c.isUpdateable()) {
                logRec.GYNCF_Apex_Job_Status__c =   'Fail';
            }
            else if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Apex_Job_Status__c.isUpdateable()) {
                
                logRec.GYNCF_Apex_Job_Status__c =   'Partially Successful';
            }
             
            
        }
        else if(errorCount == 0) {
            if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Apex_Job_Status__c.isUpdateable()) {
                logRec.GYNCF_Apex_Job_Status__c =   'Success';
            }
            if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Comments__c.isUpdateable()) {
                logRec.GYNCF_Comments__c = String.valueOf(configRec.GYNCF_To_Be_Synced__c)+ ' Records Successfully Synced. 0 Records Failed.';  
            }
            /*if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_Coment__c.isUpdateable()) {
                logRec.GYNCF_Coment__c = String.valueOf(configRec.GYNCF_To_Be_Synced__c)+ ' Records Successfully Synced. 0 sRecords Failed.';  
            }*/
            
        }
        if(Schema.sObjectType.GYNCO_Error_Logs__c.fields.GYNCF_System_Id__c.isUpdateable()) {
            logRec.GYNCF_System_Id__c = systemId;
        }
        UPDATE logRec;
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.isUpdateable()) {
            configRec.GYNCF_Mass_Sync_Live__c = False;
        }
        //configRec.GYNCF_Synced__c = 0;
        //configRec.GYNCF_To_Be_Synced__c = 0;
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Last_Synced__c.isUpdateable()) {
            configRec.GYNCF_Last_Synced__c = batchStartTime;
        }
        UPDATE configRec;
    }
}