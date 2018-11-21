/*
*******************************************  This is a Test Class of Appointment_Process_OneMDCS ***************************
Main Class : Appointment_Process_OneMDCS_Helper
Created date : 11/01/2017
Created By : Capgemini
*/

@isTest(SeeAllData = false)
public class Appointment_Process_HelperTEST_OneMDCS
{
    public static testMethod void AppointmentProcessTest()
    {
        //--------------Query Territory--------------//
        
        List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
        
        //--------------Query Territory--------------//
        //Create Account
        Id userId = UserInfo.getUserId();
        Account objAcc = new Account();
        objAcc.Name = 'Test Hospital';
        objAcc.Calendar_Logic_OneMDCS__c = true;
        insert objAcc;
        //-----------Create Appointment future Start ------//
        
        Appointment_OneMDCS__c objAppFuture1 = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture1.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture1.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture1.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture1.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture1.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture1.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture1.Status_OneMDCS__c = 'Unassigned';
        objAppFuture1.Email_OneMDCS__c = 'test@test.test';
        objAppFuture1.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture1.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture1.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture1;
        
        
        Appointment_OneMDCS__c objAppFuture3 = new Appointment_OneMDCS__c();
        Date todayAppo = date.Today();
        Date futureDateAppo = todayAppo.addDays(1);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture3.Appointment_Date_OneMDCS__c = futureDateAppo;
        objAppFuture3.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture3.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture3.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture3.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture3.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture3.Status_OneMDCS__c = 'Unassigned';
        objAppFuture3.Email_OneMDCS__c = 'test@test.test';
        objAppFuture3.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture3.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture3.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture3.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture3;
        
        
        Appointment_OneMDCS__c objAppFuture4 = new Appointment_OneMDCS__c();
        Date today4 = date.Today();
        Date futureDate4 = today.addDays(3);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture4.Appointment_Date_OneMDCS__c = futureDate4;
        objAppFuture4.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture4.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture4.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture4.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture4.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture4.Status_OneMDCS__c = 'Unassigned';
        objAppFuture4.Email_OneMDCS__c = 'test@test.test';
        objAppFuture4.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture4.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture4.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture4.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture4;
        
        //-----------Create Appointment future End ------//
        
        //-----------Create CAS Start ------//
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS1 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS1.Name = 'Test CAS';
        objAvlCAS1.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS1.AM_OneMDCS__c = True;
        objAvlCAS1.Availability_CAS_OneMDCS__c = True;
        objAvlCAS1.Default_OneMDCS__c = 'Y';
        objAvlCAS1.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS1.PM_OneMDCS__c = True;
        objAvlCAS1.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS1;
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS2 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS2.Name = 'Test CAS';
        objAvlCAS2.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS2.AM_OneMDCS__c = True;
        objAvlCAS2.Availability_CAS_OneMDCS__c = True;
        objAvlCAS2.Default_OneMDCS__c = 'Y';
        objAvlCAS2.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS2.PM_OneMDCS__c = True;
        objAvlCAS2.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS2.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS2;
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS3 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS3.Name = 'Test CAS';
        objAvlCAS3.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS3.AM_OneMDCS__c = True;
        objAvlCAS3.Availability_CAS_OneMDCS__c = True;
        objAvlCAS3.Default_OneMDCS__c = 'Y';
        objAvlCAS3.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS3.PM_OneMDCS__c = True;
        objAvlCAS3.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS3.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS3;
        
        //-----------Create CAS End ------//
        
        //-----------Create PDA DATA Start ------//
        
        
        Date todayPDA = date.Today();
        Date futureDatePDA = today.addDays(2);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA.Name = 'Test PDA';
        objAvlCASPDA.AM_OneMDCS__c = False;
        objAvlCASPDA.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA.Default_OneMDCS__c = 'N';
        objAvlCASPDA.PM_OneMDCS__c = True;
        objAvlCASPDA.Date_assigned_OneMDCS__c = futureDatePDA;
        objAvlCASPDA.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA;
        
        Date todayPDA1 = date.Today();
        Date futureDatePDA1 = today.addDays(3);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA1 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA1.Name = 'Test PDA';
        objAvlCASPDA1.AM_OneMDCS__c = True;
        objAvlCASPDA1.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA1.Default_OneMDCS__c = 'N';
        objAvlCASPDA1.PM_OneMDCS__c = False;
        objAvlCASPDA1.Date_assigned_OneMDCS__c = futureDatePDA1;
        objAvlCASPDA1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA1;
        
        Date todayPDA2 = date.Today();
        Date futureDatePDA2 = today.addDays(1);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA2 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA2.Name = 'Test PDA';
        objAvlCASPDA2.AM_OneMDCS__c = True;
        objAvlCASPDA2.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA2.Default_OneMDCS__c = 'N';
        objAvlCASPDA2.PM_OneMDCS__c = True;
        objAvlCASPDA2.Date_assigned_OneMDCS__c = futureDatePDA2;
        objAvlCASPDA2.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA2;
        
        
        //-----------Create PDA DATA End ------//
        
        
        
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
        
        Available_Services_OneMDCS__c objSlotSettingsDefault = new Available_Services_OneMDCS__c();
        objSlotSettingsDefault.Name = 'Default All Slot';
        objSlotSettingsDefault.Territory_OneMDCS__c = 'Default All Slot';
        objSlotSettingsDefault.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettingsDefault.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettingsDefault.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
        
        insert objSlotSettingsDefault;
        
        Available_Services_OneMDCS__c objSlotSettingsTerritory = new Available_Services_OneMDCS__c();
        objSlotSettingsTerritory.Name = '   Slot Settings-0.0215';
        objSlotSettingsTerritory.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objSlotSettingsTerritory.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettingsTerritory.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettingsTerritory.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
            
        insert objSlotSettingsTerritory;
        
        Account objAccQuery = new Account();
        objAccQuery = [SELECT Id from Account limit 1];
        
        Map<string,List<String>> slopMap= Appointment_Process_OneMDCS_Helper.getSlotHelper(String.valueOf(date.today()), '4', TerritoryNameEmail[0].Name, null, String.ValueOf(objAccQuery.Id));
        List<List<String>> slotList = slopMap.values();
        String slotval=String.join(slotList[0], ';');
        System.assertEquals(true,slotval.contains(objSlotSettingsTerritory.Selected_Time_Slots_AM_OneMDCS__c));
        
        
    }
    
