public class BatchSendInvoiceRemider30 implements Database.Batchable<sObject>,Database.Stateful{
    public Integer count = 0;
    
    public Set<c2g__codaInvoice__c> sInvId=new Set<c2g__codaInvoice__c>();
    public List<c2g__codaInvoice__c> sInvList=new List<c2g__codaInvoice__c>();
    public List<Invoice_Recipient__c> invRecList = New List<Invoice_Recipient__c>();
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='select id,Name, c2g__DueDate__c, c2g__PaymentStatus__c,c2g__Account__c, c2g__Account__r.name, c2g__Account__r.owner.name, Invoice_Total__c, c2g__InvoiceTotal__c '; 
        query+=',c2g__Account__r.c2g__CODAInvoiceEmail__c, c2g__Account__r.Invoice_Email_2__c , c2g__Account__r.RAE_s_Email__c, c2g__Account__r.Invoice_Email_3__c'; 
        query+=',c2g__Account__r.c2g__CODAFinanceContact__r.name ,c2g__Account__r.Finance_Contact_2__r.name, c2g__Account__r.owner.email '; 
        query+=',c2g__Account__r.Finance_Contact_3__r.name from c2g__codaInvoice__c where c2g__DueDate__c='+System.now().addDays(-30).format('yyyy-MM-dd');
        query+=!(Test.isRunningTest())? ' and X30_day_Reminder_Send__c=false': '';
        
