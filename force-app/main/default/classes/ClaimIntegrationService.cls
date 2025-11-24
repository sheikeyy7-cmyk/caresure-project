public class ClaimIntegrationService implements Queueable, Database.AllowsCallouts {

    private String claimId;

    public ClaimIntegrationService(String claimId) {
        this.claimId = claimId;
    }

    public void execute(QueueableContext context) {

        Claim__c claim = [SELECT Id, Claim_Number__c FROM Claim__c WHERE Id = :claimId LIMIT 1];

        // Simulated external API callout
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://dummy-api/validateClaim'); // mock URL
        req.setMethod('POST');
        req.setBody('{"claimNumber":"'+ claim.Claim_Number__c +'"}');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = http.send(req);

        // Update status
        if (res.getStatusCode() == 200) {
            claim.Status__c = 'Externally Validated';
        } else {
            claim.Status__c = 'Integration Failed';
        }

        update claim;
    }
}