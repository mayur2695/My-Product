/* Class Name: GYNC_SyncRecord
* This is syncing the SFDC record with SAP. Called from GYNL_SyncRecord lightnig component
* Created by: Nitish
*/

public with sharing class GYNC_SyncRecord {
    //public static String systemId;
    /*public GYNC_SyncRecord() {
        
    }*/
    
    @AuraEnabled
    public static statusMessage syncRecord(Id recordId){
        statusMessage statusObj = new statusMessage();
        statusObj.objectName = checkObject(recordId);
        system.debug('objectName'+statusObj.objectName);
        string query = 'select GYNCF_Source__c from '+statusObj.objectName+ ' where Id=:recordId';
        system.debug('query: '+query);
        sobject queryRes = Database.query(string.escapeSingleQuotes(query));
        GYNCO_Configuration__c configRec = new GYNCO_Configuration__c();
        try {
            configRec = [SELECT Id, Name,GYNCF_System_Id__c, GYNCF_SFDC_Object_Name__c,GYNCF_PricebookEntry_Field_API_Name__c,GYNCF_LineItemBodyTitle__c,GYNCF_DyanamicChildItemQuery__c,GYNCF_LineItem_Identifier_SAP__c,GYNCF_LineItemApi_Name__c, GYNCF_Create__c, GYNCF_Service_URL__c, GYNCF_Field_Maping__c, GYNCF_SAP_API_Fields__c
                         FROM  GYNCO_Configuration__c
                         WHERE GYNCF_SFDC_Object_Name__c = :statusObj.objectName AND GYNCF_System_Id__c =:string.valueof(queryRes.get('GYNCF_Source__c'))  WITH SECURITY_ENFORCED];
        }
        catch(QueryException ex) {
            statusObj.status = 'Warning';
            System.debug('inside   catch');
            //custom label to be used for status msg
            statusObj.statusMessage = System.Label.GYNCL_ErrorstatusMessage1 + statusObj.objectName + System.Label.GYNCL_ErrorstatusMessage2;
            system.debug('ex.getMessage()'+ex.getMessage());
            return statusObj;
            
        }
        GYNC_API_Dispatcher.systemId =  configRec.GYNCF_System_Id__c; //new added
        
        //System.debug(configRec.GYNCF_Field_Maping__c + 'configRec.GYNCF_Field_Maping__c');
        String endPoint = configRec.GYNCF_Service_URL__c;
        String reqqbody = getRequestbody(recordId,configRec.GYNCF_Field_Maping__c,statusObj.objectName,endPoint,configRec.GYNCF_LineItemApi_Name__c,configRec.GYNCF_DyanamicChildItemQuery__c,configRec.GYNCF_LineItem_Identifier_SAP__c,configRec.GYNCF_LineItemBodyTitle__c,configRec.GYNCF_PricebookEntry_Field_API_Name__c);
        if(configRec.GYNCF_Create__c) {
            //TO get the token for each call
            System.debug('endPoint'+endPoint);
            //String endPointForToken = endPoint.substringBeforeLast('/') + '/$metadata';
            //System.debug('endPointForToken'+endPointForToken);
            Map<String, String> apiHeaderMap = new Map<String, String>();
            apiHeaderMap.put('X-CSRF-Token', 'fetch' );
            
            
            HTTPResponse apiResponse = GYNC_API_Dispatcher.makeCallOut('GET',endPoint,apiHeaderMap, '');
            if(apiResponse.getStatusCode() != 200) {
                System.debug('Error'+apiResponse.getStatusCode());
                statusObj.status = 'Error';
                statusObj.statusMessage = System.Label.GYNCL_ErrorstatusMessage3 + statusObj.objectName +System.Label.GYNCL_ErrorstatusMessage2;
            }
            else{
                //On success of the above API we will send the request to create the data in SAP.
                System.debug('endPoinFor Post'+endPoint);
                statusObj.status = 'Success';
                String endPointForPost = endPoint.substringBeforeLast('/');
                System.debug('endPoinFor Post'+endPointForPost);
                System.debug('res'+apiResponse.getHeader('x-csrf-token'));
                apiHeaderMap.put('X-CSRF-Token', apiResponse.getHeader('x-csrf-token'));
                
                apiHeaderMap.put('Content-type', 'application/atom+xml;type=entry; charset=utf-8');
                
                apiHeaderMap.put('Cookie', apiResponse.getHeader('Set-Cookie'));
                
                /***********************For Testing only******************************/
                
                /*  GYNCS_Authorization_Setting__c authorizationSetting = GYNCS_Authorization_Setting__c.getOrgDefaults();

Blob headerValue = Blob.valueOf(authorizationSetting.GYNCF_User_Name__c + ':' + authorizationSetting.GYNCF_Password__c);
String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
HttpRequest apiRequest1 = new HttpRequest();
apiRequest1.setMethod('POST');
apiRequest1.setEndpoint(endPoint);
apiRequest1.setHeader('Authorization',authorizationHeader);
apiRequest1.setHeader('X-CSRF-Token', apiResponse.getHeader('x-csrf-token'));
apiRequest1.setHeader('Content-type','application/atom+xml;type=entry; charset=utf-8');
//apiRequest.setBody(requestBody);


System.debug('Check request: ' + apiRequest1);

Http http = new Http();
HTTPResponse apiResponse1 = http.send(apiRequest1);
if(apiResponse1.getStatusCode() != 200) {
System.debug('inside error' + apiResponse1.getStatusCode());
}
else{
System.debug('inside success11111');

}


*/
                
                /********************************************************************/
                
                
                
                
                
                HTTPResponse apiRequest = GYNC_API_Dispatcher.makeCallOut('POST',endPoint,apiHeaderMap, reqqbody);
                //apiRequest.getBody();
                //System.debug('body'+apiRequest.getBody());
                if(apiRequest.getStatusCode() == 201) {
                    statusObj.statusMessage = statusObj.objectName+' ' + System.Label.GYNCL_CreateSuccesMessage;
                    //System.debug('Status Code ' + apiRequest.getStatusCode());
                    statusObj.status = 'Success';
                }
                else{
                    //System.debug('inside success11111');
                    //for Error message
                    statusObj.status = 'Error';
                    statusObj.statusMessage = statusObj.objectName+' ' + System.Label.GYNCL_CreateErrorMessage;
                    //System.debug('Status Code ' + apiRequest.getStatusCode());
                }
                
                
            }
        }
        else {
            statusObj.status = 'Error';
            //custom label to be used for status msg
            statusObj.statusMessage = System.Label.GYNCL_ErrorstatusMessage1 + statusObj.objectName + System.Label.GYNCL_ErrorstatusMessage2;
            
        }
        
        return statusObj;
    }
    
    Private static string checkObject(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }
    //To get the body of the request to save
    @TestVisible Private static String getRequestbody(Id recordId, String Mappingfields , String ObjName,string endpoint,string LineItemName,string LineItemId,string LineItemIdentify,string BodyTitle,string PricebookApi) {
        map<string,string>MaterialMap = new map<string,string>();
        list<PricebookEntry>MaterialList = new list<PricebookEntry>([select id,Name,ProductCode from PricebookEntry WITH SECURITY_ENFORCED]);
        for(PricebookEntry mt : MaterialList){
            MaterialMap.put(mt.id,mt.ProductCode);
        }
        map<string,string>storeMatMap = new map<string,string>();
        list<Product2>storeMatList = new list<Product2>([select id,ProductCode from Product2 WITH SECURITY_ENFORCED]);
        for(Product2 pr : storeMatList){
            storeMatMap.put(pr.id,pr.ProductCode);
        }
        map<string,string>accmap = new map<string,string>();
        list<Account>acclist = new list<Account>([select id,GYNCF_SAP_Number__c,Name,BillingCountry,BillingCity,BillingPostalCode,BillingState,BillingStreet,Phone from Account WITH SECURITY_ENFORCED]);
        for(Account acc : acclist){
            accmap.put(acc.id,acc.GYNCF_SAP_Number__c);
        }
        map<string,string>Ordermap = new map<string,string>();
        list<Order>OrderNumlist = new list<Order>([select id,OrderNumber from Order WITH SECURITY_ENFORCED]);
        for(Order ord: OrderNumlist){
            Ordermap.put(ord.id,ord.OrderNumber);
        }

        //body of the request
        String body = '';
        //system.debug('OBJNAME'+ObjName);
        ///////////////////////////////////////Body Start///////////////////////////////////////
        if(ObjName == 'GYNCO_Quote__c'){
            body +='<?xml version="1.0" encoding="utf-8"?>\n';
            body +='<entry xmlns="http://www.w3.org/2005/Atom" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xml:base="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/">\n';
            
            string QuoteLineitemQuery = 'Select ';
            String QuoteqryString = 'Select ';
           //List<GYNC_ResponseDeserializeClass.mappingObject> mappingObjectList = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(Mappingfields, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
            
            //Remove Duplicate Field
            List<GYNC_ResponseDeserializeClass.mappingObject> storeMappingField = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(Mappingfields, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
            list<GYNC_ResponseDeserializeClass.mappingObject>mappingObjectList = new list<GYNC_ResponseDeserializeClass.mappingObject>();
            set<string>storeSAPfield = new set<string>();
            //System.debug('Check mapping 53: '+ mappingObjectList);
            for(Integer i = 0; i<storeMappingField.size(); i++){
                if(!storeSAPfield.contains(storeMappingField[i].sapField)){
                    storeSAPfield.add(storeMappingField[i].sapField);
                    mappingObjectList.add(storeMappingField[i]);
                }
            }//Remove Duplicate Field End
            
            // System.debug('Check mapping 53: '+ mappingObjectList);  
            for(Integer i = 0; i<mappingObjectList.size(); i++){
                
                //System.debug('field134'+mappingObjectList[i].SFDCField );
                Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                // system.debug('field138'+(sfdcFieldMap));
                if(!string.valueof(sfdcFieldMap.get('fieldValue')).contains('.')){  
                    QuoteqryString += sfdcFieldMap.get('fieldValue')+',';
                }else{
                    QuoteLineitemQuery += string.valueOf(sfdcFieldMap.get('fieldValue')).substringAfter('.')+ ',';
                }
                
            }
            //system.debug('LineItemName+==='+LineItemName);
            Integer countLineItemRecResult;
            ////////////////////////////////////////////// line item For Quotes /////////////////////////////////
            if(LineItemName != null){
                string countLineItemRec = 'select count() from ' + LineItemName + ' where '+ LineItemId + ' =' +'\''+ recordId +'\'';
                countLineItemRecResult = Database.countQuery(string.escapeSingleQuotes(countLineItemRec));
                
                //system.debug('countLineItemRec' +countLineItemRecResult);
            }
            if(countLineItemRecResult > 0){
                QuoteLineitemQuery += ' Id from ' + LineItemName + ' where '+ LineItemId+ ' =' +'\''+ recordId +'\'';
                System.debug('fieldcehck239' + QuoteLineitemQuery);
                list<sObject>LineitemResult = Database.query(string.escapeSingleQuotes(QuoteLineitemQuery));
                 System.debug('LineitemResult' + LineitemResult);
                
                for(sObject LineItem :LineitemResult){
                    //system.debug('+++LineItem++'+ string.valueOf(LineItem.get('GYNCF_SalesDocumentItem__c')).split('-')[1]);
                    string SalesDoc = string.valueOf(LineItem.get('GYNCF_SalesDocumentItem__c')).split('-')[0];
                    string salesDocItem = string.valueOf(LineItem.get('GYNCF_SalesDocumentItem__c')).split('-')[1];
                    body +='<link href="SALESDOCUMENTSet(\''+SalesDoc+'\')" rel="self" title="SALESDOCUMENT"/>\n';
                    body +='<link href="SALESDOCUMENTSet(\''+SalesDoc+'\')/ToItems" rel="http://schemas.microsoft.com/ado/2007/08/dataservices/related/ToItems" type="application/atom+xml;type=feed" title="ToItems">\n';
                    body +='<m:inline>\n';
                    body +='<feed xml:base="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/">\n';
                    body +='<id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/SALESDOCUMENTSet(\''+SalesDoc+'\')/ToItems</id>\n';
                    body +='<title type="text">SALESDOCUMENTITEMSet</title>\n';
                    body +='<updated>2020-04-30T19:20:56Z</updated>\n';
                    body +='<author>\n';
                    body +='<name/>\n';
                    body +='</author>\n';
                    body +='<link href="SALESDOCUMENTSet(\''+SalesDoc+'\')/ToItems" rel="self" title="SALESDOCUMENTITEMSet"/>\n';
                    body +='<entry>\n';
                    body +='<id>http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_SALESDOCUMENTS_SRV/SALESDOCUMENTITEMSet(SalesDocument=\''+SalesDoc+'\',SalesDocumentItem=\''+salesDocItem+'\')</id>\n';
                    body +='<title type="text">SALESDOCUMENTITEMSet(SalesDocument=\''+SalesDoc+'\',SalesDocumentItem=\''+salesDocItem+'\')</title>\n';
                    body +='<updated>2020-04-30T19:20:56Z</updated>\n';
                    body +='<category term="GCONNECT.SF_SALESDOCUMENTS_SRV.SALESDOCUMENTITEM" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/>\n';
                    body +='<link href="SALESDOCUMENTITEMSet(SalesDocument=\''+SalesDoc+'\',SalesDocumentItem=\''+salesDocItem+'\')" rel="self" title="SALESDOCUMENTITEM"/>\n';
                    body +='<link href="SALESDOCUMENTITEMSet(SalesDocument=\''+SalesDoc+'\',SalesDocumentItem=\''+salesDocItem+'\')/FromHeader" rel="http://schemas.microsoft.com/ado/2007/08/dataservices/related/FromHeader" type="application/atom+xml;type=entry" title="FromHeader"/>\n';
                    body +='<content type="application/xml">\n';
                    body +='<m:properties>\n';
                    for(Integer i = 0; i<mappingObjectList.size(); i++){      
                        Map<String, Object> LineItemFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                        
                        if(string.valueof(LineItemFieldMap.get('fieldValue')).contains('.')){
                            //system.debug('LineItemFieldValue'+string.valueof(LineItemFieldMap.get('fieldValue')));
                            if(string.valueof(LineItemFieldMap.get('fieldValue')) != LineItemName +'.'+PricebookApi){
                                if(string.valueof(mappingObjectList[i].sapField) != LineItemIdentify){
                                    if(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')) != null){
                                        body += '<d:' +mappingObjectList[i].sapField  +'>' + LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n'; 
                                    }else{
                                        body += '<d:' +mappingObjectList[i].sapField  +'>' + '' +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n'; 
                                    }
                                }else{
                                    body += '<d:' +mappingObjectList[i].sapField  +'>' + string.valueOf(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.'))).substringAfter('-') +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                            }else{
                                string storeMatId = String.valueof(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')));
                                // system.debug('storeMatId'+storeMatId);
                                //list<PricebookEntry>MaterialName = [select Name,ProductCode from PricebookEntry where id =:storeMatId WITH SECURITY_ENFORCED];
                                //system.debug('MaterialName'+MaterialName);
                                if(MaterialMap.keyset().contains(storeMatId)){
                                body += '<d:' +mappingObjectList[i].sapField  +'>' + MaterialMap.get(storeMatId) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                             }
                            
                        }   
                    }
                    body+='</m:properties>\n';
                    body+='</content>\n';
                    body+='</entry>\n';
                    body+='</feed>\n';
                    body+='</m:inline>\n';
                    body+='</link>\n';
                }    
            } 
            
            
            /////////////////////////////////////////LineItem END/////////////////////////////////////////////
            
            body+='<content type="application/xml">\n';
            body+='<m:properties>\n';
            
            QuoteqryString += ' Id from ' + ObjName + ' where Id =' +'\''+ recordId +'\'';
            //System.debug('fieldcehck164' + QuoteqryString);
            sObject results = Database.query(string.escapeSingleQuotes(QuoteqryString));
            //System.debug('results' + results);
            string storeAccId;
            list<Account>StoreSoldTo = new list<Account>();
            for(Integer i = 0; i<mappingObjectList.size(); i++){
                Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                if(!string.valueof(sfdcFieldMap.get('fieldValue')).contains('.')){
                   // system.debug('AccountField================'+sfdcFieldMap.get('fieldValue'));
                    if(string.valueof(sfdcFieldMap.get('fieldValue')) != 'Account__c'){
                        if(string.valueof(mappingObjectList[i].sapField) != 'MaterialNumber'){
                            if(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) != null){
                                if(!string.valueOf(results.get(string.valueof(sfdcFieldMap.get('fieldValue')))).contains('00:00:00')){
                                    
                                    body += '<d:' + mappingObjectList[i].sapField  +'>' + results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }else{
                                    body += '<d:' + mappingObjectList[i].sapField  +'>' + string.valueOf(results.get(string.valueof(sfdcFieldMap.get('fieldValue')))).replace(' ','T') +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                                
                            }else{
                                //system.debug('GiveTHatValue176'+'<d:' + mappingObjectList[i].sapField  +'>' + results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n');
                                body += '<d:' + mappingObjectList[i].sapField  +'>' + '' +'</d:' +mappingObjectList[i].sapField  +'>'+'\n';
                            }
                        }else{
                            string storeMatNum = String.valueof(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))));
                            
                            //list<Product2>storeMatName = [select ProductCode from Product2 where id=: storeMatNum WITH SECURITY_ENFORCED];
                            if(storeMatMap.keyset().contains(storeMatNum)){
                            body += '<d:' + mappingObjectList[i].sapField  +'>' + storeMatMap.get(storeMatNum) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                            }
                            }
                    }
                    else{
                        storeAccId = String.valueof(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))));
                        //StoreSoldTo = [select id,GYNCF_SAP_Number__c,Name,BillingCountry,BillingCity,BillingPostalCode,BillingState,BillingStreet,Phone from Account where id=:storeAccId WITH SECURITY_ENFORCED];
                        //system.debug('SapNo================'+StoreSoldTo);
                        if(accmap.keyset().contains(storeAccId)){
                        body += '<d:' + mappingObjectList[i].sapField  +'>' + accmap.get(storeAccId) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                        }
                        }
                }
            }    
            body+='</m:properties>\n';
            body+='</content>\n';
            body+='</entry>\n';
            //system.debug('OBJNAME'+body);   
        }/*********************************************For Invoice,SalesOrder,Equipment*******************************/
        else{
            
            body +='<?xml version="1.0" encoding="UTF-8"?>\n';
            body +='<atom:entry xmlns:atom="http://www.w3.org/2005/Atom"\n xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"\n xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"\n';
            body +='xml:base='+'"'+endpoint+'"'+'>\n';
            body +='<atom:content type="application/xml">\n';
            body +='<m:properties>\n';
            string LineitemQuery = 'Select ';
            String qryString = 'Select ';
            List<GYNC_ResponseDeserializeClass.mappingObject> storeMappingField = (List<GYNC_ResponseDeserializeClass.mappingObject>)JSON.deserialize(Mappingfields, List<GYNC_ResponseDeserializeClass.mappingObject>.class);
            list<GYNC_ResponseDeserializeClass.mappingObject>mappingObjectList = new list<GYNC_ResponseDeserializeClass.mappingObject>();
            set<string>storeSAPfield = new set<string>();
            //System.debug('Check mapping 53: '+ mappingObjectList);
            for(Integer i = 0; i<storeMappingField.size(); i++){
                if(!storeSAPfield.contains(storeMappingField[i].sapField)){
                    storeSAPfield.add(storeMappingField[i].sapField);
                    mappingObjectList.add(storeMappingField[i]);
                }
            }
            
            for(Integer i = 0; i<mappingObjectList.size(); i++){
                
               // sto.add(mappingObjectList[i]);
                //system.debug('++++sto'+sto);
                Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                 system.debug('field138'+(sfdcFieldMap));
                if(!string.valueof(sfdcFieldMap.get('fieldValue')).contains('.')){
                    //system.debug('+++287'+string.valueof(sfdcFieldMap.get('fieldValue')));
                    qryString += sfdcFieldMap.get('fieldValue')+',';
                   
                }
                
                else{
                    //string.ValueOf(config.get(filter.configApiName)).substring(0,string.ValueOf(config.get(filter.configApiName)).length()-9);
                    //system.debug('++++++154'+(string.valueOf(sfdcFieldMap.get('fieldValue'))).substringAfter('.'));
                    LineitemQuery += string.valueOf(sfdcFieldMap.get('fieldValue')).substringAfter('.')+ ',';
                    //system.debug('+++287'+string.valueof(sfdcFieldMap.get('fieldValue')));
                }
                
            }
            //system.debug('+++sto'+storeSAPfield);
            //system.debug('field161'+ qryString.substring(0,qryString.length()-1));
            qryString =qryString.substring(0,qryString.length()-1);
            qryString += ' from ' + ObjName + ' where Id =' +'\''+ recordId +'\'';
            //System.debug('fieldcehck164' + qryString);
            sObject results = Database.query(string.escapeSingleQuotes(qryString));
            //System.debug('results' + results);
            string storeAccId;
            list<Account>StoreSoldTo = new list<Account>();
            
            for(Integer i = 0; i<mappingObjectList.size(); i++){
               // if(SAP.contains(mappingObjectList[i].sapField)){
                Map<String, Object> sfdcFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                if(!string.valueof(sfdcFieldMap.get('fieldValue')).contains('.')){
                    //system.debug('AccountID'+mappingObjectList[i].sapField);
                    if(string.valueof(sfdcFieldMap.get('fieldValue')) != 'AccountId'){
                        if(string.valueof(sfdcFieldMap.get('fieldValue')) != 'Id'){
                        if(string.valueof(mappingObjectList[i].sapField) != 'MaterialNumber'){
                            if(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) != null){
                                if(!string.valueOf(results.get(string.valueof(sfdcFieldMap.get('fieldValue')))).contains('00:00:00')){
                                    
                                    body += '<d:' + mappingObjectList[i].sapField  +'>' + results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }else{
                                    body += '<d:' + mappingObjectList[i].sapField  +'>' + string.valueOf(results.get(string.valueof(sfdcFieldMap.get('fieldValue')))).replace(' ','T') +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                                
                            }else{
                                //system.debug('GiveTHatValue176'+'<d:' + mappingObjectList[i].sapField  +'>' + results.get(string.valueof(sfdcFieldMap.get('fieldValue'))) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n');
                                body += '<d:' + mappingObjectList[i].sapField  +'>' + '' +'</d:' +mappingObjectList[i].sapField  +'>'+'\n';
                            }
                        }else{
                            string storeMatNum = String.valueof(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))));
                            //list<Product2>storeMatName = [select ProductCode from Product2 where id=: storeMatNum WITH SECURITY_ENFORCED];
                            //system.debug('materialnumber++'+storeMatName);
                            if(storeMatMap.keyset().contains(storeMatNum)){
                            body += '<d:' + mappingObjectList[i].sapField  +'>' + storeMatMap.get(storeMatNum) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                        }
                        }
                        }else{
                           string storeOrderId = String.valueof(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))));
                          //list<Order>storeOrderNum = [select id,OrderNumber from Order where id=:storeOrderId WITH SECURITY_ENFORCED];
                            if(Ordermap.keyset().contains(storeOrderId)){
                            body += '<d:' + mappingObjectList[i].sapField  +'>' + Ordermap.get(storeOrderId) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                            }
                            }
                    }
                    else{
                        storeAccId = String.valueof(results.get(string.valueof(sfdcFieldMap.get('fieldValue'))));
                        system.debug('storeAccId '+storeAccId);
                        //StoreSoldTo = [select id,GYNCF_SAP_Number__c,Name,BillingCountry,BillingCity,BillingPostalCode,BillingState,BillingStreet,Phone from Account where id=:storeAccId WITH SECURITY_ENFORCED];
                        //system.debug('SapNo================'+StoreSoldTo);
                        if(accmap.keyset().contains(storeAccId)){
                        body += '<d:' + mappingObjectList[i].sapField  +'>' + accmap.get(storeAccId) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                        }
                     }
                }
            //}
            }
        
            body += '</m:properties>\n';
            body += '</atom:content>\n';
            
            Integer countLineItemRecResult;
            // line item 
            if(LineItemName != null){
                string countLineItemRec = 'select count() from ' + LineItemName + ' where '+ LineItemId + ' =' +'\''+ recordId +'\'';
                countLineItemRecResult = Database.countQuery(string.escapeSingleQuotes(countLineItemRec));
                
                //system.debug('countLineItemRec' +countLineItemRecResult);
            }
            if(countLineItemRecResult > 0){
                LineitemQuery += ' Id from ' + LineItemName + ' where '+ LineItemId+ ' =' +'\''+ recordId +'\'';
                //System.debug('fieldcehck239' + LineitemQuery);
                list<sObject>LineitemResult = Database.query(string.escapeSingleQuotes(LineitemQuery));
                // System.debug('fieldcehck270' + LineitemResult);
                
                for(sObject LineItem :LineitemResult){ 
                    body+= '<atom:link rel="http://schemas.microsoft.com/ado/2007/08/dataservices/related/ToItems"\n';
                    body+= 'type="application/atom+xml;type=feed"\n';
                    body+= 'title='+'"'+BodyTitle+'"'+'>\n'; 
                    body+= '<m:inline>\n';
                    body+= '<atom:feed>\n';
                    body+= '<atom:entry>\n';
                    body+= '<atom:content type="application/xml">\n';
                    body+= '<m:properties>\n';
                    for(Integer i = 0; i<mappingObjectList.size(); i++){      
                        Map<String, Object> LineItemFieldMap = (Map<String, Object>) JSON.deserializeUntyped(mappingObjectList[i].SFDCField);
                        
                        if(string.valueof(LineItemFieldMap.get('fieldValue')).contains('.')){
                            //system.debug('LineItemFieldValue'+string.valueof(LineItemFieldMap.get('fieldValue')));
                            if(string.valueof(LineItemFieldMap.get('fieldValue')) != LineItemName +'.'+ PricebookApi){
                                if(string.valueof(mappingObjectList[i].sapField) != LineItemIdentify){
                                    if(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')) != null){
                                        body += '<d:' +mappingObjectList[i].sapField  +'>' + LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n'; 
                                    }else{
                                        body += '<d:' +mappingObjectList[i].sapField  +'>' + '' +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n'; 
                                    }
                                }else{
                                    body += '<d:' +mappingObjectList[i].sapField  +'>' + string.valueOf(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.'))).substringAfter('-') +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                            }else{
                                string storeMatId = String.valueof(LineItem.get(string.valueOf(LineItemFieldMap.get('fieldValue')).substringAfter('.')));
                                // system.debug('storeMatId'+storeMatId);
                                //list<PricebookEntry>MaterialName = [select Name,ProductCode from PricebookEntry where id =:storeMatId WITH SECURITY_ENFORCED];
                                //system.debug('MaterialName'+MaterialName);
                                if(MaterialMap.keyset().contains(storeMatId)){
                                body += '<d:' +mappingObjectList[i].sapField  +'>' + MaterialMap.get(storeMatId) +'</d:' +mappingObjectList[i].sapField  +'>'+ '\n';
                                }
                                }
                            
                        }   
                    }
                    body+= '</m:properties>\n';
                    body+= '</atom:content>\n';
                    body+= '</atom:entry>\n';
                    body+= '</atom:feed>\n';
                    body+= '</m:inline>\n';
                    body+= '</atom:link>\n';
                }
            }
            /****************************line item end****************************************/
            body+= '</atom:entry>\n';
        }
        //System.debug('body' + body);
        return body;
    }
    
    Public class statusMessage {
        @AuraEnabled Public String status;
        @AuraEnabled Public String objectName;
        @AuraEnabled Public String statusMessage;
        
    }
}