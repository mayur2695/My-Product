public class CalendarInvites {
    
    public static void sendinvite() {        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(new List<String>{'cipraroutray@gmail.com'});
        mail.setSubject('Test Meeting 2');      
        mail.setPlainTextBody('');     
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();   
        attach.filename = 'reminder.ics'; 
        attach.ContentType = 'text/calendar;charset=utf-8;method=REQUEST';
     
        attach.inline = true;     
        attach.body = invite();   
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});   
        Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] { mail }); 
    if (er[0].success)
    {
        System.debug('The email was sent successfully.');
    } else
    {
        System.debug('The email failed to send: '); //+ er[0].errors[0].mail);
    }}
    
    
      private static Blob invite() {
        DateTime dt=DateTime.now().adddays(1);
        String startdatetime=String.valueof(dt.year()+'0'+dt.month()+''+dt.day()+'T000000Z');
        System.debug('startdatetime= '+startdatetime);
        String enddatetime=String.valueof(dt.year()+'0'+dt.month()+''+dt.day()+'T020000Z');
        System.debug('enddatetime= '+enddatetime);
        String txtInvite = ''; 
        txtInvite += 'BEGIN:VCALENDAR\n';        
        txtInvite += 'PRODID::-//hacksw/handcal//NONSGML v1.0//EN\n';
        txtInvite += 'VERSION:2.0\n';
        txtInvite += 'METHOD:PUBLISH\n';
        txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
        txtInvite += 'BEGIN:VEVENT\n';
       txtInvite += 'RSVP:TRUE\n';
        txtInvite += 'CLASS:PUBLIC\n';
        txtInvite += 'CREATED:20091026T203709Z\n';        
        txtInvite += 'DTEND:'+enddatetime+'\n';
        txtInvite += 'DTSTAMP:20191026T203709Z\n';        
        txtInvite += 'DTSTART:'+startdatetime+'\n';
        txtInvite += 'LAST-MODIFIED:20091026T203709Z\n';
        txtInvite += 'LOCATION:India\n';
        txtInvite += 'PRIORITY:5\n';
        txtInvite += 'SEQUENCE:0\n';
        txtInvite += 'SUMMARY;';
        txtInvite += 'LANGUAGE=en-us:Meeting\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
        txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
        txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR'; 
        return Blob.valueOf(txtInvite);
    }
 }