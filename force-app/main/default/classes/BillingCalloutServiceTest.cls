@isTest
private class BillingCalloutServiceTest {
	@TestSetup
	static void makeData(){
		Account account = new Account();
		account.Name = 'Account Consumer';
		insert account;
		Opportunity opp = new Opportunity();
		opp.Name = 'Opp Test'; 
		opp.Account = account;
		opp.CloseDate = Date.today().addMonths(1);
		opp.Amount = 250;
		opp.StageName = 'Closed Won';
		opp.Type = 'New Project';
		insert opp;
		Project__c project = new Project__c();
		project.Billable_Amount__c = 200;
		project.End_Date__c = Date.today().addMonths(1);
		project.Name = 'ProjectName';
		project.Opportunity__c = opp.Id;
		project.ProjectRef__c = '1A';
		project.Start_Date__c = Date.today();
		project.Status__c = 'Running';
		insert project;
		ServiceCredentials__c sc = new ServiceCredentials__c();
        sc.Name='BillingServiceCredential';
        sc.Username__c='bsUser1';
        sc.Password__c= 'bsPass1';
        insert sc;
	}
	@isTest
	static void executeOk(){
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		Project__c project = [SELECT Id,ProjectRef__c,Status__c FROM Project__c WHERE ProjectRef__c = '1A'];
		project.Status__c = 'Billable';
		Test.startTest();
		update project;
		Test.stopTest();
		Project__c projectUpdate = [SELECT Id,ProjectRef__c,Status__c FROM Project__c WHERE ProjectRef__c = '1A'];
		System.assertEquals('Billed', projectUpdate.Status__c);
	}
	@isTest
	static void executeError(){
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
		Project__c project = [SELECT Id,ProjectRef__c,Status__c FROM Project__c WHERE ProjectRef__c = '1A'];
		project.Status__c = 'Billable';
		Test.startTest();
		update project;
		Test.stopTest();
		Project__c projectUpdate = [SELECT Id,ProjectRef__c,Status__c FROM Project__c WHERE ProjectRef__c = '1A'];
		System.assertEquals('Billable', projectUpdate.Status__c);
	}
}