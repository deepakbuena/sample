public class ScheduleBatchSendInvoiceRemider30 implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        Database.executeBatch(new BatchSendInvoiceRemider30(), 1000);
    }
}