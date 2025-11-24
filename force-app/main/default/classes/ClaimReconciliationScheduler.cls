public class ClaimReconciliationScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        BatchClaimReconciliation b = new BatchClaimReconciliation();
        Database.executeBatch(b, 50);
    }
}