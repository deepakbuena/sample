//
// (c) 2017 Appirio, Inc.
//
// Class Name  : CPS_Loop_AFRReportTargetSchools
// Description: This is a handler class updates Birthdate_Text__c on insert and update of contact record.
//
// 17th November 2017  Abhimanyu Singh Tanwar  Original (Task # T-643100) - Please see the task description for more details.
//
global class CPS_Loop_AFRReportTargetSchools implements Loop.IApexDataSource {
  
  //  Return the sObject tags for Drawloop 
  //  @param null
  //  @Return set of object names that this Apex class will provide data for.
  public Set<string> getGlobalDescribe() {
    return new Set<String>{
      'TargetSchools'
    };
  }
  
  //  Describe each object in objectNames.
  //  @param String containing Object Name
  //  @Return List<Loop.ExternalData.DataObject> 
  public List<Loop.ExternalData.DataObject> describeObjects(List<string> objNames) {
    List<Loop.ExternalData.DataObject> output = new List<Loop.ExternalData.DataObject>();
    // Iterating over Tags 
    for (string objName : objNames) { 
      List<Loop.ExternalData.FieldInfo> outputFields = new List<Loop.ExternalData.FieldInfo>(); 
      
      if(objName == 'TargetSchools') {
        Map<string, Schema.SObjectField> fields = Schema.sObjectType.Targeted_School__c.fields.getMap();
        for (string key : fields.keySet()) {  
          Schema.DescribeFieldResult info = fields.get(key).getDescribe();
          Loop.ExternalData.FieldInfo outputInfo = new Loop.ExternalData.FieldInfo(info.getName(), info.getType());
          outputInfo.referenceTo = info.getReferenceTo().size() > 0 ? string.valueOf(info.getReferenceTo()[0]) : null;
          outputInfo.scale = info.getScale();
          outputInfo.label = info.getLabel();
          outputFields.add(outputInfo);
        }
      }
     output.add(new Loop.ExternalData.DataObject(objName, outputFields));
    }
  return output;
  }
  
  //  Return a set of object names corresponding to the children for the objectName specified
  //  @param List of  String containing object name
  //  @Return set of object names corresponding to the children for the objectName specified  
  public Set<string> getChildRelationships(string objectName) {
    Set<string> childObjectNames = new Set<string>();
    return null;
  }
  
  //  Provide data for each object in requestInfo.GetObjectNames()
  //  @param Loop.ExternalData.QueryRequestInfo as per Interface
  //  @Return result data to drawloop   
  public Loop.ExternalData.QueryResultSet query(Loop.ExternalData.QueryRequestInfo requestInfo) {

    Loop.ExternalData.QueryResultSet queryResultSet = new Loop.ExternalData.QueryResultSet();
    List<SObject> resultData;
  
    // Iterating over Tags 
    for (string objectName : Test.isRunningTest() ? new List<String> { 'TargetSchools' } : requestInfo.GetObjectNames()) {
      
      Set<string> fieldsSet = new Set<string>();
      List<string> fields = new List<string>();
      Loop.ExternalData.QueryResult queryResult ;

      if( objectName == 'TargetSchools') { 
        fieldsSet       = Schema.sObjectType.Targeted_School__c.fields.getMap().keySet(); 
        fields          = new List<string>(fieldsSet);
        queryResult     = new Loop.ExternalData.QueryResult(objectName, fields);
        resultData      = new List<SObject>();
        
        Map<Id,List<CampaignMember>> targetSchoolIdToCampaignMember = new Map<Id,List<CampaignMember>>();
        
        for (CampaignMember cm : [ SELECT 
                                    Targeted_School__c,
                                    Secondary_School_Dual_Enrollment__c,
                                    Dual_Enrollment_Predip_Cred_Course_Com__c 
                                    FROM CampaignMember 
                                    WHERE Targeted_School__c != null 
                                    AND Targeted_School__r.Is_Target_School_for_Program_s__c INCLUDES ('TS Boston','TS Brockton')
                                    AND Active__c = true
                                    AND CampaignId =: requestInfo.RecordId]) {
            if(!targetSchoolIdToCampaignMember.containsKey(cm.Targeted_School__c)) {
              targetSchoolIdToCampaignMember.put(cm.Targeted_School__c,new List<CampaignMember>());
            }
            targetSchoolIdToCampaignMember.get(cm.Targeted_School__c).add(cm);
        }
        
        for (Targeted_School__c ts : [  SELECT 
                                        ID,
                                        NCES_School_ID__c,
                                        Secondary_School_Name__c,
                                        City__c,
                                        State__c,
                                        Zip__c,
                                        Supports_Dual_Enrollment__c
                                        FROM Targeted_School__c 
                                        WHERE ID IN :targetSchoolIdToCampaignMember.keySet()]) {
                                            
          Integer sumAll = 0;
          Integer DualEnrollmentYes = 0;
          Integer collegeCreditFromDual = 0;
          Integer completedDual = 0;
          
          for (CampaignMember cm :targetSchoolIdToCampaignMember.get(ts.Id)) {
              sumAll++;
              if(cm.Secondary_School_Dual_Enrollment__c == 'Yes') {DualEnrollmentYes++;}
              if(cm.Secondary_School_Dual_Enrollment__c == 'Yes') {collegeCreditFromDual++;}
              if(cm.Secondary_School_Dual_Enrollment__c == 'Yes') {completedDual++;}
          }
          
          ts.Name = (ts.Supports_Dual_Enrollment__c? 'Yes': 'No');
          
          ts.Report_Support_1__c = sumAll+'';
          ts.Report_Support_2__c = (ts.Supports_Dual_Enrollment__c? DualEnrollmentYes+'': '9999'); 
          ts.Report_Support_3__c = collegeCreditFromDual+'';
          ts.Report_Support_4__c = completedDual+'';
          resultData.add(ts);
        }
      }

      // Adding processed data to final result that will be sent to drawloop for processing
      for (SObject record : resultData ) {
        List<string> recordValues = new List<string>();
        for (string field : fields) {
          recordValues.add(getFieldValue(record, field));  
        }
        queryResult.rows.add(recordValues);
      }
      queryResultSet.add(queryResult);
    }
    return queryResultSet;
  }
   
  //  This method properly retrieves a field value from an SObject for fields used through lookup relationships
  //  @param sObject obj, string field   
  //  @Return field value stored in the provided object   
  private string getFieldValue(sObject obj, string field) {
    if (obj == null) return '';
    string[] fieldParts = field.split('\\.');
    if (fieldParts.size() == 2) {
      sObject sobj = obj.getSObject(fieldParts[0]);
      if (sobj == null) return '';
        return string.valueOf(sobj.get(fieldParts[1]));
    }
    return string.valueOf(obj.get(field));
  }
}