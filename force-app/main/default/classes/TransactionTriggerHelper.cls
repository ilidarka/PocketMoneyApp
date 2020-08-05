public class TransactionTriggerHelper {
    
    public static void checkNewTransaction(List<Transaction__c> newTransactions) {
        if(newTransactions != null) {
            Double totalAmountOfMoney = 0;
            String userId = UserInfo.getUserId();
	        User currentUser = Database.query('SELECT Id, Name, Balance__c FROM User WHERE Id =: userId LIMIT 1');
            for(Transaction__c tr : newTransactions) {
                if(tr.Operation__c == 'Writing off money' && totalAmountOfMoney < currentUser.Balance__c && currentUser.Balance__c >= 0) {
                    totalAmountOfMoney += tr.Money__c;
                    currentUser.Balance__c -= tr.Money__c;
                } else if(tr.Operation__c == 'Сash receipts') {
                    currentUser.Balance__c += tr.Money__c;
                }
                if(totalAmountOfMoney > currentUser.Balance__c) {
	                tr.addError('Not enough money!');
                }
            }
            update currentUser;
        }
    }
    
    public static void checkUpdateTransaction(List<Transaction__c> newTransactions, List<Transaction__c> oldTransactions) {
        if(newTransactions != null) {
            String userId = UserInfo.getUserId();
	        User currentUser = Database.query('SELECT Id, Name, Balance__c FROM User WHERE Id =: userId LIMIT 1');
            for(Transaction__c newTr : newTransactions) {
                for(Transaction__c oldTr : oldTransactions) {
                    currentUser.Balance__c += oldTr.Money__c - newTr.Money__c;
                }
            }
            update currentUser;
        }
    }
}