public with sharing class ClaimListController {
    @AuraEnabled(cacheable=true)
    public static List<Claim__c> getMyClaims(String policyId) {
        return [
            SELECT Id, Claim_Amount__c, Status__c, CreatedDate
            FROM Claim__c
            WHERE Policy__c = :policyId
            ORDER BY CreatedDate DESC
        ];
    }
}