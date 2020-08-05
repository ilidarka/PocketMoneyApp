@isTest
public class TransactionsControllerTest {
    
    @testSetup
    public static void setup() {
        Transaction__c testTransaction1 = new Transaction__c();
        testTransaction1.Name = 'Test1';
        testTransaction1.Transaction_Date__c = System.today();
        testTransaction1.Money__c = 10;
		testTransaction1.Operation__c = 'Сash receipts';
        testTransaction1.User__r = [SELECT Id, Name FROM User WHERE Name = 'Vladik Leshko' LIMIT 1];
        insert testTransaction1;

        Transaction__c testTransaction2 = new Transaction__c();
        testTransaction2.Name = 'Test2';
        testTransaction2.Transaction_Date__c = System.today();
        testTransaction2.Money__c = 10;
		testTransaction2.Operation__c = 'Сash receipts';
        testTransaction2.User__r = [SELECT Id, Name FROM User WHERE Name = 'Integration User' LIMIT 1];
        insert testTransaction2;
    }
    
    @isTest
    public static void testGetData() {
        User testUser1 = [SELECT Id, Name, Email, Address, Phone FROM User WHERE Name = 'Vladik Leshko']; 
        User testUser2 = [SELECT Id, Name, Email, Address, Phone FROM User WHERE Name = 'Integration User'];
        List<Transaction__c> testTransactionsList = [SELECT Id, Name, Transaction_Date__c, Money__c, Operation__c, User__c 
                                                     FROM Transaction__c];
        System.runAs(testUser1) {
	        TransactionsController.UserWrapper wrapper = new TransactionsController.UserWrapper(testUser1, testTransactionsList);
			wrapper = TransactionsController.getData();
            System.assertEquals('Vladik Leshko', wrapper.userName);
        }
        System.runAs(testUser2) {
	        TransactionsController.UserWrapper wrapper = new TransactionsController.UserWrapper(testUser2, testTransactionsList);
			wrapper = TransactionsController.getData();
            System.assertEquals('Integration User', wrapper.userName);
        }
    }
    
    @isTest
    public static void testDeleteRecord() {
        List<Transaction__c> testTransactionsList = [SELECT Id, Name, Transaction_Date__c, Money__c, Operation__c, User__c 
                                                     FROM Transaction__c];
        System.assertEquals(2, testTransactionsList.size());
		TransactionsController.deleteRecordFromTable(testTransactionsList[0].Id);
        testTransactionsList = [SELECT Id, Name, Transaction_Date__c, Money__c, Operation__c, User__c 
                                FROM Transaction__c];
        System.assertEquals(1, testTransactionsList.size());
    }
    
}