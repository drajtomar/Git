public class searchCASAvailability_OneMDCS{

    public static String getAvailabilityDetails( String selectedDay, String customerTerritory  ){
    
        String detailOfCAS ;
        Map<String,Availability_Of_CAS_OneMDCS__c> casIdandObjectMap = new Map<String,Availability_Of_CAS_OneMDCS__c>();
        Date selectedDt = Date.valueOf(selectedDay);
         
        //::::::::::::::::: Query on Doctor Availability where CAS available per day basis for particular day 
        List<Availability_Of_CAS_OneMDCS__c> casscheduledoffObjList = getPerDayAvailableList(  selectedDay,  customerTerritory ) ;
                                                    
        //::::::::::::::::: Query on Doctor Availability Based on Teritory For default data
        List<Availability_Of_CAS_OneMDCS__c> allDefaultCASList =  getAllDefaultCASList( selectedDay,  customerTerritory );

        //::::::::::::::::::: Query on Appointment  object Based on Teritory and selected date
        List<Appointment_OneMDCS__c> AppointOfCurrentDateList = getAppointOfCurrentDate( selectedDay,  customerTerritory ) ;
        
        
        
        
        
        
        
        
        //:::::::::::::::::::::::: CAS id and its object Map :::::::::::::::::::::
        for( Availability_Of_CAS_OneMDCS__c   casAvail : casscheduledoffObjList ){
        
            casIdandObjectMap.put( casAvail.Default_CAS_ID_OneMDCS__c , casAvail ) ; 
        }
        
        detailOfCAS = getAllDetailsasJSON( allDefaultCASList ,  casIdandObjectMap , AppointOfCurrentDateList ) ;
        
        return detailOfCAS ;
    
    }   
    
    
    public static List<Availability_Of_CAS_OneMDCS__c> getPerDayAvailableList( String selectedDay, String customerTerritory ){
        Date selectedDt = Date.valueOf(selectedDay);
        
        return [ select id , Dynamic_ID_OneMDCS__c , Afternoon_Slot_OneMDCS__c,Afternoon_Slot_Updated_OneMDCS__c,            
                                                    Availability_CAS_OneMDCS__c,Availability_Updated_OneMDCS__c,            
                                                    Backend_Morning_Slot_OneMDCS__c,Backend_Afternoon_Slot_OneMDC__c,CAS_Team_OneMDCS__c,Territory_OneMDCS__c,
                                                    Date_assigned_OneMDCS__c,Default_OneMDCS__c,Morning_Slot_OneMDCS__c,Morning_Slot_Updated_OneMDCS__c,Region__c ,
                                                    Per_day_Availability_OneMDCS__c,AM_OneMDCS__c,PM_OneMDCS__c,Default_CAS_ID_OneMDCS__c
                                                    from Availability_Of_CAS_OneMDCS__c
                                                    where Per_day_Availability_OneMDCS__c = 'Y' AND Territory_OneMDCS__c =: customerTerritory 
                                                    AND Date_assigned_OneMDCS__c =: selectedDt order by createdDate asc ];
    
    }
    
    public static List<Availability_Of_CAS_OneMDCS__c> getAllDefaultCASList( String selectedDay, String customerTerritory  ){
        Date selectedDt = Date.valueOf(selectedDay);
        
        return [ select id , Dynamic_ID_OneMDCS__c , Afternoon_Slot_OneMDCS__c,Afternoon_Slot_Updated_OneMDCS__c,            
                                                    Availability_CAS_OneMDCS__c,Availability_Updated_OneMDCS__c,            
                                                    Backend_Morning_Slot_OneMDCS__c,Backend_Afternoon_Slot_OneMDC__c,CAS_Team_OneMDCS__c,Territory_OneMDCS__c,
                                                    Date_assigned_OneMDCS__c,Default_OneMDCS__c,Morning_Slot_OneMDCS__c,Morning_Slot_Updated_OneMDCS__c,Region__c ,
                                                    Per_day_Availability_OneMDCS__c,AM_OneMDCS__c,PM_OneMDCS__c,Default_CAS_ID_OneMDCS__c
                                                    from Availability_Of_CAS_OneMDCS__c
                                                    where Default_OneMDCS__c = 'Y' AND Territory_OneMDCS__c =: customerTerritory order by createdDate asc];
                                                    
                                                    
    
    }
    
    public static List<Appointment_OneMDCS__c> getAppointOfCurrentDate( String selectedDay, String customerTerritory ){
    
        Date selectedDt = Date.valueOf(selectedDay);
        
        return [ SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c,Appointment_Date_OneMDCS__c, 
                                            Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c,Location_Encrypted_OneMDCS__c, 
                                            Appointment_start_time_12hrs_OneMDCS__c, Appointment_Start_time_OneMDCS__c,Appointment_end_time_OneMDCS__c, 
                                            Name_Of_Physician_Encrypted_OneMDCS__c ,Assigned_CAS_OneMDCS__r.Name, Email_OneMDCS__c,Appointment_end_time_12_hrs_OneMDCS__c,
                                            Request_OneMDCS__c
                                            FROM Appointment_OneMDCS__c 
                                            where Appointment_Date_OneMDCS__c =: selectedDt 
                                            AND Territory_OneMDCS__c =: customerTerritory
                                            AND (Status_OneMDCS__c != 'Rejected' AND Status_OneMDCS__c != 'Cancelled')];
    }
    
    
    
    public static String getAllDetailsasJSON( List<Availability_Of_CAS_OneMDCS__c> allDefaultCASList , Map<String,Availability_Of_CAS_OneMDCS__c> casIdandObjectMap , List<Appointment_OneMDCS__c> AppointOfCurrentDateList ){
    
        System.debug( '@@@@@@@@@@ casIdandObjectMap debug 11  ' + casIdandObjectMap );
        System.debug( '@@@@@@@@@@ AppointOfCurrentDateList debug 11  ' + AppointOfCurrentDateList ); 
        
        
        
        
        //::::::::::::::: Total count of CAS Availability AM and PM ::::::::::::::::::::::::::::::::
        Integer morCount = 0 ;
        Integer NoonCount = 0 ;
        
        for( Availability_Of_CAS_OneMDCS__c  avlCASItr : allDefaultCASList ){
        
            if( casIdandObjectMap.KeySet().size() > 0 ){
            
                Availability_Of_CAS_OneMDCS__c avlCASobj = casIdandObjectMap.get( avlCASItr.Id ) ;
                if(avlCASobj != null){
                    if( avlCASobj.AM_OneMDCS__c == true )
                        morCount = morCount + 1 ;
                    
                    if( avlCASobj.PM_OneMDCS__c == true )
                        NoonCount = NoonCount+ 1 ; 
                }
			}else{
            
            morCount = morCount + 1 ;
            NoonCount = NoonCount+ 1 ;  
              /*  if(  avlCASItr.Morning_Slot_OneMDCS__c != null) 
                        morCount = morCount + 1 ;
                        
                        
                if(  avlCASItr.Afternoon_Slot_OneMDCS__c != null)   
                        NoonCount = NoonCount+ 1 ; 
                    */
            }
        
        }
    
        
        
        //::::::::::::::: Total count of Appointment AM and PM ::::::::::::::::::::::::::::::::
        Integer appMorCount = 0 ;
        Integer appNoonCount = 0 ;
        for( Appointment_OneMDCS__c    appItr :    AppointOfCurrentDateList ){
            
            String[] appoArr = appItr.Appointment_Start_time_OneMDCS__c.split( ':' ) ;
            
            Integer appStart = Integer.valueOf(  appoArr[0]  ) ;
            
            if( appStart >= 12  ){
            
                appNoonCount = appNoonCount +1 ;
                
            }
            else{
                
                appMorCount = appMorCount +1 ;
                
            }       
            
        }
        
        //::::::::::::::: Total count of remaining AM and PM procedure::::::::::::::::::::::::::::::::
        System.debug( '## morCount ' + morCount + ' ## appMorCount  ' + appMorCount + ' ##NoonCount ' +  NoonCount + ' ##appNoonCount  ' + appNoonCount ) ;
        
        
        
        
        
        DetailsOfCASWrapper  dWrapper = new DetailsOfCASWrapper();
        dWrapper.remainAMprocedure = morCount - appMorCount ;
        dWrapper.remainPMprocedure = NoonCount - appNoonCount ;
        dWrapper.submittedAMCAS = appMorCount ;
        dWrapper.submittedPMCAS = appNoonCount ;
        
        System.debug( '##### DetailsOfCASWrapper serialized ' + JSON.serialize( dWrapper ) ) ;
        
        return JSON.serialize( dWrapper )  ; 
    }
    public class DetailsOfCASWrapper{
    
        @TestVisible private Integer remainAMprocedure ;
        @TestVisible private Integer remainPMprocedure ;
        @TestVisible private Integer submittedAMCAS ; 
        @TestVisible private Integer submittedPMCAS ;
        
        public DetailsOfCASWrapper(){
        }
    }
}