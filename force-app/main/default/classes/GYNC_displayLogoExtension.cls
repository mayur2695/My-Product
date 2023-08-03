public with sharing class GYNC_displayLogoExtension {

    String recId;
    
    public GYNC_displayLogoExtension(ApexPages.StandardController controller) {
        this.recId = controller.getId();    
    }
    
    public String getFileId() {
        String fileId = '';
        GYNCO_Interview__c itv=new GYNCO_Interview__c();
            itv=[select GYNCF_Offer_Letter_Template__c from GYNCO_Interview__c where id=:recId limit 1];
        List<Attachment> attachedFiles = [select Id from Attachment where parentId =:itv.GYNCF_Offer_Letter_Template__c limit 1];
        if( attachedFiles != null && attachedFiles.size() > 0 ) {
            fileId = attachedFiles[0].Id;
        }
        return fileId;    
    }

}