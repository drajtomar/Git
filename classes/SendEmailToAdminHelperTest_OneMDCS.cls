@isTest(SeeAllData = false)
public class SendEmailToAdminHelperTest_OneMDCS
{
    public static User uatuser;
    public static Account objAcc;
    public static Contact objCon;
    public static Available_Services_OneMDCS__c objProcedure;
    public static Appointment_OneMDCS__c objAppFuture;
    public static Appointment_OneMDCS__c objAppPast;
    public static Appointment_OneMDCS__c objAppFuture1;
    public static BWI_Scheduler_Contact__c objBWIContact;
    public static Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1]; 
    public static User objeUser = [Select Id from User where ProfileId=: objProfile.Id  and isActive =: true limit 1]; 
    
    public static testMethod void insertUser()
    {
         system.runas(objeUser){
            Profile pf = [SELECT Id FROM Profile WHERE Name = 'Clinical Account Specialist'];           
            //Insert User CAS
            User CasUser = new User(  firstname = 'fName',
                                    lastName = 'lName',
                                    email = 'uniqueName' + '@test' + 'orgId' + '.org',
                                    Username = 'uniqueNameUser' + '@test' + 'orgId' + '.org',
                                    EmailEncodingKey = 'ISO-8859-1',
                                    Alias = 'fName',
                                    TimeZoneSidKey = 'America/Los_Angeles',
                                    LocaleSidKey = 'en_US',
                                    LanguageLocaleKey = 'en_US',
                                    ProfileId = pf.id,
                                    CompanyName = 'Test',
                                    External_User_Id__c = '1258963',
                                    Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned');

            insert CasUser;
             
             
             User newCasUser = new User(  firstname = 'fName',
                                    lastName = 'lName',
                                    email = 'newUniqueName' + '@test' + 'orgId' + '.org',
                                    Username = 'uniqueNameUserTest' + '@test' + 'orgId' + '.org',
                                    EmailEncodingKey = 'ISO-8859-1',
                                    Alias = 'fName',
                                    TimeZoneSidKey = 'America/Los_Angeles',
                                    LocaleSidKey = 'en_US',
                                    LanguageLocaleKey = 'en_US',
                                    ProfileId = pf.id,
                                    CompanyName = 'Test',
                                    External_User_Id__c = '1258967',
                                    Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned,Modified,Created');
             
            insert newCasUser;
            User CasUserchange = new User(  firstname = 'fNameTest',
                                          lastName = 'lNameTest',
                                          email = 'uniqueNameTestUser' + '@test' + 'orgId' + '.org',
                                          Username = 'uniqueNameTest' + '@test' + 'orgId' + '.org',
                                          EmailEncodingKey = 'ISO-8859-1',
                                          Alias = 'fNTest',
                                          TimeZoneSidKey = 'America/Los_Angeles',
                                          LocaleSidKey = 'en_US',
                                          LanguageLocaleKey = 'en_US',
                                          ProfileId = pf.id,
                                          CompanyName = 'Test',
                                          External_User_Id__c = '1258963',
                                          Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned');
            insert CasUserchange;
			Profile objProfileTM = [Select Id FROM Profile where Name =: 'Territory Manager' limit 1]; 
			User TMUser = new User(  firstname = 'fName',
                                    lastName = 'lName',
                                    email = 'uniqueName1' + '@test' + 'orgId' + '.org',
                                    Username = 'uniqueNameUser1' + '@test' + 'orgId' + '.org',
                                    EmailEncodingKey = 'ISO-8859-1',
                                    Alias = 'fName1',
                                    TimeZoneSidKey = 'America/Los_Angeles',
                                    LocaleSidKey = 'en_US',
                                    LanguageLocaleKey = 'en_US',
                                    ProfileId = objProfileTM.id,
                                    CompanyName = 'Test',
                                   	Primary_Territory_OneMDCS__c = 'South New Jersey',
                                    External_User_Id__c = '1258965',
                                    Email_Settings_OneMDCS__c = 'New Request;Created;Modified');
            insert TMUser;
             String userEmailCheck = [SELECT email FROM User order by CreatedDate desc limit 1].email;
             System.assertEquals('uniquename1@testorgid.org', userEmailCheck);
			User TMUserid = [Select Id from User where profileid =: objProfileTM.Id Limit 1];
			Territory tr = new Territory(Name =  'South New Jersey', External_Territory_Id__c = 'ht');
			insert tr;			
        }    
    }
    
    public static testMethod void SendEmailToAdminHelperTest_OneMDCS()
    {      
        system.runas(objeUser){
            objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
            update objeUser;
            insertUser();
            
        List<User> getCAS = new List<User>();
        getCAS = [SELECT id, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c != null AND Profile.Name = 'Clinical Account Specialist' limit 1];
        List<Availability_Of_CAS_OneMDCS__c> avlcaslist = new List<Availability_Of_CAS_OneMDCS__c>();
		if(getCAS.size() > 0){
			//Insert Avl CAS
            Availability_Of_CAS_OneMDCS__c objCas1 = new Availability_Of_CAS_OneMDCS__c();				
            objCas1.Name = 'CAS 1';
            objCas1.CAS_Team_OneMDCS__c = getCAS[0].id;				
            avlcaslist.add(objCas1);
            
            Insert avlcaslist;
            
		}	
        System.assertEquals('CAS 1', avlcaslist[0].Name);
        
        
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = 'Test';
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
                
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = 'Test';
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
        
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objService.Is_True_OneMDCS__c = true;
        objService.Type_OneMDCS__c = 'Email Setting Cancel Case';
        objService.Territory_OneMDCS__c = 'Test';
        objService.Name = 'Email Setting Cancel Case 2';
        Insert objService;
        
        List<Available_Services_OneMDCS__c> objServiceList = new List<Available_Services_OneMDCS__c>();
        objServiceList= [Select id from Available_Services_OneMDCS__c];
        System.assert(objServiceList.size()==3 );
        
        //Create Appointment future
        objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Status_OneMDCS__c = 'Unassigned';
        //objAppFuture.Email_OneMDCS__c = 'test@test.com';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.com;test@test.com;test@test.com';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '14:00';
        insert objAppFuture;
        }
        test.StartTest();
            List<Availability_Of_CAS_OneMDCS__c> getCASAvl = new List<Availability_Of_CAS_OneMDCS__c>();
            getCASAvl = [SELECT id, CAS_Team_OneMDCS__r.Name, CAS_Team_OneMDCS__r.Email, CAS_Team_OneMDCS__r.Email_Settings_OneMDCS__c  from Availability_Of_CAS_OneMDCS__c limit 1];
            User objUser = new User();
        	objUser = [SELECT Id, Name, Email, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned' limit 1];
			system.debug('objUser----> '+objUser.Email_Settings_OneMDCS__c);
        	objAppFuture.Status_OneMDCS__c = 'Cancelled';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
        
            objAppFuture.Status_OneMDCS__c = 'Unassigned';
            objAppFuture.Email_OneMDCS__c = 'test@test.com';
            objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician Changed';
            objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure Changed';
            objAppFuture.Service_Hours_OneMDCS__c = '6 Hours';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Modify';
            objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
            objAppFuture.Appointment_end_time_OneMDCS__c = '16:00';
            objAppFuture.Assigned_CAS_OneMDCS__c = null;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = null;
            Update objAppFuture;                   
        
        test.StopTest();
        
    }
	
	public static testMethod void SendEmailToAdminHelperTest_OneMDCS2()
    {      
        system.runas(objeUser){
            objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
            update objeUser;
            insertUser();
            
        List<User> getCAS = new List<User>();
        getCAS = [SELECT id, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c != null AND Profile.Name = 'Clinical Account Specialist' limit 2];
		List<Availability_Of_CAS_OneMDCS__c> avlcaslist = new List<Availability_Of_CAS_OneMDCS__c>();
		if(getCAS.size() > 0){
			//Insert Avl CAS
            Availability_Of_CAS_OneMDCS__c objCas1 = new Availability_Of_CAS_OneMDCS__c();				
            objCas1.Name = 'CAS 1';
            objCas1.CAS_Team_OneMDCS__c = getCAS[0].id;				
            avlcaslist.add(objCas1);
            
            Availability_Of_CAS_OneMDCS__c objCas2 = new Availability_Of_CAS_OneMDCS__c();				
            objCas2.Name = 'CAS 2';
            objCas2.CAS_Team_OneMDCS__c = getCAS[1].id;
            avlcaslist.add(objCas2);
            
            Insert avlcaslist;				
		}	
        
        
        
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = 'Test';
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
                
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = 'Test';
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
        
        //Create Appointment future
        objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Status_OneMDCS__c = 'Unassigned';
        //objAppFuture.Email_OneMDCS__c = 'test@test.com';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.com;test@test.com;test@test.com';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '14:00';
        insert objAppFuture;
        }
        test.StartTest();
            List<Availability_Of_CAS_OneMDCS__c> getCASAvl = new List<Availability_Of_CAS_OneMDCS__c>();
            getCASAvl = [SELECT id, CAS_Team_OneMDCS__r.Name, CAS_Team_OneMDCS__r.Email, CAS_Team_OneMDCS__r.Email_Settings_OneMDCS__c  from Availability_Of_CAS_OneMDCS__c limit 2];
            List<User> objUser = new List<User>();
        	objUser = [SELECT Id, Name, Email, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned' limit 2];
			system.debug('objUser----> '+objUser[0].Email_Settings_OneMDCS__c);
        	objAppFuture.Status_OneMDCS__c = 'Cancelled';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser[0].Id;
            Update objAppFuture;
        
            objAppFuture.Status_OneMDCS__c = 'Confirmed';
            objAppFuture.Email_OneMDCS__c = 'test@test.com';
            objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician Changed';
            objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure Changed';
            objAppFuture.Service_Hours_OneMDCS__c = '6 Hours';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Modify';
            objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
            objAppFuture.Appointment_end_time_OneMDCS__c = '16:00';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[1].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser[1].Id;
            Update objAppFuture;
            String phyNameUpcheck=[Select Name_Of_Physician_Encrypted_OneMDCS__c from Appointment_OneMDCS__c where id=:objAppFuture.Id].Name_Of_Physician_Encrypted_OneMDCS__c;
            System.assertEquals('Test Physician Changed', phyNameUpcheck);
        test.StopTest();
        
    }
	
	public static testMethod void SendEmailToAdminHelperTestOther_OneMDCS()
    {       
        system.runas(objeUser){
            objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
            update objeUser;
            insertUser();
         
        List<User> getCAS = new List<User>();
        getCAS = [SELECT id, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c != null limit 2];
		if(getCAS.size() > 0){
			//Insert Avl CAS
				Availability_Of_CAS_OneMDCS__c objCas1 = new Availability_Of_CAS_OneMDCS__c();
				Availability_Of_CAS_OneMDCS__c objCas2 = new Availability_Of_CAS_OneMDCS__c();
				
				objCas1.Name = 'CAS 1';
				objCas1.CAS_Team_OneMDCS__c = getCAS[0].id;
				
				
				objCas2.Name = 'CAS 2';
				objCas2.CAS_Team_OneMDCS__c = getCAS[1].id;
				
				Insert objCas1;
				Insert objCas2;
		}	
        
        
        
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = 'Test';
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
                
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = 'Test';
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
        
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objService.Is_True_OneMDCS__c = true;
        objService.Type_OneMDCS__c = 'Email Setting Cancel Case';
        objService.Territory_OneMDCS__c = 'Test';
        objService.Name = 'Email Setting Cancel Case 2';
        Insert objService;
        
        //Create Appointment future
        objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Status_OneMDCS__c = 'Unassigned';
        //objAppFuture.Email_OneMDCS__c = 'test@test.com';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.com;test@test.com;test@test.com';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '14:00';
        insert objAppFuture;
        }
        test.StartTest();
            List<Availability_Of_CAS_OneMDCS__c> getCASAvl = new List<Availability_Of_CAS_OneMDCS__c>();
            getCASAvl = [SELECT id, CAS_Team_OneMDCS__r.Name, CAS_Team_OneMDCS__r.Email, CAS_Team_OneMDCS__r.Email_Settings_OneMDCS__c  from Availability_Of_CAS_OneMDCS__c limit 2];
            User objUser = new User();
        	objUser = [SELECT Id, Name, Email, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned' limit 1];
        	/*objUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign';
        
        	Update objUser;*/
			        	
			system.debug('objUser----> '+objUser.Email_Settings_OneMDCS__c);
        	objAppFuture.Status_OneMDCS__c = 'Confirmed';
            objAppFuture.Email_OneMDCS__c = 'test@test.com';
            objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician Changed Reschedule';
            objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure Changed Reschedule';
            objAppFuture.Service_Hours_OneMDCS__c = '2 Hours';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Reschedule';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
        
            
            
            objAppFuture.Status_OneMDCS__c = 'Confirmed';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
            
            objAppFuture.Status_OneMDCS__c = 'Confirmed';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[1].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
            Integer appFuture=[SELECT count() FROM Appointment_OneMDCS__c WHERE Appointment_Date_OneMDCS__c >: System.today()];        
            System.assertEquals(1, appFuture);
        test.StopTest();
        
    }
	
	public static testMethod void SendEmailToAdminHelperTestcancel_OneMDCS()
    {       
        system.runas(objeUser){
            objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
            update objeUser;
            insertUser();
         
        List<User> getCAS = new List<User>();
        getCAS = [SELECT id, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c != null limit 2];
		if(getCAS.size() > 0){
			//Insert Avl CAS
				Availability_Of_CAS_OneMDCS__c objCas1 = new Availability_Of_CAS_OneMDCS__c();
				Availability_Of_CAS_OneMDCS__c objCas2 = new Availability_Of_CAS_OneMDCS__c();
				
				objCas1.Name = 'CAS 1';
				objCas1.CAS_Team_OneMDCS__c = getCAS[0].id;
				
				
				objCas2.Name = 'CAS 2';
				objCas2.CAS_Team_OneMDCS__c = getCAS[1].id;
				
				Insert objCas1;
				Insert objCas2;
		}	
        
        
        
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = 'Test';
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
                
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = 'Test';
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
        
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objService.Is_True_OneMDCS__c = true;
        objService.Type_OneMDCS__c = 'Email Setting Cancel Case';
        objService.Territory_OneMDCS__c = 'Test';
        objService.Name = 'Email Setting Cancel Case 2';
        Insert objService;
        
        //Create Appointment future
        objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Status_OneMDCS__c = 'Unassigned';
        //objAppFuture.Email_OneMDCS__c = 'test@test.com';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.com;test@test.com;test@test.com';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '14:00';
        insert objAppFuture;
        }
        test.StartTest();
            List<Availability_Of_CAS_OneMDCS__c> getCASAvl = new List<Availability_Of_CAS_OneMDCS__c>();
            getCASAvl = [SELECT id, CAS_Team_OneMDCS__r.Name, CAS_Team_OneMDCS__r.Email, CAS_Team_OneMDCS__r.Email_Settings_OneMDCS__c  from Availability_Of_CAS_OneMDCS__c limit 2];
            User objUser = new User();
        	objUser = [SELECT Id, Name, Email, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned' limit 1];
        	/*objUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign';
        
        	Update objUser;*/
			        	
			system.debug('objUser----> '+objUser.Email_Settings_OneMDCS__c);
        	objAppFuture.Status_OneMDCS__c = 'Confirmed';
            objAppFuture.Email_OneMDCS__c = 'test@test.com';
            objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician Changed Reschedule';
            objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure Changed Reschedule';
            objAppFuture.Service_Hours_OneMDCS__c = '2 Hours';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Reschedule';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
        
            objAppFuture.Status_OneMDCS__c = 'Unassigned';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Modify';
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
            
            objAppFuture.Status_OneMDCS__c = 'Cancelled';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Cancel';
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
            String statusNameUpcheck =[Select Change_Type_of_Request_OneMDCS__c from Appointment_OneMDCS__c where id=:objAppFuture.Id].Change_Type_of_Request_OneMDCS__c;
            System.assertEquals('Cancel', statusNameUpcheck);
        
        test.StopTest();
        
    }
	
	public static testMethod void SendEmailToTMHelperTest_OneMDCS()
    {       
        system.runas(objeUser){
            objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
            update objeUser;
            insertUser();
         
        List<User> getCAS = new List<User>();
        getCAS = [SELECT id, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c != null limit 2];
		if(getCAS.size() > 0){
			//Insert Avl CAS
				Availability_Of_CAS_OneMDCS__c objCas1 = new Availability_Of_CAS_OneMDCS__c();
				Availability_Of_CAS_OneMDCS__c objCas2 = new Availability_Of_CAS_OneMDCS__c();
				
				objCas1.Name = 'CAS 1';
				objCas1.CAS_Team_OneMDCS__c = getCAS[0].id;
				
				
				objCas2.Name = 'CAS 2';
				objCas2.CAS_Team_OneMDCS__c = getCAS[1].id;
				
				Insert objCas1;
				Insert objCas2;
		}	
        
        
        
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = 'South New Jersey';
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
                
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = 'South New Jersey';
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
        
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objService.Is_True_OneMDCS__c = true;
        objService.Type_OneMDCS__c = 'Email Setting Cancel Case';
        objService.Territory_OneMDCS__c = 'South New Jersey';
        objService.Name = 'Email Setting Cancel Case 2';
        Insert objService;
        
        //Create Appointment future
        objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Status_OneMDCS__c = 'Unassigned';
        //objAppFuture.Email_OneMDCS__c = 'test@test.com';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.com;test@test.com;test@test.com';
        objAppFuture.Territory_OneMDCS__c = 'South New Jersey';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '10:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '14:00';
        insert objAppFuture;
        }
        test.StartTest();
            List<Availability_Of_CAS_OneMDCS__c> getCASAvl = new List<Availability_Of_CAS_OneMDCS__c>();
            getCASAvl = [SELECT id, CAS_Team_OneMDCS__r.Name, CAS_Team_OneMDCS__r.Email, CAS_Team_OneMDCS__r.Email_Settings_OneMDCS__c  from Availability_Of_CAS_OneMDCS__c limit 2];
            User objUser = new User();
        	objUser = [SELECT Id, Name, Email, Email_Settings_OneMDCS__c from User where Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned,Modified,Created' limit 1];
        	/*objUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign';
        
        	Update objUser;*/
			        	
			system.debug('objUser----> '+objUser.Email_Settings_OneMDCS__c);
        	objAppFuture.Status_OneMDCS__c = 'Unassigned';
            objAppFuture.Email_OneMDCS__c = 'test@test.com';
            objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician Changed Reschedule';
            objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure Changed Reschedule';
            objAppFuture.Service_Hours_OneMDCS__c = '2 Hours';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Modify';
            objAppFuture.Assigned_CAS_OneMDCS__c = getCASAvl[0].id;
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
        
            
            objAppFuture.Status_OneMDCS__c = 'Cancelled';
            objAppFuture.Change_Type_of_Request_OneMDCS__c = 'Cancel';
        	objAppFuture.Assigned_CAS_Secondary_OneMDCS__c = objUser.Id;
            Update objAppFuture;
            System.assertEquals(false, !(objUser.Email_Settings_OneMDCS__c.contains('New Request;Cancelled Request')));
        test.StopTest();
        
    }
    
}