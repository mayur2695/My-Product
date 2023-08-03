public with sharing class GYNC_getReport 
{
    @AuraEnabled
    public static string getStandardReport(String reportLabel) 
    {
        System.debug('Label Name ::'+reportLabel);
        string reportPlannedId;//isAccessible();
        if(
            Report.SObjectType.getDescribe().isAccessible() &&
Schema.SObjectType.Report.fields.Id.isAccessible() 

) {
        List<Report> repRec=[SELECT Id,Name,DeveloperName from Report where DeveloperName=:reportLabel limit 1];

        System.debug(repRec);
        if(repRec.size()>0){
            reportPlannedId=repRec[0].Id;
        }
        System.debug('ID IS :::'+reportPlannedId);
    }
        return reportPlannedId;
    }
    @AuraEnabled
    public static string getStandardDashboard(String reportLabel) 
    {
        System.debug('Label Name ::'+reportLabel);
        string reportPlannedId;
        if(
            Dashboard.SObjectType.getDescribe().isAccessible() &&
Schema.SObjectType.Dashboard.fields.Id.isAccessible() 

) {
        List<Dashboard> repRec=[SELECT Id,DeveloperName from Dashboard where DeveloperName=:reportLabel limit 1];

        System.debug(repRec);
        if(repRec.size()>0){
            reportPlannedId=repRec[0].Id;
        }
        System.debug('ID IS :::'+reportPlannedId);
    }
        return reportPlannedId;

    }
}