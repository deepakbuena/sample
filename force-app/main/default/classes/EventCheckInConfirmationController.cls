public class EventCheckInConfirmationController
{
    public pageReference redirectToEventCheckIn()
    {
        return new Pagereference('/apex/EventCheckIn').setRedirect(true);
    }    
}