public class EmailTrackingOnSalesInvoice {

    public static void trackEmailonInvoice(List<c2g__codaInvoice__c> invList, Map<Id,c2g__codaInvoice__c> invMap){
    
        Set<Id> accIds = new Set<Id>();
        Set<Id> comIds = new Set<Id>();
        
        List<EmailTemplate> etemplate = [Select Id,Subject From EmailTemplate Where DeveloperName='codaSalesInvoice' And isActive=true];
        
        for(c2g__codaInvoice__c inv : invList){
            if(inv.c2g__InvoiceStatus__c == 'Complete' && 
                  inv.c2g__PrintStatus__c != invMap.get(inv.Id).c2g__PrintStatus__c && inv.c2g__PrintStatus__c == 'Printed'){
                
                accIds.add(inv.c2g__Account__c);
                
                if(inv.c2g__OwnerCompany__c != null)
                    comIds.add(inv.c2g__OwnerCompany__c);
            }
        }
        if(accIds.size()>0){
        
            Map<Id,Account> invAccountMap = new Map<Id,Account>();
            Map<Id,c2g__codaCompany__c> invCompMap = new Map<Id,c2g__codaCompany__c>();
            
            List<Account> accList = [Select Id, c2g__CODAFinanceContact__c,c2g__CODAFinanceContact__r.Name,Finance_Contact_2__c,
                                        Finance_Contact_2__r.Name,Finance_Contact_3__c,Finance_Contact_3__r.Name From Account Where
                                        Id In : accIds];
                                        
            List<c2g__codaCompany__c> compList = [Select Id,Name From c2g__codaCompany__c Where Id In : comIds];
            
            List<Invoice_Recipient__c> invRecList = New List<Invoice_Recipient__c>();
            
            for(Account acc : accList){
                invAccountMap.put(acc.Id,acc);   
            }
            
            for(c2g__codaCompany__c comp : compList){
                invCompMap.put(comp.Id,comp);    
            }
            
            Map<String,Attachment> attachMap = new Map<String,Attachment>();
                                                                 
            for(c2g__codaInvoice__c inv : invList){
                if(inv.c2g__InvoiceStatus__c == 'Complete' && 
                      inv.c2g__PrintStatus__c != invMap.get(inv.Id).c2g__PrintStatus__c && inv.c2g__PrintStatus__c == 'Printed'){
                  
                    if(invAccountMap.containsKey(inv.c2g__Account__c)){
                        if(invAccountMap.get(inv.c2g__Account__c).c2g__CODAFinanceContact__c != null){
                            Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                                                        
                            if(etemplate.size()>0){
                                irTemp.Subject__c = etemplate.get(0).Subject + ' ' +invCompMap.get(inv.c2g__OwnerCompany__c).Name;
                                
                                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(etemplate.get(0).Id,String.valueOf(invAccountMap.get(inv.c2g__Account__c).c2g__CODAFinanceContact__c),String.valueOf(inv.Id));
                                irTemp.Email_Body__c = email.getHtmlBody();
                                                                
                                if(email.getFileAttachments().size()>0){
                                    
                                    Attachment att = new Attachment();
                                    att.ContentType = email.getFileAttachments().get(0).getContentType();
                                    att.Name = email.getFileAttachments().get(0).getFileName();
                                    att.Body = email.getFileAttachments().get(0).getBody();
                                    
                                    irTemp.Invoice_and_Contact_Id__c = String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).c2g__CODAFinanceContact__c);
                                    attachMap.put(String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).c2g__CODAFinanceContact__c),att);
                                }
                            }                            
                            
                            irTemp.Finance_Contact__c = invAccountMap.get(inv.c2g__Account__c).c2g__CODAFinanceContact__c;
                            irTemp.Email_sent_Date__c = DateTime.now();
                            invRecList.add(irTemp);
                        }
                        if(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_2__c != null){
                            Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                            
                            if(etemplate.size()>0){
                                irTemp.Subject__c = etemplate.get(0).Subject + ' ' +invCompMap.get(inv.c2g__OwnerCompany__c).Name;
                                
                                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(etemplate.get(0).Id,String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_2__c),String.valueOf(inv.Id));
                                irTemp.Email_Body__c = email.getHtmlBody();
                                                                
                                if(email.getFileAttachments().size()>0){
                                    
                                    Attachment att = new Attachment();
                                    att.ContentType = email.getFileAttachments().get(0).getContentType();
                                    att.Name = email.getFileAttachments().get(0).getFileName();
                                    att.Body = email.getFileAttachments().get(0).getBody();
                                    
                                    irTemp.Invoice_and_Contact_Id__c = String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_2__c);
                                    attachMap.put(String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_2__c),att);
                                }
                            }
                                                    
                            irTemp.Finance_Contact__c = invAccountMap.get(inv.c2g__Account__c).Finance_Contact_2__c;
                            irTemp.Email_sent_Date__c = DateTime.now();
                            invRecList.add(irTemp);
                        }
                        if(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_3__c != null){
                            Invoice_Recipient__c irTemp = new Invoice_Recipient__c();
                            if(etemplate.size()>0){
                                irTemp.Subject__c = etemplate.get(0).Subject + ' ' +invCompMap.get(inv.c2g__OwnerCompany__c).Name;
                                
                                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(etemplate.get(0).Id,String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_3__c),String.valueOf(inv.Id));
                                irTemp.Email_Body__c = email.getHtmlBody();
                                                                
                                if(email.getFileAttachments().size()>0){
                                    
                                    Attachment att = new Attachment();
                                    att.ContentType = email.getFileAttachments().get(0).getContentType();
                                    att.Name = email.getFileAttachments().get(0).getFileName();
                                    att.Body = email.getFileAttachments().get(0).getBody();
                                    
                                    irTemp.Invoice_and_Contact_Id__c = String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_3__c);
                                    attachMap.put(String.valueOf(inv.Id)+String.valueOf(invAccountMap.get(inv.c2g__Account__c).Finance_Contact_3__c),att);
                                }
                            }
                            
                            irTemp.Finance_Contact__c = invAccountMap.get(inv.c2g__Account__c).Finance_Contact_3__c;
                            irTemp.Email_sent_Date__c = DateTime.now();
                            invRecList.add(irTemp);
                        }
                    }
                }
            }
            
            if(invRecList.size()>0){
                Database.insert(invRecList,false);
            }
            
            List<Invoice_Recipient__c> invRecpList = [Select id,Invoice_and_Contact_Id__c From Invoice_Recipient__c Where Id In : invRecList];
            List<Attachment> attInsertList = new List<Attachment>();
            
            for(Invoice_Recipient__c invRec : invRecpList){
                Attachment att = attachMap.get(invRec.Invoice_and_Contact_Id__c);
                att.ParentId = invRec.Id;
                attInsertList.add(att);
            }
            
            if(attInsertList.size()>0){
                insert attInsertList;
            }
        }
    }
}