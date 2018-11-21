/*
*******************************************  This is a Test Class of Appointment_Process_OneMDCS ***************************
Main Class : Appointment_Process_OneMDCS
Created date : 08/01/2017
Created By : Capgemini
*/

@isTest()
public class Appointment_ProcessTEST_OneMDCS
{
    public static User uatuser;
    public static Account objAcc;
    public static Contact objCon;
    public static Available_Services_OneMDCS__c objProcedure;
    public static Appointment_OneMDCS__c objAppFuture;
    public static Appointment_OneMDCS__c objAppPast;
    public static Appointment_OneMDCS__c objAppFuture1;
    public static BWI_Scheduler_Contact__c objBWIContact;
	public static User objeUser = [Select Id from User where Profile.Name='System Administrator'  and isActive =: true limit 1];
	
	
	public static Appointment_OneMDCS__c createAppointmentTestData(Date appoDate,String location,String physicianName,String procedureName,String serviceHours,
	String status,String email,String additionalEmail,String additionalEmailOther,String appoStartTime12Hours,String appoEndTime12Hours,String appoStartTime,String appoEndTime,String territory)
	{
		Appointment_OneMDCS__c objAppFuture = new Appointment_OneMDCS__c();
		objAppFuture.Appointment_Date_OneMDCS__c = appoDate;
		objAppFuture.Location_Encrypted_OneMDCS__c = location;
		objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = physicianName;
		objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = procedureName;
		objAppFuture.Service_Hours_OneMDCS__c = serviceHours;
		objAppFuture.Status_OneMDCS__c = status;
		objAppFuture.Email_OneMDCS__c = email;
		objAppFuture.Additional_Email_OneMDCS__c = additionalEmail;
        objAppFuture.Additional_Email_Other_OneMDCS__c = additionalEmailOther;
		objAppFuture.Appointment_start_time_12hrs_OneMDCS__c = appoStartTime12Hours;
		objAppFuture.Appointment_end_time_12_hrs_OneMDCS__c = appoEndTime12Hours;
		objAppFuture.Appointment_Start_time_OneMDCS__c = appoStartTime;
		objAppFuture.Appointment_end_time_OneMDCS__c = appoEndTime;
		objAppFuture.Territory_OneMDCS__c = territory;
        objAppFuture.Reason_OneMDCS__c = 'Test Reason';
		return objAppFuture;
	}

	public static Availability_Of_CAS_OneMDCS__c createAvailabilityOfCASTestData(User userData,String afternoonSlot,Boolean AM,Boolean availabilityOfCas,
	String defaultData,String morningSlot,Boolean PM,Date assignedDate, String territoryName)
	{
		Availability_Of_CAS_OneMDCS__c casData = new Availability_Of_CAS_OneMDCS__c();
		casData.Name = userData.Name;
		casData.Afternoon_Slot_OneMDCS__c = afternoonSlot;
		casData.AM_OneMDCS__c = AM;
		casData.Availability_CAS_OneMDCS__c = availabilityOfCas;
		casData.CAS_Team_OneMDCS__c = userData.Id;
		casData.Default_OneMDCS__c = defaultData;
		casData.Morning_Slot_OneMDCS__c = morningSlot;
		casData.PM_OneMDCS__c = PM;
		casData.Date_assigned_OneMDCS__c = assignedDate;
		casData.Territory_OneMDCS__c = territoryName;
		return casData;
	}

 
	public static Available_Services_OneMDCS__c createAvailableServicesTestData(Boolean isTrue,String type,String territoryName,String availableServicesName,
	String selectedTimeSlotsAM,String selectedTimeSlotsPM)
	{
		Available_Services_OneMDCS__c availableServicesData = new Available_Services_OneMDCS__c();
		availableServicesData.Is_True_OneMDCS__c = isTrue;
		availableServicesData.Type_OneMDCS__c = type;
		availableServicesData.Territory_OneMDCS__c = territoryName;
		availableServicesData.Name = availableServicesName;
		availableServicesData.Selected_Time_Slots_AM_OneMDCS__c = selectedTimeSlotsAM;
		availableServicesData.Selected_Time_Slots_PM_OneMDCS__c = selectedTimeSlotsPM;
		return availableServicesData;
	}
	
	public static Account createAccountTestData(String accName, Boolean calendarLogic) {
        
        Account acc = new Account();
        acc.Name = accName;
        acc.Calendar_Logic_OneMDCS__c = calendarLogic;
        return acc ;
		
    }
	
	public static Contact createContactTestData(String lastName, String email, String npi) {
        
        Contact con = new Contact();
        con.LastName = lastName;
        con.Email = email;
        con.NPI__c = npi;
        return con ;
		
    }
	
	public static Territory createTerritoryTestData(String externalTerritoryId, String name) {
        
        Territory territoryData = new Territory();
        territoryData.External_Territory_Id__c = externalTerritoryId;
        territoryData.Name = name;
        return territoryData ;
    }
	
	@testSetup
	static void allTheDataForThisTestClass() {
		
		objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
        update objeUser;
        System.runAs(objeUser){
		User userData = new User();
		userData = [SELECT Id, Name from User limit 1];
		List<Territory> territoryData = new List<Territory>();
        territoryData = [SELECT Id, Name, ParentTerritoryId FROM Territory where Name = 'Alaska' limit 1];
		String territoryName = territoryData[0].Name;
		//create appointments
		List<Appointment_OneMDCS__c> appointmentList = new List<Appointment_OneMDCS__c>();
        List<Appointment_OneMDCS__c> SelectedApt = appointmentList;
		Date today = date.Today();
		Date futureDate = today.addDays(2);
		Appointment_OneMDCS__c objAppFuture = createAppointmentTestData(futureDate,'Test Hospital 1','Test Physician','Test Procedure','4 Hours','Unassigned',
		'test@test.test','test@test.test;test@test.test;test@test.test','test@test.test','04:00 AM','08:00 AM','04:00','08:00','Test');
		
		appointmentList.add(objAppFuture);
		
		Appointment_OneMDCS__c objAppFutureAdmin = createAppointmentTestData(futureDate,'Test Hospital 1','Test Physician','Test Procedure','4 Hours','Unassigned',
		'test@test.test','test@test.test;test@test.test;test@test.test','test@test.test','09:00 AM','01:00 PM','09:00','13:00','');
		appointmentList.add(objAppFutureAdmin);
		
		insert appointmentList;
		
		//Create availability of CAS
		List<Availability_Of_CAS_OneMDCS__c> availabileCASList = new List<Availability_Of_CAS_OneMDCS__c>();
		Availability_Of_CAS_OneMDCS__c casDataOne = createAvailabilityOfCASTestData(userData,'13:00;17:00',true,true,'Y','08:00;12:00',true,Date.today(),territoryName);
		availabileCASList.add(casDataOne);
		Availability_Of_CAS_OneMDCS__c casDataTwo= createAvailabilityOfCASTestData(userData,'',true,true,'Y','',true,Date.today(),territoryName);
		availabileCASList.add(casDataTwo);
		Availability_Of_CAS_OneMDCS__c casDataThree= createAvailabilityOfCASTestData(userData,'',true,true,'N','',true,Date.today(),territoryName);
		availabileCASList.add(casDataThree);
		
		insert availabileCASList;
		
		//Create availability of Services
		String selectedAMSlots = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
		String selectedPMSlots = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
		
		List<Available_Services_OneMDCS__c> availabileServicesList = new List<Available_Services_OneMDCS__c>();
		Available_Services_OneMDCS__c availableServicesDataOne = createAvailableServicesTestData(true,'Email Setting Cancel Case',territoryName,'Email Setting Cancel Case 2','','');
		availabileServicesList.add(availableServicesDataOne);
		Available_Services_OneMDCS__c availableServicesDataTwo = createAvailableServicesTestData(true,'Email Setting Change Case',territoryName,'Email Setting Change Case 1','','');
		availabileServicesList.add(availableServicesDataTwo);
		Available_Services_OneMDCS__c availableServicesDataThree = createAvailableServicesTestData(true,'Email Setting New Case',territoryName,'Email Setting New Case 3','','');
		availabileServicesList.add(availableServicesDataThree);
		Available_Services_OneMDCS__c availableServicesDataFour = createAvailableServicesTestData(true,'Calendar Logic',territoryName,'Calendar Logic 5','','');
		availabileServicesList.add(availableServicesDataFour);
		Available_Services_OneMDCS__c availableServicesDataFive = createAvailableServicesTestData(true,'Slot Settings','Default','Default Slot Settings',selectedAMSlots,selectedPMSlots);
		availabileServicesList.add(availableServicesDataFive);
		Available_Services_OneMDCS__c availableServicesDataSix = createAvailableServicesTestData(true,'Slot Settings',territoryName,'Slot Settings-0.0215',selectedAMSlots,selectedPMSlots);
		availabileServicesList.add(availableServicesDataSix);
        Available_Services_OneMDCS__c availableServicesDataSeven = createAvailableServicesTestData(true,'Slot Settings',territoryName,'Slot Settings-0.1234',selectedAMSlots,selectedPMSlots);
		availabileServicesList.add(availableServicesDataSeven);
		insert availabileServicesList;
		
		
		//Create Account
		List<Account> accountlist = new List<Account>();
		Account accDataOne = createAccountTestData('Test Hospital',true);
		accountlist.add(accDataOne);
		insert accountlist;
		
		//Create Contact
		List<Contact> contactlist = new List<Contact>();
		Contact contactDataOne = createContactTestData('TestCon','test@test.com','1234567890');
		contactlist.add(contactDataOne);
		insert contactlist;
		}
		
	}

