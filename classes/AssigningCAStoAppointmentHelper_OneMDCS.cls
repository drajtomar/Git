public class AssigningCAStoAppointmentHelper_OneMDCS{
    
    //public static Map< String , Map<String,Integer> > dateWiseSlotCount = new Map< String , Map<String,Integer> >();
    
    
    
    public class assignCASWrapper{
        
        public String appoId ;
    }
    
    public class updateCASWrapper{
        public String status ;
        public String casLookupid ;
        public String recID ;
    }
    
    
	
	public static void updateSelectedAppoForSecondary( String appointmentIDJSON  ){
		List<updateCASWrapper> assignCASWrapperObj =(List<updateCASWrapper>)JSON.deserialize(appointmentIDJSON,List<updateCASWrapper>.class);
		List<Appointment_OneMDCS__c> selectedappointList = new List<Appointment_OneMDCS__c>() ;
        List<Event> casEventList = new List<Event>() ;
        Appointment_OneMDCS__c appoObj ;
		
		for( updateCASWrapper objwrap :  assignCASWrapperObj ){
            
            appoObj = new Appointment_OneMDCS__c();
            appoObj.Id = objwrap.recID ;
            appoObj.Assigned_CAS_Secondary_OneMDCS__c = objwrap.casLookupid ;
            //appoObj.Status_OneMDCS__c = objwrap.status ;
            selectedappointList.add( appoObj ) ;
            system.debug('*-*-*->selectedappointList '+selectedappointList);
        }
		update selectedappointList ;
		
		
		//update casEventList;
        
        List<Appointment_OneMDCS__c> SelApt = [ SELECT Appointment_Date_OneMDCS__c,Appointment_end_time_OneMDCS__c, Appointment_Start_time_OneMDCS__c,Email_OneMDCS__c,Additional_Email_OneMDCS__c,                                        Location_Encrypted_OneMDCS__c,Name_Of_Physician_Encrypted_OneMDCS__c,OwnerId,Request_OneMDCS__c,Procedure_Name_Encrypted_OneMDCS__c,Slots_OneMDCS__c,Territory_OneMDCS__c,Assigned_CAS_OneMDCS__r.CAS_Team_OneMDCS__c,Name, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c , Service_Hours_OneMDCS__c,Assigned_CAS_Secondary_OneMDCS__c FROM Appointment_OneMDCS__c where ID=:assignCASWrapperObj[0].recID ];
        
        String myDate=String.ValueOf(SelApt[0].Appointment_Date_OneMDCS__c);
        String[] myDateOnly = myDate.split('-');
        //String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(myDateOnly[2]);
        Integer myIntMonth = integer.valueOf(myDateOnly[1]);
        Integer myIntYear = integer.valueOf(myDateOnly[0]);
        String myTime=String.ValueOf(SelApt[0].Appointment_Start_time_OneMDCS__c);
        String[] myTimeOnly = myTime.split(':');
        Integer myIntHour = integer.valueOf(myTimeOnly[0]);
        Integer myIntMinute = integer.valueOf(myTimeOnly[1]);
        String endTimedata=String.ValueOf(SelApt[0].Appointment_end_time_OneMDCS__c);
        String[] endTime = endTimedata.split(':');
        Integer endIntHour = integer.valueOf(endTime[0]);
        Integer endIntMinute = integer.valueOf(endTime[1]);
        
        
        datetime d = datetime.newInstance(myIntYear, myIntMonth, myIntDate,myIntHour,myIntMinute,00);
        datetime endTimeDate = datetime.newInstance(myIntYear, myIntMonth, myIntDate,endIntHour,endIntMinute,00);
        Event newEvent = new Event();
        newEvent.OwnerId =SelApt[0].Assigned_CAS_Secondary_OneMDCS__c;
        newEvent.Subject ='Appointment Scheduled';
        //newEvent.WhatId = '0017F000007y2Kf';
        newEvent.IsRecurrence = false;
        
        newEvent.IsAllDayEvent =false;
        // newEvent.DurationInMinutes =30;
        Date t = Date.newInstance(2017, 08, 24);
        newEvent.ActivityDate =SelApt[0].Appointment_Date_OneMDCS__c;
        
        //datetime sttartDate =datetime.newInstance(2017, 08, 24, 06, 30, 00);
        //datetime enddDate =datetime.newInstance(2017, 08, 24, 10, 10, 40);
        newEvent.StartDateTime =d;
        newEvent.EndDateTime =endTimeDate;
        //newEvent.EndDateTime =enddDate;
        insert newEvent;
	}
	
     //:::::::::::::::::::::::::::::::::::::::::::::::::::::::: This is used to unassign cas ::::::::::::::::::::::::::::::::
    public static void updatecas( String appointmentIDJSON  ){
		List<updateCASWrapper> assignCASWrapperObj =(List<updateCASWrapper>)JSON.deserialize(appointmentIDJSON,List<updateCASWrapper>.class);
		List<Appointment_OneMDCS__c> selectedappointList = new List<Appointment_OneMDCS__c>() ;
        Appointment_OneMDCS__c appoObj ;
		
       
        
		for( updateCASWrapper objwrap :  assignCASWrapperObj ){
            
            appoObj = new Appointment_OneMDCS__c();
            appoObj.Id = objwrap.recID ;
            appoObj.Assigned_CAS_OneMDCS__c = null;            
            appoObj.Assigned_CAS_Secondary_OneMDCS__c = null ;               
            appoObj.Status_OneMDCS__c = objwrap.status ;
            appoObj.Change_Type_of_Request_OneMDCS__c = 'Normal';
            selectedappointList.add( appoObj ) ;
            system.debug('*-*-*->selectedappointList '+selectedappointList);
        }
		update selectedappointList ;
        
    }
     //:::::::::::::::::::::::::::::::::::::::::::::::::::::::: This is used to unassign secondary cas ::::::::::::::::::::::::::::::::
    public static void updateseccas( String appointmentIDJSON  ){
		List<updateCASWrapper> assignCASWrapperObj =(List<updateCASWrapper>)JSON.deserialize(appointmentIDJSON,List<updateCASWrapper>.class);
		List<Appointment_OneMDCS__c> selectedappointList = new List<Appointment_OneMDCS__c>() ;
        Appointment_OneMDCS__c appoObj ;
		
		for( updateCASWrapper objwrap :  assignCASWrapperObj ){
            
            appoObj = new Appointment_OneMDCS__c();
            appoObj.Id = objwrap.recID ;
            appoObj.Assigned_CAS_Secondary_OneMDCS__c = null ;                
            //appoObj.Status_OneMDCS__c = objwrap.status ;
            appoObj.Change_Type_of_Request_OneMDCS__c = 'Normal';
            selectedappointList.add( appoObj ) ;
            system.debug('*-*-*->selectedappointList '+selectedappointList);
        }
		update selectedappointList ;
    }
    
    //:::::::::::::::::::::::::::::::::::::::::::::::::::::::: This is used to save the record of Appointment ::::::::::::::::::::::::::::::::
    public static void updateSelectedAppo( String appointmentIDJSON  ){
        
        List<updateCASWrapper> assignCASWrapperObj =(List<updateCASWrapper>)JSON.deserialize(appointmentIDJSON,List<updateCASWrapper>.class);
        
        List<Appointment_OneMDCS__c> selectedappointList = new List<Appointment_OneMDCS__c>() ;
        List<Event> casEventList = new List<Event>() ;
        
        Appointment_OneMDCS__c appoObj ;
        
        
        
        Set<String> insertAvlCAS = new Set<String>();
        List<String> ListInsertAvlCAS = new List<String>();
        System.debug('assignCASWrapperObj data'+assignCASWrapperObj);
        
        for( updateCASWrapper objwrap :  assignCASWrapperObj )
        {
            if(objwrap.casLookupid.startsWithIgnoreCase('005'))
            {
                insertAvlCAS.add(objwrap.casLookupid);
                ListInsertAvlCAS.add(objwrap.casLookupid);
            }
        }
        Map<Id, String> mapOfAvlCasIdName = new Map<Id, String>();
        Map<Id, String> mapOfUserIdName = new Map<Id, String>();
        //Get CAS Name
        if(!insertAvlCAS.isEmpty())
        {
            
            
            for(Availability_Of_CAS_OneMDCS__c objAvlCas : [SELECT Id, CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name from 
                                                            Availability_Of_CAS_OneMDCS__c where CAS_Team_OneMDCS__c IN:insertAvlCAS])
            {
                mapOfAvlCasIdName.put(objAvlCas.CAS_Team_OneMDCS__c, objAvlCas.CAS_Team_OneMDCS__r.Name);
            }
            
            for(User objUserCAS : [SELECT Id, Name from User where Id IN: insertAvlCAS AND isActive = true])
            {
                mapOfUserIdName.put(objUserCAS.Id, objUserCAS.Name);
            }
        }
        if(!ListInsertAvlCAS.isEmpty())
        {
            List<Availability_Of_CAS_OneMDCS__c> insertCasForUser = new List<Availability_Of_CAS_OneMDCS__c>();
            Availability_Of_CAS_OneMDCS__c objAvl;
            for(String objStr : ListInsertAvlCAS)
            {
                if(!mapOfAvlCasIdName.containsKey(objStr))
                {
                    objAvl = new Availability_Of_CAS_OneMDCS__c();
                    objAvl.Name = mapOfUserIdName.get(Id.ValueOf(objStr));
                    objAvl.CAS_Team_OneMDCS__c = objStr ;
                    objAvl.Territory_OneMDCS__c = 'Other';
                    //mapOfAvlCasIdName.put(Id.valueOf(objStr), mapOfUserIdName.get(Id.ValueOf(objStr)));
                    insertCasForUser.add(objAvl);
                }
            }
            insert insertCasForUser;
        }
        
        if(!insertAvlCAS.isEmpty())
        {
            
            mapOfAvlCasIdName = new Map<Id, String>();
            for(Availability_Of_CAS_OneMDCS__c objAvlCas : [SELECT Id, CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name from 
                                                            Availability_Of_CAS_OneMDCS__c where CAS_Team_OneMDCS__c IN:insertAvlCAS])
            {
                mapOfAvlCasIdName.put(objAvlCas.CAS_Team_OneMDCS__c, String.ValueOf(objAvlCas.Id));
            }
        }
        
        
        for( updateCASWrapper objwrap :  assignCASWrapperObj ){
            
            appoObj = new Appointment_OneMDCS__c();
            
            appoObj.Id = objwrap.recID ;
            if(!objwrap.casLookupid.startsWithIgnoreCase('005'))
            {
                appoObj.Assigned_CAS_OneMDCS__c = objwrap.casLookupid ;
            }
            else
            {
                appoObj.Assigned_CAS_OneMDCS__c = mapOfAvlCasIdName.get(Id.ValueOf(objwrap.casLookupid)) ;
            }
            appoObj.Status_OneMDCS__c = objwrap.status ;
            selectedappointList.add( appoObj ) ;
            
            
            
        }
        
        update selectedappointList ;
        //update casEventList;
        
        List<Appointment_OneMDCS__c> SelApt = [ SELECT Appointment_Date_OneMDCS__c,Appointment_end_time_OneMDCS__c, Appointment_Start_time_OneMDCS__c,Email_OneMDCS__c,Additional_Email_OneMDCS__c,                                        Location_Encrypted_OneMDCS__c,Name_Of_Physician_Encrypted_OneMDCS__c,OwnerId,Request_OneMDCS__c,Procedure_Name_Encrypted_OneMDCS__c,Slots_OneMDCS__c,Territory_OneMDCS__c,Assigned_CAS_OneMDCS__r.CAS_Team_OneMDCS__c,Name, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c , Service_Hours_OneMDCS__c FROM Appointment_OneMDCS__c where ID=:assignCASWrapperObj[0].recID ];
        
        String myDate=String.ValueOf(SelApt[0].Appointment_Date_OneMDCS__c);
        String[] myDateOnly = myDate.split('-');
        //String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(myDateOnly[2]);
        Integer myIntMonth = integer.valueOf(myDateOnly[1]);
        Integer myIntYear = integer.valueOf(myDateOnly[0]);
        String myTime=String.ValueOf(SelApt[0].Appointment_Start_time_OneMDCS__c);
        String[] myTimeOnly = myTime.split(':');
        Integer myIntHour = integer.valueOf(myTimeOnly[0]);
        Integer myIntMinute = integer.valueOf(myTimeOnly[1]);
        String endTimedata=String.ValueOf(SelApt[0].Appointment_end_time_OneMDCS__c);
        String[] endTime = endTimedata.split(':');
        Integer endIntHour = integer.valueOf(endTime[0]);
        Integer endIntMinute = integer.valueOf(endTime[1]);
        
        
        datetime d = datetime.newInstance(myIntYear, myIntMonth, myIntDate,myIntHour,myIntMinute,00);
        datetime endTimeDate = datetime.newInstance(myIntYear, myIntMonth, myIntDate,endIntHour,endIntMinute,00);
        Event newEvent = new Event();
        newEvent.OwnerId =SelApt[0].Assigned_CAS_OneMDCS__r.CAS_Team_OneMDCS__c;
        newEvent.Subject ='Appointment Scheduled';
        //newEvent.WhatId = '0017F000007y2Kf';
        newEvent.IsRecurrence = false;
        
        newEvent.IsAllDayEvent =false;
        // newEvent.DurationInMinutes =30;
        Date t = Date.newInstance(2017, 08, 24);
        newEvent.ActivityDate =SelApt[0].Appointment_Date_OneMDCS__c;
        
        //datetime sttartDate =datetime.newInstance(2017, 08, 24, 06, 30, 00);
        //datetime enddDate =datetime.newInstance(2017, 08, 24, 10, 10, 40);
        newEvent.StartDateTime =d;
        newEvent.EndDateTime =endTimeDate;
        //newEvent.EndDateTime =enddDate;
        insert newEvent;
        
        
        
    }
    
    
    //:::::::::::::::::::::::::::::::::::::::: This is used to populate List of Available CAS when a Appoinment is selscted from Calender:::::::::::::::::::::::
    public static List<Availability_Of_CAS_OneMDCS__c> getAvailableCAS( String customerTerritory , String appointmentIDJSON , String unassignedappoId ){
        List<String> appointmentIDList = new List<String>();
        
        
        //assignCASWrapperObj/appointmentIDList is List of all Appoinment for that perticular day
        List<assignCASWrapper> assignCASWrapperObj =(List<assignCASWrapper>)JSON.deserialize(appointmentIDJSON,List<assignCASWrapper>.class);
        
        for( assignCASWrapper itr : assignCASWrapperObj ){
            
            appointmentIDList.add( itr.appoId) ;
        }
        
        System.debug( '@@@@@@@@@@@ appointmentIDList  debug   ' + appointmentIDList );
        
        List<Availability_Of_CAS_OneMDCS__c> casAvailableList = new List<Availability_Of_CAS_OneMDCS__c>() ;
        
        
        //:::::::::::::::::::::::::::::: Appointment  details for which CAS is not assigned for that Day ::::::::::::::::::::::::::::::::::::::::::::
        Appointment_OneMDCS__c appointmentObj = getUnassignedAppo( unassignedappoId ) ;
        
        System.debug( '@@@@@@@@@@@ appointmentObj  debug   ' + appointmentObj );
        
        
        //::::::::::::::::::::::::::::::  Appointment which CAS is assigned ::::::::::::::::::::::::::::::::::::::::::::::::
        
        //All Appointment Details for That day no relation with CAS assign or not assign
        List<Appointment_OneMDCS__c> casobjectList = getAlreadyPopulatedCASObjectList( appointmentIDList ) ; 
        
        System.debug( '@@@@@@@@@@@ casobjectList  debug   ' + casobjectList );
        
        //:::::::::::::::::::::::::::::::::
        
        //::::::: Query on Doctor Availability based on that territory
        List<Availability_Of_CAS_OneMDCS__c> casObjList = getAllDefaultCAS( customerTerritory ) ;
        
        System.debug( '@@@@@@@@@@@ casObjList  debug   ' + casObjList );
        
        
        //:::::::::::::::::::::::::::::::: return the How many time a same reuest is geven on a same day MAP :::::::::::::::::::::::::::::.
        String requestHour = appointmentObj.Service_Hours_OneMDCS__c ;
        Date inputdate2 = appointmentObj.Appointment_Date_OneMDCS__c ;
        
        
        
        //:::::::::::::::::::::::::::::::::::::::: Returns Map where Each CAS ID could associated with More than 1 Appointment records
        //CAS and assigned appoinment against her  on that Day
        
        Map<String,List<Appointment_OneMDCS__c>> AlreadyPopulatedCASandAppoIdMap = getAlreadyPopulatedCASandAppoId( appointmentIDList ) ;
        
        System.debug( '@@@@@@@@@@@ AlreadyPopulatedCASandAppoIdMap  debug   ' + AlreadyPopulatedCASandAppoIdMap );
        //::::::::::::::::::::::::::::: Find Available CAS based on AM and PM:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        
        List<Availability_Of_CAS_OneMDCS__c> CASObjectToDisplay = getCASRecordsasperAppointment(  casObjList ,  appointmentObj ) ;
        
        System.debug( '@@@@@@@@@@@ CASObjectToDisplay  debug   ' + CASObjectToDisplay );
        List<Availability_Of_CAS_OneMDCS__c> properCASObjectToDisplay = serchProperCASToDisplay( CASObjectToDisplay , AlreadyPopulatedCASandAppoIdMap , appointmentObj  );
        casAvailableList = properCASObjectToDisplay ;
        System.debug('casAvailableList now'+casAvailableList);
        return casAvailableList ;
        
        
    }
    
    public static List<Availability_Of_CAS_OneMDCS__c> getAllDefaultCAS( String customerTerritory ){
        
        return [ select id ,Name, Afternoon_Slot_OneMDCS__c,Afternoon_Slot_Updated_OneMDCS__c,            
                Availability_CAS_OneMDCS__c,Availability_Updated_OneMDCS__c,AM_OneMDCS__c,PM_OneMDCS__c,            
                Backend_Morning_Slot_OneMDCS__c,Backend_Afternoon_Slot_OneMDC__c,CAS_Team_OneMDCS__c,Territory_OneMDCS__c,
                Date_assigned_OneMDCS__c,Default_OneMDCS__c,Morning_Slot_OneMDCS__c,Morning_Slot_Updated_OneMDCS__c,Region__c from Availability_Of_CAS_OneMDCS__c
                where Default_OneMDCS__c = 'Y' AND Territory_OneMDCS__c =: customerTerritory order by createdDate asc ];
    }
    
    
    
    //:::::::::::: Returns Map where Each CAS ID could associated with More than 1 Appointment records
    public static Map<String,List<Appointment_OneMDCS__c>> getAlreadyPopulatedCASandAppoId( List<Id> appointmentIDList ){
        
        List<Appointment_OneMDCS__c> casIdList = new List<Appointment_OneMDCS__c>();
        List<String> casIdStringList = new List<String>();
        Set<String> casIdStringSet = new Set<String>();
        
        Map<String,List<Appointment_OneMDCS__c>> AlreadyPopulatedCASandAppoIdMap = new Map<String,List<Appointment_OneMDCS__c>>() ;
        List<Appointment_OneMDCS__c> assignedcasIdList = new List<Appointment_OneMDCS__c>();
        
        casIdList = [ select Id,Assigned_CAS_OneMDCS__c,Appointment_Start_time_OneMDCS__c,Appointment_end_time_OneMDCS__c from  Appointment_OneMDCS__c where id in: appointmentIDList AND Assigned_CAS_OneMDCS__c !=null ] ;
        
        for( Appointment_OneMDCS__c appointmentItr :  casIdList ){
            
            if( AlreadyPopulatedCASandAppoIdMap.containsKey( appointmentItr.Assigned_CAS_OneMDCS__c ) ){
                assignedcasIdList = AlreadyPopulatedCASandAppoIdMap.get( appointmentItr.Assigned_CAS_OneMDCS__c ) ;
                assignedcasIdList.add( appointmentItr ) ;
                AlreadyPopulatedCASandAppoIdMap.put( appointmentItr.Assigned_CAS_OneMDCS__c , assignedcasIdList ) ;
            }else{
                
                assignedcasIdList = new List<Appointment_OneMDCS__c>();
                assignedcasIdList.add( appointmentItr ) ;
                AlreadyPopulatedCASandAppoIdMap.put( appointmentItr.Assigned_CAS_OneMDCS__c , assignedcasIdList ) ;
            }
            
        }
        
        System.debug( '########### AlreadyPopulatedCASandAppoIdMap debug 1  ' + AlreadyPopulatedCASandAppoIdMap  ) ;
        
        return AlreadyPopulatedCASandAppoIdMap ;
        
    }
    
    public static List<Appointment_OneMDCS__c> getAlreadyPopulatedCASObjectList( List<Id> appointmentIDList ){
        
        List<Appointment_OneMDCS__c> casIdList = new List<Appointment_OneMDCS__c>();
        
        
        casIdList = [ select Id,Assigned_CAS_OneMDCS__c,Appointment_Start_time_OneMDCS__c,Appointment_Date_OneMDCS__c,
                     Appointment_end_time_OneMDCS__c 
                     from  Appointment_OneMDCS__c where id in: appointmentIDList  ] ;
        
        return casIdList ;
        
    }
    
    
    public static Appointment_OneMDCS__c getUnassignedAppo( String unassignedappoId ){
        
        Appointment_OneMDCS__c appoobj = new Appointment_OneMDCS__c();
        
        appoobj = [ select id,Service_Hours_OneMDCS__c,Appointment_Date_OneMDCS__c,Appointment_Start_time_OneMDCS__c , Appointment_end_time_OneMDCS__c 
                   from  Appointment_OneMDCS__c where id = : unassignedappoId ] ;
        
        
        return appoobj ;
        
    }
    
    
    
    public static List<Availability_Of_CAS_OneMDCS__c> getCASRecordsasperAppointment( List<Availability_Of_CAS_OneMDCS__c> casObjList , Appointment_OneMDCS__c appointmentObj ){
        
        Map<String , Availability_Of_CAS_OneMDCS__c > casIDandObjectMap = new Map<String , Availability_Of_CAS_OneMDCS__c >();
        
        List<Availability_Of_CAS_OneMDCS__c> CASObjectToDisplay = new List<Availability_Of_CAS_OneMDCS__c>();
        
        
        String[] appoArr = appointmentObj.Appointment_Start_time_OneMDCS__c.split( ':' ) ;
        String[] appoArr1 = appointmentObj.Appointment_end_time_OneMDCS__c.split( ':' ) ;
        
        Integer appStart = Integer.valueOf(  appoArr[0]  ) ;
        
        //start and end time of that appointment
        Integer appStart2 = Integer.valueOf(  appoArr[0] + appoArr[1]  ) ;
        Integer appEnd2 = Integer.valueOf( appoArr1[0] + appoArr1[1] ) ;
        
        for(  Availability_Of_CAS_OneMDCS__c     davItr : casObjList ){
            
            if( appStart >= 12 ){
                //::::::::::::::::::::::::::::::::Search on Afternoon Slot:::::::::::::::::::::::::::::
                
                if(davItr.PM_OneMDCS__c!=null){
                    
                    
                    //String[] casAFTArr = davItr.Afternoon_Slot_OneMDCS__c.split( ';' ) ;
                    //String[] casAFTStartarr = casAFTArr[0].split( ':' ) ;
                    //String[] casAFTEndtarr =  casAFTArr[1].split( ':' ) ;
                    //Integer caAaftStart = Integer.valueOf( casAFTStartarr[0] + casAFTStartarr[1] ) ;
                    //Integer casAftEnd = Integer.valueOf( casAFTEndtarr[0] + casAFTEndtarr[1] ) ;
                    
                    //if( appStart2 >= caAaftStart && appEnd2 <=  casAftEnd  ){
                    
                    casIDandObjectMap.put( davItr.Id , davItr ) ;
                    
                    CASObjectToDisplay.add( davItr );
                    
                }
                
                
                
            }else{
                
                //::::::::::::::::::::::::::::::::Search on Morning Slot:::::::::::::::::::::::::::::
                
                if(davItr.AM_OneMDCS__c!=null){
                    /* String[] casMorArr = davItr.Morning_Slot_OneMDCS__c.split( ';' ) ;
String[] casMORStartarr = casMorArr[0].split( ':' ) ;
String[] casMOREndtarr =  casMorArr[1].split( ':' ) ;
Integer caMORStart = Integer.valueOf( casMORStartarr[0] + casMORStartarr[1] ) ;
Integer casMOREnd = Integer.valueOf( casMOREndtarr[0] + casMOREndtarr[1] ) ;


if( appStart2 >= caMORStart && appEnd2 <=  casMOREnd ){
*/
                    casIDandObjectMap.put( davItr.Id , davItr ) ;
                    
                    CASObjectToDisplay.add( davItr );
                    
                }
            }
            
        }
        
        
        System.debug( '@@@@@@@@@@@@ casIDandObjectMap    debug  ' + casIDandObjectMap ) ;
        
        
        return CASObjectToDisplay ;
        
        
    }
    
    public static List<Availability_Of_CAS_OneMDCS__c> serchProperCASToDisplay( List<Availability_Of_CAS_OneMDCS__c> CASObjectToDisplay , Map<String,List<Appointment_OneMDCS__c>> AlreadyPopulatedCASandAppoIdMap , Appointment_OneMDCS__c appointmentObj ){
        
        System.debug( '@@@@@@@ AlreadyPopulatedCASandAppoIdMap debug 1  ' + AlreadyPopulatedCASandAppoIdMap );
        
        List<Availability_Of_CAS_OneMDCS__c>  availableCASList = new List<Availability_Of_CAS_OneMDCS__c>() ;
        Set<Availability_Of_CAS_OneMDCS__c>  availableCASSet = new Set<Availability_Of_CAS_OneMDCS__c>() ;
        Set<String> slotString = new Set<String>();
        Map<Id , boolean > casPDAMapMorning = new Map<Id , boolean >();
        Map<Id , boolean > casPDAMapAfternoon = new Map<Id , boolean >();
        
        for(Availability_Of_CAS_OneMDCS__c listPDA:[SELECT AM_OneMDCS__c,PM_OneMDCS__c,CAS_Team_OneMDCS__c,Availability_CAS_OneMDCS__c  FROM Availability_Of_CAS_OneMDCS__c where  Per_day_Availability_OneMDCS__c='Y' and Date_assigned_OneMDCS__c=:appointmentObj.Appointment_Date_OneMDCS__c]){
            
            casPDAMapMorning.put(listPDA.CAS_Team_OneMDCS__c,listPDA.AM_OneMDCS__c);
            casPDAMapAfternoon.put(listPDA.CAS_Team_OneMDCS__c,listPDA.PM_OneMDCS__c);
        }
        
        for(  Availability_Of_CAS_OneMDCS__c casItr:  CASObjectToDisplay ){
            availableCASSet.add(casItr);
            slotString = new Set<String>();
            
            
            String[] appoArr = appointmentObj.Appointment_Start_time_OneMDCS__c.split( ':' ) ;
            String[] appoArr1 = appointmentObj.Appointment_end_time_OneMDCS__c.split( ':' ) ;
            
            Integer appStart = Integer.valueOf(  appoArr[0]  ) ;
            
            //appointment Start Time & End Time
            Integer appStart2 = Integer.valueOf(  appoArr[0] + appoArr[1]  ) ;
            Integer appEnd2 = Integer.valueOf( appoArr1[0] + appoArr1[1] ) ;
            
            //for afternoon find CAS                        
            if( appStart >= 12 ){
                
                if( AlreadyPopulatedCASandAppoIdMap.containsKey( casItr.Id ) ){
                    
                    for( Appointment_OneMDCS__c appointObj :  AlreadyPopulatedCASandAppoIdMap.get( casItr.Id )  ){
                        
                        
                        String[] assigned_appoArr = appointObj.Appointment_Start_time_OneMDCS__c.split( ':' ) ;
                        String[] assigned_appoArr1 = appointObj.Appointment_end_time_OneMDCS__c.split( ':' ) ;
                        
                        
                        //every appointment start and end time for that day
                        Integer assigned_appStart2 = Integer.valueOf(  assigned_appoArr[0] + assigned_appoArr[1]  ) ;
                        Integer assigned_appEnd2 = Integer.valueOf( assigned_appoArr1[0] + assigned_appoArr1[1] ) ;
                        if(!((assigned_appStart2>=appEnd2 )|| (assigned_appEnd2<=appStart2 )))
                        {
                            availableCASSet.remove(casItr);
                            
                        }
                        else if (casPDAMapAfternoon.get(casItr.CAS_Team_OneMDCS__c)!=null && casPDAMapAfternoon.get(casItr.CAS_Team_OneMDCS__c)==false){
                            System.debug('Inside else');
                            availableCASSet.remove(casItr);
                        }
                        //availableCASList.add( casItr );
                        
                    }     
                }
                else 
                {
                    System.debug('Inside else'+casPDAMapAfternoon+'-----expected----'+casItr.CAS_Team_OneMDCS__c);
                    
                    if (casPDAMapAfternoon.get(casItr.CAS_Team_OneMDCS__c)!=null && casPDAMapAfternoon.get(casItr.CAS_Team_OneMDCS__c)==false){
                        System.debug('Inside else');
                        availableCASSet.remove(casItr);
                        //CAS List who are still not assigned to aany appointment for that day
                        //System.debug( '@@@@@@@@@ AlreadyPopulatedCASandAppoIdMap is empty afternoon    '  );
                        // availableCASList.add( casItr );
                    }
                }
                
                
            }
            else{
                
                
                if( AlreadyPopulatedCASandAppoIdMap.containsKey( casItr.Id ) ){
                    
                    for( Appointment_OneMDCS__c appointObj :  AlreadyPopulatedCASandAppoIdMap.get( casItr.Id )  ){
                        
                        
                        String[] assigned_appoArr = appointObj.Appointment_Start_time_OneMDCS__c.split( ':' ) ;
                        String[] assigned_appoArr1 = appointObj.Appointment_end_time_OneMDCS__c.split( ':' ) ;
                        
                        
                        
                        Integer assigned_appStart2 = Integer.valueOf(  assigned_appoArr[0] + assigned_appoArr[1]  ) ;
                        Integer assigned_appEnd2 = Integer.valueOf( assigned_appoArr1[0] + assigned_appoArr1[1] ) ;
                        
                        
                        
                        if(!(assigned_appStart2>=appEnd2 || assigned_appEnd2<=appStart2 ))
                            
                            availableCASSet.remove( casItr );
                        else if (casPDAMapMorning.get(casItr.CAS_Team_OneMDCS__c)!=null && casPDAMapMorning.get(casItr.CAS_Team_OneMDCS__c)==false)
                            
                            availableCASSet.remove(casItr);
                        
                        
                    }
                    
                }
                
                else{
                    if (casPDAMapMorning.get(casItr.CAS_Team_OneMDCS__c)!=null && casPDAMapMorning.get(casItr.CAS_Team_OneMDCS__c)==false){
                        System.debug('Inside else');
                        availableCASSet.remove(casItr);
                    } //CAS List who are still not assigned to aany appointment for that day
                    // System.debug( '@@@@@@@@@ AlreadyPopulatedCASandAppoIdMap is empty afternoon    '  );
                    // availableCASSet.add( casItr );
                }      
                
            }
        }   
        availableCASList.AddAll(availableCASSet);
        System.debug( '@@@@@@@@@@@@ availableCASList  debug 1 ' + availableCASList );
        return availableCASList ;
        
    }
    
    
}