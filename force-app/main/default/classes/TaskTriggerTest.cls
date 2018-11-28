@isTest
private class TaskTriggerTest {
	
	static testmethod void testTaskTriggerHandler(){

		//Test when a 'Begin Proposal Process' task has its status changed to 'Completed', it should send an email
		Account acct = new Account();
		acct.Name = 'ACME';

		insert acct;

		Opportunity oppty = new Opportunity();
		oppty.Name = 'Deal ' + System.today().year().format().remove(',');
		oppty.AccountId = acct.Id;
		oppty.Type = 'Standard';
		oppty.LeadSource = 'Advertisement';
		oppty.CloseDate = System.today().addDays(30);
		oppty.StageName = 'Proposal';

		insert oppty;

		Task proposalTaskInProgress = new Task();
		proposalTaskInProgress.Subject = 'Begin Proposal Process';
		proposalTaskInProgress.Type = 'Email';
		proposalTaskInProgress.Status = 'In Progress';
		proposalTaskInProgress.Priority = 'Normal';
		proposalTaskInProgress.WhatId = oppty.Id;
		
		insert proposalTaskInProgress;

		Test.startTest();

		proposalTaskInProgress.Status = 'Completed';
		update proposalTaskInProgress;

		//Test a manually created 'Begin Proposal Process' task with Status of 'Completed'
		Task proposalTaskCompleted = new Task();
		proposalTaskCompleted.Subject = 'Begin Proposal Process';
		proposalTaskCompleted.Type = 'Email';
		proposalTaskCompleted.Status = 'Completed';
		proposalTaskCompleted.Priority = 'Normal';
		proposalTaskCompleted.WhatId = oppty.Id;
		insert proposalTaskCompleted;

		Test.stopTest();


	}
}