    public static Territory insertTeritorry() {
        
        Territory t = new Territory();
        t.External_Territory_Id__c = 'TE';
        t.Name = 'test';
        // t.ForecastUserId = u.id;
        insert t;
        return t ;
    }
	
	public static Territory insertTeritorry1() {
    Territory tr1 = new Territory();
        tr1.External_Territory_Id__c = 'TE';
        tr1.Name = 'test123';       
        insert tr1;
    return tr1;
	} 
	
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
    
    public static User getUserRecord( String profileName  ){
        
        //UserRole uatUserrole = new UserRole(DeveloperName = UserRoleDeveloperName  , Name = userRoleName );
        //insert uatUserrole ;
        
        //UserRole uatUserrole = [ SELECT id from UserRole where DeveloperName = : UserRoleDeveloperName ];
        
        
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
        uatuser.Color__c= '#ff8c00';
        uatuser.Primary_Territory_OneMDCS__c = 'WEST BENGAL' ;
        uatuser.Email_Settings_OneMDCS__c = 'New Request' + ';' + 'Cancelled Request' + ';' + 'Change to current case'+ ';' + 'Reassign'+ ';' + 'Unassigned';
        insert uatuser ;
        
        
        return uatuser  ;
        
    }
    public static testMethod void AppointmentProcessTest() 
    {
        Appointment_OneMDCS__c appo1 = new Appointment_OneMDCS__c();
        appo1 = [SELECT Id from Appointment_OneMDCS__c limit 1];
		
        User objUser1 = new User();
        objUser1 = [SELECT Id, Name from User limit 1];
		
        Availability_Of_CAS_OneMDCS__c availableCas1 = new Availability_Of_CAS_OneMDCS__c();
        availableCas1 = [SELECT Id,CAS_Team_OneMDCS__c from Availability_Of_CAS_OneMDCS__c limit 1];
		
        List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory where name = 'Alaska' limit 1];
		
		Account objAccQuery = new Account();
        objAccQuery = [SELECT Id from Account limit 1];
        
        Account insertAccount = new Account();
            insertAccount.Name = 'Account Unique 1234321';
            insertAccount.Calendar_Logic_OneMDCS__c = false;
      insertAccount.JDE_JJHCS_Number__c = '56424/19835';
            insertAccount.Territory__c = 'testterr';
        insertAccount.Primary_Territory__c= 'testing';
            insert insertAccount;
	
		Appointment_Process_OneMDCS.getleftAccountList(TerritoryNameEmail[0].id);
		Appointment_Process_OneMDCS.getRightAccountList(TerritoryNameEmail[0].id);

        List<Available_Services_OneMDCS__c> accList = new List<Available_Services_OneMDCS__c>();
        accList = Appointment_Process_OneMDCS.getLocations(false, TerritoryNameEmail[0].Name);
        accList = Appointment_Process_OneMDCS.getLocations(true, TerritoryNameEmail[0].Name);
        
     
        List<String> weekDays = new List<String>();
        Date objDate = date.today();
        
        User objUserCAS = new User();
        objUserCAS = [Select id, name from user limit 1];

        Map<string,List<String>> getTimeSlotCover = new Map<string,List<String>>();
        String appoIdObj = null;
        getTimeSlotCover = Appointment_Process_OneMDCS.getSlot(String.valueOf(Date.today()),String.valueOf(4),TerritoryNameEmail[0].Name,appoIdObj, String.ValueOf(objAccQuery.Id));
        Appointment_Process_OneMDCS.getSlot(String.valueOf(Date.today()),String.valueOf(4),'Test',appoIdObj, 'Other');
        //Test.stopTest();
        Test.startTest();
        Appointment_Process_OneMDCS.getEmailSettings();
        
        Appointment_Process_OneMDCS.getTerritories();
        String json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2018-8-2","startslot":"07:00 AM","endslot":"11:00 AM","request":"Special","serviceName":"PVC","serviceHours":"4","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c"}';
        String json2 = '{"serviceSelected":"4"}';
        system.debug('@@@createAppointment@@@:');
        String createApp = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        
        
        json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2018-8-3","startslot":"07:00 PM","endslot":"11:00 PM","request":"Special","serviceName":"PVC","serviceHours":"4","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c"}';
        json2 = '{"serviceSelected":"4"}';
        system.debug('@@@createAppointment@@@:');
        String createApp1 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        
        Event newEvent = new Event();
        newEvent.OwnerId =  availableCas1.CAS_Team_OneMDCS__c;
        newEvent.Subject ='Appointment Scheduled';
        newEvent.IsRecurrence = false;
        newEvent.IsAllDayEvent =false;
        newEvent.DurationInMinutes =300;
        Date t = Date.newInstance(2018, 09, 16);
        newEvent.ActivityDate =t;
        datetime sttartDate =datetime.newInstance(2018, 09, 16, 07, 00, 00);
        
        newEvent.StartDateTime =sttartDate;
        
        insert newEvent;
        Event ev = new Event();
        ev = [SELECT Id from Event limit 1];
        Appointment_OneMDCS__c appoID = new Appointment_OneMDCS__c();
        appoID = [SELECT Id from Appointment_OneMDCS__c limit 1];
        
        CustomerInfoTest caswrap = new CustomerInfoTest();
        
        String appo1Id = String.valueOf(appo1.Id);
        String availableCas1Id = String.valueOf(availableCas1.Id);
        CustomerInfoTest customerInfowrap = new CustomerInfoTest();
        BookingInfoWrapperTest bookingInfoWrapper = new BookingInfoWrapperTest();
        bookingInfoWrapper.serviceSelected = 'testservice';
        customerInfowrap.location = 'Hospital 3' ;
        customerInfowrap.name = 'Rubai' ;
        customerInfowrap.Email = 'rbaner14@its.jnj.com' ;
        customerInfowrap.AssignedDate = Date.valueOf('2018-9-16');
        customerInfowrap.SelectedDateValue = '2018-9-16';
        customerInfowrap.startslot = '07:00 AM' ;
        customerInfowrap.startTime24Hrs = '07:00';
        customerInfowrap.endslot = '12:00 PM' ;
        customerInfowrap.request = 'Special' ;
        customerInfowrap.serviceName =  'PVC' ;
        customerInfowrap.serviceHours  = '5' ;
        customerInfowrap.additionalEmail = 'A@d.c' ;
        customerInfowrap.additionalEmailOther = 'a@b.c';
        customerInfowrap.HigherTimeSelected = 'true' ;
        customerInfowrap.paramValue = 'Modify' ;
        customerInfowrap.serviceDuration = '5' ;
        customerInfowrap.appointmentId = appo1Id ;
        customerInfowrap.isTimeEdited = true;
        customerInfowrap.assignedCASId = availableCas1Id ;
        json1 = JSON.serialize( customerInfowrap ) ; 
        //json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2017-09-3","startslot":"07:00 PM","endslot":"12:00 PM","request":"Special","serviceName":"PVC","serviceHours":"5","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c",HigherTimeSelected":"true","serviceDuration":"5","appointmentId ":appo1Id,"assignedCASId":availableCas1Id }';
        json2 = '{"serviceSelected":"5"}';
        system.debug('@@@createAppointment@@@:'+json1);
        String createApp2 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        CustomerInfoTest customerInfowrap1 = new CustomerInfoTest();
        
