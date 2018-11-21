@isTest
public class test_trg_UpdateAccountKol {
    @testSetup static void setup() {
        Test.startTest();
            List<RecordType> rtypes = [Select Name, Id From RecordType where (sObjectType='Account' OR sObjectType='Contact') and isActive=true];
            //Create a map between the Record Type Name and Id for easy retrieval
            Map<String,String> accountRecordTypes = new Map<String,String>();
            for(RecordType rt: rtypes)
                accountRecordTypes.put(rt.Name,rt.Id);
            // Create common test accounts
            List<Account> testAccts = new List<Account>();
            for(Integer i=0;i<10;i++) {
                testAccts.add(new Account(Name = 'TestAcct'+i,RecordTypeId =accountRecordTypes.get('Cerenovus Account')));
            }
        if(testAccts.size()>0)
             insert testAccts;
             // Create common test Contact
            Integer j=0;
            List<Contact> testContacts = new List<Contact>();
            for(Integer i=0; i<50; i++) {
                if(j==10)j=0;
                testContacts.add(new Contact(LastName = 'TestContact'+i,AccountId = testAccts[j].Id,KOL__c = True,RecordTypeId =accountRecordTypes.get('Cerenovus Fellow')));
                j++;
            }
        if(testContacts.size()>0)
            insert testContacts;
        Test.stopTest();  
    }
    
    @isTest static void testMethodUpdate() {
        List<Contact> testContactsUpdate = new List<Contact>();
        Test.startTest();
            for(Contact con : [SELECT Id,KOL__c FROM Contact Limit 50]){
                con.KOL__c=False;
                testContactsUpdate.add(con);
            }
            if(testContactsUpdate.size()>0)
            update testContactsUpdate;
           
            Account acco;
            for(Account acc:[SELECT Id,Kol_Cere__c from Account Limit 1])
            {
                acco=acc;
            }
         Test.stopTest();
        System.assert(acco.Kol_Cere__c==False);
    }
    
    @isTest static void testMethodDelete() {
        List<Contact> testContactsUpdate = new List<Contact>();
        List<Id> tesId = new List<Id>();
        Integer i=0;
        string ConName = 'TestContact0';
        List<Id> conIds=new List<Id>();
        List<Affiliation__c> affiIds=new List<Affiliation__c>();
        Test.startTest();
            for(Contact con : [SELECT Id,KOL__c,AccountId FROM Contact WHERE Name =: ConName LIMIT 30]){
                i++;
                conIds.add(con.Id);
                tesId.add(con.AccountId);
                ConName = 'TestContact'+i;
                testContactsUpdate.add(con);
            }
            affiIds=[SELECT Id FROM Affiliation__c WHERE Physician__c In:conIds];
            if(affiIds.size()>0){
                delete affiIds;
            }
        	if(testContactsUpdate.size()>0)
            	delete  testContactsUpdate;
            
            Account acco;
            for(Account acc:[SELECT Id,KOL_Cere__c from Account where Id Not In: tesId limit 1])
            {
                acco=acc;
            }
        Test.stopTest();
        System.assert(acco.Kol_Cere__c==True);
    }
}