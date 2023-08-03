global with sharing class GYNC_ScheduleMassSync implements Schedulable {
    Public String businessObjName;
    Public String systemId;
    public GYNC_ScheduleMassSync(String businessObjName, String systemId) {
        this.businessObjName = businessObjName;
        this.systemId = systemId;
    }    
    
    global void execute(SchedulableContext ctx) {
        List<String> setIterator = new List<String>();
        setIterator.add('element');
        GYNC_ExecuteScheduleBatch exeBatch = new GYNC_ExecuteScheduleBatch();
        exeBatch.batchIterator = setIterator;
        exeBatch.businessObjName = businessObjName;
        exeBatch.systemId = systemId;
        Database.executeBatch(exeBatch);
		//triggerMassSysnc(businessObjName);        
    }
    /*@future(callout=true)
    public static void triggerMassSysnc(String businessObjName) {
        GYNC_massSyncTabClass.startMassSync(businessObjName);
	}*/
}