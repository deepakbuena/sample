public with sharing class CPSQRCodeGenerator
{
    public String url{get; private set;}
    public String campaignName {get; private set;}
    public String failureMsg {get; private set;}
    Id recordId{get; private set;}
    Integer HOURSLIMIT=[select isSandbox from organization Limit 1].isSandbox ? 1:72;
    // Added by RS
    public Datetime QRCodeValidity {get; private set;}
    
    public CPSQRCodeGenerator(ApexPages.StandardController sc)
    {
        recordId=sc.getID();
    }
    
    public PageReference generateCode()
    {
        List<Campaign> campList=[Select id, name,QR_Code_Valid_From__c, QR_Code_Valid_Until__c from Campaign where id=:recordId Limit 1];
        String instanceURL=[Select isSandbox from Organization Limit 1].isSandbox ? 'http://cpsappdev-asaimpact.cs60.force.com/cps/CPS_QRCodeReader'
        :'https://asaimpact.secure.force.com/cps/CPS_QRCodeReader';
        
        DateTime nowMilliseconds=System.now();  // represents the validity start time, generated on button click
        DateTime endMilliseconds=System.now().addHours(HOURSLIMIT); // represents the validity end time HOURSLIMIT hrs from when the button was clicked
        
        String strNowMilliseconds=String.valueOf(nowMilliseconds.getTime()); 
        String strEndMilliseconds=String.valueOf(endMilliseconds.getTime()); 
            
        if(campList.size()>0)
        {
            // matching campaign found
            Campaign camp=campList.get(0);
            campaignName =camp.name;
            
            
            // if both the fields have value then
            // -- if the current time is between those then create the QR based on the values in QR_Code_Valid_From__c and QR_Code_Valid_Until__c
            // -- if not then generate a new one
            if(camp.QR_Code_Valid_From__c!=null && camp.QR_Code_Valid_Until__c !=null)
            {
                if(System.now()>=camp.QR_Code_Valid_FRom__c && System.now()<=camp.QR_Code_Valid_Until__c)
                {
                    //generate the URL based on the existing fields
                    strNowMilliseconds=String.valueOf(camp.QR_Code_Valid_FRom__c.getTime()); 
                    strEndMilliseconds=String.valueOf(camp.QR_Code_Valid_Until__c.getTime());
                    url=instanceURL+'?id='+recordId +'&st='+strNowMilliseconds+'&dt='+strEndMilliseconds;
                    TimeZone tz = UserInfo.getTimeZone();
                    QRCodeValidity = camp.QR_Code_Valid_Until__c + tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);  // Added by RS
                }
                else
                {
                    camp.QR_Code_Valid_From__c=nowMilliseconds;
                    camp.QR_Code_Valid_Until__c=endMilliseconds;
                    update camp;
                    url=instanceURL+'?id='+recordId +'&st='+strNowMilliseconds+'&dt='+strEndMilliseconds;
                    TimeZone tz = UserInfo.getTimeZone();
                    QRCodeValidity = endMilliseconds + tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);  // Added by RS
                }
            }
            
            //if either of them is blank then generate a new code based on current time
            if(camp.QR_Code_Valid_From__c==null || camp.QR_Code_Valid_Until__c==null)
            {
                camp.QR_Code_Valid_From__c=nowMilliseconds;
                camp.QR_Code_Valid_Until__c=endMilliseconds;
                update camp;
                url=instanceURL+'?id='+recordId +'&st='+strNowMilliseconds+'&dt='+strEndMilliseconds;
                
                TimeZone tz = UserInfo.getTimeZone();
                
                
                QRCodeValidity = camp.QR_Code_Valid_Until__c + tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);  // Added by RS
            }
        }
        else
        {
            failureMsg ='Unable to find a campaign with the matching details. It looks like the campaign might have been deleted.';
        }
        return null;
    }
}