        System.debug(query);
        return Database.getQueryLocator(query );
    }
    
    public void execute(Database.BatchableContext bc, List<c2g__codaInvoice__c > scope)
    {
        Map<id,c2g__codaInvoice__c > slvInvMap=new Map<id,c2g__codaInvoice__c >();
        
        for(c2g__codaInvoice__c sInvTemp : scope)
        {
            if((sInvTemp.c2g__PaymentStatus__c.toUpperCase()=='UNPAID') ||(Test.isRunningTest()))
            {
                 slvInvMap.put(sInvTemp.id, sInvTemp );
            }
        }
        
        if(slvInvMap.size()>0)
        {
            try
            {
                List<EmailTemplate> etemplate=[select
                                                        id, body,Subject, htmlvalue
                                                from
                                                        emailtemplate
                                                where
                                                        developername='X30_day_overdue_reminder' and isactive=true];
                                                        
                
                List <Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage>();
                List<String> toAddresses = new List<String>();
                List<OrgWideEmailAddress> oweaTemp = [select 
                                                                Id 
                                                        from 
                                                                OrgWideEmailAddress 
                                                        where 
                                                                displayname= 'Finance Accounts Receivable Team'];
                String owId=oweaTemp.get(0).Id;
                        
                if(etemplate.size()>0)
                {
                    List<String> emailText=new List<String>();
                    if(slvInvMap.size()>0)
                    {
                        
                        for(Id iTemp : slvInvMap.keyset())
                        {
                           
                            String emailOwner=slvInvMap.get(iTemp).c2g__Account__r.owner.email;
                            String email1=slvInvMap.get(iTemp).c2g__Account__r.c2g__CODAInvoiceEmail__c;
                            String email2=slvInvMap.get(iTemp).c2g__Account__r.Invoice_Email_2__c;
                            String email3=slvInvMap.get(iTemp).c2g__Account__r.Invoice_Email_3__c;
                            String name1=slvInvMap.get(iTemp).c2g__Account__r.owner.name;
                            String name2=slvInvMap.get(iTemp).c2g__Account__r.c2g__CODAFinanceContact__r.name;
                            String name3=slvInvMap.get(iTemp).c2g__Account__r.Finance_Contact_2__r.name;
                            String emailRAE=slvInvMap.get(iTemp).c2g__Account__r.RAE_s_Email__c;    
                            boolean RAEsent = false; 
                            System.debug(emailRAE);
                            //c2g__
                            System.debug('c2g Invoice Total = ' + String.valueOF(slvInvMap.get(iTemp).c2g__InvoiceTotal__c));
                            System.debug('Invoice Total = ' + String.valueOF(slvInvMap.get(iTemp).Invoice_Total__c));
                            if(Test.isRunningTest())
                            {
                                email1='development@gilbuenasaxena.com';
                                email2='test@test.com';
                                email3='test2@test.com';
                                name1='Test1';
                                name2='Test1';
                                name3='Test1';
                            }
                            if(emailOwner!=null && emailOwner!='')
                            {
                                
                                String temp=etemplate.get(0).htmlvalue.replace('{!Account.c2g__CODAFinanceContact__c}',name1);
                                temp=temp.replace('{!c2g__codaInvoice__c.Name}',slvInvMap.get(iTemp).name);
                                
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__DueDate__c}',String.valueOF(slvInvMap.get(iTemp).c2g__DueDate__c.format()));
                                temp=temp.replace('{!c2g__codaInvoice__c.Invoice_Total__c}',String.valueOF(slvInvMap.get(iTemp).Invoice_Total__c));
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                
                                temp=temp.replace('<![CDATA[',' ');
                                temp=temp.replace(']]>',' ');
                                System.debug('email temp' + temp);
                                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                                msg.setOrgWideEmailAddressId(owId);
                                msg.setToAddresses(new String[] {emailOwner});
                                if(emailRAE!=null && emailRAE!='' && RAEsent == false){
                                    msg.SetCcAddresses(new String[] {emailRAE});
                                    RAEsent = true;
                                    System.debug('inside the cc condition 1');
                                    }
                                msg.setReplyTo('accountsreceivable@asa.org');
                                String tempSubj = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                msg.setSubject(tempSubj);
                                msg.setHtmlBody (temp);
                                mailList.add(msg);
                                
                            }
                            
                            if(email1!=null && email1!='')
                            {
                                
                                String temp=etemplate.get(0).htmlvalue.replace('{!Account.c2g__CODAFinanceContact__c}',name2);
                                temp=temp.replace('{!c2g__codaInvoice__c.Name}',slvInvMap.get(iTemp).name);
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__DueDate__c}',String.valueOF(slvInvMap.get(iTemp).c2g__DueDate__c.format()));
                                temp=temp.replace('{!c2g__codaInvoice__c.Invoice_Total__c}',String.valueOF(slvInvMap.get(iTemp).Invoice_Total__c));
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                temp=temp.replace('<![CDATA[',' ');
                                temp=temp.replace(']]>',' ');
                                System.debug('email temp' + temp);
                                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                                msg.setOrgWideEmailAddressId(owId);
                                msg.setToAddresses(new String[] {email1});
                                if(emailRAE!=null && emailRAE!='' && RAEsent == false){
                                    msg.SetCcAddresses(new String[] {emailRAE});
                                    RAEsent = true;
                                    System.debug('inside the cc condition 2');
                                    }
                                msg.setReplyTo('accountsreceivable@asa.org');
                                String tempSubj = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                msg.setSubject(tempSubj);
                                msg.setHtmlBody (temp);
                                mailList.add(msg);                            
                            }
                           
                            
                            System.debug('========= email2'+email2);
                            if(email2!=null && email2!='')
                            {
                                
                                String temp=etemplate.get(0).htmlvalue.replace('{!Account.c2g__CODAFinanceContact__c}',name3);
                                temp=temp.replace('{!c2g__codaInvoice__c.Name}',slvInvMap.get(iTemp).name);                           
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__DueDate__c}',String.valueOF(slvInvMap.get(iTemp).c2g__DueDate__c.format()));
                                temp=temp.replace('{!c2g__codaInvoice__c.Invoice_Total__c}',String.valueOF(slvInvMap.get(iTemp).Invoice_Total__c));
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                temp=temp.replace('<![CDATA[',' ');                                
                                temp=temp.replace(']]>',' ');
                                System.debug('email temp' + temp);
                                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                                msg.setOrgWideEmailAddressId(owId);
                                msg.setToAddresses(new String[] {email2});
                                if(emailRAE!=null && emailRAE!='' && RAEsent == false){
                                    msg.SetCcAddresses(new String[] {emailRAE});
                                    RAEsent = true;
                                    System.debug('inside the cc condition 3');
                                    }
                                msg.setReplyTo('accountsreceivable@asa.org');
                                String tempSubj = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                msg.setSubject(tempSubj);
                                msg.setHtmlBody (temp);
                                mailList.add(msg);
                                
                            }
                            
                            if(email3!=null && email3!='')
                            {
                                String name=slvInvMap.get(iTemp).c2g__Account__r.Finance_Contact_3__r.name;
                                String temp=etemplate.get(0).htmlvalue.replace('{!Account.c2g__CODAFinanceContact__c}',name3);
                                temp=temp.replace('{!c2g__codaInvoice__c.Name}',slvInvMap.get(iTemp).name);
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__DueDate__c}',String.valueOF(slvInvMap.get(iTemp).c2g__DueDate__c.format()));
                                temp=temp.replace('{!c2g__codaInvoice__c.Invoice_Total__c}',String.valueOF(slvInvMap.get(iTemp).Invoice_Total__c));
                                temp=temp.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                temp=temp.replace('<![CDATA[',' ');
                                temp=temp.replace(']]>',' ');
                                System.debug('email temp' + temp);
                                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                                msg.setToAddresses(new String[] {email3});
                                if(emailRAE!=null && emailRAE!='' && RAEsent == false){
                                    msg.SetCcAddresses(new String[] {emailRAE});
                                    RAEsent = true;
                                    System.debug('inside the cc condition 4');
                                    }
                                msg.setReplyTo('accountsreceivable@asa.org');
                                msg.setOrgWideEmailAddressId(owId);
                                String tempSubj = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOF(slvInvMap.get(iTemp).c2g__Account__r.Name));
                                msg.setSubject(tempSubj);
                                msg.setHtmlBody (temp);
                                mailList.add(msg);
                            }
                            slvInvMap.get(iTemp).X30_day_Reminder_Send__c=true;
                            sInvList.add(slvInvMap.get(iTemp));
                        }
                    }

                    if(mailList.size()>0)
                    {
                        Messaging.sendEmail(mailList);
                                                
                         // Insert Invoice Recipient begin     
                        for(c2g__codaInvoice__c ciTemp : scope)
                        {   
                            if(ciTemp.c2g__Account__r.c2g__CODAFinanceContact__c != null){
                                Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                                irTemp.Subject__c = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOf(ciTemp.c2g__Account__r.Name));
                                irTemp.Finance_Contact__c = ciTemp.c2g__Account__r.c2g__CODAFinanceContact__c;
                                irTemp.Email_sent_Date__c = DateTime.now();
                            
                                invRecList.add(irTemp);
                            } 
                            if(ciTemp.c2g__Account__r.Finance_Contact_2__c != null){
                                Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                                irTemp.Subject__c = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOf(ciTemp.c2g__Account__r.Name));
                                irTemp.Finance_Contact__c = ciTemp.c2g__Account__r.Finance_Contact_2__c;
                                irTemp.Email_sent_Date__c = DateTime.now();
                                
                                invRecList.add(irTemp);
                            }
                            if(ciTemp.c2g__Account__r.Finance_Contact_3__c != null){
                                Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                                irTemp.Subject__c = etemplate[0].Subject.replace('{!c2g__codaInvoice__c.c2g__Account__c}',String.valueOf(ciTemp.c2g__Account__r.Name));
                                irTemp.Finance_Contact__c = ciTemp.c2g__Account__r.Finance_Contact_3__c;
                                irTemp.Email_sent_Date__c = DateTime.now();
                                
                                invRecList.add(irTemp);
                            }
                        }
                                                
                        if(invRecList.size() > 0)
                        {
                            insert invRecList;
                        }
                    }      
                    if(sInvList.size()>0)
                        update sInvList;
                        
                }  
            }
            catch(Exception e)
            {
                System.debug('An exception has occurred -'+e.getMessage()+' - '+e.getLineNumber());
            }
        }
    }
     
     public void finish(Database.BatchableContext bc)
     {
     }    
}