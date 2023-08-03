public with sharing class GYNC_hierarchyUpdateHandler {
    public static Boolean preventRecurrsion = false;
    public static void updateHierarchyOnInsertUpdate(List<GYNCO_Product_Category__c> triggerNew){
        List<GYNCO_Product_Category__c> categoriesToUpdate = new List<GYNCO_Product_Category__c>();
        for(GYNCO_Product_Category__c prod:[SELECT Id,GYNCF_Parent_Category__r.GYNCF_Hierarchy__c FROM GYNCO_Product_Category__c
                                            WHERE Id IN: triggerNew]){
                                                if(prod.GYNCF_Parent_Category__c==Null){
                                                    if (Schema.sObjectType.GYNCO_Product_Category__c.fields.GYNCF_Hierarchy__c.isUpdateable())
                                                    {
                                                        prod.GYNCF_Hierarchy__c=prod.Id;
                                                    }
                                                    
                                                }
                                                else{
                                                     if (Schema.sObjectType.GYNCO_Product_Category__c.fields.GYNCF_Hierarchy__c.isUpdateable())
                                                    {
                                                    	prod.GYNCF_Hierarchy__c=prod.GYNCF_Parent_Category__r.GYNCF_Hierarchy__c+'-'+prod.Id;
                                                    }
                                                }
                                                 if (Schema.sObjectType.GYNCO_Product_Category__c.fields.GYNCF_Level__c.isUpdateable())
                                                 {
                                                	prod.GYNCF_Level__c = prod.GYNCF_Hierarchy__c.split('-').size();
                                                 }
                                                categoriesToUpdate.add(prod);        
                                            }
        preventRecurrsion = true;
        update categoriesToUpdate;
    }
}