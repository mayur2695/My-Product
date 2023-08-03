@isTest
public class GYNC_SendMailWithAttachmentTest {
  
@isTest(SeeAllData=False)
  public static void SendMailAttachment()
  {
    
      	GYNCO_Salesforce_Event_Meeting_Link__c obj= new GYNCO_Salesforce_Event_Meeting_Link__c();
		obj.GYNCF_Use_Direct_Meeting_Invite__c=True;
		obj.GYNCF_Use_Salesforce_Event__c=False;
		obj.Name='Test';
		insert obj;
      
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
      	System.debug('Position record has been successfully inserted');
      
      
      	GYNCO_Candidate__c can= new GYNCO_Candidate__c();
      	can.GYNCF_Position__c=pos.Id;
      	can.GYNCF_Has_Resume__c=True;
		can.Name='Demo1';
        insert can;
     	System.debug('Candidate Record has been successfully inserted');
      
		String Body ='This is a dummy attachment.';
        Blob txt = Blob.valueOf(Body);
		Attachment attach = new Attachment();
		attach.ParentId = can.Id;
		attach.Name = 'dummy attachment';
		attach.Body = txt;
		insert attach;
        System.debug('Resume='+attach);
      
    	 GYNCO_Interview_Panel__c IP=New GYNCO_Interview_Panel__c();
       	 IP.GYNCF_Interview_Date__c=System.now();
      	 IP.GYNCF_Interview_round__c='Round 1';
      	 IP.GYNCF_Interviewer__c=UserInfo.getUserId();
    	 IP.GYNCF_Position__c=pos.ID;
      	 insert IP;
         System.debug('Interview Panel has been successfully created');
      
      
            GYNCO_Offer_Letter_Template__c Tempt=new GYNCO_Offer_Letter_Template__c();
      		Tempt.Name='Test Class Template';
         	Tempt.GYNCF_Template__c='Hi, You are successfully hired';
         	//Tempt.GYNCF_Active__c=False;
      		insert Tempt;
      		System.debug('Template has been successfully inserted');
      		String rectypeid=Schema.getGlobalDescribe().get('GYNCO_Interview__c').getDescribe().getRecordTypeInfosByDeveloperName().get('With_button_record_type').getRecordTypeId();
          
  
      
   
      List<GYNCO_Interview__c> T=New List<GYNCO_Interview__c>();
      GYNCO_Interview__c A=New GYNCO_Interview__c();
      A.Name=can.Name;
      A.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      A.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      A.GYNCF_Interviewer3__c=IP.GYNCF_Interviewer__c;
      A.GYNCF_Interviewer4__c=IP.GYNCF_Interviewer__c;
      A.GYNCF_Interviewer5__c=IP.GYNCF_Interviewer__c;
      System.debug('Interviewer='+ A.GYNCF_Interviewer1__c);
      A.GYNCF_Round1Date__c=system.now();
      A.GYNCF_Round2Date__c=system.now();
      A.GYNCF_Round3Date__c=system.now();
      A.GYNCF_Round4Date__c=system.now();
      A.GYNCF_Round5Date__c=system.now();
      A.GYNCF_Round1Complete__c=False;
      A.GYNCF_Round2Complete__c=False;
      A.GYNCF_Round3Complete__c=False;
      A.GYNCF_Round4Complete__c=False;
      A.GYNCOF_Round5Complete__c=False;
      A.GYNCF_Position__c=pos.ID;
      A.GYNCF_Status__c='Round 1';
      A.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  A.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      A.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      A.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      A.GYNF_Candidate_Resume_Id__c =attach.Id; 
      A.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(A);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
      
 
      GYNCO_Interview__c B=New GYNCO_Interview__c();
      B.Name=can.Name;
      B.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      B.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      B.GYNCF_Round1Date__c=system.now();
      B.GYNCF_Round2Date__c=system.now().addHours(3);
      B.GYNCF_Round1Complete__c=False;
      B.GYNCF_Round2Complete__c=False;
      B.GYNCF_Position__c=pos.ID;
      B.GYNCF_Status__c='Round 2';
      B.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  B.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      B.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      B.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      B.GYNF_Candidate_Resume_Id__c =attach.Id; 
      B.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(B);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
            
	  GYNCO_Interview__c C=New GYNCO_Interview__c();
      C.Name=can.Name;
      C.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      C.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      C.GYNCF_Interviewer3__c=IP.GYNCF_Interviewer__c;
      System.debug('Interviewer='+ A.GYNCF_Interviewer1__c);
      C.GYNCF_Round1Date__c=system.now();
      C.GYNCF_Round2Date__c=system.now();
      C.GYNCF_Round3Date__c=system.now();
      C.GYNCF_Round1Complete__c=False;
      C.GYNCF_Round2Complete__c=False;
      C.GYNCF_Round3Complete__c=False;
      C.GYNCF_Position__c=pos.ID;
      C.GYNCF_Status__c='Round 3';
      C.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  C.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      C.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      C.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      C.GYNF_Candidate_Resume_Id__c =attach.Id;
      C.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(C);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
      
      GYNCO_Interview__c D=New GYNCO_Interview__c();
      D.Name=can.Name;
      D.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      D.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      D.GYNCF_Interviewer3__c=IP.GYNCF_Interviewer__c;
      D.GYNCF_Interviewer4__c=IP.GYNCF_Interviewer__c;
      System.debug('Interviewer='+ A.GYNCF_Interviewer1__c);
      D.GYNCF_Round1Date__c=system.now();
      D.GYNCF_Round2Date__c=system.now();
      D.GYNCF_Round3Date__c=system.now();
      D.GYNCF_Round4Date__c=system.now();
      //D.GYNCF_Round5Date__c=system.now();
      D.GYNCF_Round1Complete__c=False;
      D.GYNCF_Round2Complete__c=False;
      D.GYNCF_Round3Complete__c=False;
      D.GYNCF_Round4Complete__c=False;
     // D.GYNCOF_Round5Complete__c=False;
      D.GYNCF_Position__c=pos.ID;
      D.GYNCF_Status__c='Round 4';
      D.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  D.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      D.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      D.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      D.GYNF_Candidate_Resume_Id__c =attach.Id; 
      D.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(D);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
      
      GYNCO_Interview__c E=New GYNCO_Interview__c();
      E.Name=can.Name;
      E.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      E.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      E.GYNCF_Interviewer3__c=IP.GYNCF_Interviewer__c;
      E.GYNCF_Interviewer4__c=IP.GYNCF_Interviewer__c;
      E.GYNCF_Interviewer5__c=IP.GYNCF_Interviewer__c;
      System.debug('Interviewer='+ A.GYNCF_Interviewer1__c);
      E.GYNCF_Round1Date__c=system.now();
      E.GYNCF_Round2Date__c=system.now();
      E.GYNCF_Round3Date__c=system.now();
      E.GYNCF_Round4Date__c=system.now();
      E.GYNCF_Round5Date__c=system.now();
      E.GYNCF_Round1Complete__c=False;
      E.GYNCF_Round2Complete__c=False;
      E.GYNCF_Round3Complete__c=False;
      E.GYNCF_Round4Complete__c=False;
      E.GYNCOF_Round5Complete__c=False;
      E.GYNCF_Position__c=pos.ID;
      E.GYNCF_Status__c='Round5';
      E.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  E.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      E.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      E.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      E.GYNF_Candidate_Resume_Id__c =attach.Id; 
      E.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(E);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
      
      GYNCO_Interview__c F=New GYNCO_Interview__c();
      F.Name=can.Name;
      F.GYNCF_Interviewer1__c=IP.GYNCF_Interviewer__c;
      F.GYNCF_Interviewer2__c=IP.GYNCF_Interviewer__c;
      F.GYNCF_Round1Date__c=system.now();
      F.GYNCF_Round2Date__c=system.now().addHours(3);
      F.GYNCF_Round1Complete__c=True;
      F.GYNCF_Round2Complete__c=False;
      F.GYNCF_Position__c=pos.ID;
      F.GYNCF_Status__c='Round 2';
      F.GYNCF_Final_offer_amount__c = pos.GYNCF_Final_offer_amount__c;
	  F.GYNCF_Offer_Letter_Template__c=Tempt.Id;
      F.GYNCF_Template__c=Tempt.GYNCF_Template__c;
      F.GYNCF_Use_Salesforce_Event__c = can.GYNCF_Position__r.GYNCF_Use_Salesforce_Event__c;
      F.GYNF_Candidate_Resume_Id__c =attach.Id; 
      F.GYNCF_Meeting_Link__c='www.gmail.com';
      F.GYNCF_Rec_Type_Id__c=rectypeid;
      T.add(F);
      System.debug(T);
      System.debug('Record has been successfully added with the List');
      
      
      
		insert T;
    //  system.debug('rec id is '+T[0].GYNCF_Rec_Type_Id__c);
      
       List<Id> Ids = New List<Id>(); 
    	For(GYNCO_Interview__c Ev :T)
    	{
     	 Ids.add(Ev.Id);
    	}
       List<GYNCO_Interview__c> Interview = New List<GYNCO_Interview__c>();
   		 Interview = [Select Id, Name,GYNCF_Position__r.Name,    GYNCF_Interviewer1__r.Name,GYNCF_Interviewer2__r.Name,GYNCF_Interviewer3__r.Name,
                GYNCF_Interviewer4__r.Name,GYNCF_Interviewer5__r.Name,GYNF_Candidate_Resume_Id__c,GYNCF_Interviewer1__c,GYNCF_Interviewer2__c,
                GYNCF_Interviewer3__c,GYNCF_Interviewer4__c,GYNCF_Interviewer5__c,GYNCF_Round1Complete__c,GYNCF_Round2Complete__c,
                GYNCF_Round3Complete__c,GYNCF_Round4Complete__c,GYNCOF_Round5Complete__c,GYNCF_Round1Date__c,GYNCF_Round2Date__c,
                GYNCF_Round3Date__c,GYNCF_Round4Date__c,GYNCF_Round5Date__c,GYNCF_Status__c,GYNCF_Meeting_Link__c, LastModifiedBy.Name,
                GYNCF_Position__r.GYNCF_Recruitment_owner__c,GYNCF_Position__r.GYNCF_Recruitment_owner__r.Name
                From GYNCO_Interview__c
                Where Id IN :Ids]; 
      	System.debug('List has been successfully inserted');
      
      	Test.startTest();
    	GYNC_SendMailWithAttachments.SendMail(Interview);
        Test.stopTest() ;
        System.assert(true);      
  }
}