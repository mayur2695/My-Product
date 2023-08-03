/*
 * @author: Sushri
 * @createdDate: 22nd Jun 2020
 * @description: This method will create mack resonse for http callouts  
 * 
 * @modifiedBy:
 * @modifiedDate:
 */
@isTest
global class MockHttpResponseGeneratorForXMLResponse implements HttpCalloutMock {
    public MockHttpResponseGeneratorForXMLResponse() {
        mockResponseBody = '<?xml version="1.0" encoding="utf-8"?>'+
'<edmx:Edmx Version="1.0" xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:sap="http://www.sap.com/Protocols/SAPData">'+
    '<edmx:DataServices m:DataServiceVersion="2.0">'+
        '<Schema Namespace="GCONNECT.SF_CUSTOMER_SRV" xml:lang="en" sap:schema-version="1" xmlns="http://schemas.microsoft.com/ado/2008/09/edm">'+
            '<EntityType Name="CUSTOMER" sap:content-version="1">'+
                '<Key>'+
                    '<PropertyRef Name="Customer"/>'+
                    '<PropertyRef Name="PartnerFunction"/>'+
                    '<PropertyRef Name="ReferenceCustomer"/>'+
                '</Key>'+
                '<Property Name="Customer" Type="Edm.String" Nullable="false" MaxLength="10" sap:unicode="false" sap:label="Customer" sap:creatable="false" sap:updatable="false" sap:sortable="false"/>'+
                
            '</EntityType>'+
            '<EntityContainer Name="GCONNECT_SF_CUSTOMER_SRV_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="atom json xlsx">'+
                '<EntitySet Name="CUSTOMERSet" EntityType="GCONNECT.SF_CUSTOMER_SRV.CUSTOMER" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:searchable="true" sap:pageable="false" sap:requires-filter="true" sap:content-version="1"/>'+
            '</EntityContainer>'+
            '<atom:link rel="self" href="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_CUSTOMER_SRV/$metadata" xmlns:atom="http://www.w3.org/2005/Atom"/>'+
            '<atom:link rel="latest-version" href="http://ec2-18-215-72-123.compute-1.amazonaws.com:8080/sap/opu/odata/GCONNECT/SF_CUSTOMER_SRV/$metadata" xmlns:atom="http://www.w3.org/2005/Atom"/>'+
        '</Schema>'+
    '</edmx:DataServices>'+
'</edmx:Edmx>'  ;
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