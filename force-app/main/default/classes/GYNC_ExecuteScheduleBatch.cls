public class GYNC_ExecuteScheduleBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
    public List<String> batchIterator;
    public String businessObjName;
    Public String systemId;
    public String Status;
    public Iterable<String> start(Database.BatchableContext BC) {
        
        return batchIterator;
    }
    public void execute(Database.BatchableContext info, List<String> iterator) {
        	Status = GYNC_massSyncTabClass.startMassSync(businessObjName,systemId);    
    }
    public void finish(Database.BatchableContext info) {
        
        	 if(Status == 'Success') {
            GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
            configRec = GYNC_massSyncTabClass.findConfigRec(businessObjName, systemId);
            List<String> batchSizeList  = new List<String>();
            for(Integer index = 0; index < Math.ceil((Decimal)configRec.GYNCF_To_Be_Synced__c/configRec.GYNCF_Batch_Size__c); index++) {
                batchSizeList.add(String.valueOf(index));
            }
            GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
            massSyncBatch.batchIterator = batchSizeList;
            massSyncBatch.top = Integer.valueOf(configRec.GYNCF_Batch_Size__c);
            massSyncBatch.configRec = configRec;
            massSyncBatch.systemId = systemId;
            if(!Test.isRunningTest()) Database.executeBatch(massSyncBatch, 1);
        }    
        
    }
    
}