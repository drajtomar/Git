@isTest(SeeAllData = false)
public class UpdateTerritoryTrigger_OneMDCS_TEST{
    
    public static User createUser() {
        User u = new User();
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        u.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        u.CompanyName = 'J&J Application Services' ;
        u.External_User_Id__c =  '643019306' ;
        u.LastName = 'last';
        u.Email = 'puser000@amamama.com';
        u.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        //u.ContactId = con.Id;
        // system.debug('con.id---'+con.id);
        insert u;
        
        return u ;
        
    }
    
    public static User portalUser() {
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User u = new User();
        u.UserRoleId = portalRole.Id ;
        u.ProfileId = [SELECT Id FROM Profile WHERE  name  = 'System Administrator' limit 1].Id;
        u.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        u.CompanyName = 'J&J Application Services' ;
        u.External_User_Id__c =  '643019306' ;
        u.LastName = 'last';
        u.Email = 'puser000@amamama.com';
        u.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        //u.ContactId = con.Id;
        // system.debug('con.id---'+con.id);
        //insert u;
        
        return u ;
        
    }
    
    public static User createUser2() {
        
        //UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        User u = new User();
        //u.UserRoleId = portalRole.Id ;
        u.ProfileId = [SELECT Id FROM Profile WHERE  name  = 'External User - Customer Case Scheduler' limit 1].Id;
        //u.ProfileId = [SELECT Id FROM Profile WHERE  name = 'Custom Community User' limit 1].Id;
        u.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        u.CompanyName = 'J&J Application Services' ;
        u.External_User_Id__c =  '643019306' ;
        u.LastName = 'last';
        u.Email = 'puser000@amamama.com';
        u.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        u.CompanyName = 'TEST';
        u.Title = 'title';
        u.Alias = 'alias';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        //u.ContactId = con.Id;
        // system.debug('con.id---'+con.id);
        //insert u;
        
        return u ;
        
    }
    
    public static Territory insertTeritorry() {
        
        Territory t = new Territory();
        t.External_Territory_Id__c = 'TE';
        t.Name = 'test';
        // t.ForecastUserId = u.id;
        insert t;
        
        return t ;
    }
    
    public static Combine_Territory__c insertcombineterritory(){
        Combine_Territory__c ct = new Combine_Territory__c();
        ct.Name = 'test';
        ct.Territory__c = 'test;test1';
        ct.Old_Name__c = 'testpar';
        
        insert ct;
        return ct;
    }
    
    public testmethod static void testUserAndContact() {
        
        User user1 = createUser() ;
        
        
        User portalUser;
        
        System.runAs( user1){
            
            portalUser = portalUser();
            
            
            insert portalUser ;
        }
        
        Account acc = new Account();
        Contact con = new Contact();
        
        System.runAs( user1 ){
            
            insertTeritorry();
            Combine_Territory__c ctr = insertcombineterritory();
            //Account acc = new Account();
            acc.Name = 'Test' ;
            acc.Territory__c = 'TE' ;
            acc.ownerID = portalUser.Id ;
            
            insert acc ;
            
            //Contact con = new Contact();
            con.FirstName = 'Test' ;
            con.LastName = 'last' ;
            con.NPI__c =  '0123456789' ;
            con.AccountId = acc.id;
            con.Territory__c = 'TE';
            //con.ownerID = user2.Id  ;
            insert con ;
            system.debug('con.id---'+con.id);
            
            
        }
        
        User newUser ;
        
        System.runAs( user1 ){
            newUser = createUser2();
            newUser.ContactId =  con.Id ;
            
            insert newUser ;
             list<User> u = [SELECT Id,Name,Primary_Territory_OneMDCS__c FROM User WHERE  Id  =: newUser.id];
            system.debug('@@@@@ u: @@@@---'+con.id);
             System.assertEquals('test' , u[0].Primary_Territory_OneMDCS__c ) ; 
        }
        
    }
    
}