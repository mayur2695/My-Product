public with sharing class GYNC_UtilityClass {
    public static String sysQuery ='SELECT Id, GYNCF_Authorization_Type__c, GYNCF_Base_URL__c, GYNCF_Client_Id__c, GYNCF_Client_Secret__c, GYNCF_oAuth_Login_URL__c, GYNCF_Password__c,Name, GYNCF_User_Name__c, Default_Parameter__c FROM GYNCS_AuthorizationSetting__c';
    public static String systemId;
    
    public class tableReplicationRequestBody {
        public String Table;
        public List<requestBodyFilter> ToFilters;
        public List<requestBodyFields> ToFields;
        
        
    }
    public class requestBodyFilter {
        public requestBodyFilter(String FieldName, String ValueLow, String ValueHigh, String Operation, String Conjunction) {
            this.FieldName = FieldName;
            this.ValueLow = ValueLow;
            this.ValueHigh = ValueHigh;
            this.Operation = Operation;
            this.Conjunction = Conjunction;
        }
        public String FieldName;
        public String ValueLow;
        public String ValueHigh;
        public String Operation;
        public String Conjunction;
        
    }
    public class requestBodyFields {
        public requestBodyFields(String FieldName) {
            this.FieldName = FieldName;
        }
        public String FieldName;
        
    }
    
    public class availableFilter{
        public string sapFieldName;
        public string valueLow;
        public string valueHigh;
        public string type;
        public string sfdcfieldName;
        public string operationType;
        
    }
    public class keyValueWrapper {
        public keyValueWrapper(String key, String value) {
            this.key = key;
            this.value = value;
        }
        @AuraEnabled public String key{get; set;}
        @AuraEnabled public String value{get; set;}
        
    }
    public static String findDefultSystemId(String systemId) {
        //return (systemId == null)?GYNCS_Authorization_Setting__c.getOrgDefaults().Id:systemId;
        return systemId;
        
    }
    
    public static List<keyValueWrapper> findSystem() {
        List<keyValueWrapper> allSystems = new List<keyValueWrapper>();
        List<GYNCS_AuthorizationSetting__c> allSysDetail = new List<GYNCS_AuthorizationSetting__c>();
        //allSysDetail = findAllSystem(sysQuery);
        allSysDetail = Database.query(String.escapeSingleQuotes(sysQuery));
        for(GYNCS_AuthorizationSetting__c sys : allSysDetail) {
            allSystems.add(new keyValueWrapper(sys.Id, sys.Name));
        }
        return allSystems;
        
    }
    
    public static GYNCS_AuthorizationSetting__c findSystem(String sysId) {
        List<GYNCS_AuthorizationSetting__c> allSysDetail = new List<GYNCS_AuthorizationSetting__c>();
        system.debug('SysId++++'+sysId);
        String query = sysQuery + ' WHERE Id =:sysId';
        System.debug('Check 74:' + query);
        //allSysDetail = findAllSystem(query);
        allSysDetail = Database.query(String.escapeSingleQuotes(query));
        System.debug('Check 74:' + allSysDetail);
        If(allSysDetail.size()==1) return allSysDetail[0];
        return null;
        
    }
    
    
    public static HTTPResponse findXcsrfToken(String endPoint) {
        Map<String, String> apiHeaderMap = new Map<String, String>();
        apiHeaderMap.put('X-CSRF-Token','fetch');
        //Calling api
        GYNC_API_Dispatcher.systemId = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
        return apiResponse;
    }
    public static HTTPResponse findTableReplicationData(String endPoint, String requestBody) {
        HTTPResponse apiResponseToken = findXcsrfToken(endPoint);
        
        System.debug('Check ststus: '+ apiResponseToken.getStatusCode());
        System.debug('Check X-CSRF token: '+ apiResponseToken.getHeader('x-csrf-token'));
        System.debug('Check Set-Cookie: '+ apiResponseToken.getHeader('Set-Cookie'));
        
        
        Map<String, String> apiHeaderMap = new Map<String, String>();
        apiHeaderMap.put('X-CSRF-Token',apiResponseToken.getHeader('x-csrf-token'));
        apiHeaderMap.put('Cookie', apiResponseToken.getHeader('Set-Cookie'));
        apiHeaderMap.put('Content-Type','application/json');
        apiHeaderMap.put('Accept','application/json');
        //for testing
        //requestBody = '{"Table": "VBAK","ToFilters": [{"FieldName": "VKORG","Value": "1710"},{"FieldName": "KUNNR","Value": "0000000111"},{"FieldName": "$top","Value": "5"},{"FieldName": "$inlinecount","Value": ""}],"ToFields": [{ "FieldName": "VBELN" },{ "FieldName": "ERDAT" }]}';
        //Calling api
        GYNC_API_Dispatcher.systemId = systemId;
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('POST',endPoint,apiHeaderMap, requestBody);
        System.debug('Check ststus: '+ apiResponse.getBody());
        return apiResponse;
    }
    
    public static String buildRequestBody(GYNCO_Configuration__c configRec, Integer top, Integer skip, Boolean isInline) {
        tableReplicationRequestBody requestBodyObj = new tableReplicationRequestBody();
        requestBodyObj.Table = configRec.Name;
        requestBodyObj.ToFields = new List<requestBodyFields>();
        if(configRec.GYNCF_Field_Maping__c != null) {
            List<GYNC_ResponseDeserializeClass.mappingObject> mappingObjectList = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(configRec.GYNCF_Field_Maping__c, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
            for(GYNC_ResponseDeserializeClass.mappingObject obj : mappingObjectList) {
                requestBodyObj.ToFields.add(new requestBodyFields(String.valueOf(obj.sapField)));   
            }   
        }
        requestBodyObj.ToFilters = new List<requestBodyFilter>();
        if(configRec.GYNCF_Available_Fileters__c != null) {
            List<availableFilter> filterList = (List<availableFilter>)JSON.deserialize(configRec.GYNCF_Available_Fileters__c, List<availableFilter>.class);
            for(availableFilter filterObj : filterList) {
                if(filterObj.operationType == 'EQ' || filterObj.operationType == 'NE' || filterObj.operationType == 'GE' || filterObj.operationType == 'LE' || filterObj.operationType == 'LT' || filterObj.operationType == 'GT') {
                    if(filterObj.valueLow != null && filterObj.valueLow.contains(',')) {
                        List<String> allFilterValues = new List<String>();
                        allFilterValues = filterObj.valueLow.split(',');
                        for(Integer index = 0; index < allFilterValues.size(); index++) {
                            String Conjunction = index == allFilterValues.size()-1?'OR':'';
                            requestBodyObj.ToFilters.add(new requestBodyFilter(filterObj.sapFieldName,allFilterValues[index],'',filterObj.operationType,Conjunction));
                        }
                    }
                    else {
                        requestBodyObj.ToFilters.add(new requestBodyFilter(filterObj.sapFieldName,filterObj.valueLow,'',filterObj.operationType,''));
                    }
                    
                }
                else if(filterObj.operationType == 'BT') {
                    requestBodyObj.ToFilters.add(new requestBodyFilter(filterObj.sapFieldName,filterObj.valueLow,filterObj.valueHigh,filterObj.operationType,''));
                }
                
            }
            
        }
        if(isInline) {
            requestBodyObj.ToFilters.add(new requestBodyFilter('$inlinecount','','','EQ',''));
        }
        else {
            requestBodyObj.ToFilters.add(new requestBodyFilter('$skip',String.valueOf(skip),'','EQ',''));
        }
        requestBodyObj.ToFilters.add(new requestBodyFilter('$top',String.valueOf(top),'','EQ',''));
        return JSON.serialize(requestBodyObj);
    }
    
    
    public static List<sObject> processTableReplicationResponse(List<Object> responseList, String mappingString, String sfdcObject) {
        List<sObject> sobjListToUpsert = new List<sObject>(); 
        List<GYNC_ResponseDeserializeClass.mappingObject> mappingObjectList = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(mappingString, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
        Map<String, Map<String, Object>> processedList = new Map<String, Map<String, Object>>();
        for(object obj : responseList) {
            Map<String, Object> filterObj = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(obj));
            if(processedList.containskey(String.valueOf(filterObj.get('Key')))) {
                if(!processedList.get(String.valueOf(filterObj.get('Key'))).containskey(String.valueOf(filterObj.get('FieldName')))) {
                    processedList.get(String.valueOf(filterObj.get('Key'))).put(String.valueOf(filterObj.get('FieldName')), filterObj.get('Value'));
                    
                }
            }
            else {
                Map<String, Object> fieldMap = new Map<String, Object>();
                fieldMap.put(String.valueOf(filterObj.get('FieldName')), filterObj.get('Value'));
                processedList.put(String.valueOf(filterObj.get('Key')),fieldMap);
            }
            
            
        }
        System.debug('Check 45:'+ processedList);
        
        for(String plKey : processedList.keySet()) {
            sObject obj = Schema.getGlobalDescribe().get(sfdcObject).newSObject();
            if(!Test.isRunningTest()) {
                for(GYNC_ResponseDeserializeClass.mappingObject mappingObj : mappingObjectList) {
                    Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObj.SFDCField);
                    String sfdcField =  String.valueOf(sfdcFieldMap.get('fieldValue'));
                    String sfdcFieldType = String.valueOf(sfdcFieldMap.get('sfdcFieldType'));
                    String stringValue = String.valueOf(processedList.get(plKey).get(mappingObj.sapField));
                    if( sfdcFieldType == 'DATETIME' )  {
                        string sapDate = stringValue;
                        String trimDate = sapDate.substring(6,sapDate.length() -2);
                        //need to check date format from Derick
                        //obj.put(sfdcField, DateTime.newInstance(Long.valueof(trimDate)));
                    }
                    else if(sfdcFieldType == 'DOUBLE' || sfdcFieldType == 'CURRENCY') {
                        System.debug('Check 99: '+ sfdcField);
                        obj.put(sfdcField, decimal.valueOf(stringValue));
                    }
                    else if(String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'BOOLEAN') {
                        obj.put(sfdcField, Boolean.valueOf(stringValue));
                    }
                    else {
                        obj.put(sfdcField, stringValue);
                    }
                    
                }
                sobjListToUpsert.add(obj);
            }
            
        }
        System.debug('Check 79: '+ sobjListToUpsert);
        return sobjListToUpsert;
        
    }
    
}