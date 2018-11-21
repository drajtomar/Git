@isTest()
public class AffiliationTriggerHelper_Test {
    
    public static Account insertAccount() {
        
        Account acc = new Account();
        acc.Name = 'Test Hospital';
        acc.Calendar_Logic_OneMDCS__c = true;
        insert acc;
        return acc ;
    }
    
    public static Contact insertContact() {  
        Contact con = new Contact();
        con.LastName = 'TestCon';
        con.Email = 'test@test.com';
        con.NPI__c = '1234567890';
        insert con;
        return con ;
    }
    
    public static testMethod void AffiliationTriggerHelper_Test(){
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        Test.startTest();
        System.runAs( uatUser1 ){
            insertAccount();
            insertContact();
            List <Account> acc = new List <Account>();
            acc = [SELECT Id, Name from Account limit 1];
            List <Contact> con = new List <Contact>();
            con = [SELECT Id, Name from Contact limit 1];
            
            Contact_Details_OneMDCS__c cd = new Contact_Details_OneMDCS__c();
            cd.name = 'CON-001';
            cd.Contact_Id_OneMDCS__c = insertContact().id;
            cd.Hospital_Id_OneMDCS__c = insertAccount().id;
            cd.Contact_Type_OneMDCS__c = 'ER';
            cd.Contact_Name__c = insertContact().name;
            insert cd;
            
            Affiliation__c aff = new Affiliation__c();
            aff.Physician__c = insertContact().id;
            aff.Hospital__c = insertAccount().id;
            insert aff;
			String conName= [Select name from Contact_Details_OneMDCS__c Limit 1].Name;
            System.assertEquals('CON-001', conName);
            String Query = 'Select Id from Affiliation__c limit 1';
			delete aff;
		Test.stopTest();    
        }
        
    }
    public static User getUserRecord( String profileName  ){
        
        String uatProfileId = [SELECT Id FROM Profile WHERE Name =: profileName ].Id;
        User uatuser = new User();
        
        uatuser.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        uatuser.CompanyName = 'J&J Application Services' ;
        uatuser.External_User_Id__c =  '643019306' ;
        uatuser.LastName = 'last';
        uatuser.Email = 'puser000@amamama.com';
        uatuser.Username = 'puser000@amamama.com' + System.currentTimeMillis() ;
        uatuser.CompanyName = 'TEST' ;
        uatuser.Title = 'title' ;
        uatuser.Alias = 'alias' ;
        uatuser.TimeZoneSidKey = 'America/Los_Angeles' ; 
        uatuser.EmailEncodingKey = 'UTF-8' ; 
        uatuser.LanguageLocaleKey = 'en_US' ;
        uatuser.LocaleSidKey = 'en_US' ; 
        uatuser.ProfileId = uatProfileId ;
        uatuser.Primary_Territory_OneMDCS__c = 'WEST BENGAL' ;
        insert uatuser ;
        
        return uatuser  ;        
    }

}