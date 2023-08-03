/* Class Name: GYNC_API_Dispatcher
 * This is a helper class for all the API callouts
 * Created by: Nitish
*/

public without sharing class GYNC_API_Dispatcher {
    
    public static String systemId;
    
    
    
    //callSAP() will make the rest call out.
    //Parameters: apiMethod - GET/POST/DELETE
    //endPoint- end point of the API
    //apiHeader - all headers in key value pair
    //requestBody - request body as string
    public static HTTPResponse callSAP(String apiMethod, String endPoint, Map<String, String> apiHeader, String requestBody) {
        HttpRequest apiRequest = new HttpRequest();
        apiRequest.setMethod(apiMethod);
        System.debug('Check EndPoint: ' + endpoint);
        apiRequest.setEndpoint(endpoint);
        
        //Map header map
        for(String key : apiHeader.keySet()) {
           apiRequest.setHeader(key, apiHeader.get(key));
        }
        system.debug('requestBody:'+requestBody);
        //Set request body
        if(requestBody != '') {
            apiRequest.setBody(requestBody);
        } 
        apiRequest.setTimeout(60000);
        Http http = new Http();
        HTTPResponse apiResponse = http.send(apiRequest);
        system.debug('apiResponse:'+apiResponse.getBody());
        return apiResponse;

        
    }


    //Depending upon the type(Basic/oAuth 2.0) create the authorization header
    public static authorizationBody getAuthorization() {
        GYNCS_AuthorizationSetting__c authorizationSetting = new GYNCS_AuthorizationSetting__c();
        
        systemId = GYNC_UtilityClass.findDefultSystemId(systemId);
        system.debug('SystemId+++APiDispatcher'+systemId);
        authorizationSetting = GYNC_UtilityClass.findSystem(systemId);
        authorizationBody authBody;
        if(authorizationSetting.GYNCF_Authorization_Type__c == 'Basic') {
            Blob headerValue = Blob.valueOf(authorizationSetting.GYNCF_User_Name__c + ':' + authorizationSetting.GYNCF_Password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            authBody = new authorizationBody(authorizationSetting.GYNCF_Authorization_Type__c, authorizationHeader);
        }
        else if(authorizationSetting.GYNCF_Authorization_Type__c == 'oAuth') {
            Map<String, String> apiHeader = new Map<String, String>();
            apiHeader.put('Content-Type','application/x-www-form-urlencoded');
            Blob headerValue = Blob.valueOf(authorizationSetting.GYNCF_Client_Id__c + ':' + authorizationSetting.GYNCF_Client_Secret__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            apiHeader.put('authorization',authorizationHeader);
            String requestBody = 'grant_type=client_credentials';
            
            HTTPResponse apiResponse = callSAP('POST',authorizationSetting.GYNCF_oAuth_Login_URL__c,apiHeader, requestBody);
            oautResponseClass oauthRes =  new oautResponseClass().parse(apiResponse.getBody());
            String authorizationHeaderBearer = 'Bearer ' + oauthRes.access_token;
            authBody = new authorizationBody(authorizationSetting.GYNCF_Authorization_Type__c, authorizationHeaderBearer);
        }
 		authBody.defaultParam = authorizationSetting.Default_Parameter__c;
        return authBody;

    }
	
    //This method will make callout
    public static HTTPResponse makeCallOut(String apiMethod, String endPoint, Map<String, String> apiHeader, String requestBody) {
        System.debug('Check SystemId: '+systemId);
        GYNC_API_Dispatcher.authorizationBody authorizationObj = getAuthorization();
        apiHeader.put('Authorization', authorizationObj.authorizationHeader);
        if(String.isNotBlank(authorizationObj.defaultParam)) {
            if(endPoint.contains('?')) {
                endPoint += '&' + authorizationObj.defaultParam;
            }
            else {
                endPoint += '?' + authorizationObj.defaultParam;
            }
        }
        if(Test.isRunningTest()){
            Map<String,String> temp = new Map<String,String>();
            temp.put('Test','Test');
            apiHeader = temp;
        }
        System.debug('API Header from GYNC_API_DIspatcher :::'+apiHeader);
        return callSAP(apiMethod, endPoint, apiHeader, requestBody);

        
    }

    //Wrapper class to store the authorizationbody for header
    public class authorizationBody {
        public authorizationBody(String authorizationType, String authorizationHeader) {
            this.authorizationType = authorizationType;
            this.authorizationHeader = authorizationHeader;
        }

        Public String authorizationType;
        Public String authorizationHeader;
        public String defaultParam;
    }

    //Wraper class to store the oAuth Response
    public class oautResponseClass {

        public String access_token;
        public String token_type;
        public String scope;
    
        
        public oautResponseClass parse(String json) {
            
            return (oautResponseClass) System.JSON.deserialize(json, oautResponseClass.class);
        }
    }


}