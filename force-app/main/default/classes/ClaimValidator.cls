public class ClaimValidator {

    public static void validateClaim(Claim__c claimRecord) {

        // 1. Fetch Policy
        Policy__c pol = [SELECT Id, Coverage_Amount__c 
                         FROM Policy__c WHERE Id = :claimRecord.Policy__c];

        // 2. Calculate already claimed amount
        AggregateResult agg = [
            SELECT SUM(Claim_Amount__c) totalClaimed
            FROM Claim__c
            WHERE Policy__c = :claimRecord.Policy__c
            AND Status__c != 'Rejected'
        ];

        Decimal alreadyClaimed = (Decimal)agg.get('totalClaimed');
        Decimal remaining = pol.Coverage_Amount__c - alreadyClaimed;

        // 3. Business validation
        if (claimRecord.Claim_Amount__c > remaining) {
            throw new AuraHandledException(
                'Claim amount exceeds remaining coverage. Remaining: ' + remaining
            );
        }
    }
}