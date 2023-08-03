/*
 * @author: Nitish
 * @createdDate: 19th Jun 2020
 * @description: This method will create mack resonse for http callouts  
 * 
 * @modifiedBy:
 * @modifiedDate:
 */
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    public MockHttpResponseGenerator() {
        mockResponseBody = '{"TestKey":"TestValue"}';
        mockResponseHeader = new Map<String, String>();
        mockResponseHeader.put('Content-Type', 'application/json');
        mockResponseStatusCode = 200; 
    }
    public String mockResponseBody;
    public Map<String, String> mockResponseHeader;
    public Integer mockResponseStatusCode;
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        for(String key : mockResponseHeader.keySet()) {
           res.setHeader(key, mockResponseHeader.get(key) );
        }
        
        res.setBody(mockResponseBody);
        res.setStatusCode(mockResponseStatusCode);
        return res;
    }
}