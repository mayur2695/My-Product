public class GYNC_CreationEndpoint {
    public class applyFilter{
        public string configApiName;
        public string sapApiName;
        public string type;
        
    }
    
    public static string EndPoint(GYNCO_Configuration__c config,integer top,integer skip,boolean inlinepage){
        
        //GYNCO_Configuration__c config = new GYNCO_Configuration__c();
        //config = [Select id, GYNCF_Service_URL__c,GYNCF_Billing_Start_Date__c,GYNCF_Billing_End_Date__c,GYNCF_Date_Range_From__c,GYNCF_Date_Range_To__c,GYNCF_Account_Group__c, GYNCF_Available_Fileters__c from GYNCO_Configuration__c where id = 'a09g000000BaE9xAAF'];
        System.debug('Check: ' + config);
        String endPoint = config.GYNCF_Service_URL__c;
        
        List<applyFilter> filterFormat = (List<applyFilter>)JSON.deserialize(config.GYNCF_Available_Fileters__c, List<applyFilter>.class);
        system.debug('=====13'+filterFormat);
        endPoint += '?';
        Boolean filterAdded = false;
        Boolean Delta = false;
        if(filterFormat.size() > 0) {
            endPoint += '$filter=';
        }
        for(applyFilter filter : filterFormat) {
            //system.debug('===24'+config.get('GYNCF_Last_Synced__c'));
            if(config.get(filter.configApiName) != '' && config.get(filter.configApiName) != null && config.get(filter.configApiName)!= false) {
                //system.debug('check24'+string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9));
               system.debug('check26'+config.get(filter.configApiName));
                system.debug('check26'+filter.configApiName);
                if(filterAdded) {
                    endPoint +=EncodingUtil.urlEncode(' and ','UTF-8');
                }
                
                if(filter.configApiName == 'GYNCF_Date_Range_From__c'){
                   string valueofSfdcFromDate = string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' ge '+'datetime\''+ valueofSfdcFromDate+'T01:01:01'+'\'', 'UTF-8')+')';
                    //endPoint +='('+filter.sapApiName +'+'+'ge'+'+'+'datetime\''+valueofSfdc +'T01:01:01'+ '\''+')';
                    filterAdded = true;
                    system.debug('check30'+endPoint);
                }
                else if(filter.configApiName == 'GYNCF_Date_Range_To__c'){
                    string valueofSfdcToDate = string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' le '+'datetime\''+ valueofSfdcToDate+'T01:01:01'+'\'', 'UTF-8')+')';
                    //endPoint +='('+filter.sapApiName +'+'+'le'+'+'+'datetime\''+valueofSfdc +'T01:01:01'+ '\''+')';
                    filterAdded = true;
                }
                else if(filter.type == 'Boolean'){
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' eq '+ config.get(filter.configApiName) , 'UTF-8')+')';
                    filterAdded = true;
                    
                }
                else if(filter.configApiName == 'GYNCF_Billing_Start_Date__c'){
                    string BillingStartDate = string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' ge '+'datetime\''+ BillingStartDate+'T01:01:01'+'\'', 'UTF-8')+')';
                    filterAdded = true;
                    system.debug('check51'+endPoint);
                }
                else if(filter.configApiName == 'GYNCF_Billing_End_Date__c'){
                    string BillingEndDate = string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' le '+'datetime\''+ BillingEndDate+'T01:01:01'+'\'', 'UTF-8')+')';
                    filterAdded = true;
                    system.debug('check58'+endPoint);
                }
                else if(filter.configApiName == 'Sync_Only_DELTA__c'){
                    if(config.get(filter.configApiName) == true  ){
                    system.debug('Delta+++'+config.get(filter.configApiName));
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' eq '+ config.get(filter.configApiName) + '', 'UTF-8')+')';
                    filterAdded = true;
                    Delta = true;
                    }
                }
                else if(filter.configApiName == 'GYNCF_Last_Synced__c'){
                    if(Delta == true){
                    string LastSyncDate = string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    system.debug('LastSyncDate+++'+LastSyncDate);
                    endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' eq '+'datetime\''+ LastSyncDate+'T01:01:01'+'\'', 'UTF-8')+')';
                    filterAdded = true;
                    system.debug('endPoint+++70'+endPoint);
                    }else{
                        if(endPoint.contains('and')){
                        endPoint = endPoint.substring(0,endpoint.length()-5);
                        }
                    }
                }
                
                else{
                    list<string>check = new list<string>();
                    check.add(string.valueOf(config.get(filter.configApiName)).split(',')[0]);
                    for(integer i=0;i<string.valueOf(config.get(filter.configApiName)).split(',').size();i++){
                        endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' eq \''+ string.valueOf(config.get(filter.configApiName)).split(',')[i] + '\'', 'UTF-8')+')';
                        endPoint +=EncodingUtil.urlEncode(' or ','UTF-8');
                    }
                    endPoint = endPoint.substring(0,endpoint.length()-4);
                    //system.debug('CheckFilterSize===='+string.valueOf(config.get(filter.configApiName)).split(',').size());
                    //endPoint +='('+filter.sapApiName +EncodingUtil.urlEncode(' eq \''+ config.get(filter.configApiName) + '\'', 'UTF-8')+')';
                    filterAdded = true;
                    system.debug('endPoint===88'+endPoint);
                }
                
            }
        }
        if(filterAdded) {
            endPoint += '&';
        }
        else {
            endPoint = endPoint.substring(0,endpoint.length()-8);
        }
        //endPoint += '$format=json&$top=2&$inlinecount=allpages';
        if(inlinepage == false){
            system.debug('check false');
            endPoint += '$format=json&$top=' + top + '&$skip=' + skip ;
        }
        else{
            endPoint += '$format=json&$top=2&$inlinecount=allpages';
            
        }
        system.debug('check45'+ endPoint);
        return endPoint;
    }
    
}