//
// (c) 2017 Appirio, Inc.
//
// Test Class Name  : CPS_Loop_AFRReportTargetSchools_Test
// Trigger Name     : CPS_Loop_AFRReportTargetSchools
// Description     : This is a Test class for CPS_Loop_AFRReportTargetSchools.
//
// 11th October 2017  Abhimanyu Singh Tanwar  Original (Task # T-637587) - Please see the task description for more details.
//
@isTest
private class CPS_Loop_AFRReportTargetSchools_Test {
  private static testMethod void test() {
    Campaign campaign = CPS_TestUtility.createCampaign(true,1).get(0);
    
    Account acct1 = new Account();
    acct1.Name = 'College Planning Services';
    insert acct1;
    
    CampaignMember cm = CPS_TestUtility.createCampaignMember(false,1,campaign.Id,CPS_TestUtility.createContacts(true,1,acct1.id).get(0).Id).get(0);
    cm.Targeted_School__c = CPS_TestUtility.createTargetedSchool(true,1,(CPS_TestUtility.createSecondarySchool(true,1).get(0).Id)).get(0).Id;
    insert cm;
    
    CPS_Loop_AFRReportTargetSchools apr  = new CPS_Loop_AFRReportTargetSchools();
      List<String> tagList = new List<String>( apr.getGlobalDescribe());
      System.assertEquals(null, apr.getChildRelationships(tagList.get(0)));
      apr.describeObjects(tagList);

      Loop.ExternalData.QueryRequestInfo requestInfo = new Loop.ExternalData.QueryRequestInfo();
      requestInfo.RecordId                           = campaign.id;
      
      Loop.ExternalData.QueryResultSet queryResultSet = apr.query(requestInfo);
    List<Loop.ExternalData.QueryResult> queryResult = queryResultSet.results;
    
    //apr.getFieldValue(cm,'Campaign.Name');
      
    System.assertEquals(1,QueryResult.size());
    System.assertEquals(1,QueryResult.get(0).rows.size());
   
    }
}