public with sharing class GYNL_SchedularRecordClass {
    @AuraEnabled
    public static void createSchedularRecord(string cronExp,string name){
        list<Schedule__c> schRecordlist= [Select id,Cron_Exp__c from Schedule__c where Cron_Exp__c=:cronExp WITH SECURITY_ENFORCED];
        if(Schema.sObjectType.Schedule__c.isCreateable()){
            if(schRecordlist.size()==0 && cronExp!=null && name!=null){
                Schedule__c sch= new Schedule__c();
                sch.name= name;
                sch.Cron_Exp__c= cronExp;
                insert sch;
                system.debug('The list of values are===>'+sch);
            }
        }
    }
    
    @AuraEnabled
    public static String getSchedulatList(String objName, String sysId){
        GYNCO_Configuration__c configRecord = [SELECT Id,Name FROM GYNCO_Configuration__c where name=:objName AND GYNCF_System_Id__c=:sysId WITH SECURITY_ENFORCED];
        list<Schedule__c> schlist= [select id,name,Cron_Exp__c,GYNCF_Configuration_Record__c,GYNCF_Configuration_Record__r.Scheduler_information__c from Schedule__c WHERE GYNC_Batch_Variant__c=true AND GYNCF_Configuration_Record__c=:configRecord.Id WITH SECURITY_ENFORCED];
        return JSON.serialize(schlist);
    }
    
    @AuraEnabled
    Public static String sendCronToSchedule(string schId,string objnam, string sysId){
        system.debug('The passed value ===>'+schId);
        system.debug('The objnam'+objnam);
        system.debug('The sysId'+sysId);
        //sysId=GYNC_UtilityClass.findDefultSystemId(sysId);
        Schedule__c schlist= [select id,name,Cron_Exp__c from Schedule__c where id=:schId WITH SECURITY_ENFORCED];
        if(Schema.sObjectType.Schedule__c.fields.Cron_Exp__c.isUpdateable()){
            update schlist;
        }
        system.debug('The schlist'+schlist);
        GYNCO_Configuration__c cus= [select id,name from GYNCO_Configuration__c where name=:objnam AND GYNCF_System_Id__c=:sysId WITH SECURITY_ENFORCED];
        system.debug('The cus'+cus);
        if(Schema.sObjectType.GYNCO_Configuration__c.fields.Scheduler_information__c.isUpdateable()){
            cus.Scheduler_information__c=schlist.name;
            update cus;
        }
        GYNC_syncParamterClass.runBatch(objnam,schlist.Cron_Exp__c,sysId);
        return schId;
    }
}