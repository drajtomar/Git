/*
*******************************************  This is a Test Class of appointmentProcess_TVCore_Helper ***************************
Main Class : DailyCASAvailabilityHelper_OneMDCS
Created date : 08/15/2017
Created By : Capgemini
*/

@isTest

public class DailyCASAvailabilityHelper_OneMDCS_TEST{
    
    
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
    
    
    public static testMethod void fetchDefaultAvailability_method1(){
        
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
            cDate = formatedDate[2]  + '-'  + formatedDate[0] + '-' + formatedDate[1];  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;14:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
            
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){

            
                                        //:: Calling getAllCASListonLoad method with parameters
           List<Availability_Of_CAS_OneMDCS__c> casList =  Appointment_Process_OneMDCS.getAllCASListonLoad( customerTeritory , cDate  )   ;
            
           System.assertEquals( 3 , casList.size() ) ;
        }
        
        
        
        
    }
    
    
    public static testMethod void fetchPerDayAvailability_method1(){
        
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
            cDate = formatedDate[2] + '-'  + formatedDate[0] + '-' + formatedDate[1] ;  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;14:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
            
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        
        
                                            //::: Adding CAS Availability PER DAY AVAILABILITY record  into the List
        List<Availability_Of_CAS_OneMDCS__c> scheduledOffCASList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        
        
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[0].Id ,  uatUser1.Id , 'Test. 1' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[1].Id ,  uatUser2.Id , 'Test. 2' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[2].Id ,  uatUser3.Id , 'Test. 3' ) ) ;
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){

            insert scheduledOffCASList ;

        
                                        //:: Calling getAllCASListonLoad method with parameters
           List<Availability_Of_CAS_OneMDCS__c> casList =  Appointment_Process_OneMDCS.getAllCASListonLoad( customerTeritory , cDate  )   ;
            
           System.assertEquals( 3 , casList.size() ) ;
        }
        
        
        
    }
    
    public static testMethod void insertPerDayAvailability_method1(){
        
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
            cDate = formatedDate[2]  + '-'  + formatedDate[0] + '-' + formatedDate[1];  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;14:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        /*
        
                                            //::: Adding CAS Availability PER DAY AVAILABILITY record  into the List
        List<Availability_Of_CAS_OneMDCS__c> scheduledOffCASList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        
        
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[0].Id ,  uatUser1.Id , 'Test. 1' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[1].Id ,  uatUser2.Id , 'Test. 2' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[2].Id ,  uatUser3.Id , 'Test. 3' ) ) ;
        */
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
			Integer CASCount = [SELECT count() FROM Availability_Of_CAS_OneMDCS__c];
            System.assertEquals(3, CASCount);
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){

            List<CASAgentWrapper> CASAgentWrapperlIst = new List<CASAgentWrapper>();
            
            //:: 1st record
            CASAgentWrapper caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser1.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  casAvailabilityobjList[0].Id ;
            caswrap.parentCaseid  = '' ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            //:: 2nd record
            caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser2.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  casAvailabilityobjList[1].Id ;
            caswrap.parentCaseid  = '' ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            //:: 3rd record
            caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser3.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  casAvailabilityobjList[2].Id ;
            caswrap.parentCaseid  = '' ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            String CASAgentUpdatedrecord = JSON.serialize( CASAgentWrapperlIst ) ;
                                        //:: Calling insertAllCASListonSave method with parameters
            Appointment_Process_OneMDCS.insertAllCASListonSave( CASAgentUpdatedrecord , cDate , customerTeritory   )   ;
            
            
        }
        
        
        
        
    }
    
    public static testMethod void updatePerDayAvailability_method1(){
        
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
            Date systemCurrentDate =System.today(); 
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
            cDate = formatedDate[2]  + '-'  + formatedDate[0] + '-' + formatedDate[1];  // 2017-08-01 
            
            
        //:::::::::::::::::::::::::::::::::::::::: Preapare First date of week END::::::::::::::::::::::::::::  
        
        
        
                                            //::: Adding CAS Availability Default record  into the List 
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityobjList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '08:00;12:00' , '13:00;14:00'  , 'Y' , uatUser1.Id ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:30;11:30' , '13:30;14:30'  , 'Y' , uatUser2.Id  ) ) ;
        casAvailabilityobjList.add( getCAS_Availability_record_method1( '07:00;11:00' , '14:00;15:00'  , 'Y' , uatUser3.Id  ) ) ;
        
        
        
                                            //::: Adding CAS Availability PER DAY AVAILABILITY record  into the List
        List<Availability_Of_CAS_OneMDCS__c> scheduledOffCASList = new List<Availability_Of_CAS_OneMDCS__c> () ;
        
        
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[0].Id ,  uatUser1.Id , 'Test. 1' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[1].Id ,  uatUser2.Id , 'Test. 2' ) ) ;
        scheduledOffCASList.add( getPerDayCAS_Availability_method1( systemCurrentDate , true , true , casAvailabilityobjList[2].Id ,  uatUser3.Id , 'Test. 3' ) ) ;
        
        
        //::::::::::::::::::::: To Avoid MIX DML OPERATION
        System.runAs( uatUser1 ){
            
            insert casAvailabilityobjList ;
            insert scheduledOffCASList ;
			Integer CASCount = [SELECT count() FROM Availability_Of_CAS_OneMDCS__c];
            System.assertEquals(6, CASCount);
        }
        
        
        
        
        //:::::::::::::::::::::::::::::::::::::: Admin work  END :::::::::::::::::::::::::::::::::::::::::
        
        //:::::::::::::::::::::::::::::::::::::: Run As User :::::::::::::::::::::::::::::::::::::::::
        System.runAs( uatUser1 ){

            List<CASAgentWrapper> CASAgentWrapperlIst = new List<CASAgentWrapper>();
            
            //:: 1st record
            CASAgentWrapper caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser1.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  scheduledOffCASList[0].Id ;
            caswrap.parentCaseid  = scheduledOffCASList[0].Default_CAS_ID_OneMDCS__c ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            //:: 2nd record
            caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser2.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  scheduledOffCASList[1].Id ;
            caswrap.parentCaseid  = scheduledOffCASList[0].Default_CAS_ID_OneMDCS__c ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            //:: 3rd record
            caswrap = new CASAgentWrapper();
            caswrap.userLookup = uatUser3.Id ;
            caswrap.AMCheckbox = true ;
            caswrap.PMCheckbox = true ;
            caswrap.PDApicklist = 'Y' ;
            caswrap.territory = 'WEST BENGAL' ;
            caswrap.assignedDate = systemCurrentDate ;
            caswrap.defaultval = 'N' ;
            caswrap.comment = 'Off' ;
            caswrap.defaultcasid =  scheduledOffCASList[2].Id ;
            caswrap.parentCaseid  = scheduledOffCASList[0].Default_CAS_ID_OneMDCS__c ;
            
            CASAgentWrapperlIst.add( caswrap ) ;
            
            String CASAgentUpdatedrecord = JSON.serialize( CASAgentWrapperlIst ) ;
                                        //:: Calling insertAllCASListonSave method with parameters
            Appointment_Process_OneMDCS.insertAllCASListonSave( CASAgentUpdatedrecord , cDate , customerTeritory   )   ;
            
            
        }
        
        
        
        
    }
    
    public class CASAgentWrapper{
        
        public String userLookup ;
        public Boolean AMCheckbox ;
        public Boolean PMCheckbox ;
        public String PDApicklist ;
        public String territory ;
        public Date assignedDate ;
        public String defaultval ;
        public String comment ;
        public String defaultcasid ;
        public String parentCaseid ;
        public CASAgentWrapper(){
            
        }
        
    }
    
}