    public static testMethod void AppointmentProcessTestCalLogic()
    {
        //--------------Query Territory--------------//
        
        List<Territory> TerritoryNameEmail = new List<Territory>();
        TerritoryNameEmail = [SELECT Id, Name, ParentTerritoryId FROM Territory limit 1];
        
        //--------------Query Territory--------------//
        
        //-----------Create Appointment future Start ------//
        
        Appointment_OneMDCS__c objAppFuture1 = new Appointment_OneMDCS__c();
        Date today = date.Today();
        Date futureDate = today.addDays(2);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture1.Appointment_Date_OneMDCS__c = futureDate;
        objAppFuture1.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture1.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture1.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture1.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture1.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture1.Status_OneMDCS__c = 'Unassigned';
        objAppFuture1.Email_OneMDCS__c = 'test@test.test';
        objAppFuture1.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture1.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture1.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture1;
        
        
        Appointment_OneMDCS__c objAppFuture3 = new Appointment_OneMDCS__c();
        Date todayAppo = date.Today();
        Date futureDateAppo = todayAppo.addDays(1);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture3.Appointment_Date_OneMDCS__c = futureDateAppo;
        objAppFuture3.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture3.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture3.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture3.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture3.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture3.Status_OneMDCS__c = 'Unassigned';
        objAppFuture3.Email_OneMDCS__c = 'test@test.test';
        objAppFuture3.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture3.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture3.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture3.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture3;
        
        
        Appointment_OneMDCS__c objAppFuture4 = new Appointment_OneMDCS__c();
        Date today4 = date.Today();
        Date futureDate4 = today.addDays(3);
        system.debug('-----> futureDate '+futureDate);
        objAppFuture4.Appointment_Date_OneMDCS__c = futureDate4;
        objAppFuture4.Email_OneMDCS__c = 'testEmail@test.com';
        objAppFuture4.Location_Encrypted_OneMDCS__c = 'Test Hospital 1';
        objAppFuture4.Name_Of_Physician_Encrypted_OneMDCS__c = 'Test Physician';
        objAppFuture4.Procedure_Name_Encrypted_OneMDCS__c = 'Test Procedure';
        objAppFuture4.Service_Hours_OneMDCS__c = '4 Hours';
        objAppFuture4.Status_OneMDCS__c = 'Unassigned';
        objAppFuture4.Email_OneMDCS__c = 'test@test.test';
        objAppFuture4.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        objAppFuture4.Appointment_start_time_12hrs_OneMDCS__c = '04:00 AM';
        objAppFuture4.Appointment_end_time_12_hrs_OneMDCS__c = '08:00 AM';
        objAppFuture4.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        insert objAppFuture4;
        
        //-----------Create Appointment future End ------//
        
        //-----------Create CAS Start ------//
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS1 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS1.Name = 'Test CAS';
        objAvlCAS1.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS1.AM_OneMDCS__c = True;
        objAvlCAS1.Availability_CAS_OneMDCS__c = True;
        objAvlCAS1.Default_OneMDCS__c = 'Y';
        objAvlCAS1.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS1.PM_OneMDCS__c = True;
        objAvlCAS1.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS1;
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS2 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS2.Name = 'Test CAS';
        objAvlCAS2.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS2.AM_OneMDCS__c = True;
        objAvlCAS2.Availability_CAS_OneMDCS__c = True;
        objAvlCAS2.Default_OneMDCS__c = 'Y';
        objAvlCAS2.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS2.PM_OneMDCS__c = True;
        objAvlCAS2.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS2.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS2;
        
        Availability_Of_CAS_OneMDCS__c objAvlCAS3 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCAS3.Name = 'Test CAS';
        objAvlCAS3.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
        objAvlCAS3.AM_OneMDCS__c = True;
        objAvlCAS3.Availability_CAS_OneMDCS__c = True;
        objAvlCAS3.Default_OneMDCS__c = 'Y';
        objAvlCAS3.Morning_Slot_OneMDCS__c = '08:00;12:00';
        objAvlCAS3.PM_OneMDCS__c = True;
        objAvlCAS3.Date_assigned_OneMDCS__c = Date.today();
        objAvlCAS3.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCAS3;
        
        //-----------Create CAS End ------//
        
        //-----------Create PDA DATA Start ------//
        
        
        Date todayPDA = date.Today();
        Date futureDatePDA = today.addDays(2);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA.Name = 'Test PDA';
        objAvlCASPDA.AM_OneMDCS__c = False;
        objAvlCASPDA.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA.Default_OneMDCS__c = 'N';
        objAvlCASPDA.PM_OneMDCS__c = True;
        objAvlCASPDA.Date_assigned_OneMDCS__c = futureDatePDA;
        objAvlCASPDA.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA;
        
        Date todayPDA1 = date.Today();
        Date futureDatePDA1 = today.addDays(3);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA1 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA1.Name = 'Test PDA';
        objAvlCASPDA1.AM_OneMDCS__c = True;
        objAvlCASPDA1.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA1.Default_OneMDCS__c = 'N';
        objAvlCASPDA1.PM_OneMDCS__c = False;
        objAvlCASPDA1.Date_assigned_OneMDCS__c = futureDatePDA1;
        objAvlCASPDA1.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA1;
        
        Date todayPDA2 = date.Today();
        Date futureDatePDA2 = today.addDays(1);
        Availability_Of_CAS_OneMDCS__c objAvlCASPDA2 = new Availability_Of_CAS_OneMDCS__c();
        objAvlCASPDA2.Name = 'Test PDA';
        objAvlCASPDA2.AM_OneMDCS__c = True;
        objAvlCASPDA2.Availability_CAS_OneMDCS__c = True;
        objAvlCASPDA2.Default_OneMDCS__c = 'N';
        objAvlCASPDA2.PM_OneMDCS__c = True;
        objAvlCASPDA2.Date_assigned_OneMDCS__c = futureDatePDA2;
        objAvlCASPDA2.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        
        insert objAvlCASPDA2;
        
        
        //-----------Create PDA DATA End ------//
        
        
        
        Available_Services_OneMDCS__c objService3 = new Available_Services_OneMDCS__c();
        objService3.Is_True_OneMDCS__c = False;
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
        
        Available_Services_OneMDCS__c objSlotSettingsDefault = new Available_Services_OneMDCS__c();
        objSlotSettingsDefault.Name = 'Default All Slot';
        objSlotSettingsDefault.Territory_OneMDCS__c = 'Default All Slot';
        objSlotSettingsDefault.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettingsDefault.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettingsDefault.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
        
        insert objSlotSettingsDefault;
        
        Available_Services_OneMDCS__c objSlotSettingsTerritory = new Available_Services_OneMDCS__c();
        objSlotSettingsTerritory.Name = '   Slot Settings-0.0215';
        objSlotSettingsTerritory.Territory_OneMDCS__c = TerritoryNameEmail[0].Name;
        objSlotSettingsTerritory.Type_OneMDCS__c = 'Slot Settings';
        objSlotSettingsTerritory.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
        objSlotSettingsTerritory.Selected_Time_Slots_PM_OneMDCS__c = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
            
        insert objSlotSettingsTerritory;
        //Create Account
        Id userId = UserInfo.getUserId();
        Account objAcc = new Account();
        objAcc.Name = 'Test Hospital';
        objAcc.Calendar_Logic_OneMDCS__c = true;
        insert objAcc;
        Account objAccQuery = new Account();
        objAccQuery = [SELECT Id from Account limit 1];
        
        Appointment_Process_OneMDCS_Helper.getSlotHelper(String.valueOf(date.today()), '4', TerritoryNameEmail[0].Name, null, 'Other');
        
        appointmentProcess_Admin_Helper_OneMDCS objCls = new appointmentProcess_Admin_Helper_OneMDCS();
        String bookedDateVal = objCls.getBookedDateString(TerritoryNameEmail[0].Name);
        List<appointmentProcess_Admin_Helper_OneMDCS.BookPTOWrapper> deseVal= new List<appointmentProcess_Admin_Helper_OneMDCS.BookPTOWrapper>();
        deseVal = (List<appointmentProcess_Admin_Helper_OneMDCS.BookPTOWrapper>)System.JSON.deserialize(bookedDateVal, List<appointmentProcess_Admin_Helper_OneMDCS.BookPTOWrapper>.class);
        System.assertEquals(3,deseVal.size());
        
        
    }
}