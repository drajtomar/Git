/*
**********************************************************************
Main Class : AssigningCAStoAppointmentHelper_OneMDCS
Created date : 08/15/2017
Created By : Capgemini
*/


@isTest


public class AssigningCASHelper_OneMDCS_TEST{


    //:: This method create User on the Basis of Role and Profile
    //:: Need to call from test method
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
        //uatuser.UserRoleId = uatUserrole.Id  ; 
        uatuser.ProfileId = uatProfileId ;
		uatuser.Email_Settings_OneMDCS__c='New Request;Cancelled Request;Change to current case;Unassigned;Reassign;Created;Modified';
     
        insert uatuser ;
        
        
        return uatuser  ;
    
    }

    //:: commnets : This method returns record of Availability_Of_CAS_OneMDCS__c object
    //:: Need to call from test methods
    public static Availability_Of_CAS_OneMDCS__c getCAS_Availability_record_method1(String morningSlot , String afterNoonSlot , String defaultValue , String casID ){
    
        Availability_Of_CAS_OneMDCS__c casavailability = new Availability_Of_CAS_OneMDCS__c();
        
        casavailability.Morning_Slot_OneMDCS__c = morningSlot ;
        casavailability.Afternoon_Slot_OneMDCS__c = afterNoonSlot ;
        casavailability.Default_OneMDCS__c = defaultValue ;
        casavailability.CAS_Team_OneMDCS__c = casID ;
        casavailability.Territory_OneMDCS__c = 'WEST BENGAL' ;
        
        return casavailability ;
    
    }
    
    //:: commnets : This method returns record of Availability_Of_CAS_OneMDCS__c object
    //:: Need to call from test methods
    public static Availability_Of_CAS_OneMDCS__c getPerDayCAS_Availability_method1(Date offDate , Boolean pmOff , Boolean amOff , String Default_CAS_ID , String casID , String commentText ){
    
        Availability_Of_CAS_OneMDCS__c casavailability = new Availability_Of_CAS_OneMDCS__c();
        
        casavailability.CAS_Team_OneMDCS__c = casID ;
        casavailability.Comment_OneMDCS__c = commentText ;
        casavailability.Date_assigned_OneMDCS__c = offDate ;
        casavailability.Default_CAS_ID_OneMDCS__c = Default_CAS_ID ;
        casavailability.AM_OneMDCS__c = amOff ;
        casavailability.PM_OneMDCS__c = pmOff ;
        casavailability.Default_OneMDCS__c = 'N' ;
        casavailability.Per_day_Availability_OneMDCS__c = 'Y' ;
        casavailability.Territory_OneMDCS__c = 'WEST BENGAL' ;
        
        //insert casavailability ;
        
        return casavailability ;
    
    }
    
    
    //:: commnets : This method returns record of Appointment_OneMDCS__c object
    //:: Need to call from test methods
    public static Appointment_OneMDCS__c getAppointmentrecord_method1(String startTime , String endTime , Date assignedDate, String serviceHour ){
    
        Appointment_OneMDCS__c appointmentrecord = new Appointment_OneMDCS__c();
        
        appointmentrecord.Appointment_Start_time_OneMDCS__c = startTime ;
        appointmentrecord.Appointment_end_time_OneMDCS__c = endTime ;
        appointmentrecord.Appointment_Date_OneMDCS__c = assignedDate ;
        appointmentrecord.Service_Hours_OneMDCS__c = serviceHour ;
        appointmentrecord.Email_OneMDCS__c = 'testEmail@test.com';
        appointmentrecord.Territory_OneMDCS__c = 'WEST BENGAL' ;
        appointmentrecord.Status_OneMDCS__c = 'Unassigned' ;
        return appointmentrecord ;
    
    }
    //:: commnets : This method returns record of Appointment_OneMDCS__c object with CAS
    //:: Need to call from test methods
    public static Appointment_OneMDCS__c getAppointmentrecord_method2(String startTime , String endTime , Date assignedDate, String serviceHour , String casID ){
    
        Appointment_OneMDCS__c appointmentrecord = new Appointment_OneMDCS__c();
        
        appointmentrecord.Appointment_Start_time_OneMDCS__c = startTime ;
        appointmentrecord.Appointment_end_time_OneMDCS__c = endTime ;
        appointmentrecord.Appointment_Date_OneMDCS__c = assignedDate ;
        appointmentrecord.Service_Hours_OneMDCS__c = serviceHour ;
        appointmentrecord.Email_OneMDCS__c = 'testEmail@test.com';
        appointmentrecord.Territory_OneMDCS__c = 'WEST BENGAL' ;
        appointmentrecord.Status_OneMDCS__c = 'Confirmed' ;
        appointmentrecord.Assigned_CAS_OneMDCS__c = casID ;
        return appointmentrecord ;
    
    }
    
    public static testMethod void reMainingCASAvailabilityOnLoad(){
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  START :::::::::::::::::::::::::::::::::::::::
        
        
        
        
        //::::::::::::::::::::::::::::::::::: Calling User creation method :::::::::::::::::::::::::::::::
        
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        
        User uatUser2 = new User() ;  
        uatUser2 =  getUserRecord( 'System Administrator' ) ;
        
        User uatUser3 = new User() ;  
        uatUser3 =  getUserRecord( 'System Administrator' ) ;
        
        
               
        //:::::::::::::::::::::::::::: Territory and Service Hour:::::::::::::::::::::::::::::::::::
        String customerTeritory  = 'WEST BENGAL' ; 
        String serviceHour = '4';                                  
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week START::::::::::::::::::::::::::::
            Date systemCurrentDate = System.today(); 
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
            cDate = formatedDate[2] + '-' + formatedDate[0] + '-'  + formatedDate[1] ;  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;17:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        

        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
            
        }
                                            //::: Adding CAS Availability PER DAY AVAILABILITY record  into the List
        List<Availability_Of_CAS_OneMDCS__c> scheduledOffCASList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        
        
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[0].Id ,  uatUser1.Id , 'Test. 1' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[1].Id ,  uatUser2.Id , 'Test. 2' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[2].Id ,  uatUser3.Id , 'Test. 3' ) ) ;
        
                        
                                        //::: Adding Appointment record  into the List 
        
        List<Appointment_OneMDCS__c> appointmentobjList = new List<Appointment_OneMDCS__c> () ; 
        appointmentobjList.add( getAppointmentrecord_method1( '08:00' , '12:00' , systemCurrentDate, serviceHour )  ) ; 

        appointmentobjList.add( getAppointmentrecord_method1( '13:00' , '17:00' , systemCurrentDate, serviceHour  )  ) ;
        
        appointmentobjList.add( getAppointmentrecord_method1( '18:00' , '22:00' , systemCurrentDate, serviceHour )  ) ; 

        appointmentobjList.add( getAppointmentrecord_method1( '04:00' , '08:00' , systemCurrentDate, serviceHour  )  ) ;
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert scheduledOffCASList ;
            insert appointmentobjList ;
            
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){
                List<updateCASWrapper> updateCASWrapperList = new List<updateCASWrapper>() ;
                updateCASWrapper upWrapper = new updateCASWrapper() ;  
                upWrapper.status = 'Confirmed' ; 
                upWrapper.casLookupid = casAvailabilityobjList[0].Id ;
                upWrapper.recID = appointmentobjList[0].Id ;
                
                updateCASWrapperList.add( upWrapper ) ;
                
                String serializeRecord = JSON.serialize( updateCASWrapperList ) ;       
                String unassignedappoId  = appointmentobjList[0].Id ;
                
                
                                                //:: Calling getDetailsOfRemainingProcedures method with parameters
                
                //::::: Updating appointment record 
                Appointment_Process_OneMDCS.updateCASAvailability( serializeRecord , 'primary')   ;
                
                List<Appointment_OneMDCS__c> appList1 = [ select id , Assigned_CAS_OneMDCS__c from Appointment_OneMDCS__c where id = : unassignedappoId ];
                
                System.debug( '@@@ appList1 assigned CAS ' + appList1[0].Assigned_CAS_OneMDCS__c ) ;
                
                //System.assertEquals( casAvailabilityobjList[0].Id , appList1[0].Assigned_CAS_OneMDCS__c ) ;
                
               
                
                
                
                List<assignCASWrapper> assignCASWrapperList = new List<assignCASWrapper>() ;
                assignCASWrapper ascWrapper = new assignCASWrapper() ;
                ascWrapper.appoId = unassignedappoId ;
                
                
                assignCASWrapperList.add( ascWrapper ) ;
                
                serializeRecord = JSON.serialize( assignCASWrapperList ) ;  

                List<Availability_Of_CAS_OneMDCS__c>  availableCASList2 = Appointment_Process_OneMDCS.getCASAvailability( customerTeritory , serializeRecord , unassignedappoId ) ;
            
                System.assertEquals( 2 , availableCASList2.size() ) ;
                
                
        }
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){
                List<updateCASWrapper> updateCASWrapperList = new List<updateCASWrapper>() ;
                updateCASWrapper upWrapper = new updateCASWrapper() ;  
                upWrapper.status = 'Confirmed' ; 
                User objUser = new User();
                objUser = [SELECT Id from User limit 1];
                upWrapper.casLookupid = objUser.Id ;
                upWrapper.recID = appointmentobjList[1].Id ;
                
                updateCASWrapperList.add( upWrapper ) ;
                
                String serializeRecord = JSON.serialize( updateCASWrapperList ) ;       
                String unassignedappoId  = appointmentobjList[1].Id ;
                
                
                                                //:: Calling getDetailsOfRemainingProcedures method with parameters
                
                //::::: Updating appointment record 
                Appointment_Process_OneMDCS.updateCASAvailability( serializeRecord , 'trainee')   ;
                
                List<Appointment_OneMDCS__c> appList1 = [ select id , Assigned_CAS_OneMDCS__c from Appointment_OneMDCS__c where id = : unassignedappoId ];
                
                System.debug( '@@@ appList1 assigned CAS ' + appList1[0].Assigned_CAS_OneMDCS__c ) ;
                
                //System.assertEquals( casAvailabilityobjList[0].Id , appList1[0].Assigned_CAS_OneMDCS__c ) ;
                
               
                
                
                
                List<assignCASWrapper> assignCASWrapperList = new List<assignCASWrapper>() ;
                assignCASWrapper ascWrapper = new assignCASWrapper() ;
                ascWrapper.appoId = unassignedappoId ;
                
                
                assignCASWrapperList.add( ascWrapper ) ;
                
                serializeRecord = JSON.serialize( assignCASWrapperList ) ;  

                List<Availability_Of_CAS_OneMDCS__c>  availableCASList2 = Appointment_Process_OneMDCS.getCASAvailability( customerTeritory , serializeRecord , unassignedappoId ) ;
            
                System.assertEquals( 3 , availableCASList2.size() ) ;
                
                
        }
         
        System.runAs( uatUser1 ){
                List<updateCASWrapper> updateCASWrapperList = new List<updateCASWrapper>() ;
                updateCASWrapper upWrapper = new updateCASWrapper() ;  
                upWrapper.status = 'Unassigned' ; 
                upWrapper.casLookupid = null ;
                upWrapper.recID = appointmentobjList[2].Id ;
                
                updateCASWrapperList.add( upWrapper ) ;
                
                String serializeRecord = JSON.serialize( updateCASWrapperList ) ;       

                Appointment_Process_OneMDCS.updateCASAvailability( serializeRecord , 'unassigncas')   ;                                             
        }
        
        System.runAs( uatUser1 ){
                List<updateCASWrapper> updateCASWrapperList = new List<updateCASWrapper>() ;
                updateCASWrapper upWrapper = new updateCASWrapper() ;  
                upWrapper.status = 'Confirmed' ; 
                upWrapper.casLookupid = null ;
                upWrapper.recID = appointmentobjList[2].Id ;
                
                updateCASWrapperList.add( upWrapper ) ;
                
                String serializeRecord = JSON.serialize( updateCASWrapperList ) ;       

                Appointment_Process_OneMDCS.updateCASAvailability( serializeRecord , 'unassignseccas')   ;                                              
        } 
        
    }
    
        
        
    public static testMethod void reMainingCASAvailabilityOnLoad_Method1(){
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  START :::::::::::::::::::::::::::::::::::::::
        
        
        
        
        //::::::::::::::::::::::::::::::::::: Calling User creation method :::::::::::::::::::::::::::::::
        
        User uatUser1 = new User() ;  
        uatUser1 =  getUserRecord( 'System Administrator' ) ;
        
        User uatUser2 = new User() ;  
        uatUser2 =  getUserRecord( 'System Administrator' ) ;
        
        User uatUser3 = new User() ;  
        uatUser3 =  getUserRecord( 'System Administrator' ) ;
        
        //:::::::::::::::::::::::::::: Territory and Service Hour:::::::::::::::::::::::::::::::::::
        String customerTeritory  = 'WEST BENGAL' ; 
        String serviceHour = '4';                                  
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week START::::::::::::::::::::::::::::
            Date systemCurrentDate = System.today();  
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
            cDate = formatedDate[2] + '-' + formatedDate[0] + '-'  + formatedDate[1] ;  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;17:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        

        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
            
        }
                                            //::: Adding CAS Availability PER DAY AVAILABILITY record  into the List
        List<Availability_Of_CAS_OneMDCS__c> scheduledOffCASList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        
        
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[0].Id ,  uatUser1.Id , 'Test. 1' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[1].Id ,  uatUser2.Id , 'Test. 2' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[2].Id ,  uatUser3.Id , 'Test. 3' ) ) ;
        
                        
                                        //::: Adding Appointment record  into the List 
        
        List<Appointment_OneMDCS__c> appointmentobjList = new List<Appointment_OneMDCS__c> () ; 
        appointmentobjList.add( getAppointmentrecord_method1( '08:00' , '12:00' , systemCurrentDate, serviceHour )  ) ; 
        appointmentobjList.add( getAppointmentrecord_method1( '13:00' , '17:00' , systemCurrentDate, serviceHour )  ) ; 

        
        
        
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert scheduledOffCASList ;
            insert appointmentobjList ;
            
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){
        
                
                String unassignedappoId  = appointmentobjList[0].Id ;
                
                List<assignCASWrapper> assignCASWrapperList = new List<assignCASWrapper>() ;
                assignCASWrapper ascWrapper = new assignCASWrapper() ;
                ascWrapper.appoId = unassignedappoId ;
                
                
                assignCASWrapperList.add( ascWrapper ) ;
                
                String serializeRecord = JSON.serialize( assignCASWrapperList ) ;  

                List<Availability_Of_CAS_OneMDCS__c>  availableCASList2 = Appointment_Process_OneMDCS.getCASAvailability( customerTeritory , serializeRecord , unassignedappoId ) ;
            
                System.assertEquals( 3 , availableCASList2.size() ) ;
                
                
        }
        
        
        
         
        
    }
    
    public class updateCASWrapper{
        public String status ;
        public String casLookupid ;
        public String recID ;
    }
    
    public class assignCASWrapper{
        
        public String appoId ;
    }
    
}