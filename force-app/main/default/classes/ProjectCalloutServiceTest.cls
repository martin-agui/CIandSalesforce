@isTest
public with sharing class ProjectCalloutServiceTest {
    @TestSetup
    public static void createData(){
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
        ServiceTokens__c cs = new ServiceTokens__c();
        cs.Name='ProjectServiceToken';
        cs.token__c= 't1o2k3e4n5';
        insert cs;
    }

    @isTest
    public static void projectCalloutServiceMock(){
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        List<Id> oppsId = new List<Id>();
        oppsId.add([SELECT Id,Name FROM Opportunity WHERE Name = 'Opp Test' LIMIT 1]?.Id);
        Test.startTest();
        ProjectCalloutService.PostOpportunityToPMS(oppsId);
        Test.stopTest();
        Opportunity opp = [SELECT Id,Name, StageName FROM Opportunity WHERE Name = 'Opp Test' LIMIT 1];
        System.assertEquals('Submitted Project', opp.StageName);
    } 
    @isTest
    public static void projectCalloutServiceMockFailure(){
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        List<Id> oppsId = new List<Id>();
        oppsId.add([SELECT Id,Name FROM Opportunity WHERE Name = 'Opp Test' LIMIT 1]?.Id);
        Test.startTest();
        ProjectCalloutService.PostOpportunityToPMS(oppsId);
        Test.stopTest();
        Opportunity opp = [SELECT Id,Name, StageName FROM Opportunity WHERE Name = 'Opp Test' LIMIT 1];
        System.assertEquals('Resubmit Project', opp.StageName);
    } 
}
