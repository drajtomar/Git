/*
*******************************************  This is a Test Class of customLookUpController ***************************
Main Class : Appointment_Process_OneMDCS
Created date : 08/01/2017
Created By : Capgemini
*/

@isTest(SeeAllData = false)
public class customLookUpControllerTEST_OneMDCS
{
    public static  User uatuser;
    public static User uatuserTrainee;
    public static User uatbwiUser;
    public static Account objAcc;
    public static Contact objCon;
    public static Available_Services_OneMDCS__c objProcedure;
    public static Appointment_OneMDCS__c objAppFuture;
    public static Appointment_OneMDCS__c objAppPast;
    public static Appointment_OneMDCS__c objAppFuture1;

   
    public static testMethod void CustomLookupTest() 
    {
        
         testUser();
        //Create Account
        User uatAdmin= [SELECT Id, Name from User WHERE profile.name ='System Administrator' AND IsActive = true limit 1 ];
        System.runAs(uatAdmin){
        Id userId = UserInfo.getUserId();
        objAcc = new Account();
        objAcc.Name = 'Test Hospital';
        insert objAcc;
        
        User objUser1 = new User();
        objUser1 = [SELECT Id, Name from User WHERE profile.name ='Clinical Account Specialist' AND IsActive = true limit 1];
        
        User objUser2 = new User();
        objUser2 = [SELECT Id, Name from User WHERE profile.name ='BWI Case Scheduler' AND IsActive = true limit 1];
        
        List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
        
        Availability_Of_CAS_OneMDCS__c inserDefault = new Availability_Of_CAS_OneMDCS__c();
        inserDefault.Name = objUser1.Name;
        inserDefault.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        inserDefault.AM_OneMDCS__c = True;
        inserDefault.Availability_CAS_OneMDCS__c = True;
        inserDefault.CAS_Team_OneMDCS__c = objUser1.Id;
        inserDefault.Default_OneMDCS__c = 'Y';
        inserDefault.Morning_Slot_OneMDCS__c = '08:00;12:00';
        inserDefault.PM_OneMDCS__c = True;
        inserDefault.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert inserDefault;
        
        String searchKey = objUser1.Name;
        String objName = 'user';
        List <sObject> fetchLookUpValueList = customLookUpController.fetchLookUpValues(searchKey, objName, 'Out of Territory CAS');
        searchKey = objUser2.Name;
        List <sObject> fetchLookUpValuesTrainee = customLookUpController.fetchLookUpValues(searchKey, objName, 'Trainee CAS');
        System.assertEquals(true,fetchLookUpValueList.size()>0);
        
        /*String searchKeyAcc = 'Test';
        String objNameAcc = 'Account';
List <sObject> fetchLookUpValuesAcc = customLookUpController.fetchLookUpValues(searchKeyAcc, objNameAcc);*/ 
        }
    }
    
    public static void testUser()
    {
         //Create User
        UserRole uatUserrole = [ SELECT id from UserRole where DeveloperName = 'Area_Director'];
        String uatProfileId = [SELECT Id FROM Profile WHERE Name = 'Clinical Account Specialist' ].Id;
        String uatProfileIdTrainee = [SELECT Id FROM Profile WHERE Name = 'Trainee CAS' ].Id;
        String ustProfileBWi=[SELECT Id FROM Profile WHERE Name = 'BWI Case Scheduler'].Id;        
        
        uatuser = new User();
        
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
        uatuser.UserRoleId = uatUserrole.Id  ; 
        uatuser.ProfileId = uatProfileId ;
        uatuser.Primary_Territory_OneMDCS__c = 'Test Territory';
        
        insert uatuser ;
        
        uatuserTrainee = new User();
        
        uatuserTrainee.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        uatuserTrainee.CompanyName = 'J&J Application Services' ;
        uatuserTrainee.External_User_Id__c =  '643019306' ;
        uatuserTrainee.LastName = 'last';
        uatuserTrainee.Email = 'puserTrainee000@amamama.com';
        uatuserTrainee.Username = 'puser000@amamama.com' + System.currentTimeMillis() ;
        uatuserTrainee.CompanyName = 'TEST1' ;
        uatuserTrainee.Title = 'title' ;
        uatuserTrainee.Alias = 'alias' ;
        uatuserTrainee.TimeZoneSidKey = 'America/Los_Angeles' ; 
        uatuserTrainee.EmailEncodingKey = 'UTF-8' ; 
        uatuserTrainee.LanguageLocaleKey = 'en_US' ;
        uatuserTrainee.LocaleSidKey = 'en_US' ; 
        uatuserTrainee.UserRoleId = uatUserrole.Id  ; 
        uatuserTrainee.ProfileId = uatProfileIdTrainee;
        uatuserTrainee.Primary_Territory_OneMDCS__c = 'Test Territory';
        
        insert uatuserTrainee ;
        
        uatbwiUser = new User();
        
        uatbwiUser.CommunityNickname = 'rbaner14' + System.currentTimeMillis() ;
        uatbwiUser.CompanyName = 'J&J Application Services' ;
        uatbwiUser.External_User_Id__c =  '643019304' ;
        uatbwiUser.LastName = 'last';
        uatbwiUser.Email = 'puserTrainee000@amamama.com';
        uatbwiUser.Username = 'puser000@amamama.com' + System.currentTimeMillis() ;
        uatbwiUser.CompanyName = 'TEST2' ;
        uatbwiUser.Title = 'title' ;
        uatbwiUser.Alias = 'alias' ;
        uatbwiUser.TimeZoneSidKey = 'America/Los_Angeles' ; 
        uatbwiUser.EmailEncodingKey = 'UTF-8' ; 
        uatbwiUser.LanguageLocaleKey = 'en_US' ;
        uatbwiUser.LocaleSidKey = 'en_US' ; 
        uatbwiUser.UserRoleId = uatUserrole.Id  ; 
        uatbwiUser.ProfileId = ustProfileBWi;
        uatbwiUser.Primary_Territory_OneMDCS__c = 'Test Territory';
        insert uatbwiUser;
    }
}