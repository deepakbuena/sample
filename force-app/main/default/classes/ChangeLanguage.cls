public class ChangeLanguage{

    public String language{get;set;}

    public ChangeLanguage(ApexPages.StandardController controller){
        Cookie languageCookie = ApexPages.currentPage().getCookies().get('lang');
        if(languageCookie == null) {
            languageCookie = new Cookie('lang','en_US',null,-1,false);
        }
        ApexPages.currentPage().setCookies(new Cookie[]{languageCookie});
        
        setLauguage();
    }

    public void setLauguage(){
        if(ApexPages.currentPage().getCookies().get('lang') != null){
           language = ApexPages.currentPage().getCookies().get('lang').getValue();
        }
        else{
            language = 'en_US';
        }
    }
    
    public void changeToSpanish(){
        Cookie languageCookie = new Cookie('lang','es_MX',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{languageCookie});
    }
    
    public void changeToEnglish(){
        Cookie languageCookie = new Cookie('lang','en_US',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{languageCookie});
    }

}