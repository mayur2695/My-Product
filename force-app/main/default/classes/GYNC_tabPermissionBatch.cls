public with sharing class GYNC_tabPermissionBatch implements Database.Batchable<String>, Database.Stateful,Database.AllowsCallouts {
    public String SFDCObjName;
    public List<String> SFDCFieldList;
    public GYNCO_Configuration__c configRec;
    public Iterable<String> start(Database.BatchableContext BC) {
        MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
        metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
        metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
        
        List<MetadataService.ListMetadataQuery> metaList = new List<MetadataService.ListMetadataQuery>(); 
        MetadataService.ListMetadataQuery metaInstance = new MetadataService.ListMetadataQuery();
        metaInstance.type_x = 'Profile';
        metaList.add(metaInstance);
        double apiVersion = 48.0;
        MetadataService.FileProperties[] listMetaResult =  metaDataServiceInstance.listMetadata(metaList, apiVersion);
        List<String> allProfileNames = new List<String>();
        for(MetadataService.FileProperties testInstance : listMetaResult) {
            allProfileNames.add(testInstance.fullName);
        }
        return allProfileNames;
    }
    public void execute(Database.BatchableContext info, List<String> iterator) {
        MetadataService.MetadataPort metaDataServiceInstance = new MetadataService.MetadataPort();
        metaDataServiceInstance.SessionHeader = new MetadataService.SessionHeader_element();
        metaDataServiceInstance.SessionHeader.sessionId = LexSessionController.fetchUserSessionId();
        List<MetadataService.Metadata> profileInstanceList = new List<MetadataService.Metadata>();
        for(String profileName : iterator) {
            
            MetadataService.Profile profileInstance = new MetadataService.Profile();
            
            profileInstance.fullName = profileName;
            List <MetadataService.ProfileTabVisibility> tabVis  =  new List<MetadataService.ProfileTabVisibility>();
            MetadataService.ProfileTabVisibility tabInstance = new MetadataService.ProfileTabVisibility();
            tabInstance.tab = SFDCObjName.replace(' ','_') + '__c';
            tabInstance.visibility = 'DefaultOn';
            tabVis.add(tabInstance);
            profileInstance.tabVisibilities = tabVis;
            
            
            List <MetadataService.ProfileFieldLevelSecurity> fieldLSecurityList  =  new List<MetadataService.ProfileFieldLevelSecurity>();
            for(String fld : SFDCFieldList) {
                MetadataService.ProfileFieldLevelSecurity fieldLSecurity = new MetadataService.ProfileFieldLevelSecurity();
                fieldLSecurity.field = SFDCObjName.replace(' ','_') + '__c.' + fld;
                fieldLSecurity.editable = true;
                fieldLSecurity.editable = true;
                fieldLSecurityList.add(fieldLSecurity);
            }
            profileInstance.fieldPermissions = fieldLSecurityList;
            
            profileInstanceList.add(profileInstance);
        }
        
        List<MetadataService.SaveResult> resultPermisions= new List<MetadataService.SaveResult>();
        if(!Test.isRunningTest())resultPermisions = metaDataServiceInstance.updateMetadata(profileInstanceList);
        //System.debug('Check result: '+ resultPermisions[0]);
    }
    public void finish(Database.BatchableContext info) {
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_isFLSActive__c.isUpdateable()){
        configRec.GYNCF_isFLSActive__c = true;
        }
        UPDATE configRec;
    }
}