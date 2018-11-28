public class SendMail {
    public static void failIds(){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Report> rep = new List<Report>([Select Id from Report where Name = 'Failed Insight Data Storage']);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>{UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(UserInfo.getUserEmail());
        mail.setSubject('Failed Insight Data Storage Records');
        String hello = 'Hello,\n';
        String msg = 'Please click the link given below to check the failed Insight Data Storage Records Report and update the records with the new values.<br><br>';
        if(rep.size()>0){msg += 'Link to Report: '+URL.getSalesforceBaseUrl().toExternalForm()+'/' + rep[0].id;}
        mail.setHtmlBody(hello+'<br><br>'+msg+'<br><br>'+'Thanks');
        mails.add(mail);
        Messaging.sendEmail(mails);
    }

}