global class SocialToCaseModifier extends InboundSocialPostHandlerImpl{

    global override String getDefaultAccountId() {
        String accountId = Label.AccountIDForSocToCase;
        return accountId;
    }
    
    
    global override SObject createPersonaParent(SocialPersona persona) {
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counseling Services Contact').getRecordTypeId();
    
        String firstName = getPersonaFirstName(persona);
        String lastName = getPersonaLastName(persona);
        
        Contact contact = new Contact(LastName = lastName, FirstName = firstName, recordTypeId = conRecordTypeId);
        String defaultAccountId = getDefaultAccountId();
        if (defaultAccountId != null)
            contact.AccountId = defaultAccountId;
        insert contact;
        return contact;
    }

}