/*
TestClassName : ConfirmationControllerTest
*/

public class ConfirmationController
{
    public String pageOrigin {get;set;}
    public ConfirmationController()
    {
        pageOrigin  = ApexPages.currentPage().getParameters().get('origin');
        System.debug('pageOrigin @@@'+pageOrigin);
    }
    
    public pageReference redirectToSignOn()
    {
        if(pageOrigin == 'eoc')
        {
           PageReference redirectEOC = new Pagereference('/apex/EOCSignOn');
           redirectEOC.setRedirect(true);
           return redirectEOC; 
        }
        else if(pageOrigin == 'ts')
        {
           PageReference redirectTS = new Pagereference('/apex/TSSignOn');
           redirectTS.setRedirect(true);
           return redirectTS; 
        }
        return null;
    }
}