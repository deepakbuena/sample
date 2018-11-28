public with sharing class SaltClientReportController {
    static Id userId;
    static String sortedby;
    public static List<SALTColumnWrapper> colList=new List<SALTColumnWrapper>();
    public static SALTTableWrapper tableWrapper=new SALTTableWrapper();
    
    
    @AuraEnabled
    public static Boolean hasCreatePermission()
    {
        Boolean canCreate=false;
        canCreate=Schema.SObjectType.Salt_Client_Reports__c.isCreateAble();
        return canCreate;
    }
    @AuraEnabled
    public static SALTTableWrapper findAll() {
        sortedby='Sorted by Salt Client Report Names';
        System.Debug(userId);
        Id currentUser=[Select contactId from user where id=:userId].contactId;
        Id currentUserCommAcc=[Select accountId from contact where id=: currentUser].accountId;
        
        SALTColumnWrapper elem1=new SALTColumnWrapper();
        elem1.name='Name';
        elem1.label='Salt Client Report Name';
        elem1.sortDirection='ASC';
        
        SALTColumnWrapper elem2=new SALTColumnWrapper();
        elem2.name='CreatedDate';
        elem2.label='Created Date';
        elem2.sortDirection='ASC';
        
        colList.add(elem1);
        colList.add(elem2);
        
        tableWrapper.satCols=new List<SALTColumnWrapper>();        
        tableWrapper.satCols=colList;
         
        tableWrapper.clientRecords=new List<Salt_Client_Reports__c>();
        tableWrapper.clientRecords=[SELECT Id, Name, CreatedDate 
                FROM Salt_Client_Reports__c where Account__c=:currentUserCommAcc ORDER BY Name];
        /*
        List<Salt_Client_Reports__c> saltReports=[SELECT Id, Name, CreatedDate 
                FROM Salt_Client_Reports__c where Account__c=:currentUserCommAcc ORDER BY Name];
        */
        System.debug(tableWrapper);
        return tableWrapper;
    }
    
   /* @AuraEnabled
    public static List<SALTColumnWrapper> sort(String fieldName, String sortDirection)
    {
        if(fieldName=='Name')
        {
            
        }
        return null;
    }*/
    
    @AuraEnabled
    public static Id getUserId()
    {
        LoginHistory lastSuccessFullLogin=null;
        userId=UserInfo.getUserID();
        
        List<LoginHistory> lHistory=[Select 
                                            userId,LoginTime,status 
                                    From 
                                            LoginHistory 
                                    Where 
                                            userId= :UserInfo.getUserID()
                                    AND
                                            LoginUrl like'%customers/s/login'
                                    Order by  
                                            loginTime desc];
        //get the last successfull loging as status is not filterable in the query
        
        for(LoginHistory lTemp : lHistory)
        {
            if(lTemp.status.toLowerCase()=='success')
            {
                lastSuccessFullLogin=lTemp;
                break;
            }
        }
        
        Id loginRecordTypeId=Schema.SObjectType.Tracking_Detail__c.getRecordTypeInfosByName().get('Login').getRecordTypeId();
 
        List<Tracking_Detail__c> lastLogin=[Select 
                                                    Login_Time__c 
                                            from 
                                                    Tracking_Detail__c 
                                            where 
                                                    Logged_In_User__c =: userId 
                                            AND   
                                                    recordTypeId=:loginRecordTypeId
                                            order by 
                                                    createddate desc Limit 1];
        if((lastLogin!=null) && (lastLogin.size()>0) && (lastSuccessFullLogin != null))
        {
            if(lastLogin.get(0).Login_Time__c !=lastSuccessFullLogin.LoginTime)
            {
                Tracking_Detail__c newrecordDetails=new Tracking_Detail__c ();
                Id relatedContactId=[Select contactId from user where id=: userinfo.getUserId()].contactId;
                
                Contact relatedContact=[Select accountId from contact where id= : relatedContactId];
                if(relatedContact!=null)
                {
                    newrecordDetails.account__c=relatedContact.accountId;
                }
                newrecordDetails.Logged_In_User__c= userId;
                newrecordDetails.Login_Time__c = lastSuccessFullLogin.LoginTime;
                newrecordDetails.recordTypeId=loginRecordTypeId;
                insert newrecordDetails;
            }
        }
        else
        {
            Tracking_Detail__c newrecordDetails=new Tracking_Detail__c ();
            Id relatedContactId=[Select contactId from user where id=: userinfo.getUserId()].contactId;
            System.Debug(relatedContactId); 
            Contact relatedContact=[Select accountId from contact where id= : relatedContactId];
            System.Debug(relatedContact);
            if(relatedContact!=null)
            {
                newrecordDetails.account__c=relatedContact.accountId;
            }
            newrecordDetails.Logged_In_User__c= userId;
            if(lastSuccessFullLogin!=null)
                newrecordDetails.Login_Time__c = lastSuccessFullLogin.LoginTime;
            newrecordDetails.recordTypeId=loginRecordTypeId;
            insert newrecordDetails; 
        }
        //userId='00532000005Tozg';
        System.debug('logged in user is  '+userId);
        return userId;
    }

    @AuraEnabled
    public static List<SALTColumnWrapper> getColumns()
    {
        SALTColumnWrapper elem1=new SALTColumnWrapper();
        elem1.name='Name';
        elem1.label='Salt Client Report Name';
        elem1.sortDirection='ASC';
        
        SALTColumnWrapper elem2=new SALTColumnWrapper();
        elem2.name='CreatedDate';
        elem2.label='Created Date';
        elem2.sortDirection='ASC';
        
        colList.add(elem1);
        colList.add(elem2);
        return colList;
    }

    
    @AuraEnabled
    public static String getURL()
    {
        return SF_Community__c.getInstance('URL').Community_Url__c;
    }
    
    /*@AuraEnabled
    public static List<Salt_Client_Reports__c> sortByName(String columnName, String orderby) {
        System.debug(columnName +'----'+orderby);
        sortedby='Sorted by Salt Client Report Names';
        Id currentUser=[Select contactId from user where id=:userId].contactId;
        Id currentUserCommAcc=[Select accountId from contact where id=: currentUser].accountId;
        
        List<Salt_Client_Reports__c> saltReports=[SELECT Id, Name, CreatedDate 
                FROM Salt_Client_Reports__c where Account__c=:currentUserCommAcc ORDER BY Name];
        return saltReports;
    }*/
    
    @AuraEnabled
    public static List<Salt_Client_Reports__c> sortByCreatedDate() {
        sortedby='Sorted by Salt Client Report Names';
        Id currentUser=[Select contactId from user where id=:userId].contactId;
        Id currentUserCommAcc=[Select accountId from contact where id=: currentUser].accountId;
        
        List<Salt_Client_Reports__c> saltReports=[SELECT Id, Name, CreatedDate 
                FROM Salt_Client_Reports__c where Account__c=:currentUserCommAcc ORDER BY CreatedDate];
        return saltReports;
    }
    
    @AuraEnabled
    public static String getCurrentSortedByName()
    {
        return sortedby;
    }
    
    @AuraEnabled
    public static Tracking_Detail__c saveRecord (String curl) {
        Tracking_Detail__c newrecordDetails=new Tracking_Detail__c ();
        Id relatedContactId=[Select contactId from user where id=: userinfo.getUserId()].contactId;
        
        Contact relatedContact=[Select accountId from contact where id= : relatedContactId];
        if(relatedContact!=null)
        {
            newrecordDetails.account__c=relatedContact.accountId;
        }
        
        newrecordDetails.Clicked_By__c = userinfo.getUserId();
        newrecordDetails.Clicked_Time__c = DateTime.now();
        newrecordDetails.Clicked_Url__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+curl;   
        upsert newrecordDetails;
        return newrecordDetails;
    }
    @AuraEnabled
    public static String getAvailableListviews()
    {
        List<ListView> viewList=new List<ListView>();
        Set<id> listViewId=new Set<id>();
        try
        {
            ApexPages.StandardSetController sc=new ApexPages.StandardSetController(Database.getQueryLocator
                                                    ('Select id from Salt_client_reports__c Limit 1'));
            
            List<System.SelectOption> listViews = sc.getListViewOptions();
            for(System.SelectOption listView : listViews)
            {
                System.debug('List View Name : ' + listView.getValue());
                System.debug('List View Label : ' + listView.getLabel());
                listViewId.add(listView.getValue());
            }
            
            if(listViewId.size()>0)
            {
                viewList=[Select id, name from Listview where SobjectType= 'salt_client_reports__c' and Id in : listViewId];
            }
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        return JSON.serialize(viewList);
    }
   
    /*@AuraEnabled
    public static SALTTableWrapper findAllByFilter(Id filterId)
    {
        sortedby='Sorted by Salt Client Report Names';
        Id currentUser=[Select contactId from user where id=:userId].contactId;
        Id currentUserCommAcc=[Select accountId from contact where id=: currentUser].accountId;
        
        SALTColumnWrapper elem1=new SALTColumnWrapper();
        elem1.name='Name';
        elem1.label='Salt Client Report Name';
        elem1.sortDirection='ASC';
        
        SALTColumnWrapper elem2=new SALTColumnWrapper();
        elem2.name='CreatedDate';
        elem2.label='Created Date';
        elem2.sortDirection='ASC';
        
        colList.add(elem1);
        colList.add(elem2);
        
        tableWrapper.satCols=new List<SALTColumnWrapper>();        
        tableWrapper.satCols=colList;
         
        tableWrapper.clientRecords=new List<Salt_Client_Reports__c>();
        
        String query='SELECT Id, Name, CreatedDate FROM Salt_Client_Reports__c where Account__c ='+currentUserCommAcc +' ORDER BY Name';
                
        ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(Database.getQueryLocator(query));          
        ssc.setFilterId(filterId);
        
        Set<id> rIds=new Set<id>();
        
        for(Sobject s : ssc.getRecords())
        {
            rIds.add(s.id);
        }
        
        if(rIds.size()>0)
        {
            tableWrapper.clientRecords=[SELECT Id, Name, CreatedDate 
                FROM Salt_Client_Reports__c where id in :rIds ORDER BY Name];
        }
       
        System.debug(tableWrapper);
        return tableWrapper;
    } */
}