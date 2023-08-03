global with sharing class GYNC_mappingScreenClass implements Comparable {
    public pickListWrapper pickWrapInst;
    global Integer compareTo(Object objToCompare) {
        pickListWrapper compareItem = (pickListWrapper)objToCompare;
        if (pickWrapInst.label == compareItem.label) return 0;
        if (pickWrapInst.label  > compareItem.label) return 1;
        return -1; 
    }
    @auraEnabled 
    Public static List<String> fetchObjectNames(String systemId)
    {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        
        List<GYNCO_Configuration__c> configList = new List<GYNCO_Configuration__c>([select Name from GYNCO_Configuration__c where name!= '' and GYNCF_Operation_Type__c = 'Business Object Sync' and GYNCF_System_Id__c = :systemId]);
        List<String> SAPObjectNames = new List<String>();
        for (GYNCO_Configuration__c configVar : configList){
            SAPObjectNames.add(configVar.name);   
        }   
        SAPObjectNames.sort();
        return SAPObjectNames;
    }       
    @auraEnabled 
    Public static String fetchDependantPickListValues(String selectedOption, String systemId)
    {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        GYNCO_Configuration__c configInst = new GYNCO_Configuration__c();
        if(systemId != '' && selectedOption != ''){
            if(GYNCO_Configuration__c.sObjectType.getDescribe().isAccessible()){
        configInst =[select Name,GYNCF_SAP_API_Fields__c,GYNCF_SFDC_Object_Name__c,GYNCF_Field_Maping__c,GYNCF_LineItemApi_Name__c from GYNCO_Configuration__c where name =:selectedOption and GYNCF_System_Id__c = :systemId];
        }
        }
        system.debug('configInst:33 '+configInst);
        List<pickListWrapper> pickListWrapSFDCList = new List<pickListWrapper>();
        List<pickListWrapper> SFDCLineItemList = new List<pickListWrapper>();
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType sobjType;
        if(configInst.GYNCF_SFDC_Object_Name__c != '' || configInst.GYNCF_SFDC_Object_Name__c != null){
            if(System.Label.GYNCL_Namespace != 'c'){
        sobjType = gd.get(System.Label.GYNCL_Namespace+'__'+configInst.GYNCF_SFDC_Object_Name__c); 
            }else{
                sobjType = gd.get(configInst.GYNCF_SFDC_Object_Name__c);
            }
        }
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
        if(!Test.isRunningTest()) fieldMap = sobjType.getDescribe().fields.getMap();
        system.debug('fieldMap:43 '+fieldMap);
        String relatedTo = '';
        for(String fieldName: fieldMap.keySet()){
            relatedTo = '';
            Schema.SObjectField field = fieldMap.get(fieldName);
            Schema.DisplayType FldType = field.getDescribe().getType();
            DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
            for(Schema.SObjectType reference : fieldResult.getReferenceTo()) {  
                relatedTo =  String.valueof(reference.getDescribe().getName());
            }
            pickListWrapSFDCList.add(new pickListWrapper(String.valueof(fieldMap.get(fieldName).getDescribe().getname()),String.valueof(fieldMap.get(fieldName).getDescribe().getLabel()),false,String.valueof(FldType),relatedTo,true));  
        }
        //pickListWrapSFDCList.sort();
        system.debug('pickListWrapSFDCList'+pickListWrapSFDCList);
        // Adding line item condition
         Schema.SObjectType LineItemsobjType;
        if(configInst.GYNCF_LineItemApi_Name__c != null && configInst.GYNCF_LineItemApi_Name__c != ''){
            Map<String,Schema.SObjectType> StoreLineItem = Schema.getGlobalDescribe();
            if(System.Label.GYNCL_Namespace != 'c'){
             LineItemsobjType = StoreLineItem.get(System.Label.GYNCL_Namespace+'__'+configInst.GYNCF_LineItemApi_Name__c);
            }else{
             LineItemsobjType = StoreLineItem.get(configInst.GYNCF_LineItemApi_Name__c);
            }
            Map<String, Schema.SObjectField> LineItemfieldMap = new Map<String, Schema.SObjectField>();
            if(!Test.isRunningTest()) LineItemfieldMap = LineItemsobjType.getDescribe().fields.getMap();
            String LimeItemRelatedTo = '';
            for(String LineItemfieldName : LineItemfieldMap.keySet()){
                LimeItemRelatedTo = '';
                Schema.SObjectField LineItemfield = LineItemfieldMap.get(LineItemfieldName);
                Schema.DisplayType LineItemFldType = LineItemfield.getDescribe().getType();
                DescribeFieldResult fieldResult = LineItemfieldMap.get(LineItemfieldName).getDescribe();
                for(Schema.SObjectType reference : fieldResult.getReferenceTo()) {  
                    LimeItemRelatedTo =  String.valueof(reference.getDescribe().getName());
                }
                
               SFDCLineItemList.add(new pickListWrapper(configInst.GYNCF_LineItemApi_Name__c+'.'+String.valueof(LineItemfieldMap.get(LineItemfieldName).getDescribe().getname()),String.valueof(LineItemfieldMap.get(LineItemfieldName).getDescribe().getLabel())+'(Item)',false,String.valueof(LineItemFldType),LimeItemRelatedTo,true));
               
            }
            
        }// LineItem Condition end
        List<String> SapAPIFieldList = configInst.GYNCF_SAP_API_Fields__c.split(',');
        List<pickListWrapper> pickListSAPList = new List<pickListWrapper>();
        Set<String> sapAPIFieldSet = new Set<String>();
        for (String inst: SapAPIFieldList){
            pickListSAPList.add(new pickListWrapper(inst,inst,false,'','',false));
        }
        //pickListSAPList.sort();
        mappingScreenWrapper pickListValueWrap = new mappingScreenWrapper(pickListSAPList,configInst.GYNCF_Field_Maping__c,pickListWrapSFDCList,SFDCLineItemList);
        return JSON.serialize(pickListValueWrap);
    } 
    @auraEnabled 
    Public static void saveMappingList(String mappingListFront, String SelectedOption, String systemId)
    {
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        GYNCO_Configuration__c configInst = new GYNCO_Configuration__c();
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Field_Maping__c.isCreateable() || Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Field_Maping__c.isUpdateable()
            || Schema.sObjectType.GYNCO_Configuration__c.fields.name.isCreateable() || Schema.sObjectType.GYNCO_Configuration__c.fields.name.isUpdateable()){
        configInst = [select name,GYNCF_Field_Maping__c from GYNCO_Configuration__c where name =:SelectedOption and GYNCF_System_Id__c = :systemId];
        configInst.GYNCF_Field_Maping__c = mappingListFront;
        }
        upsert configInst;
        system.debug('configInst'+configInst);
        
        
    }
    public Class mappingScreenWrapper 
    {
        @AuraEnabled public List<pickListWrapper> SAPAPIFields;
        @AuraEnabled public String mappingString;
        @AuraEnabled public List<pickListWrapper> SFDCFields;
        @AuraEnabled public List<pickListWrapper> LineItemList;
        public mappingScreenWrapper(List<pickListWrapper> SAPAPIFields,String mappingString,List<pickListWrapper> SFDCFields,List<pickListWrapper> LineItemList) 
        {
            
            this.SAPAPIFields = SAPAPIFields;
            this.mappingString=mappingString;
            this.SFDCFields = SFDCFields;
            this.LineItemList = LineItemList;
        }
        
    }
    public Class pickListWrapper{
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        @AuraEnabled public Boolean isSelected;
        @AuraEnabled public String sfdcFieldType;
        @AuraEnabled public String relatedTo;
        public pickListWrapper(String value,String label,Boolean isSelected,String sfdcFieldType,String relatedTo,Boolean isSFDC){
            if(isSFDC){
                this.value= JSON.serialize(new pickListValueWrapper(value,sfdcFieldType, relatedTo));  
            }
            else{
                this.value = value;  
            }
            this.label=label;
            this.isSelected = isSelected;
            this.sfdcFieldType = sfdcFieldType;
            this.relatedTo = relatedTo;
        }
    }
    public Class pickListValueWrapper{
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String sfdcFieldType;
        @AuraEnabled public String relatedTo;
        public pickListValueWrapper(String fieldValue,String sfdcFieldType,String relatedTo){
            this.fieldValue=fieldValue;
            this.sfdcFieldType=sfdcFieldType;
            this.relatedTo = relatedTo;
        }
    }
    
}