        customerInfowrap1.location = 'Hospital 3' ;
        customerInfowrap1.name = 'Rubai' ;
        customerInfowrap1.Email = 'rbaner14@its.jnj.com' ;
        customerInfowrap1.AssignedDate = Date.valueOf('2017-9-16');
        customerInfowrap1.SelectedDateValue = '2018-9-16';
        customerInfowrap1.paramValue = 'Modify' ;
        customerInfowrap1.startTime24Hrs = '09:00';
        customerInfowrap1.startslot = '09:00 AM' ;
        customerInfowrap1.endslot = '12:00 PM' ;
        customerInfowrap1.request = 'Special' ;
        customerInfowrap1.serviceName =  'PVC' ;
        customerInfowrap1.serviceHours  = '3' ;
        customerInfowrap1.additionalEmail = 'A@d.c' ;
        customerInfowrap1.additionalEmailOther = 'a@b.c' ; 
        customerInfowrap.isTimeEdited = true;
        customerInfowrap1.HigherTimeSelected = 'false' ;
        customerInfowrap1.serviceDuration = '3' ;
        customerInfowrap1.appointmentId = appo1Id ;
        customerInfowrap1.assignedCASId = availableCas1Id ;
        
        json1 = JSON.serialize( customerInfowrap1 ) ; 
        json2 = '{"serviceSelected":"3"}';
        system.debug('@@@createAppointment for modify@@@:'+json1);
        String createApp3 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        CustomerInfoTest customerInfowrap2 = new CustomerInfoTest();
        
        customerInfowrap2.location = 'Hospital 3' ;
        customerInfowrap2.name = 'Rubai' ;
        customerInfowrap2.Email = 'rbaner14@its.jnj.com' ;
        customerInfowrap2.AssignedDate = Date.valueOf('2018-9-16');
        customerInfowrap2.SelectedDateValue = '2018-9-16';
        customerInfowrap2.paramValue = 'Reschedule' ;
        customerInfowrap2.startTime24Hrs = '09:00';
        customerInfowrap2.startslot = '09:00 AM' ;
        customerInfowrap2.endslot = '12:00 PM' ;
        customerInfowrap2.request = 'Special' ;
        customerInfowrap2.serviceName =  'PVC' ;
        customerInfowrap2.serviceHours  = '3' ;
        customerInfowrap2.additionalEmail = 'A@d.c' ;
        customerInfowrap2.additionalEmailOther = 'a@b.c';
        customerInfowrap2.HigherTimeSelected = 'false' ;
        customerInfowrap2.serviceDuration = '3' ;
        customerInfowrap2.appointmentId = appo1Id ;
        customerInfowrap2.assignedCASId = availableCas1Id ;
        
        json1 = JSON.serialize( customerInfowrap2 ) ; 
        json2 = '{"serviceSelected":"3"}';
        system.debug('@@@createAppointment for modify 1111@@@:');
        String createApp4 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
		
		Id checkAccId= [SELECT CreatedDate FROM Appointment_OneMDCS__c order by CreatedDate asc Limit 1 ].id;
        System.assertEquals(checkAccId, createApp4);
        
        Account insertAcc = new Account();
        insertAcc.Name = 'Test Account';
        Account insertAcc1 = new Account();
        insertAcc1.Name = '';
        List<Appointment_OneMDCS__c> getApp = new List<Appointment_OneMDCS__c>();
        getApp = Appointment_Process_OneMDCS.getAppointmentList('Hospital 3','Test Account');
        getApp = Appointment_Process_OneMDCS.getAppointmentList('Hospital 3','');
        Appointment_OneMDCS__c getPastAppId = new Appointment_OneMDCS__c();
        getPastAppId = [SELECT id from Appointment_OneMDCS__c limit 1];
        String appPastId = string.ValueOf(getPastAppId.id);
        List<Appointment_OneMDCS__c> getAppSel = new List<Appointment_OneMDCS__c>();
        getAppSel = Appointment_Process_OneMDCS.getSelectedAppt(appPastId);
        
        
        Boolean isCalendarLogicTrue = AdmincalendarLogic_OneMDCS.getcalendarSettings(TerritoryNameEmail[0].Name);
        
        Date todayParam = date.Today();
        Date futureDateParam = todayParam.addDays(2);
        String dateParam = string.ValueOf(futureDateParam);
        String territoryParam = 'Test';
        Appointment_Process_OneMDCS.getAppointmentListonDay(dateParam, territoryParam);
        Appointment_Process_OneMDCS.getEventListonDay(dateParam, territoryParam); //Added for event list
        
        String  BookedAppointment = Appointment_Process_OneMDCS.getBookedAppointment(territoryParam);
        Appointment_Process_OneMDCS.getAllCASListonLoad(territoryParam, dateParam);
        
        
        Appointment_OneMDCS__c getFutureAppId = new Appointment_OneMDCS__c();
        getFutureAppId = [SELECT id, Email_OneMDCS__c from Appointment_OneMDCS__c limit 1];
        String appFutureId = string.ValueOf(getFutureAppId.id);
        Appointment_Process_OneMDCS.updateCancelCase(appFutureId);
        
        Appointment_OneMDCS__c getAppId = new Appointment_OneMDCS__c();
        getAppId = [SELECT id, Email_OneMDCS__c from Appointment_OneMDCS__c where Email_OneMDCS__c != null  limit 1];
        String getId = string.ValueOf(getAppId.id);
        Appointment_Process_OneMDCS.getSelectedScheduleDetail(getId);
        
        //to cover Admin Class
        String jsonString  = JNJ_Admin_Calender_Controller_OneMDCS.getBookedAppointment( territoryParam );
        
        //Get Territory Id for Test class
        
        //saveEmailSettings
       Boolean newCase = true;
        Boolean cancelCase = true;
        Boolean changeCase = true;
        Boolean reAssignCase = true;
        Boolean calendarLogic = true;
        Boolean unassigned = true;
        String territoryName = TerritoryNameEmail[0].Id;
        
        Appointment_Process_OneMDCS.getProfileName();
       // Appointment_Process_OneMDCS.getCAS(territoryName);
		Appointment_Process_OneMDCS.getCASwraplist(territoryName);
        Appointment_Process_OneMDCS.getCustomerForTerritory('WEST BENGAL');
        List<Appointment_Process_OneMDCS.TimeRecordWrapper> getSlots = Appointment_Process_OneMDCS.getAllSlots(territoryName);

