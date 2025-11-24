public class BatchClaimReconciliation implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Claim_Number__c, Claim_Amount__c FROM Claim__c WHERE Claim_Status__c = \'Approved\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Claim__c> scope) {

        for (Claim__c c : scope) {

            // simulate finance API sync
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://finance-api/syncClaim'); // mock URL
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody('{"claimNumber":"'+ c.Claim_Number__c +'","amount":"'+ c.Claim_Amount__c +'"}');

            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                c.Reconciliation_Status__c = 'Synced';
            } else {
                c.Reconciliation_Status__c = 'Failed';
            }
        }

        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Completed Successfully');
    }
}