public class BillingCalloutService {
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal amount){
        ServiceCredentials__c billingServiceCredential = ServiceCredentials__c.getValues('BillingServiceCredential');
        String username =billingServiceCredential.Username__c;
        String password =billingServiceCredential.Password__c;
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.billAmount = amount;
        project.projectid = projectRef;
        project.username = username;
        project.password = password;
        BillingServiceProxy.InvoicesPortSoap11 invoiceService = new BillingServiceProxy.InvoicesPortSoap11();
        String responseStatus = invoiceService.billProject(project);
        System.debug('response --> ' + responseStatus);
        if (responseStatus.equals('OK')) {
            try {
                Project__c projectSalesforce = [SELECT Id, Status__c, ProjectRef__c FROM Project__c WHERE ProjectRef__c =: projectRef];
                projectSalesforce.Status__c = 'Billed';
                update projectSalesforce;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
            return;
        }
    }
}