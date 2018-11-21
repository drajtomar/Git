@isTest
private class TestContactOwnerChangeonUserInactive{
  static testMethod void test_mixed_dmlbug() {  
    User u;
    Contact c;      
    User thisUser = [ select Id from User where profile.name ='System Administrator' AND IsActive=true Limit 1];
    System.runAs ( thisUser ) {
        Profile p = [select id from profile where name='System Administrator'];
       // UserRole r = [Select id from userrole where name='(some role)'];
        u = new User(alias = 'standt11', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', 
            CompanyName = 'ABC Comapany',
            External_User_Id__c = '1234567',
            username='standarduser11@testorg11.com');
        insert u;
        
    }
    System.runAs(u) {
        Contact_Owner__c  co = new Contact_Owner__c();
        co.Name = 'owner';
        co.UserId__c = thisUser.id;
        insert co;
        c= new Contact();
        c.lastname = 'tester';
        c.NPI__c = '1111100000';
        insert c;
        String conName= [Select lastname from Contact Limit 1].lastname;
        System.assertEquals('tester',conName);
    }
    System.runAs ( thisUser )
    {
      u.isactive=false;
      update u;
    }

}
}