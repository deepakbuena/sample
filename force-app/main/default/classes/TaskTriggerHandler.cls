public with sharing class TaskTriggerHandler {

	public static void completeProposalEmail(Task[] listTask){

		Set<Id> listOpptyId = new Set<Id>();

		for(Task t : listTask){

			listOpptyId.add(t.WhatId);
		}

		Opportunity[] listOppty = [SELECT OwnerId, Owner.isActive, Name FROM Opportunity WHERE Id IN :listOpptyId];

		Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};

		for(Opportunity oppty : listOppty){

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();		  
			mail.setTargetObjectId(oppty.OwnerId);
			mail.setReplyTo(UserInfo.getUserEmail());
			mail.setSenderDisplayName(UserInfo.getName());
			mail.setSubject(oppty.Name + ': Proposal Complete.');
			mail.setPlainTextBody('Your proposal request for ' + oppty.Name +' is complete and ready to send to the client.\n\n' 
									+ 'Opportunity Link: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppty.Id);
			mail.setSaveAsActivity(false);
			mailList.add(mail);
		}

		Messaging.sendEmail(mailList);

	}
}