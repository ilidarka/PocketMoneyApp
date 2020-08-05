@isTest
public class TransactionTriggerHelperTest {
    
    @isTest
    public static void testNewTransactionWrittingOff() {
        User usr1 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1190, usr1.Balance__c);
        Test.startTest();
        Transaction__c testTransaction1 = new Transaction__c(Name = 'Test Transaction', 
                                                             Transaction_Date__c = System.today(),
                                                             Money__c = 10,
                                                             Operation__c = 'Writing off money',
                                                             User__r = [SELECT Id, Name FROM User WHERE Name = 'Vladik Leshko' LIMIT 1]);
        insert testTransaction1;
        Test.stopTest();
        User usr2 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1180, usr2.Balance__c);
    }
    
    @isTest
    public static void testNewTransactionWrittingOffNegative() {
        Test.startTest();
        Transaction__c testTransaction2 = new Transaction__c(Name = 'Test Transaction', 
                                                             Transaction_Date__c = System.today(),
                                                             Money__c = 1000000,
                                                             Operation__c = 'Writing off money',
                                                             User__r = [SELECT Id, Name FROM User WHERE Name = 'Vladik Leshko' LIMIT 1]);
        Database.SaveResult result = Database.insert(testTransaction2, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Not enough money!', result.getErrors()[0].getMessage());
    }
    
    @isTest
    public static void testNewTransactionCashReceipts() {
        User usr1 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1190, usr1.Balance__c);
        Test.startTest();
        Transaction__c testTransaction3 = new Transaction__c(Name = 'Test Transaction', 
                                                             Transaction_Date__c = System.today(),
                                                             Money__c = 10,
                                                             Operation__c = 'Сash receipts',
                                                             User__r = [SELECT Id, Name FROM User WHERE Name = 'Vladik Leshko' LIMIT 1]);
        insert testTransaction3;
        Test.stopTest();
        User usr2 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1200, usr2.Balance__c);
    }
    
    @isTest
    public static void testUpdateTransaction() {
        User usr1 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1190, usr1.Balance__c);
        Test.startTest();
        Transaction__c testTransaction = new Transaction__c(Name = 'Test Transaction', 
                                                             Transaction_Date__c = System.today(),
                                                             Money__c = 100,
                                                             Operation__c = 'Writing off money',
                                                             User__r = [SELECT Id, Name FROM User WHERE Name = 'Vladik Leshko' LIMIT 1]);
        insert testTransaction;
        testTransaction.Money__c = 90;
        Database.SaveResult result = Database.update(testTransaction, false);
        Test.stopTest();
        User usr2 = [SELECT Id, Name, Balance__c FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        System.assertEquals(1100, usr2.Balance__c);
    }
}