@isTest
global class MockWebServiceResponseGenerator implements WebServiceMock {
    public object responseElementObject;
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {    
		//object test;
        response.put('response_x',responseElementObject); 
   }
}