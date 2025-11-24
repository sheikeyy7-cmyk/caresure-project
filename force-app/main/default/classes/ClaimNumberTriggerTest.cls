@isTest
public class ClaimNumberTriggerTest {
    @isTest
    static void testNumberGeneration() {

        Policy__c p = new Policy__c(
            Name = 'Test',
            Start_Date__c = Date.today().addDays(-10),
            End_Date__c = Date.today().addDays(10)
        );
        insert p;

        Claim__c c = new Claim__c(
            Name = 'Test Claim',
            Policy__c = p.Id,
            Status__c = 'New'
        );

        insert c;

        Claim__c inserted = [SELECT Claim_Number__c FROM Claim__c LIMIT 1];

        System.assertNotEquals(null, inserted.Claim_Number__c);
        System.assert(inserted.Claim_Number__c.startsWith('CLM-'));
    }
}