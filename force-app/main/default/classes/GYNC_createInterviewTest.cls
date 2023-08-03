@isTest
public class GYNC_createInterviewTest 
{
	@isTest
	public static void testcreate1()     
	{
        List<GYNCO_Position__c> posList = New List<GYNCO_Position__c>();
        
        GYNCO_Salesforce_Event_Meeting_Link__c obj= new GYNCO_Salesforce_Event_Meeting_Link__c();
		obj.GYNCF_Use_Direct_Meeting_Invite__c=True;
		obj.GYNCF_Use_Salesforce_Event__c=False;
		obj.Name='Test';
		insert obj;
        //-----------------position record where status = round 1-----------------
        
      	GYNCO_Position__c pos= New GYNCO_Position__c();
		pos.GYNCF_Designation__c='Fresher';
		pos.GYNCF_Final_offer_amount__c=45000;
		pos.GYNCF_HR_Owner__c=UserInfo.getUserId();
      	System.debug('HR OwnerId='+UserInfo.getUserId());
		pos.GYNCF_Number_Of_Rounds__c='1';
		pos.GYNCF_Company__c='gyansys';
		pos.GYNCF_Joining_Date__c=system.today();
      	pos.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
		pos.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
      	pos.GYNCF_Status__c='Open';
      	insert pos;
        posList.add(pos);
      	System.debug('Inserted Position record is - '+pos);
      
      
      	GYNCO_Candidate__c can= new GYNCO_Candidate__c();
      	can.GYNCF_Position__c=pos.Id;
      	can.GYNCF_Has_Resume__c=True;
		can.Name='Demo1';
        can.GYNCF_Location__c ='Carmel';
        insert can;
     	System.debug('Inserted Candidate Record is - '+can);
      
		String Body ='This is a dummy attachment.';
        Blob txt = Blob.valueOf(Body);
		Attachment attach = new Attachment();
		attach.ParentId = can.Id;
		attach.Name = 'dummy attachment';
		attach.Body = txt;
		insert attach;
        System.debug('Inserted Resume is - '+attach);
      
    	 GYNCO_Interview_Panel__c IP=New GYNCO_Interview_Panel__c();
       	 IP.GYNCF_Interview_Date__c=System.now();
      	 IP.GYNCF_Interview_round__c='Round 1';
      	 IP.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP.GYNCF_Position__c=pos.ID;
      	 insert IP;
         System.debug('Inserted Interview Panel is - '+IP);
      
      
            GYNCO_Offer_Letter_Template__c Tempt=new GYNCO_Offer_Letter_Template__c();
      		Tempt.Name='Test Class Template';
         	Tempt.GYNCF_Template__c='Hi &Candidate Name&, &Designation& &Location& &Joining Date& &Final Compensation& You are successfully hired';
         	Tempt.GYNCF_Active__c=True;
      		insert Tempt;
      		System.debug('Inserted Template is - '+Tempt);
        
        //-----------------position record where status = round 2-----------------
        
        GYNCO_Position__c pos2= New GYNCO_Position__c();
		pos2.GYNCF_Designation__c='Fresher';
		pos2.GYNCF_Final_offer_amount__c=45000;
		pos2.GYNCF_HR_Owner__c=UserInfo.getUserId();
      	System.debug('HR OwnerId='+UserInfo.getUserId());
		pos2.GYNCF_Number_Of_Rounds__c='2';
		pos2.GYNCF_Company__c='gyansys';
		pos2.GYNCF_Joining_Date__c=system.today();
      	pos2.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
		pos2.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
      	pos2.GYNCF_Status__c='Open';
      	insert pos2;
        posList.add(pos2);
      	System.debug('Inserted Position record is - '+pos2);
      
      
      	GYNCO_Candidate__c can2= new GYNCO_Candidate__c();
      	can2.GYNCF_Position__c=pos2.Id;
      	can2.GYNCF_Has_Resume__c=True;
		can2.Name='Demo1';
        can2.GYNCF_Location__c ='Carmel';
        insert can2;
     	System.debug('Inserted Candidate Record is - '+can2);
      
		Attachment attach2 = new Attachment();
		attach2.ParentId = can2.Id;
		attach2.Name = 'dummy attachment';
		attach2.Body = txt;
		insert attach2;
        System.debug('Inserted Resume is - '+attach2);
      
    	 GYNCO_Interview_Panel__c IP2a=New GYNCO_Interview_Panel__c();
       	 IP2a.GYNCF_Interview_Date__c=System.now();
      	 IP2a.GYNCF_Interview_round__c='Round 1';
      	 IP2a.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP2a.GYNCF_Position__c=pos2.ID;
      	 insert IP2a;
         System.debug('Inserted Interview Panel is - '+IP2a);
        
        GYNCO_Interview_Panel__c IP2b=New GYNCO_Interview_Panel__c();
       	 IP2b.GYNCF_Interview_Date__c=System.now();
      	 IP2b.GYNCF_Interview_round__c='Round 2';
      	 IP2b.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP2b.GYNCF_Position__c=pos2.ID;
      	 insert IP2b;
         System.debug('Inserted Interview Panel is - '+IP2b);
        
        //-----------------position record where status = round 3-----------------
        
        GYNCO_Position__c pos3= New GYNCO_Position__c();
		pos3.GYNCF_Designation__c='Fresher';
		pos3.GYNCF_Final_offer_amount__c=45000;
		pos3.GYNCF_HR_Owner__c=UserInfo.getUserId();
      	System.debug('HR OwnerId='+UserInfo.getUserId());
		pos3.GYNCF_Number_Of_Rounds__c='3';
		pos3.GYNCF_Company__c='gyansys';
		pos3.GYNCF_Joining_Date__c=system.today();
      	pos3.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
		pos3.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
      	pos3.GYNCF_Status__c='Open';
      	insert pos3;
        posList.add(pos3);
      	System.debug('Inserted Position record is - '+pos3);
      
      
      	GYNCO_Candidate__c can3= new GYNCO_Candidate__c();
      	can3.GYNCF_Position__c=pos3.Id;
      	can3.GYNCF_Has_Resume__c=True;
		can3.Name='Demo1';
        can3.GYNCF_Location__c ='Carmel';
        insert can3;
     	System.debug('Inserted Candidate Record is - '+can3);
      
		Attachment attach3 = new Attachment();
		attach3.ParentId = can3.Id;
		attach3.Name = 'dummy attachment';
		attach3.Body = txt;
		insert attach3;
        System.debug('Inserted Resume is - '+attach3);
      
    	 GYNCO_Interview_Panel__c IP3a=New GYNCO_Interview_Panel__c();
       	 IP3a.GYNCF_Interview_Date__c=System.now();
      	 IP3a.GYNCF_Interview_round__c='Round 1';
      	 IP3a.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP3a.GYNCF_Position__c=pos3.ID;
      	 insert IP3a;
         System.debug('Inserted Interview Panel is - '+IP3a);
        
        GYNCO_Interview_Panel__c IP3b=New GYNCO_Interview_Panel__c();
       	 IP3b.GYNCF_Interview_Date__c=System.now();
      	 IP3b.GYNCF_Interview_round__c='Round 2';
      	 IP3b.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP3b.GYNCF_Position__c=pos3.ID;
      	 insert IP3b;
         System.debug('Inserted Interview Panel is - '+IP3b);
        
        GYNCO_Interview_Panel__c IP3c=New GYNCO_Interview_Panel__c();
       	 IP3c.GYNCF_Interview_Date__c=System.now();
      	 IP3c.GYNCF_Interview_round__c='Round 3';
      	 IP3c.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP3c.GYNCF_Position__c=pos3.ID;
      	 insert IP3c;
         System.debug('Inserted Interview Panel is - '+IP3c);
        
        //-----------------position record where status = round 4-----------------
        
        GYNCO_Position__c pos4= New GYNCO_Position__c();
		pos4.GYNCF_Designation__c='Fresher';
		pos4.GYNCF_Final_offer_amount__c=45000;
		pos4.GYNCF_HR_Owner__c=UserInfo.getUserId();
      	System.debug('HR OwnerId='+UserInfo.getUserId());
		pos4.GYNCF_Number_Of_Rounds__c='4';
		pos4.GYNCF_Company__c='gyansys';
		pos4.GYNCF_Joining_Date__c=system.today();
      	pos4.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
		pos4.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
      	pos4.GYNCF_Status__c='Open';
      	insert pos4;
        posList.add(pos4);
      	System.debug('Inserted Position record is - '+pos4);
      
      
      	GYNCO_Candidate__c can4= new GYNCO_Candidate__c();
      	can4.GYNCF_Position__c=pos4.Id;
      	can4.GYNCF_Has_Resume__c=True;
		can4.Name='Demo1';
        can4.GYNCF_Location__c ='Carmel';
        insert can4;
     	System.debug('Inserted Candidate Record is - '+can4);
      
		Attachment attach4 = new Attachment();
		attach4.ParentId = can4.Id;
		attach4.Name = 'dummy attachment';
		attach4.Body = txt;
		insert attach4;
        System.debug('Inserted Resume is - '+attach4);
      
    	 GYNCO_Interview_Panel__c IP4a=New GYNCO_Interview_Panel__c();
       	 IP4a.GYNCF_Interview_Date__c=System.now();
      	 IP4a.GYNCF_Interview_round__c='Round 1';
      	 IP4a.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP4a.GYNCF_Position__c=pos4.ID;
      	 insert IP4a;
         System.debug('Inserted Interview Panel is - '+IP4a);
        
        GYNCO_Interview_Panel__c IP4b=New GYNCO_Interview_Panel__c();
       	 IP4b.GYNCF_Interview_Date__c=System.now();
      	 IP4b.GYNCF_Interview_round__c='Round 2';
      	 IP4b.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP4b.GYNCF_Position__c=pos4.ID;
      	 insert IP4b;
         System.debug('Inserted Interview Panel is - '+IP4b);
        
        GYNCO_Interview_Panel__c IP4c=New GYNCO_Interview_Panel__c();
       	 IP4c.GYNCF_Interview_Date__c=System.now();
      	 IP4c.GYNCF_Interview_round__c='Round 3';
      	 IP4c.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP4c.GYNCF_Position__c=pos4.ID;
      	 insert IP4c;
         System.debug('Inserted Interview Panel is - '+IP4c);
      
        GYNCO_Interview_Panel__c IP4d=New GYNCO_Interview_Panel__c();
       	 IP4d.GYNCF_Interview_Date__c=System.now();
      	 IP4d.GYNCF_Interview_round__c='Round 4';
      	 IP4d.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP4d.GYNCF_Position__c=pos4.ID;
      	 insert IP4d;
         System.debug('Inserted Interview Panel is - '+IP4d);
        
        //-----------------position record where status = round 5-----------------
        
        GYNCO_Position__c pos5= New GYNCO_Position__c();
		pos5.GYNCF_Designation__c='Fresher';
		pos5.GYNCF_Final_offer_amount__c=45000;
		pos5.GYNCF_HR_Owner__c=UserInfo.getUserId();
      	System.debug('HR OwnerId='+UserInfo.getUserId());
		pos5.GYNCF_Number_Of_Rounds__c='5';
		pos5.GYNCF_Company__c='gyansys';
		pos5.GYNCF_Joining_Date__c=system.today();
      	pos5.GYNCF_Recruitment_owner__c=UserInfo.getUserId();
		pos5.GYNCF_Position_Sponsor__c=UserInfo.getUserId();
      	pos5.GYNCF_Status__c='Open';
      	insert pos5;
        posList.add(pos5);
      	System.debug('Inserted Position record is - '+pos5);
      
      
      	GYNCO_Candidate__c can5= new GYNCO_Candidate__c();
      	can5.GYNCF_Position__c=pos5.Id;
      	can5.GYNCF_Has_Resume__c=True;
		can5.Name='Demo1';
        can5.GYNCF_Location__c ='Carmel';
        insert can5;
     	System.debug('Inserted Candidate Record is - '+can5);
      
		Attachment attach5 = new Attachment();
		attach5.ParentId = can5.Id;
		attach5.Name = 'dummy attachment';
		attach5.Body = txt;
		insert attach5;
        System.debug('Inserted Resume is - '+attach5);
      
    	 GYNCO_Interview_Panel__c IP5a=New GYNCO_Interview_Panel__c();
       	 IP5a.GYNCF_Interview_Date__c=System.now();
      	 IP5a.GYNCF_Interview_round__c='Round 1';
      	 IP5a.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP5a.GYNCF_Position__c=pos5.ID;
      	 insert IP5a;
         System.debug('Inserted Interview Panel is - '+IP5a);
        
        GYNCO_Interview_Panel__c IP5b=New GYNCO_Interview_Panel__c();
       	 IP5b.GYNCF_Interview_Date__c=System.now();
      	 IP5b.GYNCF_Interview_round__c='Round 2';
      	 IP5b.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP5b.GYNCF_Position__c=pos5.ID;
      	 insert IP5b;
         System.debug('Inserted Interview Panel is - '+IP5b);
        
        GYNCO_Interview_Panel__c IP5c=New GYNCO_Interview_Panel__c();
       	 IP5c.GYNCF_Interview_Date__c=System.now();
      	 IP5c.GYNCF_Interview_round__c='Round 3';
      	 IP5c.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP5c.GYNCF_Position__c=pos5.ID;
      	 insert IP5c;
         System.debug('Inserted Interview Panel is - '+IP5c);
      
        GYNCO_Interview_Panel__c IP5d=New GYNCO_Interview_Panel__c();
       	 IP5d.GYNCF_Interview_Date__c=System.now();
      	 IP5d.GYNCF_Interview_round__c='Round 4';
      	 IP5d.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP5d.GYNCF_Position__c=pos5.ID;
      	 insert IP5d;
         System.debug('Inserted Interview Panel is - '+IP5d);
        
        GYNCO_Interview_Panel__c IP5e=New GYNCO_Interview_Panel__c();
       	 IP5e.GYNCF_Interview_Date__c=System.now();
      	 IP5e.GYNCF_Interview_round__c='Round 5';
      	 IP5e.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP5e.GYNCF_Position__c=pos5.ID;
      	 insert IP5e;
         System.debug('Inserted Interview Panel is - '+IP5e);
      
        Test.startTest();
        
        GYNC_createInterview.createNew(posList);
        
        Test.stopTest();
        System.assert(true);
        
    }
}