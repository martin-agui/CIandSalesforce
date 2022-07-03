public with sharing class ProjectCalloutService {
    @InvocableMethod
    public static void PostOpportunityToPMS(List<Id> oppsId){
        if(!oppsId.isEmpty()){
            System.enqueueJob(new QueueablePMSCall(oppsId));
        }
    }

    public class QueueablePMSCall implements Queueable,Database.AllowsCallouts{
        List<Id> oppsId;
        public QueueablePMSCall(List<Id> oppsId){
            this.oppsId = oppsId;
        }
        public void execute(QueueableContext context){
            List<Opportunity> opps = [
                SELECT  Id , Name ,Account.Name,
                        CloseDate, Amount, StageName
                FROM Opportunity
                WHERE Id =: this.oppsId[0]
            ];
            if (opps.isEmpty()) {
                return;
            }
            Opportunity oppToSend = opps[0];
            Map<String,Object> requestBody = new Map<String,Object>{
                'opportunityId'=>oppToSend.Id,
                'opportunityName'=>oppToSend.Name,
                'accountName'=>oppToSend.Account.Name,
                'closeDate'=>oppToSend.CloseDate,
                'amount'=>oppToSend.Amount
            };
            System.debug('requestBody --> ' +requestBody);
            ServiceTokens__c serviceTokens = ServiceTokens__c.getValues('ProjectServiceToken');
            System.debug('serviceTokens --> ' +serviceTokens);
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setHeader('token', serviceTokens.token__c);
            httpRequest.setEndpoint('callout:ProjectService');
            httpRequest.setBody(JSON.serialize(requestBody));
            System.debug(httpRequest.getHeader('token'));
            System.debug(httpRequest.getBody());
            HttpResponse httpResponse = http.send(httpRequest);
            if(httpResponse.getStatusCode() == 200){
                oppToSend.StageName = 'Submitted Project';
                update oppToSend;
            }else{
                oppToSend.StageName = 'Resubmit Project';
                update oppToSend;
            }
            return;
        }
    }

}