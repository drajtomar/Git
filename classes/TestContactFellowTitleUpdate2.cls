@isTest
public class TestContactFellowTitleUpdate2 {
	static testMethod void dtTests()
    {
	Id conRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'EP Fellow'].id;
        	//Create the test account
   		  	Account AccToCreate = new Account();
        	AccToCreate.Name='BWIAcc';
       	   	Insert AccToCreate;
			Contact c = new Contact();
        	c.FirstName = 'Sergio';
        	c.LastName = 'Flores';
        	c.NPI__c = '1234567890';
        	c.RecordTypeId = conRecordType;
        	c.Custom_Title__c = 'First Year EP Fellow';
        	c.AccountId = AccToCreate.Id;
        	insert c;
            
        	Contact c2 = new Contact();
        	c2.FirstName = 'Ben';
        	c2.LastName = 'Huang';
        	c2.NPI__c = '2345678901';
        	c2.RecordTypeId = conRecordType;
        	c2.Custom_Title__c = 'Second Year EP Fellow';
        	c2.AccountId = AccToCreate.Id;
        	insert c2;
			//----Pull contacts from the contact object where they match first and second year then requery
			//----and match them in the system.assertEquals method
        
        Contact secondYearFellow = [SELECT ID, Custom_Title__c
                                    FROM Contact 
                                    WHERE Custom_Title__c = 'Second Year EP Fellow'
                                    Limit 1];
        system.debug('secondYearFellow' + secondYearFellow);
        
        Contact firstYearFellow =  [SELECT ID, Custom_Title__c
                                    FROM Contact 
                                    WHERE Custom_Title__c= 'First Year EP Fellow'
                                    Limit 1];
        system.debug('firstYearFellow' + firstYearFellow);
        
        ContactFellowTitleUpdate2 cftu = new ContactFellowTitleUpdate2();
        cftu.isTesting();
        cftu.UpdateFellowTitle2();
        
        
        Contact c3 = [Select ID, Custom_Title__c
                      From Contact
                      Where id =: secondYearFellow.id];
        
        Contact c4 = [Select ID, Custom_Title__c
                      From Contact
                      Where id =: firstYearFellow.Id];
        
        system.assertEquals('Attending', c3.Custom_Title__c );
        system.assertEquals('Second Year EP Fellow', c4.Custom_Title__c);
       
    }
}