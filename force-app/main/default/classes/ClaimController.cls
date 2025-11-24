public with sharing class ClaimController {
    @AuraEnabled
    public static String createClaim(String policyId, Decimal amount, ) {

        Claim__c c = new Claim__c(
            Policy__c = policyId,
            Claim_Amount__c = amount,
            
            Status__c = 'Submitted'
        );

        insert c;
        return c.Id;
    }
}
