/* This class is created to send email to the respective interviewer with candidate's resume attached whenever an interview
   task is created. This controller is used in GYNT_sendEmail trigger.
   Created by - Arnab Dey  */

   public with sharing class GYNC_SendMailWithAttachments 
   {


     public static void sendMail(List<GYNCO_Interview__c> intr) //send mail to the interviewer
     {
       List<Id> attachmentIds = New List<Id>(); 
          For(GYNCO_Interview__c interview :intr)
          {
             attachmentIds.add(interview.GYNF_Candidate_Resume_Id__c);
          }
          
          if(

            Attachment.SObjectType.getDescribe().isAccessible()&&

            Schema.SobjectType.Attachment.fields.Id.isAccessible()&&
            Schema.SobjectType.Attachment.fields.Name.isAccessible() &&
            Schema.SobjectType.Attachment.fields.Body.isAccessible() &&
            Schema.SobjectType.Attachment.fields.ContentType.isAccessible() 

        ) {
        List<Attachment> AllResume = [SELECT Name, Body, ContentType FROM Attachment Where Id IN :attachmentIds];//Querying all the attachments
        if(

          OrgWideEmailAddress.SObjectType.getDescribe().isAccessible()&&

          Schema.SobjectType.OrgWideEmailAddress.fields.Id.isAccessible()
        ) {
        List<OrgWideEmailAddress> addresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address != null LIMIT 1];
        List<Messaging.SingleEmailMessage>  mailList = new List<Messaging.SingleEmailMessage>();
         //Querying email template
         if(

          EmailTemplate.SObjectType.getDescribe().isAccessible()&&

            Schema.SobjectType.EmailTemplate.fields.Id.isAccessible()&&
            Schema.SobjectType.EmailTemplate.fields.Subject.isAccessible() &&
            Schema.SobjectType.EmailTemplate.fields.Description.isAccessible() &&
            Schema.SobjectType.EmailTemplate.fields.HtmlValue.isAccessible() &&
            Schema.SobjectType.EmailTemplate.fields.DeveloperName.isAccessible() &&
            Schema.SobjectType.EmailTemplate.fields.Body.isAccessible() 

        ) {
        List<EmailTemplate> template = [SELECT Id, Subject, Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE DeveloperName = 'GYNC_Email_Alert_to_the_Interviewer1'];
        
      For(GYNCO_Interview__c I :intr)
          {
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
             
               if (I.GYNF_Candidate_Resume_Id__c != Null) 
               {
                 List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                 Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                   // set the attachment
                   for (Attachment file :AllResume)
                   {
                      If(file.Id == I.GYNF_Candidate_Resume_Id__c)
                      {
                        efa.setFileName(file.Name);
                        efa.setBody(file.Body);
                        efa.setContentType(file.ContentType);
                        attachments.add(efa); 
                      } 
                   } 
                message.setFileAttachments(attachments);// adding the attachment to email
              }
              // set the email body
             String plainBody = template[0].Body;
              // set the marge field values 
              
             If(I.GYNCF_Round1Date__c != Null && I.GYNCF_Interviewer1__c != NULL && I.GYNCF_Round1Complete__c == False && I.GYNCF_Status__c == 'Round 1')
             {
                  message.setTargetObjectId(I.GYNCF_Interviewer1__c);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Interviewer1__r.Name);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Round1Date__c}', I.GYNCF_Round1Date__c.format('MMMMM dd, yyyy ')+'\nTime of Interview- '+I.GYNCF_Round1Date__c.format(' hh:mm:ss a'));
             }
             else If(I.GYNCF_Round2Date__c != Null && I.GYNCF_Interviewer2__c != NULL && I.GYNCF_Round2Complete__c == False && I.GYNCF_Status__c == 'Round 2' )
             {
                  message.setTargetObjectId(I.GYNCF_Interviewer2__c);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Interviewer2__r.Name);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Round1Date__c}', I.GYNCF_Round2Date__c.format('MMMMM dd, yyyy ')+'\nTime of Interview- '+I.GYNCF_Round2Date__c.format(' hh:mm:ss a'));
             }
             else If(I.GYNCF_Round3Date__c != Null && I.GYNCF_Interviewer3__c != NULL && I.GYNCF_Round3Complete__c == False && I.GYNCF_Status__c == 'Round 3')
             {
                  message.setTargetObjectId(I.GYNCF_Interviewer3__c);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Interviewer3__r.Name);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Round1Date__c}', I.GYNCF_Round3Date__c.format('MMMMM dd, yyyy ')+'\nTime of Interview- '+I.GYNCF_Round3Date__c.format(' hh:mm:ss a'));
             }
             else If(I.GYNCF_Round4Date__c != Null && I.GYNCF_Interviewer4__c != NULL && I.GYNCF_Round4Complete__c == False && I.GYNCF_Status__c == 'Round 4')
             {
                  message.setTargetObjectId(I.GYNCF_Interviewer4__c);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Interviewer4__r.Name);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Round1Date__c}', I.GYNCF_Round4Date__c.format('MMMMM dd, yyyy ')+'\nTime of Interview- '+I.GYNCF_Round4Date__c.format(' hh:mm:ss a'));
                 
             }
             else If(I.GYNCF_Round5Date__c != Null && I.GYNCF_Interviewer5__c != NULL && I.GYNCOF_Round5Complete__c == False && I.GYNCF_Status__c == 'Round5')
             {
                  message.setTargetObjectId(I.GYNCF_Interviewer5__c);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Interviewer5__r.Name);
                  plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Round1Date__c}', I.GYNCF_Round5Date__c.format('MMMMM dd, yyyy ')+'\nTime of Interview- '+I.GYNCF_Round5Date__c.format(' hh:mm:ss a'));
             }
            else
             { 
                 message.setTargetObjectId(I.GYNCF_Position__r.GYNCF_Recruitment_owner__c);
                 plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Interviewer1__c}', I.GYNCF_Position__r.GYNCF_Recruitment_owner__r.Name);
                 plainBody = plainBody.replace('Date of Interview- {!GYNCO_Interview__c.GYNCF_Round1Date__c}', '');
             }   
   
              plainBody = plainBody.replace('{!GYNCO_Interview__c.Name}', I.Name);
              plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Position__c}', I.GYNCF_Position__r.Name);
              plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Status__c}', I.GYNCF_Status__c);
              plainBody = plainBody.replace('{!GYNCO_Interview__c.LastModifiedBy}', I.LastModifiedBy.Name);
              // Set the meeting link
             If(I.GYNCF_Meeting_Link__c != Null)
             {
               plainBody = plainBody.replace('{!GYNCO_Interview__c.GYNCF_Meeting_Link__c}',string.valueof(I.GYNCF_Meeting_Link__c));
             }
             else
             {
                plainBody = plainBody.replace('Meeting Link: {!GYNCO_Interview__c.GYNCF_Meeting_Link__c}','');
             }
         message.setTemplateId(template[0].Id);
         message.setSubject(template[0].Subject);
         message.setPlainTextBody(plainBody);
         message.setSaveAsActivity(false);
             // Set the message sender address
            if (!addresses.isEmpty()) 
            {
              message.setOrgWideEmailAddressId(addresses[0].Id);
            }
         mailList.add(message);
         }
       // Send the message
       
         Messaging.sendEmail(mailList);
        }
     }
   }
  }
}