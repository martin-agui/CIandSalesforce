@isTest
private class ProjectRESTServiceTest {
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
  }
	@isTest
  static void testProjectEmpty(){
    String ProjectName = 'ProjectName';
    String ProjectRef = '1A';
    String OpportunityId = [SELECT Id FROM Opportunity LIMIT 1]?.Id;
    Date StartDate = Date.today();
    Date EndDate = Date.today().addMonths(1);
    Double Amount = 200;
    String Status = 'Running';

    Test.startTest();
    ProjectRESTService.postProjectData(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
    Test.stopTest();
    List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
    System.assertEquals(1, projects.size());
    Opportunity opportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
    System.assertEquals('In progress', opportunity.DeliveryInstallationStatus__c);
  }
  @isTest
  static void testProjectNotEmpty(){
		String ProjectName = 'ProjectName';
    String ProjectRef = '1A';
    String OpportunityId = [SELECT Id FROM Opportunity LIMIT 1]?.Id;
    Date StartDate = Date.today();
    Date EndDate = Date.today().addMonths(1);
    Double Amount = 200;
    String Status = 'Running';

		Project__c project = new Project__c();
		project.Billable_Amount__c = Amount;
    project.End_Date__c = EndDate;
    project.Name = ProjectName;
    project.Opportunity__c = OpportunityId;
    project.ProjectRef__c = ProjectRef;
    project.Start_Date__c = StartDate;
    project.Status__c = Status;
		insert project;

		Test.startTest();
		try{
			ProjectRESTService.postProjectData(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
		} catch (DmlException ex) {
				System.assertEquals('Field is not writeable: Project__c.Opportunity__c', ex.getMessage());
		}  
		Test.stopTest();
	}
}	
// {
  //   "ProjectName":"ProjectName",
  //  "ProjectRef":"1A",
  //  "OpportunityId":"0068c00000sAaXnAAK",
  //  "StartDate":"2022-06-07",
  //  "EndDate":"2022-09-07",
  //  "Amount":500,
  //  "Status":"Running"
   
  //  }
	// Field is not writeable: Project__c.Opportunity__c