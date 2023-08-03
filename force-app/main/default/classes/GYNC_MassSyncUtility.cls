/* Class Name: GYNC_MassSyncUtility
* This is a utility class to handle all the mass sync functionality
* Created by: Nitish
*/
public with sharing class GYNC_MassSyncUtility {
    
    //This flag wii differentiate buiness object sync from table replication
    public static boolean tableReplicationFlag;
    public GYNC_MassSyncUtility() {
        tableReplicationFlag = false;
    }
    
    
    
    //Prepare the mass sync request and make the callout by calling GYNC_API_Dispatcher.
    //First it will make a callout to SAP to get the total record count ($inlinecount=allpages)
    //Then it will update the config record with GYNCF_To_Be_Synced__c.
    //Then execute the batch
    public static String callMassSync(List<GYNCO_Configuration__c> listconfig, String systemId) {
    GYNCO_Configuration__c configRec= new GYNCO_Configuration__c();
        for(GYNCO_Configuration__c configVar:listconfig)
        {
            configRec=configVar;
            break;
        } 
        System.debug('Check 20: '+ configRec);
        list<GYNCO_Configuration__c> bulkifyUpdate = new list<GYNCO_Configuration__c>();
        String endPoint = '';
        if(!Test.isRunningTest()) endPoint = GYNC_CreationEndpoint.EndPoint(configRec,0,0,true); //new added
        System.debug('Check 20: '+ endPoint);
        try{
            Map<String, String> apiHeaderMap = new Map<String, String>();
            //Calling api
            System.debug('Check 20: calling API');
            GYNC_API_Dispatcher.systemId = systemId;
            HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
            System.debug('Check 20: '+ apiResponse.getStatusCode());
            if(apiResponse.getStatusCode() == 200) {
                System.debug('Check: '+ apiResponse.getBody());
                Map<String, Object> responseBodyD =   (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
                Map<String, Object> responseBodyResults =  (Map<String, Object>)responseBodyD.get('d');
                Integer totalRecords = Integer.valueOf(responseBodyResults.get('__count'));
                
                //for testing only
                //totalRecords = totalRecords > 5000? 5000: totalRecords;
                //totalRecords = 100;
                
                //Activating progressbar 
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_To_Be_Synced__c.IsUpdateable()){
                    configRec.GYNCF_To_Be_Synced__c = totalRecords;
                }
                if(Schema.sObjectType.GYNCO_Configuration__c.fields.GYNCF_Synced__c.IsUpdateable()){
                    configRec.GYNCF_Synced__c = 0;
                }
                bulkifyUpdate.add(configRec);
                UPDATE bulkifyUpdate;
                //UPDATE configRec;
                
                
                //for scheduled mass sync, this will be reffered from the batch
                //Skipping as we can execute another batch from execute method of a batch(Batch is executed from the finish mehod)
                if(!System.isBatch()){
                    List<String> batchSizeList  = new List<String>();
                    
                    //batchSizeList has totalrecords/ GYNCF_Batch_Size__c no of elemets
                    for(Integer index = 0; index < Math.ceil((Decimal)totalRecords/configRec.GYNCF_Batch_Size__c); index++) {
                        batchSizeList.add(String.valueOf(index));
                    }    
                    GYNC_MassSyncBatch massSyncBatch = new GYNC_MassSyncBatch();
                    massSyncBatch.batchIterator = batchSizeList;
                    massSyncBatch.top = Integer.valueOf(configRec.GYNCF_Batch_Size__c);
                    massSyncBatch.configRec = configRec;
                    massSyncBatch.systemId = systemId;
                    if(!Test.isRunningTest()) massSyncBatch.executeThisBatch();
                }				
                
                
                
            }
            else {
                return 'Authorization Error';
            }
            
        }
        catch(Exception ex) {
            return ex.getMessage();
            
        }
        return 'Success';
        
    }
}