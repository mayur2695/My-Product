public with sharing class GYNC_SAPTableReplicationHomeApex {
    Public static String fieldTypeSFDC;
    
    public class fieldMappingWrapper {
        public String sapField;
        public String SFDCField;
        public fieldMappingWrapper(String sapField, String SFDCField) {
            this.sapField = sapField;
            this.SFDCField = SFDCField;
        }
    }
    public class sapTableWrapper {
        @AuraEnabled Public String value{get; set;}
        @AuraEnabled Public String description{get; set;}
        public sapTableWrapper(String value, String description) {
            this.value = value;
            this.description = description;
        }
    }
    public class sapFieldWrapper {
        @AuraEnabled Public String fieldName{get; set;}
        @AuraEnabled Public String fieldType{get; set;}
        @AuraEnabled Public Boolean isSelected{get; set;}
        @AuraEnabled Public Boolean isAdded{get; set;}
        public sapFieldWrapper(String fieldName, String fieldType,Boolean isSelected) {
            this.fieldName = fieldName;
            this.fieldType = fieldType;
            this.isSelected = isSelected;
        }
    }
    @AuraEnabled
    public static String updateFieldMap(String configRecId, String selectedFieldsString, List<String> deleteFields) {
        String status = 'success';
        try{
            List<String> SFDCFieldList = new List<String>();
            List<sapFieldWrapper> selectedFields = new List<sapFieldWrapper>();
            List<fieldMappingWrapper> maapingFieldList = new List<fieldMappingWrapper>();
            GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
            configRec = [sELECT id, Name, GYNCF_SFDC_Object_Name__c,GYNCF_Field_Maping__c FROM GYNCO_Configuration__c WHERE Id = :configRecId WITH SECURITY_ENFORCED];
            
            
            status = 'check point 1';
            MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
            metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
            metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
            
            List<String> fullNameList = new List<String>();
            for(String fld : deleteFields) {
                fullNameList.add(configRec.GYNCF_SFDC_Object_Name__c+'.'+fld+ '__c');
            }
            List<MetadataService.DeleteResult> results = new List<MetadataService.DeleteResult>();
            status = 'check point 2';
            if(!Test.isRunningTest() && fullNameList.size() > 0) results = metaDataServiceInstance.deleteMetadata('CustomField',fullNameList);
            status = 'check point 3';
            for(MetadataService.DeleteResult result : results) {
                if(!result.success) status = 'Not able to delete fields. Please try again later.';
                
            }
            List<MetadataService.Metadata> fields = new List<MetadataService.CustomField>();
            status = 'check point 4';
            status = 'success';
            System.debug('Check selectedFieldsString: '+ selectedFieldsString);
            if(status == 'success') {
                selectedFields = (List<sapFieldWrapper>)JSON.deserialize(selectedFieldsString, List<sapFieldWrapper>.class);
                
                for(sapFieldWrapper fld : selectedFields) {
                    if(fld.isSelected ) {
                        MetadataService.CustomField fieldMeta = customFieldMetadataCreate(configRec.GYNCF_SFDC_Object_Name__c+'.'+fld.fieldName, fld.fieldType);
                        if(fieldMeta != null) {
                            if(fld.isAdded != null && !fld.isAdded) {
                                fields.add(fieldMeta);
                                SFDCFieldList.add(fld.fieldName + '__c');
                            }
                            String sfdcField = '{"sfdcFieldType":"'+fieldTypeSFDC+'","fieldValue":"'+fld.fieldName.replace(' ','_') + '__c'+'"}';
                            
                            maapingFieldList.add(new fieldMappingWrapper(fld.fieldName, sfdcField));                    
                            
                        }
                        
                    }
                    
                }
                metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
                List<MetadataService.SaveResult> resultsField = new List<MetadataService.SaveResult>();
                //status = 'check point 5';
                if(!Test.isRunningTest() && fields.size()>0) resultsField = metaDataServiceInstance.createMetadata(fields);
                //status = 'check point 6';
                for(MetadataService.SaveResult result :  resultsField) {
                    System.debug('Check 88: '+result);
                    if(!result.success) status = 'Error while creating fields.';
                }
                configRec.GYNCF_Field_Maping__c = JSON.serialize(maapingFieldList);
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Field_Maping__c.isUpdateable()){
                    UPDATE configRec;
                }
                if(status == 'success') {
                    
                    GYNC_tabPermissionBatch tabBatch = new GYNC_tabPermissionBatch();
                    tabBatch.SFDCObjName = configRec.GYNCF_SFDC_Object_Name__c;
                    tabBatch.SFDCFieldList = SFDCFieldList;
                    tabBatch.configRec = configRec;
                    if(!Test.isRunningTest()) Database.executeBatch(tabBatch,1);
                }
                
                
            }
        }
        catch(Exception ex) {
            status = ex.getMessage();
        }
        
        return status;
    }
    
    @AuraEnabled
    public static String deleteObjectMapping(String systemId, String tableName) {
        String status = 'success';
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        configRec = GYNC_massSyncTabClass.findConfigRec(tableName, systemId);
        
        MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
        metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
        metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
        
        List<String> objList = new List<String>();
        objList.add(configRec.GYNCF_SFDC_Object_Name__c);
        List<MetadataService.DeleteResult> results = metaDataServiceInstance.deleteMetadata('CustomObject',objList);
        for(MetadataService.DeleteResult result : results) {
            if(!result.success) status = 'Not able to delete object. Please try again later.';
            
        }
        if(status == 'success') {
            try {
                if(Schema.sObjectType.GYNCO_Configuration__c.isDeletable()){
                    DELETE configRec;
                }
            }
            catch (Exception ex) {
                status = ex.getMessage();
            }
        }
        
        
        return status;
    }
    
    private static GYNCS_AuthorizationSetting__c findAuthRec(String systemId) {
        return [SELECT id, Name, GYNCF_Base_URL__c FROM GYNCS_AuthorizationSetting__c WHERE Id = :systemId WITH SECURITY_ENFORCED LIMIT 1 ];
    }
    
    @AuraEnabled
    public static String searchSAPTable(String searchPara, String systemId) {
        //GYNC_massSyncTabClass.findConfigRec(objNameSAP, systemId)
        List<sapTableWrapper> availabeTables = new List<sapTableWrapper>();
        Map<String, String> apiHeaderMap = new Map<String, String>();
        String endPoint = findAuthRec(systemId).GYNCF_Base_URL__c+'/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHTABLES?SapTable=\''+searchPara+'*\'&$format=json';
        System.debug('Check point 7: ' + endPoint);
        //Calling api
        GYNC_API_Dispatcher.systemId = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
        System.debug('Check 9: '+ apiResponse.getStatusCode()+ ' : ' +apiResponse.getBody());
        if(apiResponse.getStatusCode() == 200) {
            Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
            Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
            List<Object> responseList = (List<Object>)responseBodyResults.get('results');
            for(Object obj : responseList) {
                Map<String, Object> recMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
                availabeTables.add(new sapTableWrapper(String.valueOf(recMap.get('Value')), String.valueOf(recMap.get('Description'))));
            }
        }
        return JSON.serialize(availabeTables);
    }
    
    @AuraEnabled
    public static String fetchAllFields(String tableName, String systemId) {
        List<sapFieldWrapper> availabeFields = new List<sapFieldWrapper>();
        Map<String, String> apiHeaderMap = new Map<String, String>();
        String endPoint = findAuthRec(systemId).GYNCF_Base_URL__c+'/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHTABLEFIELDS?SapTable=\''+tableName+'\'&$format=json';
        System.debug('Check point 7: ' + endPoint);
        //Calling api
        GYNC_API_Dispatcher.systemId = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
        if(apiResponse.getStatusCode() == 200) {
            Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
            Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
            List<Object> responseList = (List<Object>)responseBodyResults.get('results');
            for(Object obj : responseList) {
                Map<String, Object> recMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
                availabeFields.add(new sapFieldWrapper(String.valueOf(recMap.get('Field')), String.valueOf(recMap.get('EdmCoreType')), false));
            }
            
        }
        return JSON.serialize(availabeFields);
        
    }
    
    @AuraEnabled
    public static void customSFDCObj(String tableSelected, String SFDCObjName, String selectedFieldsString, String systemId) {
        List<String> SFDCFieldList = new List<String>(); 
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        List<fieldMappingWrapper> maapingFieldList = new List<fieldMappingWrapper>();
        List<sapFieldWrapper> selectedFields = new List<sapFieldWrapper>();
        selectedFields = (List<sapFieldWrapper>)JSON.deserialize(selectedFieldsString, List<sapFieldWrapper>.class);
        MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
        metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
        metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
        
        List<MetadataService.Metadata> customObjectlst = new List<MetadataService.Metadata>();
        MetadataService.CustomObject customObject = new MetadataService.CustomObject();
        
        customObject.label = SFDCObjName;
        customObject.pluralLabel = SFDCObjName + 's';
        customObject.fullName = SFDCObjName.replace(' ','_') + '__c';
        
        customObject.nameField = new MetadataService.CustomField();
        customObject.nameField.type_x = 'AutoNumber';
        customObject.nameField.label = SFDCObjName + ' Name';
        customObject.deploymentStatus = 'Deployed';
        customObject.sharingModel = 'ReadWrite';
        
        
        List<MetadataService.CustomField> fields = new List <MetadataService.CustomField>();
        for(sapFieldWrapper fld : selectedFields) {
            if(fld.isSelected) {
                MetadataService.CustomField fieldMeta = customFieldMetadataCreate(fld.fieldName, fld.fieldType);
                if(fieldMeta != null) {
                    fields.add(fieldMeta);
                    String sfdcField = '{"sfdcFieldType":"'+fieldTypeSFDC+'","fieldValue":"'+fld.fieldName.replace(' ','_') + '__c'+'"}';
                    SFDCFieldList.add(fieldMeta.fullName);
                    maapingFieldList.add(new fieldMappingWrapper(fld.fieldName, sfdcField));                    
                    
                }
                
            }
            
        }
        //fields.add(customField);
        //fields.add(customField2);
        if(fields.size() > 0) customObject.fields = fields;
        
        //create listview
        List<MetadataService.ListView> listViews = new List<MetadataService.ListView>();
        MetadataService.ListView listViewAll = new MetadataService.ListView();
        listViewAll.fullName = 'All'/*+ SFDCObjName*/;
        listViewAll.label = 'All '+ SFDCObjName;
        listViewAll.filterScope = 'Everything';
        listViews.add(listViewAll);
        customObject.listViews = listViews;
        customObjectlst.add(customObject);
        
        List<MetadataService.SaveResult> results = metaDataServiceInstance.createMetadata(customObjectlst);
        Boolean isCreated = true;
        System.debug('Check error235: '+ results[0]);
        for(MetadataService.SaveResult result :  results) {
            System.debug('Check: '+result);
            if(!result.success) isCreated = false;
        }
        if(isCreated) {
            //MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
            //metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
            metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
            
            List<MetadataService.Metadata> customTablist = new List<MetadataService.Metadata>();
            MetadataService.CustomTab customTabInstance = new MetadataService.CustomTab();
            
            customTabInstance.fullName = SFDCObjName.replace(' ','_') + '__c';
            customTabInstance.customObject = true;
            customTabInstance.motif = 'Custom53: Bell';
            
            
            customTablist.add(customTabInstance);
            
            List<MetadataService.SaveResult> resultsTab = metaDataServiceInstance.createMetadata(customTablist);
            System.debug('Check error256: '+ resultsTab[0]);
            for(MetadataService.SaveResult result :  resultsTab) {
                if(!result.success) isCreated = false;
            }
            if(isCreated) {
                
                GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
                configRec.Name = tableSelected;
                configRec.GYNCF_Operation_Type__c = 'Table Replication Sync';
                configRec.GYNCF_SFDC_Object_Name__c = SFDCObjName.replace(' ','_') + '__c';
                configRec.GYNCF_Field_Maping__c  = JSON.serialize(maapingFieldList);
                configRec.GYNCF_System_Id__c = systemId;
                configRec.GYNCF_Service_URL__c = [SELECT id,GYNCF_Base_URL__c from GYNCS_AuthorizationSetting__c WHERE Id = :systemId ].GYNCF_Base_URL__c + '/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/TABLESet';
                configRec.GYNCF_Batch_Size__c = 500;
                if(Schema.sObjectType.GYNCO_Configuration__c.isCreateable()){
                    INSERT configRec;
                }
                GYNC_tabPermissionBatch tabBatch = new GYNC_tabPermissionBatch();
                tabBatch.SFDCObjName = SFDCObjName;
                tabBatch.SFDCFieldList = SFDCFieldList;
                tabBatch.configRec = configRec;
                if(!Test.isRunningTest()) Database.executeBatch(tabBatch,1);
            }
        }
        
    }
    
    @AuraEnabled
    public static GYNCO_Configuration__c findConfigRec(String objNameSAP, String systemId) {
        return GYNC_massSyncTabClass.findConfigRec(objNameSAP, systemId);
        
    }
    
    
    @AuraEnabled
    public static String findExistingTableMapping(String systemId) {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        List<GYNCO_Configuration__c> configRecList = new List<GYNCO_Configuration__c>();
        configRecList = [SELECT Id, Name, GYNCF_SFDC_Object_Name__c,GYNCF_Field_Maping__c, GYNCF_Available_Fileters__c, 
                         GYNCF_Last_Synced__c,GYNCF_Mass_Sync_Live__c, GYNCF_isFLSActive__c 
                         FROM GYNCO_Configuration__c WHERE GYNCF_Operation_Type__c = 'Table Replication Sync'
                         and GYNCF_System_Id__c = :systemId WITH SECURITY_ENFORCED];
        
        return JSON.serialize(configRecList);
    }
    
    @AuraEnabled
    public static String startMassSyncSAP(String tableNameSAP, String systemId) {
        String statusMsg = 'success';
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        configRec = GYNC_massSyncTabClass.findConfigRec(tableNameSAP, systemId);
        String requestBody = GYNC_UtilityClass.buildRequestBody(configRec,1,1,true);
        System.debug('Check 144: ' + requestBody);
        //String requestBody = '{"Table": "VBAK","ToFilters": [{"FieldName": "$top","ValueLow": "1","Operation": "EQ"},{"FieldName": "$inlinecount","ValueLow": "","Operation": "EQ"}],"ToFields": [{ "FieldName": "VBELN" },{ "FieldName": "ERDAT" }]}';
        GYNC_UtilityClass.systemId = systemId;
        System.debug('Check requestBody: '+ requestBody);
        HTTPResponse apiResponse = GYNC_UtilityClass.findTableReplicationData(configRec.GYNCF_Service_URL__c, requestBody);
        if(apiResponse.getStatusCode() == 201 || Test.isRunningTest()) {
            
            Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
            Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
            Map<String, Object> responseBodyToFilters=  (Map<String, Object>)responseBodyResults.get('ToFilters');
            System.debug('Check point 332: '+ responseBodyToFilters);
            List<Object> responseBodyFilterResult =  (List<Object>)responseBodyToFilters.get('results');
            Integer totalRecords = 0;
            for(object obj : responseBodyFilterResult) {
                Map<String, Object> filterObj = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(obj));
                //System.debug('Check 153: ' + Integer.valueOf(String.valueOf(filterObj.get('ValueLow')).deleteWhitespace()));
                if(filterObj.containskey('FieldName') && filterObj.get('FieldName') == '&inlinecount' ) totalRecords = Integer.valueOf(String.valueOf(filterObj.get('ValueLow')).deleteWhitespace());
            }
            System.debug('Check 156: ' + totalRecords);
            if(totalRecords != 0) {
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_To_Be_Synced__c.IsUpdateable()){
                    //Tesing purpose only
                    totalRecords = 500;
                    configRec.GYNCF_To_Be_Synced__c = totalRecords;
                    
                }
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Synced__c.IsUpdateable()){
                    configRec.GYNCF_Synced__c = 0;
                }
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Synced__c.IsUpdateable()){
                    configRec.GYNCF_Synced__c = 0;
                }
                UPDATE configRec;
                
                List<String> batchSizeList  = new List<String>();
                for(Integer index = 0; index < Math.ceil((Decimal)totalRecords/configRec.GYNCF_Batch_Size__c); index++) {
                    batchSizeList.add(String.valueOf(index));
                }   
                
                GYNC_TableReplicationBatch tableSyncBatch = new GYNC_TableReplicationBatch();
                tableSyncBatch.batchIterator = batchSizeList;
                tableSyncBatch.top = Integer.valueOf(configRec.GYNCF_Batch_Size__c);
                tableSyncBatch.configRec = configRec;
                tableSyncBatch.systemId = systemId;
                if(!Test.isRunningTest()) tableSyncBatch.executeThisBatch();
                
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Mass_Sync_Live__c.IsUpdateable()){
                    configRec.GYNCF_Mass_Sync_Live__c = true;
                }
                UPDATE configRec;
                
            }
            else {
                statusMsg = 'Warning There is no record in Source.';
            }
        }
        else {
            statusMsg = 'Authorization Error. Please contact your system admin.';
        }
        return statusMsg;
        
    }
    
    @AuraEnabled
    public static void storeFilterData(String configRecId, String availableFilter) {
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c(Id = configRecId );
        configRec.GYNCF_Available_Fileters__c = availableFilter;
        UPDATE configRec;
    }
    
    
    
    
    
    
    
    
    public static MetadataService.CustomField customFieldMetadataCreate(String fieldName, String fieldType) {
        MetadataService.CustomField customField = new MetadataService.CustomField();
        
        customField.fullName = fieldName.replace(' ','_') + '__c';
        if(fieldName.split('\\.').size() < 2) {
            customField.label = fieldName;
        }
        else {
            customField.label = fieldName.split('\\.')[1];
        }
        customField.securityClassification = 'Public';
        Boolean typeMapped = false;
        if(fieldType == 'Edm.Boolean'){
            customField.defaultvalue = 'false';
            customField.type_x = 'Checkbox';
            fieldTypeSFDC = 'BOOLEAN';
            typeMapped = true;
        }
        if(fieldType == 'Edm.String'){
            customField.length = 255;
            customField.type_x = 'Text';
            fieldTypeSFDC = 'STRING';
            typeMapped = true;
        }
        if(fieldType == 'Edm.Single' || fieldType ==  'Edm.Float'){
            customField.type_x = 'Number';
            customField.externalId = false;
            customField.precision = 18;
            customField.required = false;
            customField.scale = 7;
            customField.unique = false;
            fieldTypeSFDC = 'DOUBLE';
            typeMapped = true;
        }
        if(fieldType == 'Edm.Decimal' ){
            customField.type_x = 'Number';
            customField.externalId = false;
            customField.precision = 18;
            customField.required = false;
            customField.scale = 2;
            customField.unique = false;
            fieldTypeSFDC = 'DOUBLE';
            typeMapped = true;
        }
        
        if(fieldType == 'Edm.DateTime'){
            customField.type_x = 'DateTime';
            fieldTypeSFDC = 'DATETIME';
            typeMapped = true;
        }
        if(typeMapped) return customField;
        return null;
        
        
        
    }
    
}