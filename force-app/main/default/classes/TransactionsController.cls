public class TransactionsController {
    
    @AuraEnabled
    public static UserWrapper getData() {
        String userId = UserInfo.getUserId();
        User currentUser = Database.query('SELECT Id, Name, Email, Address, Phone FROM User WHERE Id =: userId LIMIT 1');
        List<Transaction__c> transactionsList = Database.query('SELECT Id, Name, Transaction_Date__c, Money__c, Operation__c ' + 
                                                               'FROM Transaction__c ' + 
                                                               'WHERE User__r.Id =: userId ' + 
                                                               'ORDER BY Transaction_Date__c DESC');
		UserWrapper wrapper = new UserWrapper(currentUser, transactionsList);
        return wrapper;
    }
    
    @AuraEnabled
    public static UserWrapper deleteRecordFromTable(Id idRecordToDelete) {
        Transaction__c transactionToDelete = [SELECT Id
                                              FROM Transaction__c
                                              WHERE Id =: idRecordToDelete
                                              LIMIT 1];
        delete transactionToDelete;
        return getData();
    }
    
    public class UserWrapper {
		@AuraEnabled
        public id userId;
		@AuraEnabled
        public String userName;
		@AuraEnabled
        public String userEmail;
		@AuraEnabled
        public String userAdress;
		@AuraEnabled
        public String userMobile;
		@AuraEnabled
        public List<Transaction__c> userTransactions;
        
        public UserWrapper(User currentUser, List<Transaction__c> transactionsList) {
            this.userId = currentUser.Id;
            this.userName = currentUser.Name;
            this.userEmail = currentUser.Email;
            this.userAdress = currentUser.Address.getCity();
            this.userMobile = currentUser.Phone;
            this.userTransactions = transactionsList;
        }
    }
}