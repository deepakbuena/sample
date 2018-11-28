public class ChangeLanguage2{

    public String language{get;set;}
    public boolean rndrSpenish{get;set;}

    public ChangeLanguage2(ApexPages.StandardController controller){
        if(apexpages.currentpage().getparameters().get('lang') != null){
            language = apexpages.currentpage().getparameters().get('lang');
            System.debug('if>>>>language>>>>>'+language);
        }
        else{
            language = 'en_US';
            rndrSpenish = true;
            System.debug('else>>>>language>>>>>'+language);
        }
    }
    
}