        Test.stopTest();
    }
    
    public static testMethod void AppointmentProcessTest2(){
        
        User objUser1 = new User();
        objUser1 = [SELECT Id, Name from User limit 1];
         User objUserCAS = new User();
        objUserCAS = [Select id, name from user limit 1];
         List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory where name = 'Alaska' limit 1];
        test.startTest();
         //saveEmailSettings
        Boolean newCase = true;
        Boolean cancelCase = true;
        Boolean changeCase = true;
        Boolean reAssignCase = true;
        Boolean calendarLogic = true;
        Boolean unassigned = true;
        Boolean modifiedCase = true;
        Boolean createdCase = true;
        String territoryName = TerritoryNameEmail[0].Id;
        
        Appointment_Process_OneMDCS.saveEmailSettingsAdmin(territoryName,newCase,cancelCase,changeCase,reAssignCase,unassigned,modifiedCase,createdCase);
        //Appointment_Process_OneMDCS.saveCalendarAdmin(territoryName,calendarLogic);
        
        List<Available_Services_OneMDCS__c> procedureList = new List<Available_Services_OneMDCS__c>();
        String TerritoryNameProCedure = 'Test Territory';
        procedureList = Appointment_Process_OneMDCS.getServiceListAdmin(territoryName);
        String CASId = String.valueOf(objUser1.id) + ';' + String.valueOf(objUser1.id);
        system.runas(objUserCAS){ 
		Appointment_Process_OneMDCS.saveCAS(territoryName, CASId, CASId);
        }
        
        procedureList = Appointment_Process_OneMDCS.getServiceList(TerritoryNameProCedure, true);
        Appointment_Process_OneMDCS.getServiceList(TerritoryNameProCedure, false);
        List<Appointment_OneMDCS__c> getAppHistory = new List<Appointment_OneMDCS__c>();
        getAppHistory = Appointment_Process_OneMDCS.getAppointmentHistoryList(TerritoryNameProCedure,true,'Test Account');
		Integer appHistory=[SELECT count() FROM Appointment_OneMDCS__c WHERE Appointment_Date_OneMDCS__c <: System.today()];
        System.assertEquals(0, appHistory);
        Appointment_Process_OneMDCS.getAppointmentHistoryList(TerritoryNameProCedure,false,'Test Account');
        Appointment_Process_OneMDCS.getAppointmentHistoryList(TerritoryNameProCedure,false,'');
         Appointment_Process_OneMDCS.getAppointmentHistoryList(TerritoryNameProCedure,true,'');
        Appointment_Process_OneMDCS.getAllCAS();
        Appointment_Process_OneMDCS.getSelectedCalendarLogic(territoryName);
        Appointment_Process_OneMDCS.getSelectedNewCaseLogic(territoryName);
        Appointment_Process_OneMDCS.getSelectedChangeCaseLogic(territoryName);
        Appointment_Process_OneMDCS.getSelectedCancelCaseLogic(territoryName);
        Appointment_Process_OneMDCS.getSelectedSamedayLogic(territoryName);
        Appointment_Process_OneMDCS.getDetailsOfRemainingProcedures( '2017-9-16',territoryName);

        test.stopTest();
    }
	public static testMethod void saveTimetest(){
	
		List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory where name = 'Alaska' limit 1];
		String territoryName = TerritoryNameEmail[0].Id;
		String selectedTimes = '[{"isSelected":false,"timeslot":"4:00AM"},{"isSelected":false,"timeslot":"4:30AM"},{"isSelected":true,"timeslot":"5:00AM"},{"isSelected":true,"timeslot":"5:30AM"},{"isSelected":true,"timeslot":"6:00AM"},{"isSelected":true,"timeslot":"6:30AM"},{"isSelected":true,"timeslot":"7:00AM"},{"isSelected":true,"timeslot":"7:30AM"},{"isSelected":true,"timeslot":"8:00AM"},{"isSelected":true,"timeslot":"8:30AM"},{"isSelected":true,"timeslot":"9:00AM"},{"isSelected":true,"timeslot":"9:30AM"},{"isSelected":true,"timeslot":"10:00AM"},{"isSelected":true,"timeslot":"10:30AM"},{"isSelected":true,"timeslot":"11:00AM"},{"isSelected":false,"timeslot":"11:30AM"},{"isSelected":false,"timeslot":"12:00PM"},{"isSelected":false,"timeslot":"12:30PM"},{"isSelected":true,"timeslot":"1:00PM"},{"isSelected":true,"timeslot":"1:30PM"},{"isSelected":true,"timeslot":"2:00PM"},{"isSelected":true,"timeslot":"2:30PM"},{"isSelected":false,"timeslot":"3:00PM"},{"isSelected":false,"timeslot":"3:30PM"},{"isSelected":false,"timeslot":"4:00PM"},{"isSelected":false,"timeslot":"4:30PM"},{"isSelected":false,"timeslot":"5:00PM"},{"isSelected":false,"timeslot":"5:30PM"},{"isSelected":false,"timeslot":"6:00PM"},{"isSelected":false,"timeslot":"6:30PM"},{"isSelected":false,"timeslot":"7:00PM"},{"isSelected":true,"timeslot":"7:30PM"},{"isSelected":false,"timeslot":"8:00PM"}]';
		Test.startTest();
        Appointment_Process_OneMDCS.saveTime(territoryName,selectedTimes);
        String selectedSlotCheck = [Select Selected_Time_Slots_AM_OneMDCS__c from Available_Services_OneMDCS__c where Territory_OneMDCS__c ='Alaska' AND Type_OneMDCS__c = 'Slot Settings' Limit 1].Selected_Time_Slots_AM_OneMDCS__c;
        System.assert(selectedSlotCheck.contains('5:00AM'));
        //saveCalendarSameday
        Boolean Sameday = true; 
        String samedayTime = '5:00AM';

        //saveProcedureSettings
        String UpdateProcedue = '[{"Name":"PN-7165","Procedure_Name_One_MDCS__c":"WPW","Service_Hours_OneMDCS__c":"4","Territory_OneMDCS__c":"Memphis, TN","Type_OneMDCS__c":"Procedure"}]';
        Appointment_Process_OneMDCS.saveProcedureSettings(territoryName,UpdateProcedue);
		Test.stopTest();
	}
	
	
    public static testMethod void AppointmentProcessTest1() 
    {
        Test.startTest();
        List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
        //saveEmailSettings
        Boolean newCase = true;
        Boolean cancelCase = true;
        Boolean changeCase = true;
        Boolean reAssignCase = true;
        Boolean calendarLogic = true;
        Boolean unassigned = true;
        Boolean modifiedCase = true;
        Boolean createdCase = true;
        String territoryName = TerritoryNameEmail[0].Id;
        Appointment_Process_OneMDCS.saveEmailSettingsAdmin(territoryName,newCase,cancelCase,changeCase,reAssignCase,unassigned,modifiedCase,createdCase);
        //Appointment_Process_OneMDCS.saveCalendarAdmin(territoryName,calendarLogic);
        
        //saveCalendarSameday
        Boolean Sameday = true; 
        Boolean Sameday2 = false; 
        String samedayTime = '5:00AM';
        Appointment_Process_OneMDCS.saveCalendarSameday(territoryName,Sameday,samedayTime);
        Appointment_Process_OneMDCS.saveCalendarSameday(territoryName,Sameday2,samedayTime);
        String Email = 'abc@xyz.com';
        String Phone = '1234567890';
        
        Appointment_Process_OneMDCS.createBWISettings(Email,Phone,territoryName,'Test');
        List<BWI_Scheduler_Contact__c> BWIScheduler = new List<BWI_Scheduler_Contact__c>();
        
        
        BWIScheduler = [SELECT Id, Name, BWI_Scheduler_Email_OneMDCS__c, BWI_Scheduler_Name_OneMDCS__c, BWI_Scheduler_phone_OneMDCS__c, Territory__c FROM BWI_Scheduler_Contact__c limit 1];
        
        Appointment_Process_OneMDCS.getBWIInfo(String.valueOf(BWIScheduler[0].Territory__c));
        String jsonstring = Json.serialize(BWIScheduler); 
        Appointment_Process_OneMDCS.UpdateBWISettings(jsonstring,'West');
        List<BWI_Scheduler_Contact__c> BWISettingsVal = Appointment_Process_OneMDCS.getBWISettings(territoryName);
        System.assertEquals(1, BWISettingsVal.size()); 
        Appointment_Process_OneMDCS.getTerritoryForUser(territoryName);
        Appointment_Process_OneMDCS.getReport();
        //Appointment_Process_OneMDCS.getCASPrimary(territoryName);
       //Insert Account
        Account insertAcc = new Account();
        insertAcc.Name = 'Test Account Unique 1234321';
        insertAcc.Calendar_Logic_OneMDCS__c = false;
        insertAcc.Primary_Territory__c = TerritoryNameEmail[0].Name;
        insert insertAcc;
        
   		Appointment_Process_OneMDCS.getCASPrimarylist(territoryName);
        Appointment_Process_OneMDCS.getAllAccounts(String.valueOf(TerritoryNameEmail[0].Id));
        
        String searchKey = 'Test Account Unique 1234321';
        String accListFind = null;
        Appointment_Process_OneMDCS.findByName(searchKey, accListFind, String.valueOf(TerritoryNameEmail[0].Id));
        LookUpControllerAdminSettings.fetchLookUpValues('Test Account Unique','Account',TerritoryNameEmail[0].Id);
        
        List<Territory> TerritoryNameCalendar = new List<Territory>();
        TerritoryNameCalendar = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
        List<Account> lstAcc = new List<Account>();
        List<Account> getAcc = new List<Account>();
        getAcc = [Select Id, Primary_Territory__c, Calendar_Logic_OneMDCS__c From Account limit 1];
        
        String AccDetils = '';
        system.debug('-------------->AccDetils '+AccDetils);
        Appointment_Process_OneMDCS.saveCalendarAdmin(String.valueOf(TerritoryNameCalendar[0].Id),AccDetils);
        
        Test.stopTest();
    }
    
    public static testMethod void loadCalendarByTeritory_method1(){
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  START :::::::::::::::::::::::::::::::::::::::
        
        //::::::::::::::::::::::::::::::::::: Calling User creation method :::::::::::::::::::::::::::::::
        
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        Test.startTest();
        System.runAs( uatUser1 ){
            
            Id terID= insertTeritorry().id;
            User objUser1 = new User();
            objUser1 = [SELECT Id, Name from User limit 1];
            List<Territory> TerritoryNameEmail = new List<Territory>();
            TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
            system.debug('------------>TerritoryId --------------> DateSelected ' );  
            
            Availability_Of_CAS_OneMDCS__c inserDefault = new Availability_Of_CAS_OneMDCS__c();
            inserDefault.Name = objUser1.Name;
            inserDefault.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
            inserDefault.AM_OneMDCS__c = false;
            inserDefault.Availability_CAS_OneMDCS__c = True;
            inserDefault.CAS_Team_OneMDCS__c = objUser1.Id;
            inserDefault.Default_OneMDCS__c = 'N';
            inserDefault.Morning_Slot_OneMDCS__c = '08:00;12:00';
            inserDefault.PM_OneMDCS__c = True;
            inserDefault.Date_assigned_OneMDCS__c = Date.today();
            inserDefault.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
            
            insert inserDefault;
            String todayDate = String.ValueOf(Date.today());    
            List<Territory> TerritoryNameCalendar = new List<Territory>();
            TerritoryNameCalendar = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
            Appointment_Process_OneMDCS.getPerDayAvlOfCAS(TerritoryNameEmail[0].Name,todayDate);
            List<Account> lstAcc = new List<Account>();
            //Insert Account
            Account insertAcc = new Account();
            insertAcc.Name = 'Test Account Unique 1234321';
            insertAcc.Calendar_Logic_OneMDCS__c = false;
            insertAcc.Primary_Territory__c = TerritoryNameCalendar[0].Name;
      insertAcc.JDE_JJHCS_Number__c = '56423/19834';
            lstAcc.add(insertAcc);
            Account insertAccount = new Account();
            insertAccount.Name = 'Account Unique 1234321';
            insertAccount.Calendar_Logic_OneMDCS__c = false;
            insertAccount.Primary_Territory__c = TerritoryNameCalendar[0].Name;
      		insertAccount.JDE_JJHCS_Number__c = '56424/19835';
            lstAcc.add(insertAccount);
            insert lstAcc;
            
            List<Appointment_Process_OneMDCS.AccountRecordWrapper> lstAccRecords = new List<Appointment_Process_OneMDCS.AccountRecordWrapper>();
            Appointment_Process_OneMDCS.AccountRecordWrapper accRecordWrapper = new Appointment_Process_OneMDCS.AccountRecordWrapper();
            List<Appointment_Process_OneMDCS.AccountRightRecordWrapper> lstAccRightrecs = new List<Appointment_Process_OneMDCS.AccountRightRecordWrapper>();
            Appointment_Process_OneMDCS.AccountRightRecordWrapper accRightdWrapper = new Appointment_Process_OneMDCS.AccountRightRecordWrapper();
            
            accRecordWrapper.isSelected = false ;
            accRecordWrapper.AccountName = 'Rubai' ;
            accRecordWrapper.AccountId = lstAcc[0].Id;
            lstAccRecords.add(accRecordWrapper);
            
            accRecordWrapper = new Appointment_Process_OneMDCS.AccountRecordWrapper();
            accRecordWrapper.isSelected = false ;
            accRecordWrapper.AccountName = 'Rubai Test' ;
            accRecordWrapper.AccountId = lstAcc[1].Id;
            lstAccRecords.add(accRecordWrapper);
            
          
            String AccDetilsAsJson = JSON.serialize( lstAccRecords ) ; 
            Appointment_Process_OneMDCS.saveCalendarAdmin(String.valueOf(TerritoryNameCalendar[0].Id),AccDetilsAsJson);
            
            Appointment_Process_OneMDCS.getAppoForCust(getUserRecord( 'System Administrator' ).id );
            Appointment_Process_OneMDCS.getAppoForCustPast(getUserRecord( 'System Administrator' ).id );
            
            List<Account> getAcc = new List<Account>();
            getAcc = [Select Id, Primary_Territory__c, Calendar_Logic_OneMDCS__c From Account limit 1];
            
            String AccDetils = '';
            system.debug('-------------->AccDetils '+AccDetils);
            Appointment_Process_OneMDCS.saveCalendarAdmin(String.valueOf(TerritoryNameCalendar[0].Id),AccDetils);
            
            
            String RemoveCAS = '1234;2345';
            Appointment_Process_OneMDCS.removeAccountTerritory(String.valueOf(TerritoryNameCalendar[0].Id),RemoveCAS);
            
            String SelectedCAS = getAcc[0].Id + ';' + getAcc[0].Id;
            Appointment_Process_OneMDCS.addAccountTerritory(String.valueOf(TerritoryNameCalendar[0].Id), SelectedCAS);
            
     		Appointment_Process_OneMDCS.saveAccountInfo(String.valueOf(TerritoryNameCalendar[0].Id),SelectedCAS,RemoveCAS);
      
            //Affiliation Object trigger test 
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
            
            String Query = 'Select Id from Affiliation__c limit 1';
            List<sObject> getRecord = new List<sObject>();
            Lookupcontroller_OneMDCS objClass = new Lookupcontroller_OneMDCS();
            getRecord = Lookupcontroller_OneMDCS.querySalesforceRecord(Query);
            
            List<sObject> getAccRec = New List<sObject>();
            getAccRec = Lookupcontroller_OneMDCS.queryAccountRecord(acc[0].Name, 'Account', TerritoryNameCalendar[0].Id);
            List<Appointment_OneMDCS__c> applist = [Select id, Location_Encrypted_OneMDCS__c from Appointment_OneMDCS__c];
            getAccRec = Lookupcontroller_OneMDCS.queryAccountRecordforAppointment(acc[0].Name, 'Account',applist);
            Map<String, Boolean> emailSettingVal = Appointment_Process_OneMDCS.getEmailSettings();
            List<String> emailSetList= new List<String>();
            for(String str:emailSettingVal.keySet())
            {
                if(emailSettingVal.get(str)== true)
                {
                    emailSetList.add(str);
                }
            }
            System.assertEquals('New Request;Cancelled Request;Change to current case;Reassign;Unassigned', String.join(emailSetList, ';'));
            Test.stopTest();            
        }
    }
  
   public static testMethod void AppointmentProcessTestOne() 
    {
        objeUser.Email_Settings_OneMDCS__c = 'New Request;Cancelled Request;Change to current case;Reassign;Unassigned';
        update objeUser;
        System.runAs(objeUser){
        Appointment_OneMDCS__c objAppFuture = new Appointment_OneMDCS__c();
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
        objAppFuture.Email_OneMDCS__c = 'test@test.test';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '04:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '08:00';
        insert objAppFuture;
        
        Appointment_OneMDCS__c objAppFutureAdmin = new Appointment_OneMDCS__c();
        system.debug('-----> futureDate '+futureDate);
        objAppFutureAdmin.Appointment_Date_OneMDCS__c = futureDate;
        objAppFutureAdmin.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFutureAdmin.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFutureAdmin.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFutureAdmin.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFutureAdmin.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFutureAdmin.Status_OneMDCS__c = 'Unassigned';
        objAppFutureAdmin.Email_OneMDCS__c = 'test@test.test';
        objAppFutureAdmin.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFutureAdmin.Appointment_start_time_12hrs_OneMDCS__c = '09:00 AM';
        objAppFutureAdmin.Appointment_end_time_12_hrs_OneMDCS__c = '01:00 PM';
        objAppFutureAdmin.Appointment_Start_time_OneMDCS__c = '09:00';
        objAppFutureAdmin.Appointment_end_time_OneMDCS__c = '13:00';
        insert objAppFutureAdmin;
        
        Appointment_OneMDCS__c appo1 = new Appointment_OneMDCS__c();
        appo1 = [SELECT Id from Appointment_OneMDCS__c limit 1];
        User objUser1 = new User();
        objUser1 = [SELECT Id, Name from User limit 1];
        
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
        inserDefault.Date_assigned_OneMDCS__c = Date.today();
        inserDefault.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert inserDefault;
        //Appointment_Process_OneMDCS.getPerDayAvlOfCAS(TerritoryNameEmail[0].Name,'9/22/2017');
        Availability_Of_CAS_OneMDCS__c availableCas1 = new Availability_Of_CAS_OneMDCS__c();
        availableCas1 = [SELECT Id,CAS_Team_OneMDCS__c from Availability_Of_CAS_OneMDCS__c limit 1];
        
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objService.Is_True_OneMDCS__c = true;
        objService.Type_OneMDCS__c = 'Email Setting Cancel Case';
        objService.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objService.Name = 'Email Setting Cancel Case 2';
        Insert objService;
        
        Available_Services_OneMDCS__c objService1 = new Available_Services_OneMDCS__c();
        objService1.Is_True_OneMDCS__c = True;
        objService1.Type_OneMDCS__c = 'Email Setting Change Case';
        objService1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objService1.Name = 'Email Setting Change Case 1';
        Insert objService1;
              
        // Appointment_Process_OneMDCS.getAccountList(TerritoryNameEmail[0].id);
        // Appointment_Process_OneMDCS.getAccountListRightPanel(TerritoryNameEmail[0].id);
        // Appointment_Process_OneMDCS.getAccountListRightPanelOutsideTerritory(TerritoryNameEmail[0].id);
        // 
        Account insertAccount = new Account();
        insertAccount.Name = 'Account Unique 1234321';
        insertAccount.Calendar_Logic_OneMDCS__c = false;
     	insertAccount.JDE_JJHCS_Number__c = '56424/19835';
        insertAccount.Territory__c = 'testterr';
        insertAccount.Primary_Territory__c= 'testing';
        insert insertAccount;
        
        
    	Appointment_Process_OneMDCS.getleftAccountList(TerritoryNameEmail[0].id);
    	Appointment_Process_OneMDCS.getRightAccountList(TerritoryNameEmail[0].id);
    
        Available_Services_OneMDCS__c objService2 = new Available_Services_OneMDCS__c();
        objService2.Is_True_OneMDCS__c = True;
        objService2.Type_OneMDCS__c = 'Email Setting New Case';
        objService2.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objService2.Name = 'Email Setting New Case 3';
        Insert objService2;
        
        Available_Services_OneMDCS__c objServiceSameDay = new Available_Services_OneMDCS__c();
        objServiceSameDay.Is_True_OneMDCS__c = True;
        objServiceSameDay.Type_OneMDCS__c = 'Sameday Logic';
        objServiceSameDay.Selected_Time_Slots_OneMDCS__c = '10:00 AM';
        objServiceSameDay.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objServiceSameDay.Name = 'Sameday Logic 4';
        Insert objServiceSameDay;
        
        Available_Services_OneMDCS__c objService3 = new Available_Services_OneMDCS__c();
        objService3.Is_True_OneMDCS__c = True;
        objService3.Type_OneMDCS__c = 'Calendar Logic';
        objService3.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objService3.Name = 'Calendar Logic 5';
        Insert objService3;
     
        Available_Services_OneMDCS__c objSlotSettings = new Available_Services_OneMDCS__c();
        objSlotSettings.Name = 'Default Slot Settings';
        objSlotSettings.Territory_OneMDCS__c = 'Default';
        objSlotSettings.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettings.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettings.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
        
        insert objSlotSettings;
        
        
        Available_Services_OneMDCS__c objSlotSettingsTerritory = new Available_Services_OneMDCS__c();
        objSlotSettingsTerritory.Name = '   Slot Settings-0.0215';
        objSlotSettingsTerritory.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objSlotSettingsTerritory.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettingsTerritory.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettingsTerritory.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
        insert objSlotSettingsTerritory;

        
        system.debug('------> Entry');
        List<Available_Services_OneMDCS__c> accList = new List<Available_Services_OneMDCS__c>();
        accList = Appointment_Process_OneMDCS.getLocations(true, TerritoryNameEmail[0].Name);
        
        
        
        User objUser = new User();
        objUser = Appointment_Process_OneMDCS.userDetails();
        
        List<String> weekDays = new List<String>();
        Date objDate = date.today();
        
        User objUserCAS = new User();
        objUserCAS = [Select id, name from user limit 1];
        //Insert availableCas
        Availability_Of_CAS_OneMDCS__c objCAS = new Availability_Of_CAS_OneMDCS__c();
        objCAS.Name = objUserCAS.name;
        objCAS.AM_OneMDCS__c = true;
        objCAS.CAS_Team_OneMDCS__c = objUserCAS.id;
        objCAS.Default_OneMDCS__c = 'Y';
        //added for test coverage
        objCAS.Date_assigned_OneMDCS__c = Date.today();
        objCAS.PM_OneMDCS__c = true;
        objCAS.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objCAS;
        
        //Insert PDA
        Availability_Of_CAS_OneMDCS__c objCASPDA = new Availability_Of_CAS_OneMDCS__c();
        objCASPDA.Name = objUserCAS.name;
        objCASPDA.AM_OneMDCS__c = true;
        objCASPDA.CAS_Team_OneMDCS__c = objUserCAS.id;
        objCASPDA.Default_OneMDCS__c = 'N';
        objCASPDA.Date_assigned_OneMDCS__c = Date.today();
        objCASPDA.PM_OneMDCS__c = true;
        objCASPDA.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objCASPDA;
        
        //Create Account
        Id userId = UserInfo.getUserId();
        objAcc = new Account();
        objAcc.Name = 'Test Hospital';
        objAcc.Calendar_Logic_OneMDCS__c = true;
        insert objAcc;
        
        Account objAccQuery = new Account();
        objAccQuery = [SELECT Id from Account limit 1];
        
        Map<string,List<String>> getTimeSlotCover = new Map<string,List<String>>();
        String appoIdObj = null;
        getTimeSlotCover = Appointment_Process_OneMDCS.getSlot(String.valueOf(Date.today()),String.valueOf(4),TerritoryNameEmail[0].Name,appoIdObj, String.ValueOf(objAccQuery.Id));
        Appointment_Process_OneMDCS.getSlot(String.valueOf(Date.today()),String.valueOf(4),'Test',appoIdObj, 'Other');
        //Test.stopTest();
        Test.startTest();
        Appointment_Process_OneMDCS.getEmailSettings();
        
        Appointment_Process_OneMDCS.getTerritories();
        String json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2018-8-2","startslot":"07:00 AM","endslot":"11:00 AM","request":"Special","serviceName":"PVC","serviceHours":"4","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c"}';
        String json2 = '{"serviceSelected":"4"}';
        system.debug('@@@createAppointment@@@:');
        String createApp = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        
        
        json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2018-8-3","startslot":"07:00 PM","endslot":"11:00 PM","request":"Special","serviceName":"PVC","serviceHours":"4","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c"}';
        json2 = '{"serviceSelected":"4"}';
        system.debug('@@@createAppointment@@@:');
        String createApp1 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        
        Event newEvent = new Event();
        newEvent.OwnerId =  availableCas1.CAS_Team_OneMDCS__c;
        newEvent.Subject ='Appointment Scheduled';
        newEvent.IsRecurrence = false;
        newEvent.IsAllDayEvent =false;
        newEvent.DurationInMinutes =300;
        Date t = Date.newInstance(2018, 09, 16);
        newEvent.ActivityDate =t;
        datetime sttartDate =datetime.newInstance(2018, 09, 16, 07, 00, 00);
        
        newEvent.StartDateTime =sttartDate;
        
        insert newEvent;
        Event ev = new Event();
        ev = [SELECT Id from Event limit 1];
        Appointment_OneMDCS__c appoID = new Appointment_OneMDCS__c();
        appoID = [SELECT Id from Appointment_OneMDCS__c limit 1];
        
        CustomerInfoTest caswrap = new CustomerInfoTest();
        
        String appo1Id = String.valueOf(appo1.Id);
        String availableCas1Id = String.valueOf(availableCas1.Id);
        CustomerInfoTest customerInfowrap = new CustomerInfoTest();
        
        customerInfowrap.location = 'Hospital 3' ;
        customerInfowrap.name = 'Rubai' ;
        customerInfowrap.Email = 'rbaner14@its.jnj.com' ;
        customerInfowrap.AssignedDate = Date.valueOf('2018-9-16');
        customerInfowrap.SelectedDateValue = '2018-9-16';
        customerInfowrap.startslot = '07:00 AM' ;
        customerInfowrap.startTime24Hrs = '07:00';
        customerInfowrap.endslot = '12:00 PM' ;
        customerInfowrap.request = 'Special' ;
        customerInfowrap.serviceName =  'PVC' ;
        customerInfowrap.serviceHours  = '5' ;
        customerInfowrap.additionalEmail = 'A@d.c' ;
        customerInfowrap.additionalEmailOther = 'a@b.c';
        customerInfowrap.HigherTimeSelected = 'true' ;
        customerInfowrap.paramValue = 'Modify' ;
        customerInfowrap.serviceDuration = '5' ;
        customerInfowrap.appointmentId = appo1Id ;
        customerInfowrap.isTimeEdited = true;
        customerInfowrap.assignedCASId = availableCas1Id ;
        json1 = JSON.serialize( customerInfowrap ) ; 
        //json1 = '{"location":"Hospital 3","name":"Rubai","Email":"rbaner14@its.jnj.com","AssignedDate":"2017-09-3","startslot":"07:00 PM","endslot":"12:00 PM","request":"Special","serviceName":"PVC","serviceHours":"5","additionalEmail":"A@d.c","additionalEmailOther":"a@b.c","HigherTimeSelected":"true","serviceDuration":"5","appointmentId ":appo1Id,"assignedCASId":availableCas1Id }';
        json2 = '{"serviceSelected":"5"}';
        system.debug('@@@createAppointment@@@:');
        String createApp2 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
        CustomerInfoTest customerInfowrap1 = new CustomerInfoTest();
        
        customerInfowrap1.location = 'Hospital 3' ;
        customerInfowrap1.name = 'Rubai' ;
        customerInfowrap1.Email = 'rbaner14@its.jnj.com' ;
        customerInfowrap1.AssignedDate = Date.valueOf('2017-9-16');
        customerInfowrap1.SelectedDateValue = '2018-9-16';
        customerInfowrap1.paramValue = 'Modify' ;
        customerInfowrap1.startTime24Hrs = '09:00';
        customerInfowrap1.startslot = '09:00 AM' ;
        customerInfowrap1.endslot = '12:00 PM' ;
        customerInfowrap1.request = 'Special' ;
        customerInfowrap1.serviceName =  'PVC' ;
        customerInfowrap1.serviceHours  = '3' ;
        customerInfowrap1.additionalEmail = 'A@d.c' ;
        customerInfowrap1.additionalEmailOther = 'a@b.c';
        customerInfowrap1.isTimeEdited = true;
        customerInfowrap1.HigherTimeSelected = 'false' ;
        customerInfowrap1.serviceDuration = '3' ;
        customerInfowrap1.appointmentId = appo1Id ;
        customerInfowrap1.assignedCASId = availableCas1Id ;
        
        json1 = JSON.serialize( customerInfowrap1 ) ; 
        json2 = '{"serviceSelected":"3"}';
        system.debug('@@@createAppointment@@@:');
        String createApp3 = Appointment_Process_OneMDCS.createAppointment(json1,json2);
		Id checkAccId= [SELECT CreatedDate FROM Appointment_OneMDCS__c order by CreatedDate asc Limit 1 ].id;
        System.assertEquals(checkAccId, createApp3);
        }
    
  }
    public class CustomerInfoTest
    {
        Date AssignedDate {get; set;}
        String name {get; set;}
        String Email {get; set;}
        String location {get; set;}
        String request {get; set;}
        String startslot {get; set;}
        String endslot {get; set;}
        String serviceName {get; set;}
        String serviceHours {get; set;}
        String additionalEmail {get; set;}
        String additionalEmailOther {get; set;}
        String appointmentId {get; set;}
        String startTime24Hrs {get; set;}
        String assignedCASId {get; set;}
        String assignedCASName {get; set;}
        String HigherTimeSelected {get; set;}
        String SelectedDateValue {get; set;}
        String serviceDuration {get; set;}
        String paramValue {get; set;}
        Boolean isTimeEdited {get; set;}
        String territoryUser;
        
        
    }
    public class BookingInfoWrapperTest{
        String serviceSelected {get; set;}
    }
    
    
    public static testMethod void testColor_OneMDCS()
    {
       
       Combine_Territory__c terri= new Combine_Territory__c();
       terri.Name='Houston';
       List <String> terr= new List<String>();
        Territory ter1 = new Territory();
        ter1.Name='Test1';
        Territory ter2 = new Territory();
        ter2.Name='Test2';
        
       User uatUser10 =  getUserRecord( 'System Administrator' ) ;
       User uatUser11 = new User();
        if(uatUser11.Color__c == '')
        {
            
            uatUser10.Color__c='#ff8c00';
            uatUser10.Primary_Territory_OneMDCS__c = 'terri.Name';
            terr.add(uatUser10.Primary_Territory_OneMDCS__c);
            
        }
        else
        {
            
            uatUser11.Color__c= uatUser10.Color__c;
            uatUser11.Primary_Territory_OneMDCS__c = 'terri.Name';
        }
        List<String> listOfColors = Appointment_Process_OneMDCS.getcolorlist();
        System.runAs(uatUser10){
        String Check = Appointment_Process_OneMDCS.iscoloradded();
        System.assertEquals('#ff8c00', Check);
        Appointment_Process_OneMDCS.isPrimaryTerritory();
        Appointment_Process_OneMDCS.addcolortouser('#ff8c00');
        }
        
        
    }
    
    public static testMethod void testObjServiceCalLogic()
    {
        List<Available_Services_OneMDCS__c> CalLogic = new List<Available_Services_OneMDCS__c>();
        
        if(CalLogic.size() == 0)
        {
         String selectedAMSlots = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
		 String selectedPMSlots = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
         List<Territory> TerritoryNameEmail1 = new List<Territory>();
         TerritoryNameEmail1 = [SELECT Id, Name, ParentTerritoryId FROM Territory where name = 'Alaska' limit 1];
         Available_Services_OneMDCS__c availableServicesData = new Available_Services_OneMDCS__c();
		 availableServicesData.Is_True_OneMDCS__c = True;
		 availableServicesData.Type_OneMDCS__c = 'Slot Settings';
		 availableServicesData.Territory_OneMDCS__c = TerritoryNameEmail1[0].Name;
		 availableServicesData.Name = 'Slot Settings-0.1234';
		 availableServicesData.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
		 availableServicesData.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
         insert availableServicesData;
            
       List<Available_Services_OneMDCS__c> availabileServicesList = new List<Available_Services_OneMDCS__c>();
		Available_Services_OneMDCS__c availableServicesData1 = createAvailableServicesTestData(true,'Slot Settings',TerritoryNameEmail1[0].Name,'Slot Settings-0.0215',selectedAMSlots,selectedPMSlots);
		availabileServicesList.add(availableServicesData1);
            
        String selectedTimes = '[{"isSelected":false,"timeslot":"4:00AM"},{"isSelected":false,"timeslot":"4:30AM"},{"isSelected":true,"timeslot":"5:00AM"},{"isSelected":true,"timeslot":"5:30AM"},{"isSelected":true,"timeslot":"6:00AM"},{"isSelected":true,"timeslot":"6:30AM"},{"isSelected":true,"timeslot":"7:00AM"},{"isSelected":true,"timeslot":"7:30AM"},{"isSelected":true,"timeslot":"8:00AM"},{"isSelected":true,"timeslot":"8:30AM"},{"isSelected":true,"timeslot":"9:00AM"},{"isSelected":true,"timeslot":"9:30AM"},{"isSelected":true,"timeslot":"10:00AM"},{"isSelected":true,"timeslot":"10:30AM"},{"isSelected":true,"timeslot":"11:00AM"},{"isSelected":false,"timeslot":"11:30AM"},{"isSelected":false,"timeslot":"12:00PM"},{"isSelected":false,"timeslot":"12:30PM"},{"isSelected":true,"timeslot":"1:00PM"},{"isSelected":true,"timeslot":"1:30PM"},{"isSelected":true,"timeslot":"2:00PM"},{"isSelected":true,"timeslot":"2:30PM"},{"isSelected":false,"timeslot":"3:00PM"},{"isSelected":false,"timeslot":"3:30PM"},{"isSelected":false,"timeslot":"4:00PM"},{"isSelected":false,"timeslot":"4:30PM"},{"isSelected":false,"timeslot":"5:00PM"},{"isSelected":false,"timeslot":"5:30PM"},{"isSelected":false,"timeslot":"6:00PM"},{"isSelected":false,"timeslot":"6:30PM"},{"isSelected":false,"timeslot":"7:00PM"},{"isSelected":true,"timeslot":"7:30PM"},{"isSelected":false,"timeslot":"8:00PM"}]';
        Appointment_Process_OneMDCS.saveTime(TerritoryNameEmail1[0].Name,selectedTimes);
		String selectedSlotCheck = [Select Selected_Time_Slots_AM_OneMDCS__c from Available_Services_OneMDCS__c where Territory_OneMDCS__c ='Alaska' AND Type_OneMDCS__c = 'Slot Settings' Limit 1].Selected_Time_Slots_AM_OneMDCS__c;
        System.assert(selectedSlotCheck.contains('07:00 AM'));
        }
    }
    
    public static testMethod void testColorData()
    {
	    List<Color_List_OneMDCS__c> cList = new List<Color_List_OneMDCS__c>();
        Color_List_OneMDCS__c colList = new Color_List_OneMDCS__c();
        colList.Name= 'darkslateblue';
        colList.Hexacode__c = '#483d8b';
        Color_List_OneMDCS__c newColList = new Color_List_OneMDCS__c();
        newColList.Name = 'goldenrod';
        newColList.Hexacode__c = '#daa520';
        cList.add(colList);
        cList.add(newColList);
        insert cList;
		
        List<String> Color= new List<String>();
        Color.add('#483d8b');
        Color.add('#daa520');
        Color.add('#00ffff');
        Color_List_OneMDCS__c testlist = new Color_List_OneMDCS__c();
        testList.Name= 'aqua';
        testList.Hexacode__c= '#00ffff';
        Territory Terr= new Territory();
        Terr.Name='Test Territory';
        Territory Terr1= new Territory();
        Terr1.Name='Test Territory2';
        Combine_Territory__c Combine_terr= new Combine_Territory__c();
        Combine_terr.Name='Combine Territory test';
        Combine_terr.Territory__c='Terr.Name' +';' +'Terr1.Name';
        List<String> listOfColors = Appointment_Process_OneMDCS.getcolorlist();
		String colorList = String.join( listOfColors, ',');
        System.assert(colorList.contains('#daa520'));
        
    }
    
    static testMethod void test_updateNote(){
        List<Appointment_OneMDCS__c> appointment_onemdcs_Obj  =  [SELECT Id,Detailed_Note_OneMDCS__c,Header_Note_OneMDCS__c from Appointment_OneMDCS__c limit 1];
        System.assertEquals(true,appointment_onemdcs_Obj.size()>0);
        List<Appointment_Process_OneMDCS.updateMyCASWrapper> obj01 = new List<Appointment_Process_OneMDCS.updateMyCASWrapper>();
        Appointment_Process_OneMDCS.updateMyCASWrapper obj11 = new Appointment_Process_OneMDCS.updateMyCASWrapper();
        obj11.recID = appointment_onemdcs_Obj[0].Id;
        obj11.Header_Note = 'test data';
        obj11.Detailed_Note = 'test data1';
        obj01.add(obj11);
        String Json_Data=JSON.serialize(obj01);
        Appointment_Process_OneMDCS.updateNote(Json_Data);
    }
   
    static testMethod void test_getContact()
    {
            List <Account> acc = new List <Account>();
            acc = [SELECT Id, Name from Account limit 1];
            List <Contact> con = new List <Contact>();
            con = [SELECT Id, Name from Contact limit 1];
            
            Contact_Details_OneMDCS__c cd = new Contact_Details_OneMDCS__c();
            cd.name = 'CON-001';
            cd.Contact_Id_OneMDCS__c = insertContact().id;
            cd.Hospital_Id_OneMDCS__c = insertAccount().id;
            cd.Contact_Type_OneMDCS__c = 'EP';
            cd.Contact_Name__c = 'Test Con';
            insert cd;
            
            Affiliation__c aff = new Affiliation__c();
            aff.Physician__c = insertContact().id;
            aff.Hospital__c = insertAccount().id;
            insert aff;
            List<Contact_Details_OneMDCS__c> conn = Appointment_Process_OneMDCS.getContacts(cd.Hospital_Id_OneMDCS__c);
            System.assertEquals('Test Con', conn[0].Contact_Name__c);
    }
    
    
    
	
	static testmethod void testsendmail(){
        List<appointment_OneMDCS__c> appolist = new List<appointment_OneMDCS__c>();
        appointment_OneMDCS__c objAppFuture = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture.Location_Encrypted_OneMDCS__c = null;
        objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = null;
        objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = null;
        objAppFuture.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture.Email_OneMDCS__c = 'test@test.test';
        objAppFuture.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture.Appointment_start_time_12hrs_OneMDCS__c = null;
        objAppFuture.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture.Territory_OneMDCS__c = 'Test';
        objAppFuture.Appointment_Start_time_OneMDCS__c = '04:00';
        objAppFuture.Appointment_end_time_OneMDCS__c = '08:00';
        objAppFuture.Assigned_CAS_OneMDCS__c = [Select Id,Name from Availability_Of_CAS_OneMDCS__c where Name != null limit 1].Id;
        objAppFuture.Header_Note_OneMDCS__c = null;
        objAppFuture.Detailed_Note_OneMDCS__c = null;
        appolist.add(objAppFuture);
        Territory tr = [Select Name from Territory where name != null limit 1 ];
        User userData = new User();
        userData = [SELECT Id, Name from User limit 1];
        List<Availability_Of_CAS_OneMDCS__c> caslist = new List<Availability_Of_CAS_OneMDCS__c>();
        Availability_Of_CAS_OneMDCS__c casDataOne = createAvailabilityOfCASTestData(userData,'13:00;17:00',true,true,'Y','08:00;12:00',false,Date.today(),tr.Name);
        caslist.add(casDataOne);
        Test.startTest();
        String str = Appointment_Process_OneMDCS.sendemailtoteam(appolist,caslist,tr.Name,'05/02/2018');
        List<String> options = Appointment_Process_OneMDCS.getselectOptions('Default_OneMDCS__c');
        Availability_Of_CAS_OneMDCS__c casDataTwo = createAvailabilityOfCASTestData(userData,'13:00;17:00',false,true,'Y','08:00;12:00',true,Date.today(),tr.Name);
        caslist.add(casDataTwo);
        String str1 = Appointment_Process_OneMDCS.sendemailtoteam(appolist,caslist,tr.Name,'05/02/2018');
        List<String> options1 = Appointment_Process_OneMDCS.getselectOptions('Default_OneMDCS__c');
        Availability_Of_CAS_OneMDCS__c casDataThree = createAvailabilityOfCASTestData(userData,'13:00;17:00',false,true,'Y','08:00;12:00',false,Date.today(),tr.Name);
        caslist.add(casDataThree);
        String str2 = Appointment_Process_OneMDCS.sendemailtoteam(appolist,caslist,tr.Name,'05/02/2018');
        List<String> options2 = Appointment_Process_OneMDCS.getselectOptions('Default_OneMDCS__c');
		System.assert(str2.contains('Daily Appointment Summary Data 05/02/2018'));

        //List<String> SumReport = Appointment_Process_OneMDCS.getSumReport(tr.Name);
        Test.stopTest();
        
    }
    public static testMethod void testdata1()
    {
        Date todayParam = date.Today();
        Date futureDateParam = todayParam.addDays(2);
        String dateParam = string.ValueOf(futureDateParam);
        Finalize_Schedule_Per_Territory_OneMDCS__c evt= new Finalize_Schedule_Per_Territory_OneMDCS__c();
            evt.Subject__c = 'Test event';
            evt.Date_OneMDCS__c = todayParam;
            evt.State_Time__c = '12:00 PM';
            evt.End_Time__c = '01:30 PM';
            evt.Territory_OneMDCS__c = 'Alaska';
			evt.Description_OneMDCS__c = 'Test description';
        insert evt;
        
        String evtId= [Select id,name from Finalize_Schedule_Per_Territory_OneMDCS__c limit 1].id;
        String evtDesc= [Select Description_OneMDCS__c from Finalize_Schedule_Per_Territory_OneMDCS__c limit 1].Description_OneMDCS__c;
        System.assertEquals('Test description', evtDesc);
        String name= 'test1';
        User user_list = new User();
        user_list = [SELECT Id, name from User limit 1];
        Test.startTest();
            Appointment_Process_OneMDCS.finalzedSchedulePerTerritory(name,dateParam);    
            Appointment_Process_OneMDCS.getDetailsOfCust(String.valueof(user_list.id));       
            Appointment_Process_OneMDCS.getSelectedDate(dateParam);
            Appointment_Process_OneMDCS.EventDeletion(evtId);
        Test.stopTest();
    }
    
    public static testMethod void emailTest()
	{
		test.startTest();
		Appointment_OneMDCS__c getAppId = new Appointment_OneMDCS__c();
        getAppId = [SELECT id, Email_OneMDCS__c from Appointment_OneMDCS__c where Email_OneMDCS__c != null  limit 1];
        String getId = string.ValueOf(getAppId.id);
        String message = 'Test mreason';
        String emailIds = 'test@test.test; test@test.test';
        String emailIds1 ='test@test.test';
        Appointment_Process_OneMDCS.sendEmailTo(getId,emailIds1);
        Appointment_Process_OneMDCS.sendEmailTo(getId,emailIds);
        Appointment_Process_OneMDCS.updateReason(getId,message);
		String reason= [SELECT Reason_OneMDCS__c from Appointment_OneMDCS__c where id =:getId].Reason_OneMDCS__c;
        System.assertEquals(message, reason);
		test.stopTest();
	}
}