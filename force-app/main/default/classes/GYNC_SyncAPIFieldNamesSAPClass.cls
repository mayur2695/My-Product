public with sharing class GYNC_SyncAPIFieldNamesSAPClass {
    @AuraEnabled
    Public static void getAPIFieldsfromSAP(String ObjectName, String systemId){
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        Map<String, String> apiHeader = new Map<String, String>();
        GYNCO_Configuration__c configInst = new GYNCO_Configuration__c();
        if(GYNCO_Configuration__c.sObjectType.getDescribe().isAccessible() || GYNCO_Configuration__c.sObjectType.getDescribe().isAccessible()){
            configInst = [Select id,Name,GYNCF_Service_URL__c,GYANF_SAP_Object_API__c,GYNCF_SAP_API_Fields__c,GYNCF_Nodes_for_SAP_API__c,(Select id,Label__c from Configuration__r) from GYNCO_Configuration__c where Name =: ObjectName and GYNCF_System_Id__c = :systemId WITH SECURITY_ENFORCED limit 1]; 
        }       
        String EndPoint = configInst.GYNCF_Service_URL__c.substringBefore(configInst.GYANF_SAP_Object_API__c)+configInst.GYANF_SAP_Object_API__c+'/$metadata';
        GYNC_API_Dispatcher.systemId = systemId;
        
        HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',EndPoint,apiHeader,'');
        String parsingXmlFile = apiResponse.getbody();
        List<String> nodeList = new List<String>();
        if(configInst.GYNCF_Nodes_for_SAP_API__c != null && configInst.GYNCF_Nodes_for_SAP_API__c != ''){
            nodeList = configInst.GYNCF_Nodes_for_SAP_API__c.split(',');    
        }
        Set<String> nodeNames =new  Set<string>(nodeList);
        List<String> customFieldList = new List<String>();
        
        List<String> listofProperties = XMLUtility.processXML(parsingXmlFile,nodeNames);
        if(configInst.Configuration__r.size() > 0){
            for(GYNCO_Custom_Field__c custInst : configInst.Configuration__r){
                customFieldList.add(custInst.Label__c); 
            } 
        }
        String customField = String.join(customFieldList,',');
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_SAP_API_Fields__c.isUpdateable()){
         configInst.GYNCF_SAP_API_Fields__c = string.join(listofProperties,',');
          configInst.GYNCF_SAP_API_Fields__c = configInst.GYNCF_SAP_API_Fields__c +',CustomField,'+ customField;
        }
        update configInst;
    } 
}