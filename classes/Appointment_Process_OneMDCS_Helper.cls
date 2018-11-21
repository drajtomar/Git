/*
* Description : This helper class is used to show Apointment slots on UI based on the date user selects from UI screen.
* Copyright : Capgemini
* ClassNAme: Appointment_Process_OneMDCS_Helper
* Main Class: Appointment_Process_OneMDCS
* CreatedDate : 09/14/2017
* Modification Log  : 09/14/2017 
*/


public class Appointment_Process_OneMDCS_Helper{


    public static Map<string,List<String>> getSlotHelper( String dateSelected , String requestHour , String customerTerritory , String AppoId, String SelectedAcc){
        
        
        
        //::::: START
        
        //::::::::::: appointmentProcess_Helper_OneMDCS class is calling :::  start
            
            Boolean highCompetetionFlag = false ;
            Map<string, List<String>> slotFinal = new Map<String, List<String>>();
			Map<string, List<String>> returnSlotFinal = new Map<String, List<String>>();
            Map<string, Integer> slotForDateFinal = new Map<String, Integer>();
            Map<string, Availability_Of_CAS_OneMDCS__c > mapOfPerDayAvl = new Map<String, Availability_Of_CAS_OneMDCS__c >();
            List<String> slotsForUI = new List<String>();
            Set<String> RemoveDupSlotsForUI = new Set<String>();
            Boolean CalLogicForAcc = false ;
            
            
            if(SelectedAcc != 'Other')
            {
                CalLogicForAcc = AdmincalendarLogic_OneMDCS.getcalendarSettings( SelectedAcc );
            }
        	if(SelectedAcc == 'Other')
            {
                CalLogicForAcc = true;
            }
            
            if( CalLogicForAcc )
            {

               //Get Slots for booking

                //map to store each slots from custom settings with no of available CAS
                Map<String, Map<String, Integer>> mapOfSlotVsAvlCAS = new Map<String, Map<String, Integer>>();
                Map<String, Map<String, Integer>> mapOfSlotVsAvlCASforElse = new Map<String, Map<String, Integer>>();
                //map to store appointment, date wise with statr & end time ';' separator
                Map<String, List<String>> mapOfAppStartEndTime = new Map<String, List<String>>();

                //get Six Days for slot bookings
                List<String> getDates = new List<String>();
                getDates = getweek(Date.valueOf(dateSelected));

                //Status setting
                Set<String> setOfStatus = new Set<String>();
                setOfStatus.add('Rejected');
                setOfStatus.add('Cancelled');
                //setOfStatus.add('High Competetion Zone');

                //List of start/end time
                List<String> startendTimeList = new List<String>();
                
                //Check for Community User
                User checkCommunityUser = new User();
                checkCommunityUser = [SELECT Id, Profile.Name from User where id =: UserInfo.getUserId()];
                
                
                //Create map of appointment's start/end time if AppoId == null
                if(AppoId == null)
                {
                    if(checkCommunityUser.Profile.Name == 'External User - Customer Case Scheduler')
                    {
                        for(Appointment_OneMDCS__c objApp : [SELECT Id, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where OwnerId =: userInfo.getUserId() AND Status_OneMDCS__c Not IN: setOfStatus AND Appointment_Date_OneMDCS__c >=: Date.Today() AND Territory_OneMDCS__c =: customerTerritory])
                        {
                            
                            String StartEndTime = objApp.Appointment_start_time_12hrs_OneMDCS__c + ';' + objApp.Appointment_end_time_12_hrs_OneMDCS__c;
                            
                            if(mapOfAppStartEndTime.containsKey(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)))
                            {
                                List<String> getListOfTime = mapOfAppStartEndTime.get(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)); //::::: Do not create unneccessary List
                                getListOfTime.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), getListOfTime);
                            }
                            else
                            {
                                startendTimeList = new List<String>();
                                startendTimeList.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), startendTimeList);
                            }
                        }
                    }
                    else
                    {
                        for(Appointment_OneMDCS__c objApp : [SELECT Id, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where Status_OneMDCS__c Not IN: setOfStatus AND Appointment_Date_OneMDCS__c >=: Date.Today() AND Territory_OneMDCS__c =: customerTerritory])
                        {
                            
                            String StartEndTime = objApp.Appointment_start_time_12hrs_OneMDCS__c + ';' + objApp.Appointment_end_time_12_hrs_OneMDCS__c;
                            
                            if(mapOfAppStartEndTime.containsKey(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)))
                            {
                                List<String> getListOfTime = mapOfAppStartEndTime.get(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)); //::::: Do not create unneccessary List
                                getListOfTime.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), getListOfTime);
                            }
                            else
                            {
                                startendTimeList = new List<String>();
                                startendTimeList.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), startendTimeList);
                            }
                        }
                    }
                }
                
                //Create map of appointment's start/end time if AppoId != null
                if(AppoId != null && AppoId != '')
                {
                    if(checkCommunityUser.Profile.Name == 'External User - Customer Case Scheduler')
                    {   
                        for(Appointment_OneMDCS__c objApp : [SELECT Id, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where OwnerId =: userInfo.getUserId() AND Id!=: AppoId AND Status_OneMDCS__c Not IN: setOfStatus AND Appointment_Date_OneMDCS__c >=: Date.Today() AND Territory_OneMDCS__c =: customerTerritory])
                        {
                            
                            String StartEndTime = objApp.Appointment_start_time_12hrs_OneMDCS__c + ';' + objApp.Appointment_end_time_12_hrs_OneMDCS__c;
                            
                            if(mapOfAppStartEndTime.containsKey(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)))
                            {
                                List<String> getListOfTime = mapOfAppStartEndTime.get(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)); //::::: Do not create unneccessary List
                                getListOfTime.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), getListOfTime);
                            }
                            else
                            {
                                startendTimeList = new List<String>();
                                startendTimeList.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), startendTimeList);
                            }
                        }
                    }
                    else
                    {
                        for(Appointment_OneMDCS__c objApp : [SELECT Id, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where Id!=: AppoId AND Status_OneMDCS__c Not IN: setOfStatus AND Appointment_Date_OneMDCS__c >=: Date.Today() AND Territory_OneMDCS__c =: customerTerritory])
                        {
                            
                            String StartEndTime = objApp.Appointment_start_time_12hrs_OneMDCS__c + ';' + objApp.Appointment_end_time_12_hrs_OneMDCS__c;
                            
                            if(mapOfAppStartEndTime.containsKey(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)))
                            {
                                List<String> getListOfTime = mapOfAppStartEndTime.get(String.ValueOf(objApp.Appointment_Date_OneMDCS__c)); //::::: Do not create unneccessary List
                                getListOfTime.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), getListOfTime);
                            }
                            else
                            {
                                startendTimeList = new List<String>();
                                startendTimeList.add(StartEndTime);
                                mapOfAppStartEndTime.put(String.ValueOf(objApp.Appointment_Date_OneMDCS__c), startendTimeList);
                            }
                        }
                    }
                }
                system.debug('------->>>> startendTimeList '+ startendTimeList );
                system.debug('------->>>> mapOfAppStartEndTime '+mapOfAppStartEndTime);
                //get all selected slots
                //get all slots default
                List<String> getConCatedAMPMSlotsDefault = new List<String>();
                List<Available_Services_OneMDCS__c> getAllDefaultSlots = new List<Available_Services_OneMDCS__c>();
                getAllDefaultSlots = [SELECT Id, Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Name, Type_OneMDCS__c from Available_Services_OneMDCS__c where Type_OneMDCS__c = 'Slot Settings' AND Territory_OneMDCS__c ='Default All Slot' ];
                for(Available_Services_OneMDCS__c objSlotsCus :getAllDefaultSlots)
                {
                    String allSlotsDefault = objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c + ';' + objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c;              
                    getConCatedAMPMSlotsDefault = allSlotsDefault.split(';');
                }
                
                
                List<Available_Services_OneMDCS__c> getTimeSlotForTerritory = new List<Available_Services_OneMDCS__c>();
                getTimeSlotForTerritory = [SELECT Id, Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Name, Type_OneMDCS__c from Available_Services_OneMDCS__c where Type_OneMDCS__c = 'Slot Settings' AND Territory_OneMDCS__c =: customerTerritory ];
                if(getTimeSlotForTerritory.isEmpty())
                {
                    getTimeSlotForTerritory = [SELECT Id, Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Name, Type_OneMDCS__c from Available_Services_OneMDCS__c where Type_OneMDCS__c = 'Slot Settings' AND Territory_OneMDCS__c ='Default' ];
                }
                
                List<String> getConCatedAMPMSlots = new List<String>();
                String AMSelectedSlots = '';
                String PMSelectedSlots = '';
                for(Available_Services_OneMDCS__c objSlotsCus :getTimeSlotForTerritory)
                {
                    if(objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c != null && objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c != '')
                    {
                        AMSelectedSlots = objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c;
                    }
                    else
                    {
                        AMSelectedSlots = '';
                    }
                    if(objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c != null && objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c != '')
                    {
                        PMSelectedSlots = objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c;
                    }
                    else
                    {
                        PMSelectedSlots = '';
                    }
                    String allSlots = AMSelectedSlots + ';' + PMSelectedSlots;              
                    getConCatedAMPMSlots = allSlots.split(';');
                }
                
                //Get perday Availability_CAS_OneMDCS__c
                //mapOfPerDayAvl
                for(Availability_Of_CAS_OneMDCS__c objPDA : [SELECT Id, AM_OneMDCS__c, PM_OneMDCS__c, CAS_Team_OneMDCS__c, Date_assigned_OneMDCS__c, Territory_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Territory_OneMDCS__c =: customerTerritory AND Default_OneMDCS__c = 'N'])
                {
                    String GenerateUniqueKey = String.ValueOf(objPDA.Date_assigned_OneMDCS__c) + '--' + objPDA.CAS_Team_OneMDCS__c;
                    mapOfPerDayAvl.put(GenerateUniqueKey, objPDA);
                }
                
                Map<string, Integer> slotVsCasAvl = new Map<String, Integer>();
                //system.debug('------------->getDates '+getDates);
                for(String objDates : getDates)
                {
                    for(Availability_Of_CAS_OneMDCS__c objAvlCAS : [SELECT Id, AM_OneMDCS__c, PM_OneMDCS__c, CAS_Team_OneMDCS__c, Territory_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Territory_OneMDCS__c =: customerTerritory AND Default_OneMDCS__c = 'Y'])
                    {
                        //Check PDA
                        String GenerateUniqueKeyPDA = objDates + '--' + objAvlCAS.CAS_Team_OneMDCS__c;
                        Availability_Of_CAS_OneMDCS__c getObjPDA = new Availability_Of_CAS_OneMDCS__c();
                        List<Availability_Of_CAS_OneMDCS__c> pdaObjList = new List<Availability_Of_CAS_OneMDCS__c>();
                        if(mapOfPerDayAvl.containsKey(GenerateUniqueKeyPDA))
                        {
                            getObjPDA = mapOfPerDayAvl.get(GenerateUniqueKeyPDA);
                            pdaObjList.add(getObjPDA);
                        }
                        //system.debug('*-*-*-*-*-*-*- pdaObjList ' +pdaObjList);
                        if(pdaObjList != null && !pdaObjList.isEmpty())
                        {
                            if(pdaObjList[0].AM_OneMDCS__c)
                            {
                                //system.debug('Inside AM True');
                                for(String objAvlSlots : getConCatedAMPMSlots)
                                {
                                    if(objAvlSlots.Contains('AM'))
                                    {
                                        //system.debug('-----------> objAvlSlots '+objAvlSlots);
                                        String keyMapUnique = objAvlSlots + ';' + objDates;
                                        if(slotVsCasAvl.containsKey(keyMapUnique))
                                        {
                                            Integer i = slotVsCasAvl.get(keyMapUnique);
                                            i = i+1;
                                            slotVsCasAvl.put(keyMapUnique, i);
                                        }
                                        else
                                        {
                                            Integer noOfCASAvl = 0;
                                            noOfCASAvl = noOfCASAvl + 1;
                                            slotVsCasAvl.put(keyMapUnique, noOfCASAvl);
                                        }
                                    }
                                }
                            }
                        
                            if(pdaObjList[0].PM_OneMDCS__c)
                            {
                                for(String objAvlSlots : getConCatedAMPMSlots)
                                {
                                    if(objAvlSlots.Contains('PM'))
                                    {
                                        //system.debug('-----------> objAvlSlotsPM '+objAvlSlots);
                                        String keyMapUniquePM = objAvlSlots + ';' + objDates;
                                        if(slotVsCasAvl.containsKey(keyMapUniquePM))
                                        {
                                            Integer i = slotVsCasAvl.get(keyMapUniquePM);
                                            i = i+1;
                                            slotVsCasAvl.put(keyMapUniquePM, i);
                                        }
                                        else
                                        {
                                            Integer noOfCASAvlPM = 0;
                                            noOfCASAvlPM = noOfCASAvlPM + 1;
                                            slotVsCasAvl.put(keyMapUniquePM, noOfCASAvlPM);
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            //for AM if PDA not available
                            for(String objAvlSlots : getConCatedAMPMSlots)
                            {
                                if(objAvlSlots.Contains('AM'))
                                {
                                    //system.debug('-----------> objAvlSlots '+objAvlSlots);
                                    String keyMapUnique = objAvlSlots + ';' + objDates;
                                    if(slotVsCasAvl.containsKey(keyMapUnique))
                                    {
                                        Integer i = slotVsCasAvl.get(keyMapUnique);
                                        i = i+1;
                                        slotVsCasAvl.put(keyMapUnique, i);
                                    }
                                    else
                                    {
                                        Integer noOfCASAvl = 0;
                                        noOfCASAvl = noOfCASAvl + 1;
                                        slotVsCasAvl.put(keyMapUnique, noOfCASAvl);
                                    }
                                }
                            }
                            //for PM if PDA is not available
                            for(String objAvlSlots : getConCatedAMPMSlots)
                            {
                                system.debug('%%%%%%% objAvlSlots  ' +objAvlSlots);
                                if(objAvlSlots.Contains('PM'))
                                {
                                    //system.debug('-----------> objAvlSlotsPM '+objAvlSlots);
                                    String keyMapUniquePM = objAvlSlots + ';' + objDates;
                                    if(slotVsCasAvl.containsKey(keyMapUniquePM))
                                    {
                                        Integer i = slotVsCasAvl.get(keyMapUniquePM);
                                        i = i+1;
                                        slotVsCasAvl.put(keyMapUniquePM, i);
                                        system.debug('%%%%%%% IF slotVsCasAvl  ' +slotVsCasAvl);
                                    }
                                    else
                                    {
                                        Integer noOfCASAvlPM = 0;
                                        noOfCASAvlPM = noOfCASAvlPM + 1;
                                        slotVsCasAvl.put(keyMapUniquePM, noOfCASAvlPM);
                                        system.debug('%%%%%%% ELSE slotVsCasAvl  ' +slotVsCasAvl);
                                    }
                                }
                            }
                            
                            
                        }//::: End of Else
                            
                        //system.debug('---------->slotVsCasAvl 456 '+slotVsCasAvl);
                        //mapOfSlotVsAvlCAS.put(objDates, slotVsCasAvl);
                    }
                    
                    mapOfSlotVsAvlCAS.put(objDates, slotVsCasAvl);
                    mapOfSlotVsAvlCASforElse.put(objDates, slotVsCasAvl);
                    system.debug('@@@@@@@ mapOfSlotVsAvlCASforElse '+mapOfSlotVsAvlCASforElse);
                    
                    
                   
            }//outer for loop dates

            List<String> getAppointmentsForDate = new List<String>();
            //List<String> getStartEndSlots = new List<String>();
            Set<String> getStartEndSlots = new Set<String>();
            
            Map<string, Integer> slotForDate = new Map<String, Integer>();
            String EndSlots = '';
            String StartSlots = '';
            Integer updatedCasNo = 0;
            //Get available slots after checking appointments
            String FinalFormatUI = '';
            
            
            
            system.debug('------------->getDates first '+getDates);
            
            
            
            for(String objDates : getDates)
            {
                System.debug( '#### objDates  first ' + objDates );
                if(mapOfAppStartEndTime.ContainsKey(objDates))
                {
                    //::::::::::::::::::::: Appointment record found ::::::::::::::
                    
                    
                    //System.debug( '#### mapOfAppStartEndTime.get(objDates)::::  ' + mapOfAppStartEndTime.get(objDates) );
                    getAppointmentsForDate = mapOfAppStartEndTime.get(objDates);
                
                    System.debug( '######### getConCatedAMPMSlots 1 ' + getConCatedAMPMSlots );
                    if(!getAppointmentsForDate.isEmpty())
                    {
                        for(String objStr: getAppointmentsForDate)
                        {
                            System.debug( '##### Appoint First 1 ' + objStr );
                            
                            slotsForUI = new List<String>();
                            RemoveDupSlotsForUI = new set<String>();
                            
                            List<String> separatedStartEnd = new List<String>();
                            separatedStartEnd = objStr.split(';');
                            StartSlots = separatedStartEnd[0];
                            EndSlots = separatedStartEnd[1];
                            system.debug('------->StartSlots '+StartSlots);
                            system.debug('------->EndSlots '+EndSlots);
                            
                            
                            //getStartEndSlots = new List<String>();
                            getStartEndSlots = new Set<String>();
                            //Prepare Start to End range  Slot
                            for(String objStrSlots : getConCatedAMPMSlotsDefault)
                            {
                                system.debug('-*-*-*-> objStrSlots '+objStrSlots);
                                
                                if(objStrSlots == StartSlots)
                                {
                                    getStartEndSlots.add(objStrSlots);
                                }
                                if(!getStartEndSlots.isEmpty())
                                {
                                    getStartEndSlots.add(objStrSlots);
                                }
                                if(objStrSlots == EndSlots)
                                {
                                    getStartEndSlots.add(objStrSlots);
                                    break;
                                }
                            }
                            
                           // system.debug('--------------------> getStartEndSlots before remove '+getStartEndSlots);
                            
                            /*
                            if(!getStartEndSlots.isEmpty())
                            {
                                //system.debug('--------------------> getStartEndSlots '+getStartEndSlots);
                                getStartEndSlots.remove(0);  //:::: 
                                getStartEndSlots.remove(getStartEndSlots.size()-1);
                                
                                
                            }
                            */
                            
                            
                            system.debug('--------------------> getStartEndSlots '+getStartEndSlots);
                            
                            for(String ObjSlots : getStartEndSlots)
                            {
                                if(mapOfSlotVsAvlCAS.ContainsKey(objDates))
                                {
                                    System.debug( '@@@@@ before ObjSlots ' + ObjSlots ) ;
                                    System.debug( '@@@@@ before ObjSlots ' + EndSlots ) ;
                                    if(ObjSlots != EndSlots) //::: 6.30 != 9.30 
                                    {
                                        //System.debug( '@@@@@ after ObjSlots ' + ObjSlots ) ;
                                        
                                        slotForDate = mapOfSlotVsAvlCAS.get(objDates);
                                        String uniqueMapKey = ObjSlots + ';' + objDates;
                                        if(slotForDate.containsKey(uniqueMapKey))
                                        {
                                            System.debug( '@@@@@ inside ObjSlots ' + ObjSlots ) ;
                                            
                                            System.debug( '@@@@@ inside slotForDate ' + slotForDate ) ;
                                            
                                            updatedCasNo = slotForDate.get(uniqueMapKey);
                                            updatedCasNo = updatedCasNo - 1;
                                            
                                            slotForDate.put(uniqueMapKey, updatedCasNo);
                                            //mapOfSlotVsAvlCAS.put(objDates, slotForDate);
                                            //system.debug('--------inside minus slotForDate '+slotForDate);
                                        }
                                        
                                    }
                                    mapOfSlotVsAvlCAS.put(objDates, slotForDate);
                                }
                            }
                            
                            System.debug( '@@@@@@@@@@ After modify  mapOfSlotVsAvlCAS  ' +  mapOfSlotVsAvlCAS );
                            //System.debug( '####### Appointment record list end   ' + objStr );
                        }
                    }
                    
                    
                    
                    //test outside appo list =====//
                    
                    for(String getFinalSlots : getConCatedAMPMSlots)
                    {
                        System.debug( '::: getConCatedAMPMSlots 822 ' + getConCatedAMPMSlots );
                        System.debug( '::: getFinalSlots 111 ' + getFinalSlots );
                        system.debug('------->mapOfSlotVsAvlCAS keyset ' +mapOfSlotVsAvlCAS.keySet()  );
                        
                        if(mapOfSlotVsAvlCAS.containsKey(objDates))
                        {
                            System.debug( '::: getFinalSlots 829  ' + getFinalSlots );
                            
                            //::: New added for testing
                            
                            
                            slotForDateFinal = mapOfSlotVsAvlCAS.get(objDates);
                            
                            system.debug('------->slotForDateFinal ' +slotForDateFinal);
                            
                            String createMapKey = getFinalSlots + ';' + objDates;
                            
                            system.debug('------->createMapKey ' +createMapKey);
                            if(slotForDateFinal.ContainsKey(createMapKey))
                            {
                                system.debug('---------objDates 3 '+objDates);
                                System.debug( '::: before split createMapKey ::: ' + createMapKey );  // 12:00 PM;2017-09-14
                                
                                String[] AllSlotsforReqHour = createMapKey.split(':');
                                String[] AllSlotsforMinPart = AllSlotsforReqHour[1].split(' ');
                                Integer endSlotOfProcess = (Integer.valueOf(AllSlotsforReqHour[0]) + Integer.valueOf(requestHour));
                                system.debug('AllSlotsforReqHour[0] ' +AllSlotsforReqHour[0]);
                                system.debug('requestHour ' +requestHour);
                                system.debug('endSlotOfProcess ' +endSlotOfProcess);
                                Boolean isSlotPM = false;
                                Boolean isSlotAM = false;
                                String EndSlotOfSelectedProcess = '';
                                
                                
                                
                                
                                if(AllSlotsforReqHour[1].contains('AM'))
                                {
                                    if(endSlotOfProcess >= 12)
                                    {
                                        isSlotPM = true;
                                    }
                                    if(endSlotOfProcess > 12)
                                    {
                                        endSlotOfProcess = endSlotOfProcess - 12;
                                    }
                                    if(!isSlotPM)
                                    {
                                        if(endSlotOfProcess <10)
                                        {
                                            EndSlotOfSelectedProcess = '0' + String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'AM' + ';' + objDates;
                                        }
                                        else
                                        {
                                            EndSlotOfSelectedProcess = String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'AM' + ';' + objDates;
                                        }
                                    }
                                    else
                                    {
                                        if(endSlotOfProcess != 12 && endSlotOfProcess < 10)
                                        {
                                            EndSlotOfSelectedProcess = '0' + String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'PM' + ';' + objDates;
                                        }
                                        else
                                        {
                                            EndSlotOfSelectedProcess = String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'PM' + ';' + objDates;
                                        }
                                    }
                                }
                                else if(AllSlotsforReqHour[1].contains('PM'))
                                {
                                    //EndSlotOfSelectedProcess = '0' + String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'PM' + ';' + objDates;
                                    
                                    system.debug('------------>endSlotOfProcess ' +endSlotOfProcess);
                                    if(endSlotOfProcess >12)
                                    {
                                        endSlotOfProcess = endSlotOfProcess - 12;
                                    }
                                    if(endSlotOfProcess < 10)
                                    {
                                        EndSlotOfSelectedProcess = '0' + String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'PM' + ';' + objDates;
                                    }
                                    else
                                    {
                                        EndSlotOfSelectedProcess = String.valueOf(endSlotOfProcess) + ':' + AllSlotsforMinPart[0] + ' ' + 'PM' + ';' + objDates;
                                    }
                                }
                                
                                String[] getStartSlotProcess = createMapKey.split(';');
                                String[] getEndSlotProcess = EndSlotOfSelectedProcess.split(';');
                                
                                String StartSlot = getStartSlotProcess[0];
                                String EndSlotProcess = getEndSlotProcess[0];
                                
                                
                                
                                
                                
                                
                                system.debug('StartSlot and EndSlotProcess '+StartSlot+'GGGGGG '+EndSlotProcess);
                                //to check all consecutive slots are available
                                
                                //new added
                                
                                for(String checkAvailSlots : getConCatedAMPMSlotsDefault)
                                {
                                    
                                    System.debug( '   ###### Initial checkAvailSlots::: ' +  checkAvailSlots );
                                    //remove AM/PM from custom settings data
                                    String[] convertto24HrsCustom = checkAvailSlots.split(' ');
                                    
                                    //remove ':'
                                    String[] convertto24HrsCustomwithoutColon = convertto24HrsCustom[0].split(':');
                                    if(convertto24HrsCustom[1].contains('PM'))
                                    {
                                        if(Integer.valueOf(convertto24HrsCustomwithoutColon[0]) != 12 )
                                        {
                                            convertto24HrsCustomwithoutColon[0] = String.ValueOf(Integer.valueOf(convertto24HrsCustomwithoutColon[0]) + 12);
                                        }
                                    }
                                    
                                    String concatedTimeCustSettings = convertto24HrsCustomwithoutColon[0] + convertto24HrsCustomwithoutColon[1]; // FOR AM/PM both
                                    //====================================//
                                    //StartSlot
                                        
                                        //remove AM/PM from data
                                        String[] convertto24HrsStart = StartSlot.split(' ');
                                        
                                        //remove ':'
                                        String[] convertto24HrsStartSlotwithoutColon = convertto24HrsStart[0].split(':');
                                        
                                        if(convertto24HrsStart[1].contains('PM'))
                                        {
                                            if(Integer.valueOf(convertto24HrsStartSlotwithoutColon[0]) != 12 )
                                            {
                                                convertto24HrsStartSlotwithoutColon[0] = String.ValueOf(Integer.valueOf(convertto24HrsStartSlotwithoutColon[0]) + 12);
                                            }
                                        }
                                        String concatedTimeStartSlot = convertto24HrsStartSlotwithoutColon[0] + convertto24HrsStartSlotwithoutColon[1];
                                        
                                        //EndSlotProcess
                                        
                                        //remove AM/PM from data
                                        String[] convertto24HrsEnd = EndSlotProcess.split(' ');
                                        
                                        //remove ':'
                                        String[] convertto24HrsEndSlotwithoutColon = convertto24HrsEnd[0].split(':');
                                        
                                        if(convertto24HrsEnd[1].contains('PM'))
                                        {
                                            if(Integer.valueOf(convertto24HrsEndSlotwithoutColon[0]) != 12 )
                                            {
                                                convertto24HrsEndSlotwithoutColon[0] = String.ValueOf(Integer.valueOf(convertto24HrsEndSlotwithoutColon[0]) + 12);
                                            }
                                        }
                                        
                                        String concatedTimeEndSlot = convertto24HrsEndSlotwithoutColon[0] + convertto24HrsEndSlotwithoutColon[1];
                                        
                                        //system.debug('-------------------> concatedTimeStartSlot '+concatedTimeStartSlot);
                                        //system.debug('-------------------> concatedTimeEndSlot '+concatedTimeEndSlot);
                                    //====================================//
                                    
                                    /*system.debug('---------objDates 2 '+objDates);
                                    System.debug( '::: concatedTimeCustSettings debug ' + Integer.ValueOf(concatedTimeCustSettings) );
                                    System.debug( ':::: concatedTimeStartSlot debug  ' + Integer.ValueOf(concatedTimeStartSlot)  );
                                    System.debug( ':::: concatedTimeEndSlot debug  ' + Integer.ValueOf(concatedTimeEndSlot)  );*/
                                    
                                    if(Integer.ValueOf(concatedTimeCustSettings) >= Integer.ValueOf(concatedTimeStartSlot)
                                            && Integer.ValueOf(concatedTimeCustSettings) < Integer.ValueOf(concatedTimeEndSlot))
                                    {
                                        String createMapKeyUnique = checkAvailSlots + ';' + objDates;
                                        Integer isCasAvlforEachSlot = slotForDateFinal.get(createMapKeyUnique);
                                        
                                        System.debug( ' :::: createMapKeyUnique 954  ' + createMapKeyUnique + ' :::: isCasAvlforEachSlot 954 ' + isCasAvlforEachSlot + ' createMapKey before 954 ' + createMapKey + ' slotForDateFinal before put 954 ' + slotForDateFinal.get(createMapKey) ); 
                                        
                                        //System.debug( ':::: Only 12 pm value 954 ' + slotForDateFinal.get(  '12:00 PM' ) );
                                       
                                        if(isCasAvlforEachSlot == 0)
                                        {
                                            System.debug( ':::: createMapKey after 954 ' + createMapKey );
                                            slotForDateFinal.put(createMapKey, 0);
                                            break;
                                            System.debug( ':::: slotForDateFinal after put 954 ' + slotForDateFinal.get(createMapKey) );
                                        }
                                        /*if(isCasAvlforEachSlot == null)
                                        {
                                            //System.debug( ':::: createMapKey after 954 ' + createMapKey );
                                            slotForDateFinal.put(createMapKey, 1);
                                            System.debug( ':::: slotForDateFinal after put 954 ' + slotForDateFinal.get(createMapKey) );
                                            break;
                                            
                                        }*/
                                    }
                                    
                                }
                                    
                                
                                
                                
                                Integer isCasAvl = slotForDateFinal.get(createMapKey);
                                System.debug( ':::: Only isCasAvl 652 ' + isCasAvl + 'Only isCasAvl 652 ' +createMapKey);
                                if(isCasAvl > 0)
                                {
                                    String[] createslotsForUIFinal = createMapKey.split(';');
                                    if(createslotsForUIFinal[0] != null)
                                    {
                                        slotsForUI.add(createslotsForUIFinal[0]);
                                    }
                                    //CreateMap For UI
                                    
                                    String[] nextweekvar = objDates.split( '-' ); //::: Sample date 2017-08-29
                                    dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                                    FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                                    slotFinal.put(FinalFormatUI, slotsForUI);
                                    System.debug( '@@@@ slotFinal inside if 1    ' + slotFinal );
                                }
                                else
                                {
                                    String[] nextweekvar = objDates.split( '-' ); //::: Sample date 2017-08-29
                                    dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                                    FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                                    if(slotsForUI.isEmpty())
                                    {
                                        List<String> forBlankSlots = new List<String>();
                                        slotFinal.put(FinalFormatUI, forBlankSlots);
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    
                    //test outside appo list =====//
                    
                }
                else
                {
                    //::::::::::::::::::::: Appointment record Not found ::::::::::::::
                         
                   
                    slotsForUI = new List<String>();
                    RemoveDupSlotsForUI = new set<String>();
                            
                    for(String getFinalSlots : getConCatedAMPMSlots)
                    {
                        if(mapOfSlotVsAvlCASforElse.containsKey(objDates))
                        {
                            
                            
                            slotForDateFinal = mapOfSlotVsAvlCASforElse.get(objDates);
                            
                            String createMapKey = getFinalSlots + ';' + objDates;
                            if(slotForDateFinal.ContainsKey(createMapKey))
                            {
                                
                                Integer isCasAvl = slotForDateFinal.get(createMapKey);
                                if(isCasAvl > 0 || isCasAvl == null)
                                {
                                    String[] createslotsForUIFinal = createMapKey.split(';');
                                    //system.debug('*-*-*-*-*->>> ELSE slotsForUI '+slotsForUI);
                                    if(createslotsForUIFinal[0] != null)
                                    {
                                        slotsForUI.add(createslotsForUIFinal[0]);
                                    }
                                    //system.debug('*-*-*-*-*->>> ELSE slotsForUI '+slotsForUI);
                                    String[] nextweekvar = objDates.split( '-' ); //::: Sample date 2017-08-29
                                    dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                                    FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                                    
                                    //System.debug( '##### inside else  FinalFormatUI ' + FinalFormatUI +  ' ### slotsForUI ' + slotsForUI  );
                                    slotFinal.put(FinalFormatUI, slotsForUI);
                                }
                                else
                                {
                                    String[] nextweekvar = objDates.split( '-' ); //::: Sample date 2017-08-29
                                    dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                                    FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                                    if(slotsForUI.isEmpty())
                                    {
                                        List<String> forBlankSlots = new List<String>();
                                        slotFinal.put(FinalFormatUI, forBlankSlots);
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if(slotFinal.containsKey(FinalFormatUI))
                    {
                        slotsForUI = slotFinal.get(FinalFormatUI);
                        RemoveDupSlotsForUI.addAll(slotsForUI);
                        slotsForUI = new List<String>();
                        slotsForUI.addAll(RemoveDupSlotsForUI);
                        /*Integer j = 0;
                        while (j < slotsForUI.size())
                        {
                            if(slotsForUI.get(j) == null)
                            {
                                slotsForUI.remove(j);
                            }
                            else
                            {
                                j++;
                            }
                        }*/
                        slotFinal.put(FinalFormatUI, slotsForUI);
                    }
                    
                }
            }
            if(slotFinal.keyset().isEmpty())
            {
                for(String objDates : getDates)
                {
                    String[] nextweekvar = objDates.split( '-' ); //::: Sample date 2017-08-29
                    dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                    FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                    List<String> forBlankSlots = new List<String>();
                    slotFinal.put(FinalFormatUI, forBlankSlots);
                }
            }
            System.debug( ':::::::: slotFinal   Check blank'  +  slotFinal );
            return slotFinal;

            
        }
        else
        {
            highCompetetionFlag = true ;
           
            List<String> getDates = new List<String>();
            getDates = getweek(Date.valueOf(dateSelected));
            //Get Selected slots for User's territory
            List<Available_Services_OneMDCS__c> getTimeSlotForTerritory = new List<Available_Services_OneMDCS__c>();
            getTimeSlotForTerritory = [SELECT Id, Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Name, Type_OneMDCS__c from Available_Services_OneMDCS__c where Type_OneMDCS__c = 'Slot Settings' AND Territory_OneMDCS__c =: customerTerritory limit 1];
            if(getTimeSlotForTerritory.isEmpty())
            {
                getTimeSlotForTerritory = [SELECT Id, Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Name, Type_OneMDCS__c from Available_Services_OneMDCS__c where Type_OneMDCS__c = 'Slot Settings' AND Territory_OneMDCS__c ='Default' limit 1];
            }
            List<String> getConCatedAMPMSlots = new List<String>();
            String AMSelectedSlots = '';
            String PMSelectedSlots = '';
            for(Available_Services_OneMDCS__c objSlotsCus :getTimeSlotForTerritory)
            {
                if(objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c != null)
                {
                    AMSelectedSlots = objSlotsCus.Selected_Time_Slots_AM_OneMDCS__c;
                }
                else
                {
                    AMSelectedSlots = '';
                }
                if(objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c != null)
                {
                    PMSelectedSlots = objSlotsCus.Selected_Time_Slots_PM_OneMDCS__c;
                }
                else
                {
                    PMSelectedSlots = '';
                }
                String allSlots;
				if(AMSelectedSlots != '' && PMSelectedSlots != ''){
					allSlots = AMSelectedSlots + ';' + PMSelectedSlots;
				}
				else if(AMSelectedSlots != '' && PMSelectedSlots == ''){
					allSlots = AMSelectedSlots;
				}
				else if(AMSelectedSlots == '' && PMSelectedSlots != ''){
					allSlots = PMSelectedSlots;
				}      
                getConCatedAMPMSlots = allSlots.split(';');
                
            }
            //outer most loop of dates
            for(String objDateString: getDates)
            {
                //loop of appointment of that date in outer loop
                
                //loop of slots from custom settings
                
                
                String FinalFormatUI;
                String[] nextweekvar = objDateString.split( '-' ); //::: Sample date 2017-08-29
                dateTime dtime = DateTime.newInstance( Integer.valueOf( nextweekvar[0] ) , Integer.valueOf( nextweekvar[1] ) , Integer.valueOf( nextweekvar[2] ) ,0,0,0);
                FinalFormatUI  = dtime.format( 'EE' ) + ' ' + nextweekvar[1] + '/' + nextweekvar[2] ;
                
                system.debug('getConCatedAMPMSlots ------+++>> '+getConCatedAMPMSlots);
                slotFinal.put(FinalFormatUI, getConCatedAMPMSlots);
            }
            return slotFinal;
           
          
       }
       
        return returnSlotFinal ;
       
       
        //::::::::::: appointmentProcess_Helper_OneMDCS class is calling :::  end  
        
        
        //::::: END
        
        
    }
    
    //get the weekdays details
    public static List<String> getweek(Date dat)
    {
        
        system.debug('-------->dat '+dat);
        List<String> daywithDate = new List<String>();
        
        for(Integer i = 1; i <=10; i++)
        {
            Date WeekDate = dat.addDays(i);
            Datetime dt1 = (DateTime)WeekDate;
            String dayOfWeeks = dt1.format('EE');
            if(dayOfWeeks!= 'Sun' && dayOfWeeks!= 'Sat')
            { 
                String dateFormatted = dt1.format('yyyy-MM-dd');
                if(daywithDate.size() < 6)
                {
                    daywithDate.add(dateFormatted);    
                }
                
                
            }
        }   
        system.debug('-------> '+daywithDate);
        return daywithDate;
    }
}