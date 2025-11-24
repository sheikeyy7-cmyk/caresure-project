trigger ClaimTrigger on Claim__c (before insert, before update) {

    for (Claim__c c : Trigger.new) {
        ClaimValidator.validateClaim(c);
    }

    if (Trigger.isBefore && Trigger.isInsert) {
        ClaimAutoApproval.process(Trigger.new);
    }
}