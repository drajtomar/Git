/*
*******************************************  This is a Test Class of appointmentProcess_TVCore_Helper ***************************
Main Class : JNJ_Admin_Calender_Controller_OneMDCS and JNJ_Admin_Calender_helper_OneMDCS
Created date : 08/01/2017
Created By : Capgemini
*/


@isTest

public class JNJ_Admin_Calender_OneMDCS_TEST{

    
    
	@TestSetup
	static void initData()
	{
		Combine_Territory__c comTerritory = new Combine_Territory__c(Name='Houston',Territory__c = 'Houston North;Houston, TX',Old_Name__c = 'HUN-HUS');
		insert comTerritory;
	}
	//:: This method create User on the Basis of Role and Profile
    //:: Need to call from test method
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
        uatuser.Primary_Territory_OneMDCS__c = 'WEST BENGAL' ;
		uatuser.Email_Settings_OneMDCS__c='New Request;Cancelled Request;Change to current case;Unassigned;Reassign;Created;Modified';
        insert uatuser ;
        
        
        return uatuser  ;
    
    }

    public static Territory insertTeritorry() {
        
        Territory t = new Territory();
        t.External_Territory_Id__c = 'TE';
        t.Name = 'Alaska';
        // t.ForecastUserId = u.id;
        insert t;
        
        return t ;
    }
	
	public static Available_Services_OneMDCS__c insertavailableservices (){
		
		Available_Services_OneMDCS__c avl = new Available_Services_OneMDCS__c();
        avl.Name = 'Default Slot Settings';
		avl.Selected_Time_Slots_AM_OneMDCS__c = '04:00 AM;04:30 AM;05:00 AM;05:30 AM;06:00 AM;06:30 AM;07:00 AM;07:30 AM;08:00 AM;08:30 AM;09:00 AM;09:30 AM;10:00 AM;10:30 AM;11:00 AM;11:30 AM';
		avl.Selected_Time_Slots_PM_OneMDCS__c  = '12:00 PM;12:30 PM;01:00 PM;01:30 PM;02:00 PM;02:30 PM;03:00 PM;03:30 PM;04:00 PM;04:30 PM;05:00 PM;05:30 PM;06:00 PM;06:30 PM;07:00 PM;07:30 PM;08:00 PM';
		insert avl;
		return avl;
	}
    
    public static Finalize_Schedule_Per_Territory_OneMDCS__c inserteventdata(){
        
    	Finalize_Schedule_Per_Territory_OneMDCS__c fspt = new Finalize_Schedule_Per_Territory_OneMDCS__c();
        fspt.Subject__c = 'test event'; 
        fspt.Date_OneMDCS__c = date.today(); 
        fspt.State_Time__c = '04:00 AM';
        fspt.End_Time__c = '05:30 AM';
        fspt.Name = 'testname';
        fspt.Territory_OneMDCS__c = 'Alabama, Gerogia';
        
		insert fspt;
		return fspt;        
        
    }
    
    //:: commnets : This method returns record of Appointment_OneMDCS__c object
    //:: Need to call from test methods
    public static Appointment_OneMDCS__c getAppointmentrecord_method1(String startTime , String endTime , Date assignedDate, String serviceHour ){
    
        Appointment_OneMDCS__c appointmentrecord = new Appointment_OneMDCS__c();
        
        appointmentrecord.Appointment_Start_time_OneMDCS__c = startTime ;
        appointmentrecord.Appointment_end_time_OneMDCS__c = endTime ;
        appointmentrecord.Appointment_Date_OneMDCS__c = assignedDate ;
        appointmentrecord.Service_Hours_OneMDCS__c = serviceHour ;
        appointmentrecord.Territory_OneMDCS__c = 'WEST BENGAL' ;
        appointmentrecord.Status_OneMDCS__c = 'Unassigned';
        appointmentrecord.Email_OneMDCS__c = 'test@test.test';
        appointmentrecord.Additional_Email_OneMDCS__c = 'test@test.test;test@test.test;test@test.test';
        //insert casavailability ;
        
        return appointmentrecord ;
    
    }
    
    
    public static testMethod void loadCalendarByTeritory_method1(){
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  START :::::::::::::::::::::::::::::::::::::::
        

        
        
        //::::::::::::::::::::::::::::::::::: Calling User creation method :::::::::::::::::::::::::::::::
        
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
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
            
            
           JNJ_Admin_Calender_Controller_OneMDCS.getPerDayAvlOfCAS(TerritoryNameEmail[0].Name,'9/22/2017');
           //JNJ_Admin_Calender_Controller_OneMDCS.getPerDayAvlOfCASWithoutJson(TerritoryNameEmail[0].Name,'9/22/2017');
            
            
            String customerTerritory   = 'WEST BENGAL';
            Date systemCurrentDate =System.today() ; 
            String cDate ;
            String[] formatedDateTime ;
            String[] formateddate ;
            String finalDateformatonUI ;
            String requestHour = '4' ;
            
                                    //:: Find out first day of week excluding Saturday and Sunday
            Date inputdate2 = System.today()  ;
            Date nextday = inputdate2 ;
            String strDate = inputdate2.format() ;
            Integer Indexvar = 0;
            Integer upperlimitvar = 6 ;
            
            while( Indexvar <  upperlimitvar ){
                
                String[] nextweekvar = strDate.split( '/' );
                DateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[2] ) , Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) ,0,0,0);
                
                if( dtime.format( 'EEEE' ) == 'Saturday' || dtime.format( 'EEEE' ) ==  'Sunday' ){
                    upperlimitvar++ ;
                
                }else{
                    systemCurrentDate = nextday ;
                    break ;
                }
                
                Indexvar++ ;  //::::::::: Increment index
                nextday = inputdate2.addDays( Indexvar ) ;
                strDate = inputdate2.addDays( Indexvar ).format() ;
            }
            
            
            
            formatedDateTime = systemCurrentDate.format().split( ' ' ) ;            // 8/1/2017 00:00:00
            formateddate = formatedDateTime[0].split( '/' ) ;                       // 8/1/2017
            cDate = formatedDate[2] + '-' + formatedDate[0] + '-'  + formatedDate[1] ;  // 2017-08-01 00:00:00
            
            
            
            
                
                                                    //::: Calling Appointment data generator method
            List<Appointment_OneMDCS__c> appointmentobjList = new List<Appointment_OneMDCS__c> () ; 
                                                   
            appointmentobjList.add( getAppointmentrecord_method1( '07:00' , '11:00' , systemCurrentDate, requestHour )  ) ; 
        
            insert appointmentobjList ;
            
            
            //::::::::::::: CLASS : JNJ_Admin_Calender_Controller_OneMDCS METHOD: userDetails
            User testUser = JNJ_Admin_Calender_Controller_OneMDCS.userDetails() ;
           
            
            
            //::::::::::::: CLASS : JNJ_Admin_Calender_Controller_OneMDCS METHOD: getBookedAppointment
            
            String JSONStr = JNJ_Admin_Calender_Controller_OneMDCS.getBookedAppointment( customerTerritory ) ;
            System.assert(JSONStr.contains(String.valueOf(nextday)));
            
            //System.assertEquals( expectedlistSize , actualListSize ) ;
        }
        
        
        //getTerritories
        test.startTest();
        List<JNJ_Admin_Calender_Controller_OneMDCS.TerritoryRecordWrapper> terrWrapper = new List<JNJ_Admin_Calender_Controller_OneMDCS.TerritoryRecordWrapper>();
        List<String> ternameList = new List<String> ();
        terrWrapper = JNJ_Admin_Calender_Controller_OneMDCS.getTerritories();
        if(terrWrapper.size()>0 && terrWrapper != null)
        {
        for(JNJ_Admin_Calender_Controller_OneMDCS.TerritoryRecordWrapper ter:terrWrapper)
        {
            String tername= ter.name;
            ternameList.add(tername);
        }
        System.assert(ternameList.contains('Alaska'));
        }
        test.stopTest();
       
        
    }
    
    
    public class weekClaendarunBlockWrapper{
        public String startString    {get;set;}
        public String endString    {get;set;}
        public String location    {get;set;}
        
        public weekClaendarunBlockWrapper( String startString, String endString, String location ){
            this.startString = startString ;
            this.endString = endString ;
            this.location = location ;
        }
    
    }
	
	public class EventWrapper{
        
         private Date eventdate ;
         private String startTime ;
         private String endTime ;
         private String eventName;
         private String territory;
    }

	static testMethod void test_customEvent(){
		String eventdetail;
        Available_Services_OneMDCS__c avl = insertavailableservices ();
		List<EventWrapper> ewlist = new List<EventWrapper>();
		EventWrapper ew = new EventWrapper();
		ew.eventdate = date.today();
		ew.startTime = '07:30 AM';
		ew.endTime = '08:30 AM';
		ew.eventName = 'test name';
		ew.territory = 'Alabama, Gerogia';
		ewlist.add(ew);
		eventdetail = JSON.serialize(ewlist);
       
		Finalize_Schedule_Per_Territory_OneMDCS__c evt= new Finalize_Schedule_Per_Territory_OneMDCS__c();
            evt.Subject__c = 'Test event';
            evt.Date_OneMDCS__c = date.today();
            evt.State_Time__c = '12:00 PM';
            evt.End_Time__c = '01:30 PM';
            evt.Territory_OneMDCS__c = 'Alaska';
			evt.Description_OneMDCS__c = 'Test description';
        insert evt;

        System.test.startTest();
        JNJ_Admin_Calender_Controller_OneMDCS.customEventSlot();
		JNJ_Admin_Calender_Controller_OneMDCS.customEventCreate(eventdetail);
		JNJ_Admin_Calender_Controller_OneMDCS.EventUpdation(JSON.serialize(evt));
        String evtList= JNJ_Admin_Calender_Controller_OneMDCS.getEventlist('Alabama, Gerogia');
        System.assert(evtList.contains('test name'));
        System.test.stopTest();
    }
	
    static testMethod void test_getProfileName(){
        
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        System.runAs(uatUser1){
        System.test.startTest();
        String profname= JNJ_Admin_Calender_Controller_OneMDCS.getProfileName();
        System.assertEquals('System Administrator', profname);
        System.test.stopTest();
        }
    }

   
}