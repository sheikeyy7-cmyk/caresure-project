trigger ClaimNumberTrigger on Claim__c (after insert) {

    List<Claim__c> updates = new List<Claim__c>();

    for (Claim__c c : Trigger.new) {

        if (String.isBlank(c.Claim_Number__c)) {

            // Get Date
            Date d = Date.today();

            // Year-Month-Day padded manually
            String yearStr  = String.valueOf(d.year());
            String monthStr = (d.month() < 10) ? '0' + d.month() : String.valueOf(d.month());
            String dayStr   = (d.day() < 10) ? '0' + d.day()   : String.valueOf(d.day());

            String dt = yearStr + monthStr + dayStr;

            // Random number (0–999)
            Integer rnd = Math.mod(Math.abs(Crypto.getRandomInteger()), 1000);

            // Manually pad random number to 3 digits
            String rndStr = '';
            if (rnd < 10) {
                rndStr = '00' + rnd;
            } else if (rnd < 100) {
                rndStr = '0' + rnd;
            } else {
                rndStr = String.valueOf(rnd);
            }

            // Final Claim Number
            c.Claim_Number__c = 'CLM-' + dt + '-' + rndStr;

            updates.add(c);
        }
    }

    if (!updates.isEmpty()) {
        update updates;
    }
}