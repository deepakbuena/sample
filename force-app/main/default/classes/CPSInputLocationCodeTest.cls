/**
@Name            : CPSInputLocationCodeTest
@Description     : Test class for 'CPSInputLocationCode' Class 
**/
@isTest
public class CPSInputLocationCodeTest{
    @isTest
    public static void unitTest(){
        CPSInputLocationCode objCPSInputLocation = new CPSInputLocationCode();
        List<CPS_Location_Code__mdt> lstCpsData = [Select location_name__c,Location_Code__c
                               from CPS_Location_Code__mdt where location_name__c = 'EOC Boston'];
        if(lstCpsData != null && lstCpsData.size()>0){
            objCPSInputLocation.cpsLocationCode = lstCpsData[0].Location_Code__c;   
        }
        objCPSInputLocation.fetchLocationName();
    }
    
    @isTest
    public static void unitTest2(){
        CPSInputLocationCode objCPSInputLocation = new CPSInputLocationCode();
        List<CPS_Location_Code__mdt> lstCpsData = [Select location_name__c,Location_Code__c
                               from CPS_Location_Code__mdt where location_name__c = 'TS Boston'];
        if(lstCpsData != null && lstCpsData.size()>0){
            objCPSInputLocation.cpsLocationCode = lstCpsData[0].Location_Code__c;   
        }
        objCPSInputLocation.fetchLocationName();
    }
    
    @isTest
    public static void unitTest3(){
        CPSInputLocationCode objCPSInputLocation = new CPSInputLocationCode();
        objCPSInputLocation.cpsLocationCode = 'xyz';
        objCPSInputLocation.fetchLocationName();
    }
}