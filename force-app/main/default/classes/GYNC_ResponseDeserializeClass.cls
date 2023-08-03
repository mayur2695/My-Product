/* Class Name: GYNC_ResponseDeserializeClass
 * This Class is used to deserialize the response from SAP
 * Also map the fields
 * Created by: Nitish
*/
public with sharing class GYNC_ResponseDeserializeClass {
    
    //public static Map<String, List<lookupFieldMap>> allLookup;
    public static Map<String, String> parentObjMap;
    public static Map<String, List<String>> parentIdentifierMap;
    //Userd to deserialize mapping field
    public class mappingObject {
        public String sapField;
        public String SFDCField;
        public String SFDCType;
        public String relatedTo;
    }
    public class logItem {
        public string status;
        public string recId;
        public string errorMsg;
    }
    public class lookupFieldMap {
        public string apiName;
        public string sapIdentifyingValue;
        public lookupFieldMap(String apiName, String sapIdentifyingValue) {
            this.apiName = apiName;
            this.sapIdentifyingValue = sapIdentifyingValue;
        }
    }
    
    public class mappingResponseWrapper {
        public List<sObject> sobjListToUpsert;
        public List<GYNC_ResponseDeserializeClass.mappingObject> itemMappingList;
        public Map<String, String> itemLineItemMap;
        public mappingResponseWrapper(List<sObject> sobjListToUpsert, List<GYNC_ResponseDeserializeClass.mappingObject> itemMappingList) {
            this.sobjListToUpsert = sobjListToUpsert;
            this.itemMappingList = itemMappingList;
        }
        public mappingResponseWrapper(List<sObject> sobjListToUpsert, List<GYNC_ResponseDeserializeClass.mappingObject> itemMappingList, Map<String, String> itemLineItemMap) {
            this.sobjListToUpsert = sobjListToUpsert;
            this.itemMappingList = itemMappingList;
            this.itemLineItemMap = itemLineItemMap;
        }
    }
    
    //This method will map the SAP field values with SFDC fields and return a List<sObject>
    //The List<sObject> is used to insert record in the batch class.
    public static mappingResponseWrapper createFieldMapping(String sfdcObject, List<Object> responseBody, String mappingString, String identifierSAP, String identifierSFDC, Boolean lineItemMappinCheck, String parentIdentifierSAP) {
        List<GYNC_ResponseDeserializeClass.mappingObject> itemMappingList = new List<GYNC_ResponseDeserializeClass.mappingObject>();
        List<sObject> sobjListToUpsert = new List<sObject>();       //List<sObject> used to upsert
        List<GYNC_ResponseDeserializeClass.mappingObject> mappingObjectList = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(mappingString, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
        System.debug('Check mapping mappingObjectList: '+ mappingObjectList);
        parentObjMap =new Map<String, String>();
        Integer loopCount = 0;
        parentIdentifierMap = new Map<String, List<String>>();
        Map<String, String> itemLineItemMap = new Map<String, String>();
        system.debug('responseBody=='+responseBody);
        for(object rec : responseBody) {
            
            Map<String, Object> recMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec));
            system.debug('recMap:'+recMap);
            if(lineItemMappinCheck) {
                System.debug('Check parentIdentifierSAP: '+parentIdentifierSAP);
                System.debug('Check lineitem map key: '+recMap.get(parentIdentifierSAP) );
                itemLineItemMap.put(String.valueOf(recMap.get(parentIdentifierSAP)) +'-'+ String.valueOf(recMap.get(identifierSAP)), String.valueOf(recMap.get(parentIdentifierSAP)));
            }
            System.debug('Check sfdcObject:68 '+sfdcObject);
            sObject obj = Schema.getGlobalDescribe().get(sfdcObject).newSObject();
            //allLookup = new Map<String, List<lookupFieldMap>>();
            System.debug('obj:71 '+obj);
            for(GYNC_ResponseDeserializeClass.mappingObject mappingObj : mappingObjectList) {
                Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObj.SFDCField);
                //System.debug('Check mapping: '+sfdcFieldMap);
                String sfdcField = '';
                sfdcField = String.valueOf(sfdcFieldMap.get('fieldValue'));
                if(lineItemMappinCheck && sfdcField.contains('.')) {
                    sfdcField = sfdcField.split('\\.')[1];
                }
                
                if(!sfdcField.contains('.')) {
                    
                    if(String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'DATETIME' )  {
                        //convert string to date time
                        string sapDate = String.valueOf(recMap.get(mappingObj.sapField));
                        String trimDate = sapDate.substring(6,sapDate.length() -2);
                        //system.debug('Check: ' +DateTime.newInstance(Long.valueof(trimDate)));
                        obj.put(sfdcField, DateTime.newInstance(Long.valueof(trimDate)));

                    }
                    else if(String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'DATE') {
                        //convert string to date
                        string sapDate = String.valueOf(recMap.get(mappingObj.sapField));
                        String trimDate = sapDate.substring(6,sapDate.length() -2);
                        //system.debug('Check: ' +DateTime.newInstance(Long.valueof(trimDate)));
                        DateTime dateTimeValue = DateTime.newInstance(Long.valueof(trimDate));
                        obj.put(sfdcField, date.newinstance(dateTimeValue.year(), dateTimeValue.month(), dateTimeValue.day()));
                    }
                    else if(String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'DOUBLE' || String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'CURRENCY') {
                        System.debug('Check 99: '+ sfdcField);
                        obj.put(sfdcField, decimal.valueOf(String.valueOf(recMap.get(mappingObj.sapField))));
                    }
                    else if(String.valueOf(sfdcFieldMap.get('sfdcFieldType'))== 'REFERENCE') {
                        System.debug('Check64: '+ mappingObj.SFDCField+' : '+parentObjMap.containsKey(mappingObj.SFDCField));
                        //allLookup.add(new lookupFieldMap());
                        if(parentObjMap.containsKey(sfdcField)) {
                            List<String> identifierList = parentIdentifierMap.get(sfdcField);
                            identifierList.add(String.valueOf(recMap.get(mappingObj.sapField)));
                            //System.debug('Check68: '+ identifierList);
                            parentIdentifierMap.put(sfdcField, identifierList);
                            
                        }
                        else {
                            parentObjMap.put(sfdcField, String.valueOf(sfdcFieldMap.get('relatedTo')));
                            List<String> identifierList = new List<String>();
                            identifierList.add(String.valueOf(recMap.get(mappingObj.sapField)));
                            System.debug('Check75: '+ identifierList);
                            parentIdentifierMap.put(sfdcField, identifierList);
                            
                        }
                        //System.debug('Check81: '+ parentObjMap);
                        obj.put(sfdcField, recMap.get(mappingObj.sapField));
                    }
                    else if(String.valueOf(sfdcFieldMap.get('sfdcFieldType')) == 'BOOLEAN') {
                        obj.put(sfdcField, Boolean.valueOf(String.valueOf(recMap.get(mappingObj.sapField))));
                    }
                    else {
                        obj.put(sfdcField, recMap.get(mappingObj.sapField));
                    }
                }
                else {
                    //String sfdcFieldValue = String.valueOf(sfdcFieldMap.get('fieldValue'));
                    //sfdcFieldMap.put('fieldValue', sfdcFieldValue.split('\\.')[1]);
                    if(loopCount == 0) {
                        itemMappingList.add(mappingObj);
                    }
                }
                
            }
            //parentIdentifierSAP
            if(lineItemMappinCheck) {
                obj.put(identifierSFDC, String.valueof(recMap.get(parentIdentifierSAP)) +'-'+String.valueof(recMap.get(identifierSAP)));
            }
            else {
                obj.put(identifierSFDC, recMap.get(identifierSAP));
            }
            sobjListToUpsert.add(obj);
            loopCount++;
            
        }
        //System.debug('Check sobjListToUpsert 64: '+ sobjListToUpsert);
        if(lineItemMappinCheck) {
            return new mappingResponseWrapper(sobjListToUpsert, itemMappingList, itemLineItemMap);
        }
        return new mappingResponseWrapper(sobjListToUpsert, itemMappingList);
        
        
    }
    
    
        
    
}