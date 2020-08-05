trigger TransactionTrigger on Transaction__c (before insert, before update) {
    if(Trigger.isInsert) {
        TransactionTriggerHelper.checkNewTransaction(Trigger.new);
    } else if(Trigger.isUpdate) {
        TransactionTriggerHelper.checkUpdateTransaction(Trigger.new, Trigger.old);
    }
}