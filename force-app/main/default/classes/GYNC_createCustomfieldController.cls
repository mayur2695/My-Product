public  with sharing class GYNC_createCustomfieldController {
    @AuraEnabled 
    public static Void CreateCustomField(String Label,String Name,String Type,String objectName,Boolean AddToSalesforce,Boolean AddToItemObj,String PicklistValue,String systemId){
        //systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        // metadata API to create the field
        //system.debug('inside apex');
        system.debug('objectName'+objectName +'Label'+Label + 'Name '+Name  + ' AddToSalesforce'+AddToSalesforce +'PicklistValues++++++++'+PicklistValue  + '+++++++++++===');
        String [] expenseAccessFields = new String [] {'Name',
                                                        'Label__c',
                                                        'Property__c',
                                                        'SAP_Object_Name__c',
                                                        'SFDC_Object_Name__c',
                                                        'Item__c',
                                                        'Configuration__c',
                                                        'Picklist_Values__c',
                                                        'Add_Field_To_Salesforce__c',
                                                        'GYNF_System_ID__c'
                                                        };
         Map<String,Schema.SObjectField> m = Schema.SObjectType.GYNCO_Custom_Field__c.fields.getMap();
        
         for (String fieldToCheck : expenseAccessFields) {
            System.debug('Check 22: ' + fieldToCheck);
            // Check if the user has access to view field
            if (!Test.isRunningTest() && !m.get(fieldToCheck).getDescribe().isCreateable() ) {
                
                // Pass error to client
                throw new System.NoAccessException();
            }
        }
        //List<Object> PicklistValues = (List<Object>)System.JSON.deserialize(PicklistValue, List<Object>.class);
        List<Object> PicklistValues = (List<Object>)JSON.deserializeUntyped(PicklistValue);
        System.debug(PicklistValues+'PicklistValues');

        
        GYNCO_Configuration__c config =[select id,name,GYNCF_SFDC_Child_Object_Name__c,GYNCF_LineItemApi_Name__c,GYNCF_SFDC_Object_Name__c from GYNCO_Configuration__c where name=:objectName and GYNCF_System_Id__c = :systemId WITH SECURITY_ENFORCED limit 1];
        system.debug(config.GYNCF_LineItemApi_Name__c + '  ' + config.GYNCF_SFDC_Object_Name__c);
        if(AddToSalesforce){
            if(AddToItemObj){
                if(config.GYNCF_LineItemApi_Name__c != null){
                    system.debug('inside child');
                    createcustomfield(Label,Name,Type,config.GYNCF_LineItemApi_Name__c,PicklistValues);
                }else{
                    system.debug('There is no Item object for this Object');
                }
            }
            else{
                system.debug('inside parent');
                createcustomfield(Label,Name,Type,config.GYNCF_SFDC_Object_Name__c,PicklistValues);
            }
            //create record in custom field
            GYNCO_Custom_Field__c custmdata = new GYNCO_Custom_Field__c();
            custmdata.Name =Name;
            custmdata.Label__c=Label;
            custmdata.Property__c=Type;
            custmdata.SAP_Object_Name__c = objectName;
            custmdata.SFDC_Object_Name__c=config.GYNCF_SFDC_Object_Name__c;
            custmdata.Item__c = AddToItemObj;
            custmdata.Configuration__c = config.Id;
            custmdata.Picklist_Values__c = JSON.serialize(PicklistValues);
            custmdata.Add_Field_To_Salesforce__c = AddToSalesforce;
            custmdata.GYNF_System_ID__c = systemId;
            if(Schema.sObjectType.GYNCO_Custom_Field__c.isCreateable()){
                insert custmdata;
            }
        }
        else{
            
            //objectName='GYNCO_Custom_Field__c';
            GYNCO_Custom_Field__c custmdata = new GYNCO_Custom_Field__c();
            custmdata.Name = Name;
            custmdata.Label__c = Label;
            custmdata.Property__c = Type;
            custmdata.SAP_Object_Name__c = objectName;
            custmdata.SFDC_Object_Name__c = config.GYNCF_SFDC_Object_Name__c;
            custmdata.Item__c = AddToItemObj;
            custmdata.Configuration__c = config.Id;
            custmdata.Picklist_Values__c =JSON.serialize(PicklistValues);//PicklistValues.toString();   //JSON.deserializeUntyped(JSON.serialize(PicklistValues)).toString();//JSON.stringify(PicklistValues);
            custmdata.Add_Field_To_Salesforce__c = AddToSalesforce;
            custmdata.GYNF_System_ID__c = systemId;
            if(Schema.sObjectType.GYNCO_Custom_Field__c.isCreateable()){
            insert custmdata; 
             }
        }
    }
    
    //To create Custom fields
    //@future(callout=true)
    public static void createcustomfield(String Label,String Name,String Type,String ObjName,List<Object> Pickvalue){
        String SessionId = LexSessionController.fetchUserSessionId();
        system.debug('SessionId'+SessionId);
        system.debug('Pickvalue'+Pickvalue);
        List<Object> objectList = new List<Object>();
        //System.debug(UserInfo.getSessionId()+ 'session '  + EncodingUtil.base64Encode(Blob.valueOf(userinfo.getSessionId())));
        //String SessionId = EncodingUtil.base64Encode(Blob.valueOf(sessionId));
        MetadataService.MetadataPort metadataservice = new MetadataService.MetadataPort();
        metadataservice .SessionHeader = new MetadataService.SessionHeader_element();
        metadataservice .SessionHeader.sessionId = SessionId;
        MetadataService.CustomField customField = new MetadataService.CustomField();
        List<MetadataService.Metadata> fields = new List <MetadataService.Metadata>();
        customField.fullName = ObjName+'.'+Name;
        customField.label = Label;
        if(Type == 'Checkbox'){
            customField.defaultvalue = 'false';
            customField.type_x = Type;
        }
        if(Type == 'Text'){
            customField.length = 255;
            customField.type_x = Type;
        }
        if(Type == 'Number'){
            customField.type_x = Type;
            customField.externalId = false;
            customField.precision = 18;
            customField.required = false;
            customField.scale = 2;
            customField.unique = false;
        }
        if(Type == 'Date'){
            customField.type_x = Type;
        }
        if(Type == 'Currency'){
            customField.type_x = Type;
            customField.externalId = false;
            customField.precision = 18;
            customField.required = false;
            customField.scale = 2;
            customField.unique = false;
        }
        if(Type == 'Picklist'){
            customField.type_x = Type;
            //Create the valueSet for picklist type
            List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(JSON.serialize(Pickvalue));
            
            MetadataService.ValueSet picklistValueSet = new MetadataService.ValueSet();
            
            //For each ValueSet, we have either ValueSetValuesDefinition or ValueSettings and some other attributes
            MetadataService.ValueSetValuesDefinition valueDefinition = new MetadataService.ValueSetValuesDefinition();
            
            List<MetadataService.CustomValue> values = new List<MetadataService.CustomValue>();
            for(Object obj : fieldList){
                Map<String,Object> data = (Map<String,Object>)obj;
                if(String.valueOf(data.get('value'))!='' && String.valueOf(data.get('key'))!=''){
                    
                    system.debug('obj'+data.get('key'));
                    system.debug('val'+data.get('value'));
                    MetadataService.CustomValue customValue = new MetadataService.CustomValue();
                    customValue.fullName = String.valueOf(data.get('key'));
                    customValue.isActive = true;
                    customValue.label = String.valueOf(data.get('value'));
                    values.add(customValue);
                }
            }
            
            //It will be list of CustomValue
            valueDefinition.value = values;
            valueDefinition.sorted = false;
            
            //set the valueSetDefinition
            picklistValueSet.valueSetDefinition = valueDefinition;
            
            //Set the valueSet for picklist type
            customField.valueSet = picklistValueSet;
        }
        
        fields.add(customField);
        metadataservice.createMetadata(fields);
    }   
    
    @AuraEnabled
    public static String getfieldData(String ObjName,String SysId){
        List<GYNCO_Custom_Field__c> custmlist= new List<GYNCO_Custom_Field__c>();
        custmlist = [select id,Name,SFDC_Object_Name__c,Add_Field_To_Salesforce__c,SAP_Object_Name__c,Label__c,Item__c,Property__c,Picklist_Values__c from GYNCO_Custom_Field__c where SAP_Object_Name__c=:ObjName and GYNF_System_ID__c=:SysId WITH SECURITY_ENFORCED];
        return JSON.serialize(custmlist);
    }
    
    @AuraEnabled
    public static void addtoSfdc(String RecId){
        
        GYNCO_Custom_Field__c custmlist= new GYNCO_Custom_Field__c();
        custmlist = [select id,Name,SFDC_Object_Name__c,Add_Field_To_Salesforce__c,SAP_Object_Name__c,Label__c,Item__c,Property__c,Configuration__r.GYNCF_LineItemApi_Name__c,Picklist_Values__c from GYNCO_Custom_Field__c where id=:RecId WITH SECURITY_ENFORCED];
        String pickval1 = custmlist.Picklist_Values__c;
        System.debug(pickval1+'pickval1');
        List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(String.valueOf(custmlist.Picklist_Values__c));
        System.debug(fieldList+'fieldList');
        String objName;
        if(custmlist.Item__c){
            objName=custmlist.Configuration__r.GYNCF_LineItemApi_Name__c;
        }
        else{
            objName= custmlist.SFDC_Object_Name__c;
        }
        createcustomfield(custmlist.Label__c,custmlist.Name,custmlist.Property__c,objName,fieldList);
        if (!Test.isRunningTest() && !Schema.sObjectType.GYNCO_Custom_Field__c.fields.Add_Field_To_Salesforce__c.isUpdateable()){
            throw new System.NoAccessException();
        }
        //custmlist.Add_Field_To_Salesforce__c=true;        
        //update custmlist;
        updaterecord(custmlist.Id);
    }
    
    @future
    public static void updaterecord(String Id) {
        GYNCO_Custom_Field__c custmlist = [select id,Name,SFDC_Object_Name__c,Add_Field_To_Salesforce__c,SAP_Object_Name__c,Label__c,Item__c,Property__c,Configuration__r.GYNCF_LineItemApi_Name__c,Picklist_Values__c from GYNCO_Custom_Field__c where id=:Id];
        System.debug(custmlist+'cusfield');
        custmlist.Add_Field_To_Salesforce__c=true;        
        update custmlist;
    }
    
    @AuraEnabled
    public static String fetchSAPPicklist(String businessObject,String fieldName,String indicator,String SysId ){
        ///sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHPICKLIST?BusinessObject='SALESORDER'&PickListField='VKORG'&PickListIndicator=' '
        GYNCS_AuthorizationSetting__c getdata = [select ID,GYNCF_Base_URL__c from GYNCS_AuthorizationSetting__c where Id=:SysId WITH SECURITY_ENFORCED];
        
        String url=getdata.GYNCF_Base_URL__c+'/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHPICKLIST?BusinessObject=\''+businessObject+'\'&PickListField=\''+fieldName+'\'&PickListIndicator=\''+indicator+'\'';
        //System.debug(url);
        HTTPResponse resResult = callout(url,SysId);
        String xml = resResult.getBody();
        System.debug('xml'+xml);
        if(resResult.getStatusCode()!=200){
            throw new AuraHandledException('No Data available');  
        }
        String jsonContent = GYNC_XML_Parser.xmlToJson(xml);
        return jsonContent;
    }
    @AuraEnabled
    public static String fetchSAPallFields(String businessObject,String indicator,String SysId ){
        ///sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHEXTENSIONFIELDS?BusinessObject='SALESORDER'&ExtensionIndicator='I'
        //System.debug('SysId'+SysId);
        GYNCS_AuthorizationSetting__c getdata = [select ID,GYNCF_Base_URL__c from GYNCS_AuthorizationSetting__c where Id=:SysId WITH SECURITY_ENFORCED];
        
        String url=getdata.GYNCF_Base_URL__c+'/sap/opu/odata/GCONNECT/SF_PICK_LIST_SRV/FETCHEXTENSIONFIELDS?BusinessObject=\''+businessObject+'\'&ExtensionIndicator=\''+indicator+'\'';
        //System.debug(url);
        HTTPResponse resResult = callout(url,SysId);
        String xml = resResult.getBody();
        System.debug('xml'+xml);
        if(resResult.getStatusCode()!=200){
            throw new AuraHandledException('Not able fetch feilds from SAP');  
        }
        String jsonContent = GYNC_XML_Parser.xmlToJson(xml);
        return jsonContent;
    }
    
    public static HTTPResponse callout(String url,String SysId){
        GYNC_API_Dispatcher.systemId = SysId;
        Map<String, String> apiHeaderMap = new Map<String, String>();
        HTTPResponse resResult = GYNC_API_Dispatcher.makeCallOut('GET',url,apiHeaderMap,'');
        return resResult;   
    }
    
    @AuraEnabled
    public static String checkduplicatevalue(String ObjName,String SystemId){
        List<GYNCO_Custom_Field__c> custmlist= new List<GYNCO_Custom_Field__c>();
        custmlist = [select id,Name,Label__c from GYNCO_Custom_Field__c where SAP_Object_Name__c=:ObjName and GYNF_System_ID__c=:SystemId];
        return JSON.serialize(custmlist);
    }
}