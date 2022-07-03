// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

Map<String,Object> requestBody = new Map<String,Object>{
    'opportunityId'=>'opportunityId',
    'opportunityName'=>'opportunityName',
    'accountName'=>'accountName',
    'closeDate'=>'closeDate',
    'amount'=>'amount'
};

System.debug(JSON.serialize(requestBody));


List<Id> oppsId = new List<Id>{'0068c00000sAaXQAA0'};
ProjectCalloutService.PostOpportunityToPMS(oppsId);

ServiceTokens__c serviceTokens = ServiceTokens__c.getValues('ProjectServiceToken');
System.debug(serviceTokens.token__c);


System.debug([SELECT DeveloperName,Endpoint,Id,MasterLabel,PrincipalType FROM NamedCredential]);
