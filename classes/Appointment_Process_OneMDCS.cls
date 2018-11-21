public with sharing class Appointment_Process_OneMDCS{
    
    //public static List<weekClaendarunBlockWrapper> appoBookedList = new List<weekClaendarunBlockWrapper>();
    
    //for appoint list
    @AuraEnabled
    public list<Appointment_OneMDCS__c> apt;
    @AuraEnabled
    public list<Appointment_OneMDCS__c> SelApt;
    
    public list<Appointment_OneMDCS__c> SelectedApt{get;set;}{SelectedApt = new list<Appointment_OneMDCS__c>();}
    
    @AuraEnabled
    public integer offst;
    
    /*@AuraEnabled
	public String dateSelected;*/
    
    @AuraEnabled
    public integer total;
    
    @AuraEnabled
    public boolean hasprev;
    
    @AuraEnabled
    public boolean hasnext;
    
    private static integer pagesize=8;
    private static integer offset;
    
    Public static Map<Date, String> weekdaysMap = new Map<Date, String>();
    Public static Boolean isFirstTimeLoad = False;
    
    
    //get all the location data(Basically hospitals name)
    @AuraEnabled
    public static List<Available_Services_OneMDCS__c> getLocations(Boolean adminScreen, String territory)
    {
        List<User> GetLoggedInUserTerritory = new List<User>();
        GetLoggedInUserTerritory = [SELECT id, Primary_Territory_OneMDCS__c from User where id=: userinfo.getUserId()];
        //List<Available_Services_OneMDCS__c>  objAcc = new List<Available_Services_OneMDCS__c>();
        if(adminScreen)
        {

            return [Select Hospital_Name_OneMDCS__c, Hospital_Id_OneMDCS__c from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: territory AND Type_OneMDCS__c = 'Hospital Territory' Order by Hospital_Name_OneMDCS__c];
        }
        else 
        {
            
            return [Select Hospital_Name_OneMDCS__c, Hospital_Id_OneMDCS__c from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c AND Type_OneMDCS__c = 'Hospital Territory' Order by Hospital_Name_OneMDCS__c];
        }
    }
    
    @AuraEnabled
    public static List<Contact_Details_OneMDCS__c> getContacts(String AccId)
    {   
        List<Contact_Details_OneMDCS__c>  objAcc = new List<Contact_Details_OneMDCS__c>();
        for( Contact_Details_OneMDCS__c condetl: [Select Id, Contact_Name__c, Contact_Id_OneMDCS__c   from Contact_Details_OneMDCS__c where Hospital_Id_OneMDCS__c =: AccId and Contact_Type_OneMDCS__c =: 'EP' Order by Contact_Name__c]){
			if(condetl.Id != null){
				objAcc.add(condetl);
			}
		}
        return objAcc;
    }
    
    @AuraEnabled
    public static Boolean getProfileName()
    {
        Boolean isClinicalAccountProfile = false;
        User userDtls=new User();
        Id userId = UserInfo.getUserId();
        userDtls = [SELECT Profile.Name FROM User where Id =:userId];
        if(!('Clinical Account Specialist'.equals(userDtls.Profile.Name) || 'Ultra Sound CAS'.equals(userDtls.Profile.Name) || 'Trainee CAS'.equals(userDtls.Profile.Name) || 'Custom SP Profile'.equals(userDtls.Profile.Name)))
            isClinicalAccountProfile = true;           
        return isClinicalAccountProfile;
    }
    
    //get all the territory name
    @AuraEnabled
    public static List<Territory> getTerritories()
    {
        /*List<Account>  objAccTerritory = new List<Account>();
objAccTerritory = [Select name, id, Territory__c from Account];
return objAccTerritory;*/
        //Get LoggedInUserId
        Id currentUserId = userinfo.getUserId();
        //Level 1 Territory
        Set<Id> territoryIdslevel1 = new Set<Id>();
        //Level 2 Territory
        Set<Id> territoryIdslevel2 = new Set<Id>();
        //Level 3 Territory
        Set<Id> territoryIdslevel3 = new Set<Id>();
        //Level 4 Territory
        Set<Id> territoryIdslevel4 = new Set<Id>();
        
        //List to get lowest Territory Details
        List<Territory> getTerritory = new List<Territory>();
        //Get Level 1 Territory Id
        for(UserTerritory objUserTerr: [SELECT Id, TerritoryId FROM UserTerritory WHERE UserId =: currentUserId AND IsActive =: true])
        {
            territoryIdslevel1.add(objUserTerr.TerritoryId);
        }
        
        //Get Level 2 Territory Id
        for(Territory objTerritory: [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE ParentTerritoryId IN : territoryIdslevel1])
        {
            territoryIdslevel2.add(objTerritory.Id);
        }
        //Get Level 3 Territory Id
        for(Territory objTerritoryLowestLvl: [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE ParentTerritoryId IN : territoryIdslevel2])
        {
            territoryIdslevel3.add(objTerritoryLowestLvl.Id);
        }
        //Get Level 4 Territory Id
        for(Territory objTerritoryLowestLvl: [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE ParentTerritoryId IN : territoryIdslevel3])
        {
            territoryIdslevel4.add(objTerritoryLowestLvl.Id);
        }
        system.debug('------->territoryIdslevel1 '+territoryIdslevel1);
        system.debug('------->territoryIdslevel2 '+territoryIdslevel2);
        system.debug('------->territoryIdslevel3 '+territoryIdslevel3);
        system.debug('------->territoryIdslevel4 '+territoryIdslevel4);
        
        if(!territoryIdslevel4.isEmpty())
        {
            getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel4];
        }
        else
        {
            if(!territoryIdslevel3.isEmpty())
            {
                getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel3];
            }
            else
            {
                if(!territoryIdslevel2.isEmpty())
                {
                    getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel2];
                }
                else
                {
                    if(!territoryIdslevel1.isEmpty())
                    {
                        getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel1];
                    }
                }
            }
        }
        if(!getTerritory.isEmpty())
        { 
            getTerritory.sort();
        }
        return getTerritory;
    }
    
    
    //get user Teriitory
    
    //get loggedin User details
    @AuraEnabled
    public static User userDetails()
    {
        User userDtls = [SELECT name, email,Id,Primary_Territory_OneMDCS__c,Contact.Account.Name,Profile.Name  FROM User where Id =:UserInfo.getUserID()];
        return userDtls;
    }
    
    //fetch Email Settings for logged in user
    @AuraEnabled
    public static Map<String, Boolean>  getEmailSettings()
    {
        String emailSettings;
        Boolean newRequest = false;
        Boolean cancelledRequest = false;
        Boolean changetoCurrentCase = false;
        Boolean reassign = false;
        Boolean Unassigned = false;
        Boolean Created = false;
        Boolean Modified = false;
        
        List<String> splittedemailSettings;
        User userDtls= [SELECT Id, Email_Settings_OneMDCS__c  FROM User where Id =:UserInfo.getUserId()];
        if(userDtls.Email_Settings_OneMDCS__c != null && userDtls.Email_Settings_OneMDCS__c != '' )
        {   
            emailSettings = userDtls.Email_Settings_OneMDCS__c;
            
            splittedemailSettings = emailSettings.split(';');
            for(String objStr: splittedemailSettings)
            {
                if(objStr.equalsIgnoreCase('New Request'))
                {
                    newRequest = true;
                }
                else if(objStr.equalsIgnoreCase('Cancelled Request'))
                {
                    cancelledRequest = true;
                }
                else if(objStr.equalsIgnoreCase('Change to current case'))
                {
                    changetoCurrentCase = true;
                }
                else if(objStr.equalsIgnoreCase('Reassign'))
                {
                    reassign = true;
                }
                else if(objStr.equalsIgnoreCase('Unassigned'))
                {
                    Unassigned = true;
                }
                else if(objStr.equalsIgnoreCase('Created'))
                {
                    Created = true;
                }
                else if(objStr.equalsIgnoreCase('Modified'))
                {
                    Modified = true;
                }
                
            }
            
            
        }
        Map<String, Boolean> m1 = new Map<String, Boolean>();
        m1.put('New Request', newRequest);
        m1.put('Cancelled Request', cancelledRequest);
        m1.put('Change to current case', changetoCurrentCase);
        m1.put('Reassign', reassign);
        m1.put('Unassigned', Unassigned);
        m1.put('Created', Created);
        m1.put('Modified', Modified);
        return m1;
    }    
    
    //get territory wise data
    @AuraEnabled
    //get the Procedurelist from custom settings
    public static List<Available_Services_OneMDCS__c> getServiceListAdmin(String TerritoryId)
    {
        //get Territory Name
        List<Territory> TerritoryNameService = new List<Territory>();
        TerritoryNameService = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameService)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
            
        //List<Available_Services_OneMDCS__c>  listServices = Available_Services_OneMDCS__c.getAll().Values();
        List<Available_Services_OneMDCS__c>  listServices = [SELECT id, Name, Procedure_Name_One_MDCS__c, Service_Hours_OneMDCS__c, Territory_OneMDCS__c, Type_OneMDCS__c from Available_Services_OneMDCS__c 
                                                             where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Procedure'];
        System.debug('listServices  data in custom settings '+listServices);
        return listServices;
    }
    
    
    
    @AuraEnabled
    //get the Procedurelist from custom settings
    public static List<Available_Services_OneMDCS__c> getServiceList(String territoryUser, boolean adminScreen)
    {
        if(adminScreen)
        {
            
            List<Available_Services_OneMDCS__c>  listServices = [SELECT id, Name, Procedure_Name_One_MDCS__c, Service_Hours_OneMDCS__c, Territory_OneMDCS__c, Type_OneMDCS__c from Available_Services_OneMDCS__c 
                                                                 where Territory_OneMDCS__c =: territoryUser AND Type_OneMDCS__c = 'Procedure'];
            System.debug('listServices  data in custom settings '+listServices);
            return listServices;
        }
        else
        {
            List<User> GetLoggedInUserTerritory = new List<User>();
            GetLoggedInUserTerritory = [SELECT id, Primary_Territory_OneMDCS__c from User where id=: userinfo.getUserId()];
            //List<Available_Services_OneMDCS__c>  listServices = Available_Services_OneMDCS__c.getAll().Values();
            system.debug('GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c '+GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c);
            List<Available_Services_OneMDCS__c>  listServices = [SELECT id, Name, Procedure_Name_One_MDCS__c, Service_Hours_OneMDCS__c, Territory_OneMDCS__c, Type_OneMDCS__c from Available_Services_OneMDCS__c 
                                                                 where Territory_OneMDCS__c =: GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c AND Type_OneMDCS__c = 'Procedure'];
            System.debug('listServices  data in custom settings '+listServices);
            return listServices;
        }
    }
    
    
    //insert appointment record from UI details
    @AuraEnabled
    public static String createAppointment(String jsonString,String jsonStringbooking)
    {
        CustomerInfo CustomerInfodata =(CustomerInfo)JSON.deserialize(jsonString,CustomerInfo.class);
        BookingInfoWrapper bookingwrapperdata =(BookingInfoWrapper)JSON.deserialize(jsonStringbooking,BookingInfoWrapper.class);
        Appointment_OneMDCS__c appnew = new Appointment_OneMDCS__c();
        appnew.Name_Of_Physician_Encrypted_OneMDCS__c = CustomerInfodata.name;
        appnew.Email_OneMDCS__c = CustomerInfodata.Email;
        appnew.Location_Encrypted_OneMDCS__c = CustomerInfodata.location;
        appnew.Request_OneMDCS__c = CustomerInfodata.request;
        appnew.Physician_Type_OneMDCS__c = CustomerInfodata.PhysicianType;
        appnew.Location_Type_OneMDCS__c = CustomerInfodata.LocationType;
        appnew.Account_Information_OneMDCS__c = CustomerInfodata.AccountInformation;
		appnew.Reason_OneMDCS__c = CustomerInfodata.reason;
        if(CustomerInfodata.forCustomer != null && CustomerInfodata.forCustomer != '')
        {
            appnew.For_Customer_OneMdcs__c = CustomerInfodata.forCustomer;
        }
        //Geting Account Id to check Calendar Logic
        List<String> ListAccountId = new List<String>();
        String AccountId = null;
        if(CustomerInfodata.AccountInformation != null && CustomerInfodata.AccountInformation != '')
        {
            if(CustomerInfodata.AccountInformation.contains(':'))
            {
                ListAccountId = CustomerInfodata.AccountInformation.Split(':');
                
                AccountId = ListAccountId[1];
                
            }
            else
            {
                AccountId = CustomerInfodata.AccountInformation;
            }
        }
        if( AdmincalendarLogic_OneMDCS.getcalendarSettings( AccountId ) ){
            appnew.Status_OneMDCS__c = 'Unassigned';
        }else{
            appnew.Status_OneMDCS__c = 'High Competetion Zone';
        }
        //appnew.Status_OneMDCS__c = 'Unassigned';
        
        
        appnew.Appointment_Date_OneMDCS__c=Date.valueOf(CustomerInfodata.AssignedDate);
        
        system.debug('Date format--> '+CustomerInfodata.AssignedDate);
        
        /*appnew.Appointment_DateTime_OneMDCS__c = Datetime.valueOf(Date.valueOf(CustomerInfodata.AssignedDate));*/
        
        
        
        if(CustomerInfodata.additionalEmail != '' && CustomerInfodata.additionalEmail != null)
        {
            appnew.Additional_Email_OneMDCS__c=CustomerInfodata.additionalEmail;
        }
        if(CustomerInfodata.additionalEmailOther != '' && CustomerInfodata.additionalEmailOther != null)
        {
            appnew.Additional_Email_Other_OneMDCS__c=CustomerInfodata.additionalEmailOther;
        }
        if(CustomerInfodata.startslot.contains('AM'))
        {
            List<String> lststartslotswithAM = CustomerInfodata.startslot.split(' ');
            
            String[] lststartsHour = lststartslotswithAM[0].split( ':' ) ;
            /* if( Integer.valueOf( lststartsHour[0] ) < 10 ){
appnew.Appointment_Start_time_OneMDCS__c= '0' + lststartslotswithAM[0];
}else{

appnew.Appointment_Start_time_OneMDCS__c = lststartslotswithAM[0];
} */
            appnew.Appointment_Start_time_OneMDCS__c= lststartslotswithAM[0];
            system.debug('-*-*----*-> lststartslotswithAM[0] '+lststartslotswithAM[0]);
        }
        if(CustomerInfodata.startslot.contains('PM'))
        {
            List<String> lststartslotswithPM = CustomerInfodata.startslot.split(' ');
            List<String> lststattslots = new List<String>();
            if( lststartslotswithPM[0].contains( ':' ) ){
                lststattslots = lststartslotswithPM[0].split(':');
            }else{
                
                lststattslots.add( lststartslotswithPM[0] ) ;
                lststattslots.add( '00' ) ;
            }
            
            if(lststattslots[0] != '12')
            {
                String slotstartFinal = string.valueOf(Integer.valueOf(lststattslots[0]) + 12);
                
                if( null != lststattslots[1] ){
                    slotStartFinal = slotstartFinal + ':' + lststattslots[1];
                }else{
                    slotStartFinal = slotstartFinal + ':' + '00' ;
                }
                //slotStartFinal = slotstartFinal + ':' + lststattslots[1];
                appnew.Appointment_Start_time_OneMDCS__c= slotStartFinal;
                system.debug('-*-*----*-> slotStartFinal '+slotStartFinal);
            }
            else
            {
                appnew.Appointment_Start_time_OneMDCS__c= lststartslotswithPM[0];
                system.debug('-*-*----*-> slotStartFinal 12 '+lststartslotswithPM[0]);
            }
        }
        if(CustomerInfodata.endslot.contains('AM'))
        {
            String EndTimeForAM = null;
            List<String> lstendslotswithAM = CustomerInfodata.endslot.split(' ');
            List<String> lstendslotswithAMWithZero = lstendslotswithAM[0].split(':');
            if(Integer.ValueOf(lstendslotswithAMWithZero[0]) < 10)
            {
                //EndTimeForAM = '0' + lstendslotswithAMWithZero[0] + ':' + lstendslotswithAMWithZero[1];
                EndTimeForAM = lstendslotswithAMWithZero[0] + ':' + lstendslotswithAMWithZero[1];
            }
            else
            {
                if(Integer.ValueOf(lstendslotswithAMWithZero[0]) != 12)
                {
                    EndTimeForAM = lstendslotswithAM[0];
                }
                else if(Integer.ValueOf(lstendslotswithAMWithZero[0]) == 12)
                {
                    EndTimeForAM = '23:59';
                }
            }
            appnew.Appointment_end_time_OneMDCS__c=EndTimeForAM;
        }
        if(CustomerInfodata.endslot.Contains('PM'))
        {
            List<String> lstendslotswithPM = CustomerInfodata.endslot.split(' ');
            List<String> lstendslots = lstendslotswithPM[0].split(':');
            if(lstendslots[0] != '12')
            {
                String slotEndFinal = string.valueOf(Integer.valueOf(lstendslots[0]) + 12);
                slotEndFinal = slotEndFinal + ':' + lstendslots[1];
                appnew.Appointment_end_time_OneMDCS__c= slotEndFinal;
            }
            else
            {
                appnew.Appointment_end_time_OneMDCS__c= lstendslotswithPM[0];
            }
        }
        system.debug('------->>CustomerInfodata.startslot '+CustomerInfodata.startslot);
        
        appnew.Appointment_start_time_12hrs_OneMDCS__c=CustomerInfodata.startslot;
        
        String endTime = CustomerInfodata.endslot;
        List<String> getTimeWithoutAMPMList = new List<String>();
        List<String> getOnlyHourTimeList = new List<String>();
        getTimeWithoutAMPMList = endTime.split(' ');
        getOnlyHourTimeList = getTimeWithoutAMPMList[0].split(':');
        String EndtimeSlot = null;
        if(Integer.ValueOf(getOnlyHourTimeList[0]) < 10)
        {
            //EndtimeSlot = '0' + getOnlyHourTimeList[0] + ':' + getOnlyHourTimeList[1] + ' ' + getTimeWithoutAMPMList[1];
            EndtimeSlot = getOnlyHourTimeList[0] + ':' + getOnlyHourTimeList[1] + ' ' + getTimeWithoutAMPMList[1];
        }
        else
        {
            EndtimeSlot =CustomerInfodata.endslot;
        }
        system.debug('-------> ' +EndtimeSlot);
        
        appnew.Appointment_end_time_12_hrs_OneMDCS__c=EndtimeSlot;
        
        List<User> GetLoggedInUserTerritory = new List<User>();
        GetLoggedInUserTerritory = [SELECT id, Primary_Territory_OneMDCS__c from User where id=: userinfo.getUserId()];
        system.debug('-*-*----*->CustomerInfodata.territoryUser:'+CustomerInfodata.territoryUser);
        if(CustomerInfodata.territoryUser !=null && CustomerInfodata.territoryUser != '')
        {
            system.debug('-*-*----*->Inside if CustomerInfodata.territoryUser:'+CustomerInfodata.territoryUser);
            appnew.Territory_OneMDCS__c = CustomerInfodata.territoryUser;
        }  
        else
        {
            system.debug('-*-*----*->Inside else CustomerInfodata.territoryUser:'+CustomerInfodata.territoryUser);
            appnew.Territory_OneMDCS__c = GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c ;
        }
        
        
        appnew.Procedure_Name_Encrypted_OneMDCS__c= CustomerInfodata.serviceName;
        //+ ' ' + CustomerInfodata.serviceHours;
        appnew.Service_Hours_OneMDCS__c = CustomerInfodata.serviceHours ;
        
        try
        {
            system.debug('-*-*----*->Appointment Id:'+CustomerInfodata.appointmentId);
            if(CustomerInfodata.appointmentId != '' && CustomerInfodata.appointmentId != null)
            {
                system.debug('-*-*----*->Inside if Appointment Id:'+CustomerInfodata.appointmentId);
                if(CustomerInfodata.paramValue =='Modify')
                {
                    appnew.Change_Type_of_Request_OneMDCS__c= 'Modify';
                    system.debug('-*-*----*->CustomerInfodata.isTimeEdited'+CustomerInfodata.isTimeEdited);
                    if(CustomerInfodata.isTimeEdited)
                    {
                        system.debug('-*-*----*->Time is edited on modify');
                        appnew.Assigned_CAS_OneMDCS__c= NULL;
                    } 
                    system.debug('-*-*----*->Inside if paramValue'+CustomerInfodata.paramValue);
                    if(CustomerInfodata.HigherTimeSelected =='true')
                    {
                        system.debug('-*-*----*->Inside if HigherTimeSelected');
                        String assignedCASId=String.ValueOf(CustomerInfodata.assignedCASId);
                        system.debug('-*-*----*->Inside if assignedCASId:'+assignedCASId);
                        String myDate=String.ValueOf(CustomerInfodata.SelectedDateValue);
                        String[] myDateOnly = myDate.split('-');
                        //String[] strDate = myDateOnly[0].split('/');
                        Integer myIntDate = integer.valueOf(myDateOnly[2]);
                        Integer myIntMonth = integer.valueOf(myDateOnly[1]);
                        Integer myIntYear = integer.valueOf(myDateOnly[0]);
                        String myTime=String.ValueOf(CustomerInfodata.startTime24Hrs);
                        String[] myTimeOnly = myTime.split(':');
                        Integer myIntHour = integer.valueOf(myTimeOnly[0]);
                        Integer myIntMinute = integer.valueOf(myTimeOnly[1]);
                        datetime dateValue = datetime.newInstance(myIntYear, myIntMonth, myIntDate,myIntHour,myIntMinute,00);
                        List<Availability_Of_CAS_OneMDCS__c > li = new List<Availability_Of_CAS_OneMDCS__c>();
                        if(assignedCASId != '' && assignedCASId != null)
                        {
                            li = [Select Id,CAS_Team_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Id =: assignedCASId];
                            
                            String CASTeamId = String.ValueOf(li[0].CAS_Team_OneMDCS__c);
                            
                            system.debug('-*-*----*->Inside if CASTeamId:'+CASTeamId);
                            List<Event> ev = new List<Event>();
                            ev = [Select Id from Event where OwnerId =: CASTeamId and StartDateTime =: dateValue];
                            if(!ev.isEmpty())
                            {
                                delete ev;
                                system.debug('-*-*----*->Deleted event successfully:');
                            }
                        }
                    }
                    else
                    {
                        // serviceDuration
                        system.debug('-*-*----*->Inside if LowerTimeSelected');
                        String assignedCASId = String.ValueOf(CustomerInfodata.assignedCASId);
                        String serviceDuration = String.ValueOf(CustomerInfodata.serviceDuration);
                        system.debug('-*-*----*->Inside if assignedCASId:'+assignedCASId);
                        String myDate=String.ValueOf(CustomerInfodata.SelectedDateValue);
                        String[] myDateOnly = myDate.split('-');
                        //String[] strDate = myDateOnly[0].split('/');
                        Integer myIntDate = integer.valueOf(myDateOnly[2]);
                        Integer myIntMonth = integer.valueOf(myDateOnly[1]);
                        Integer myIntYear = integer.valueOf(myDateOnly[0]);
                        String myTime=String.ValueOf(CustomerInfodata.startTime24Hrs);
                        String[] myTimeOnly = myTime.split(':');
                        Integer myIntHour = integer.valueOf(myTimeOnly[0]);
                        Integer myIntMinute = integer.valueOf(myTimeOnly[1]);
                        datetime dateValue = datetime.newInstance(myIntYear, myIntMonth, myIntDate,myIntHour,myIntMinute,00);
                        List<Availability_Of_CAS_OneMDCS__c > li = new List<Availability_Of_CAS_OneMDCS__c>();
                        if(assignedCASId != '' && assignedCASId != null)
                        {
                            li = [Select Id,CAS_Team_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Id =: assignedCASId];
                            
                            String CASTeamId = String.ValueOf(li[0].CAS_Team_OneMDCS__c);
                            
                            system.debug('-*-*----*->Inside if CASTeamId:'+CASTeamId);
                            
                            List<Event> ev = new List<Event>();
                            ev = [Select Id from Event where OwnerId =: CASTeamId and StartDateTime =: dateValue];
                            if(!ev.isEmpty())
                            {
                                system.debug('------> ' +ev[0].Id + '******>> ' +serviceDuration);
                                ev[0].DurationInMinutes = Integer.ValueOf(serviceDuration);
                                update ev[0];
                                system.debug('-*-*----*->Updated event successfully:');
                            }
                        }
                        //appnew.Assigned_CAS_OneMDCS__c= NULL;
                    }
                }
                
                
                appnew.Id=CustomerInfodata.appointmentId;
                update appnew;
                return appnew.Id;
            }   
            
            else
            {
                
                insert appnew;
                return appnew.Id;
            }
        }
        catch(Exception ex)
        {
            return null;
        }
        return null;
    }
    
    /*
method for returning dates and slot and owner map 
*/  
    @AuraEnabled
    public static Map<string,List<String>> getSlot( String dateSelected , String requestHour , String customerTerritory , String AppoId, String SelectedAcc)
    {
        return Appointment_Process_OneMDCS_Helper.getSlotHelper( dateSelected,requestHour,customerTerritory,AppoId,SelectedAcc );
        
    }
    
    
    //wrapper from booking information
    public class BookingInfoWrapper
    {
        // String timeslot {get; set;}
        String serviceSelected {get; set;}
        
    }
    
    
    
    //wrapper from customer information
    
    public class CustomerInfo
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
        String PhysicianType {get; set;}
        String LocationType {get; set;}
        String AccountInformation {get; set;}
        String territoryUser;
        String forCustomer;
        Boolean isTimeEdited {get; set;}
		String reason{get; set;}        
        
    }
    
    
    
    //get the Apppintment list 
    @AuraEnabled
    public static List<Appointment_OneMDCS__c> getAppointmentList(String location, String account)
    {
	    String accQuery;
        accQuery = '%' + account;
        system.debug('*-----****---->>>location '+location);
        List<Appointment_OneMDCS__c> AppointmentLits = new List<Appointment_OneMDCS__c>();
        Date todayDate = Date.today();
        
        System.debug( ':::::::: todayDate inside getAppointmentList method::: ' + todayDate );
        
        List<User> GetLoggedInUserTerritory = new List<User>();
        GetLoggedInUserTerritory = [SELECT id, Primary_Territory_OneMDCS__c,Contact.Account.Name, Profile.name from User where id=: userinfo.getUserId()];
        system.debug('GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c '+  GetLoggedInUserTerritory[0].Contact.Account.Name );
        Set<Id> linkedId = new Set<Id>();
		String searchid = GetLoggedInUserTerritory[0].id;
		String appoquery = 'SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c, Appointment_Date_OneMDCS__c, Service_Hours_OneMDCS__c, Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c, Location_Encrypted_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c , Assigned_CAS_OneMDCS__r.Name, Account_Information_OneMDCS__c FROM Appointment_OneMDCS__c where Appointment_Date_OneMDCS__c >=: todayDate AND Status_OneMDCS__c != \'Rejected\' AND Status_OneMDCS__c != \'Cancelled\'';
		
        if(GetLoggedInUserTerritory[0].Profile.name == 'External User - Customer Case Scheduler')
        {
            if(account != null && account != '' && account != 'undefined'){
                
				appoquery = appoquery + ' AND Account_Information_OneMDCS__c  LIKE : accQuery';
			}
			
            for(Customer_Link_OneMDCS__c ca : [SELECT Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Territory__c =: location]){
				if(ca.Affiliations__c != null && ca.Affiliations__c != ''){
					if(ca.Affiliations__c.contains(searchid)){
						for(String uid : ca.Affiliations__c.split(';')){
							linkedId.add(uid);
						}
					}	
				}
			}
			
			if(linkedId.size() > 0){
				appoquery = appoquery + ' AND OwnerId IN: linkedId';
			}
			else{
				appoquery = appoquery + ' AND OwnerId =: searchid';
			}
            
			appoquery = appoquery + ' ORDER BY Appointment_Date_OneMDCS__c ASC , Appointment_Start_time_OneMDCS__c ASC';
			system.debug('appoquery-->'+appoquery);
			AppointmentLits = Database.query(appoquery);	
            system.debug('AppointmentLits-->'+AppointmentLits);
            return AppointmentLits;  
        }
        
        else
        {
            if(account != null && account != '' && account != 'undefined'){
                
                for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c,Appointment_Date_OneMDCS__c, Service_Hours_OneMDCS__c,
                                                    Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c, 
                                                    Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c,Location_Encrypted_OneMDCS__c, 
                                                    Name_Of_Physician_Encrypted_OneMDCS__c ,Assigned_CAS_OneMDCS__r.Name, Account_Information_OneMDCS__c
                                                    FROM Appointment_OneMDCS__c 
                                                    where Appointment_Date_OneMDCS__c >=: todayDate AND Territory_OneMDCS__c =: location
                                                    AND (Status_OneMDCS__c != 'Rejected' AND Status_OneMDCS__c != 'Cancelled') AND Account_Information_OneMDCS__c  LIKE :accQuery ORDER BY Appointment_Date_OneMDCS__c ASC , Appointment_Start_time_OneMDCS__c ASC] )
                {
                AppointmentLits.add(objApt);
                }
            }
            else{
                for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c,Appointment_Date_OneMDCS__c, Service_Hours_OneMDCS__c,
                                                    Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c, 
                                                    Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c,Location_Encrypted_OneMDCS__c, 
                                                    Name_Of_Physician_Encrypted_OneMDCS__c ,Assigned_CAS_OneMDCS__r.Name, Account_Information_OneMDCS__c
                                                    FROM Appointment_OneMDCS__c 
                                                    where Appointment_Date_OneMDCS__c >=: todayDate AND Territory_OneMDCS__c =: location
                                                    AND (Status_OneMDCS__c != 'Rejected' AND Status_OneMDCS__c != 'Cancelled')  ORDER BY Appointment_Date_OneMDCS__c ASC , Appointment_Start_time_OneMDCS__c ASC] )
                {
                    AppointmentLits.add(objApt);
                }
            }   
            return AppointmentLits;  
        }
        return AppointmentLits;
    }
    
    
    //get the Apppintment list 
    @AuraEnabled
    public static List<Appointment_OneMDCS__c> getAppointmentListonDay( String selectedDay, String customerTeritory )
    {
        System.debug('#### selectedDay ::::'+ selectedDay );
        
        Date selectedDate = Date.valueOf(selectedDay) ;
        List<Appointment_OneMDCS__c> AppointmentLits = new List<Appointment_OneMDCS__c>();
        //Date todayDate = Date.today();
        for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c,Appointment_Date_OneMDCS__c, 
                                            Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c,Location_Encrypted_OneMDCS__c, Assigned_CAS_Secondary_OneMDCS__r.Name, 
                                            Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c, Appointment_Start_time_OneMDCS__c ,
                                            Name_Of_Physician_Encrypted_OneMDCS__c ,Assigned_CAS_OneMDCS__r.Name, Email_OneMDCS__c,Appointment_end_time_12_hrs_OneMDCS__c,
                                            Request_OneMDCS__c,Header_Note_OneMDCS__c,Detailed_Note_OneMDCS__c
                                            FROM Appointment_OneMDCS__c 
                                            where Appointment_Date_OneMDCS__c =: selectedDate 
                                            AND Territory_OneMDCS__c =: customerTeritory
                                            AND (Status_OneMDCS__c != 'Rejected' AND Status_OneMDCS__c != 'Cancelled') ORDER BY Appointment_Start_time_OneMDCS__c   asc])
        {
            AppointmentLits.add(objApt);
        }
        return AppointmentLits;    
    }
    
    
    
    //get the appointment History data for past days
    @AuraEnabled
    public static List<Appointment_OneMDCS__c> getAppointmentHistoryList(String customerTeritoryold, boolean adminScreen, String account)
    {
	    String accQuery;
        accQuery = '%' + account;
        List<Appointment_OneMDCS__c> AppointmentListHistory = new List<Appointment_OneMDCS__c>();
        Date todayDate = Date.today();
        if(adminScreen)
        {
            if(account != null && account != '' && account != 'undefined'){
                
                for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Appointment_Date_OneMDCS__c, Assigned_CAS_OneMDCS__r.Owner.Name,Location_Encrypted_OneMDCS__c, 
                                                    Assigned_CAS_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Procedure_Name_Encrypted_OneMDCS__c,Service_Hours_OneMDCS__c,
                                                    Appointment_end_time_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c, Account_Information_OneMDCS__c  
                                                    FROM Appointment_OneMDCS__c where Appointment_Date_OneMDCS__c <: todayDate AND 
                                                    Territory_OneMDCS__c =: customerTeritoryold AND Account_Information_OneMDCS__c  Like :accQuery ORDER BY Appointment_Date_OneMDCS__c desc , Appointment_Start_time_OneMDCS__c ASC]){
                AppointmentListHistory.add(objApt);
                }               
            }
            else{
                for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Appointment_Date_OneMDCS__c, Assigned_CAS_OneMDCS__r.Owner.Name,Location_Encrypted_OneMDCS__c, 
                                                    Assigned_CAS_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Procedure_Name_Encrypted_OneMDCS__c,Service_Hours_OneMDCS__c,
                                                    Appointment_end_time_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c, Account_Information_OneMDCS__c  
                                                    FROM Appointment_OneMDCS__c where Appointment_Date_OneMDCS__c <: todayDate AND 
                                                    Territory_OneMDCS__c =: customerTeritoryold ORDER BY Appointment_Date_OneMDCS__c desc , Appointment_Start_time_OneMDCS__c ASC])
                {
                    AppointmentListHistory.add(objApt);
                }
            }
        }
        else
        {
            List<User> GetLoggedInUserTerritory = new List<User>();
            GetLoggedInUserTerritory = [SELECT id, Primary_Territory_OneMDCS__c from User where id=: userinfo.getUserId()];
            system.debug('GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c '+GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c);
			Set<Id> linkedId = new Set<Id>();
			String searchid = GetLoggedInUserTerritory[0].id;
			String PTerritory = GetLoggedInUserTerritory[0].Primary_Territory_OneMDCS__c;
			String appoquery = 'SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c, Appointment_Date_OneMDCS__c, Service_Hours_OneMDCS__c, Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c, Location_Encrypted_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c , Assigned_CAS_OneMDCS__r.Name, Account_Information_OneMDCS__c FROM Appointment_OneMDCS__c where Appointment_Date_OneMDCS__c <: todayDate AND Territory_OneMDCS__c =:PTerritory';
			
			if(account != null && account != '' && account != 'undefined'){
                
				appoquery = appoquery + ' AND Account_Information_OneMDCS__c  LIKE : accQuery';
			}
			
            for(Customer_Link_OneMDCS__c ca : [SELECT Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Territory__c =: customerTeritoryold]){
				if(ca.Affiliations__c != null && ca.Affiliations__c != ''){
					if(ca.Affiliations__c.contains(searchid)){
						for(String uid : ca.Affiliations__c.split(';')){
							linkedId.add(uid);
						}
					}	
				}
			}
			
			if(linkedId.size() > 0){
				appoquery = appoquery + ' AND OwnerId IN: linkedId';
			}
			else{
				appoquery = appoquery + ' AND OwnerId =: searchid';
			}
            
			appoquery = appoquery + ' ORDER BY Appointment_Date_OneMDCS__c ASC , Appointment_Start_time_OneMDCS__c ASC';
			system.debug('appoquery-->'+appoquery);
			AppointmentListHistory = Database.query(appoquery);	
            system.debug('AppointmentLits-->'+AppointmentListHistory);            
        }
        return AppointmentListHistory;    
    }
    
    //get the details  of particular appointment
    @AuraEnabled
    public static List<Appointment_OneMDCS__c>  getSelectedAppt(String appId)
    {
        
        List<Appointment_OneMDCS__c> SelApt = [ SELECT Appointment_Date_OneMDCS__c,Appointment_end_time_OneMDCS__c, Appointment_Start_time_OneMDCS__c,Email_OneMDCS__c,Additional_Email_OneMDCS__c,
                                               Location_Encrypted_OneMDCS__c,Location_Type_OneMDCS__c,Account_Information_OneMDCS__c,Name,Name_Of_Physician_Encrypted_OneMDCS__c,Physician_Type_OneMDCS__c,OwnerId,Request_OneMDCS__c,Procedure_Name_Encrypted_OneMDCS__c,Slots_OneMDCS__c,
                                               Territory_OneMDCS__c,Assigned_CAS_OneMDCS__c,Assigned_CAS_OneMDCS__r.Name, Appointment_end_time_12_hrs_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c ,
                                               Service_Hours_OneMDCS__c, For_Customer_OneMdcs__c, For_Customer_OneMdcs__r.Name, Assigned_CAS_Secondary_OneMDCS__r.Name, Assigned_CAS_Secondary_OneMDCS__r.Id,
                                               Assigned_CAS_OneMDCS__r.CAS_Team_OneMDCS__c,Header_Note_OneMDCS__c,Detailed_Note_OneMDCS__c,Reason_OneMDCS__c FROM Appointment_OneMDCS__c where id =: appId];
        return SelApt;    
    }
    
    
    //Cancel Case method
    @AuraEnabled
    public static void updateCancelCase(String AppId)
    {
        List<Appointment_OneMDCS__c> updateCancelCase = new List<Appointment_OneMDCS__c>();
        updateCancelCase = [SELECT id, Status_OneMDCS__c from Appointment_OneMDCS__c where id =: AppId];
        if(!updateCancelCase.isEmpty())
        {  
            updateCancelCase[0].Status_OneMDCS__c = 'Cancelled';
            updateCancelCase[0].Change_Type_of_Request_OneMDCS__c = 'Cancel';
            update updateCancelCase;
        }
    }
    
    //Get Territory wise admin details
    @AuraEnabled
    public static List<BWI_Scheduler_Contact__c>  getSelectedScheduleDetail(String appId)
    {
        // Find all the BWI_Scheduler_Contact__c in the custom setting
        Map<String, BWI_Scheduler_Contact__c> schedulerDetail = new Map<String, BWI_Scheduler_Contact__c>();
        schedulerDetail = BWI_Scheduler_Contact__c.getAll();
        List<BWI_Scheduler_Contact__c> lstAdminDetails = new List<BWI_Scheduler_Contact__c>();
        Appointment_OneMDCS__c objApp = new Appointment_OneMDCS__c();
        objApp = [SELECT id, Territory_OneMDCS__c from Appointment_OneMDCS__c where id=: appId];
        system.debug('*---*-*--> objApp '+objApp);
        system.debug('*---*-*--> schedulerDetail '+schedulerDetail);
        lstAdminDetails.add(schedulerDetail.get(objApp.Territory_OneMDCS__c));
        return lstAdminDetails;
    }
    
    //Send email on clicking email icon
    @AuraEnabled
    public static void sendEmailTo(String AppId, String EmailIds)
    {
        String[] toAddresses;
        List<String> additionalEmails = new List<String>();
        List<Appointment_OneMDCS__c> sendEmailApp = new List<Appointment_OneMDCS__c>();
        sendEmailApp = [SELECT id, Status_OneMDCS__c, Email_OneMDCS__c, Additional_Email_OneMDCS__c, Name, Appointment_Date_OneMDCS__c, Procedure_Name_Encrypted_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c from Appointment_OneMDCS__c where id =: AppId limit 1];
        String additionalEmail = Null;
        
        system.debug('-------->EmailIds '+EmailIds);
        if(EmailIds != null && EmailIds != '')
        {
            
            if(EmailIds.Contains(';'))
            {
                additionalEmails = EmailIds.split(';');
            }
            else
            {
                additionalEmails.add(EmailIds);
            }
            /*for(String objStr: additionalEmails)
{
if(additionalEmail == null)
{
additionalEmail = objStr + ',';
}
else
{
additionalEmail = additionalEmail + objStr + ',';
}
system.debug('------->additionalEmail  '+additionalEmail);
}
}
else
{
toAddresses = new String[] {EmailIds};
}
if(additionalEmail != null && additionalEmail != '')
{
additionalEmail = additionalEmail.removeend(',');
}*/
            
        }
        toAddresses = new String[]{};
            system.debug('------->additionalEmail  '+additionalEmail);
        if(!additionalEmails.isEmpty())
        {
            
            for(String strEmail: additionalEmails)
            {
                toAddresses.add(strEmail);
            }
            
        }            
        system.debug('-------->toAddresses '+toAddresses);
        Id loggedInUserId = UserInfo.getUserId();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
        //mail.setSenderDisplayName('Salesforce Case Scheduler');
        mail.setSubject('Appointment created successfully');
        mail.setHtmlBody('Hi <br/>' + 'Appointment has been created successfully.<br/>' + 'Appointment details are as follows. <br/>' 
                         + 'Case:' + sendEmailApp[0].Name + '<br/>Date:' + sendEmailApp[0].Appointment_Date_OneMDCS__c + '<br/>Procedure:' + sendEmailApp[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/>Time:' + sendEmailApp[0].Appointment_start_time_12hrs_OneMDCS__c + '<br/>Physician:' + sendEmailApp[0].Name_Of_Physician_Encrypted_OneMDCS__c
                         + '<br/>Regards,' + '<br/>BWI Admin');
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    //::::: Added in Sprint 2
    @AuraEnabled
    public static String getDetailsOfRemainingProcedures( String selectedDay, String customerTeritory ){
        return searchCASAvailability_OneMDCS.getAvailabilityDetails( selectedDay , customerTeritory ) ;
        
    }
    //::::: Added in Sprint 2
    @AuraEnabled
    public static void updateCASAvailability( String appointmentIDJSON , String Secondary  )
    {
        if(Secondary == 'primary')
        {
            AssigningCAStoAppointmentHelper_OneMDCS.updateSelectedAppo( appointmentIDJSON ) ;
        }
        if(Secondary == 'trainee')
        {
            AssigningCAStoAppointmentHelper_OneMDCS.updateSelectedAppoForSecondary( appointmentIDJSON ) ;
        }
        if(Secondary == 'unassigncas')
        {
            AssigningCAStoAppointmentHelper_OneMDCS.updatecas( appointmentIDJSON ) ;
        }
        if(Secondary == 'unassignseccas')
        {
            AssigningCAStoAppointmentHelper_OneMDCS.updateseccas( appointmentIDJSON ) ;
        }
    }
    
    //::::: Added in Sprint 2
    @AuraEnabled
    public static List<Availability_Of_CAS_OneMDCS__c> getCASAvailability( String customerTerritory , String appointmentIDJSON , String unassignedappoId  )
    {
        
        return AssigningCAStoAppointmentHelper_OneMDCS.getAvailableCAS( customerTerritory , appointmentIDJSON, unassignedappoId ) ;
        
    }
    
    
    
    //::: Added in Sprint 2
    @AuraEnabled
    public static void insertAllCASListonSave( String CASAgentUpdatedrecord , String selecteddate , String customerTerritory ) {
        DailyCASAvailabilityHelper_OneMDCS dailyCASobj = new DailyCASAvailabilityHelper_OneMDCS() ;
        dailyCASobj.saveNewCASAgentRecord( CASAgentUpdatedrecord , selecteddate , customerTerritory ) ;
        
        
    }
    
    //::: Added in Sprint 2
    @AuraEnabled
    public static List<Availability_Of_CAS_OneMDCS__c> getAllCASListonLoad( String customerTerritory , String selecteddate) {
        DailyCASAvailabilityHelper_OneMDCS dailyCASobj = new DailyCASAvailabilityHelper_OneMDCS() ;
        return dailyCASobj.getAllCASList( customerTerritory , selecteddate ) ;
        
        
    }
    
    //::: Added in Sprint 2
    @AuraEnabled
    public static String getBookedAppointment( String customerTerritory ) {
        
        
        appointmentProcess_Admin_Helper_OneMDCS sc = new appointmentProcess_Admin_Helper_OneMDCS();
        
        return sc.getBookedDateString( customerTerritory ) ;
    }
    
    //::: Added in Sprint 2
    /*
public class weekClaendarunBlockWrapper{
public String startString    {get;set;}
public String endString    {get;set;}

public weekClaendarunBlockWrapper( String startString, String endString ){
this.startString = startString ;
this.endString = endString ;
}

}
*/
    @AuraEnabled
    public static List<TimeRecordWrapper> getAllSlots(String TerritoryId)
    {
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        
        String UpdatedTerritoryName = '';
    
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
        
        List<String> timeSlots = new List<String>();
        List<TimeRecordWrapper> timeSlotWrapperList = new List<TimeRecordWrapper>();
        integer i = 4;
        integer j;
        for(i=4;i<=20;i++)
        {
            if(i<10)
            {
                timeSlots.add('0' + String.valueOf(i) + ':00' + ' ' + 'AM');
                timeSlots.add('0' + String.valueOf(i) + ':30' + ' ' + 'AM');
            }
            else if(i>9 && i<12)
            {
                timeSlots.add(String.valueOf(i) + ':00' + ' ' + 'AM');
                timeSlots.add(String.valueOf(i) + ':30' + ' ' + 'AM');
            }
            if(i>=12)
            {
                if(i>12)
                {
                    j = i-12;
                    system.debug('-------->j '+j);
                }
                else
                {
                    j=i;
                }
                if(j == 12)
                {
                    timeSlots.add(String.valueOf(j) + ':00' + ' ' + 'PM');
                    timeSlots.add(String.valueOf(j) + ':30' + ' ' + 'PM');
                }
                else
                {
                    timeSlots.add('0' + String.valueOf(j) + ':00' + ' ' + 'PM');
                    timeSlots.add('0' + String.valueOf(j) + ':30' + ' ' + 'PM');
                }
            }
        }
        timeSlots.remove(timeSlots.size()-1);
        //Get Previous selected slots
        List<String> selectedChangedSlots = new List<String>();
        List<Available_Services_OneMDCS__c> getSelectedChangedSlots = new List<Available_Services_OneMDCS__c>();
        getSelectedChangedSlots = [SELECT Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c,Territory_OneMDCS__c, Type_OneMDCS__c from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Slot Settings'];
        
        if(!getSelectedChangedSlots.isEmpty()) 
        {
            String allSlotsAMPM = getSelectedChangedSlots[0].Selected_Time_Slots_AM_OneMDCS__c + ';' +getSelectedChangedSlots[0].Selected_Time_Slots_PM_OneMDCS__c;
            selectedChangedSlots = allSlotsAMPM.split(';');
        }
        Set<String> setOfSelectedSlots = new Set<String>();
        setOfSelectedSlots.addAll(selectedChangedSlots);
        
        for(String objString: timeSlots)
        {
            TimeRecordWrapper objTime = new  TimeRecordWrapper();
            if(setOfSelectedSlots.contains(objString))
            {
                objTime.isSelected = true;
            }
            else
            {
                objTime.isSelected = false;
            }
            objTime.timeslot = objString;
            timeSlotWrapperList.add(objTime);
        }
        return timeSlotWrapperList;
    }
    
    public class TimeRecordWrapper
    {
        
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public string timeslot;
        
        public TimeRecordWrapper()
        {
            isSelected = false;
            timeslot = '';
        }
    }
    
    
    //GET CAS LIST
    @AuraEnabled
    public static List<CASRecordWrapper> getCASwraplist(String TerritoryId){
        Set<Id> userIds = new Set<Id>();
        List<CASRecordWrapper> CASWrapperList = new List<CASRecordWrapper>();
        List<User> territoryCAS = new List<User>();
        List<Id> TerritoryIdList = new List<Id>();
        List<String> territories = new List<String>();
        List<Territory> TerritoryNameSelected = new List<Territory>();
        
        String Profiledetails = Label.CASSelectionProfile;      
        List<String> Profilelist = Profiledetails.split(';') ;      
        for(Integer i=0; i<Profilelist.size(); i++){        
            Profilelist[i] = Profilelist[i].trim();     
        }
        
        TerritoryNameSelected = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
    
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);         
        }
        
        for(Territory tr : TerritoryNameSelected)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
                TerritoryIdList.add(tr.Id);
            }
        }
                
        for(Combine_Territory__c ter : allterritories.values()){
            if(ter.Name == UpdatedTerritoryName){
                territories = ter.Territory__c.split(';') ;
            }
        }
        
        if(!territories.isEmpty()){
            for(Integer i=0; i<territories.size(); i++){
                territories[i] = territories[i].trim();
                system.debug(territories[i]);
            }
            
            for(Territory terr : [Select Id from Territory where name IN: territories]){
                TerritoryIdList.add(terr.Id);
            }
        }
        
        for(UserTerritory objUserTerr: [SELECT Id, UserId,TerritoryId FROM UserTerritory WHERE  TerritoryId IN: TerritoryIdList  AND IsActive =: true])
        {
            
            userIds.add(objUserTerr.UserId);
        }
        
        system.debug('--------> User ID '+userIds);
        for(User objUser: [Select id, Name from User where id IN: userIds AND Primary_Territory_OneMDCS__c !=: UpdatedTerritoryName AND isActive = true AND Profile.Name IN: Profilelist ORDER BY Name])
        {
            territoryCAS.add(objUser);
        }
        territoryCAS.sort();
        if(!territoryCAS.isEmpty())
        {            
            for(User objUser : territoryCAS)
            {
                CASRecordWrapper objWrapper = new CASRecordWrapper();
                objWrapper.isSelected = false;
                objWrapper.CASName = objUser.Name;
                objWrapper.CASId = objUser.Id;
                
                CASWrapperList.add(objWrapper);
            }
        }
        return CASWrapperList;
    }
    //Wrapper Class for CAS selection
    public class CASRecordWrapper
    {
        
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public string CASName;
        @AuraEnabled public string CASId;
        
        public CASRecordWrapper()
        {
            isSelected = false;
            CASName = '';
            CASId = '';
        }
    }
    
    //Get Selected Territory's Primary CASAgentUpdatedrecord for Remaining list 
    @AuraEnabled
    public static List<CASRecordWrapper> getCASPrimarylist(String TerritoryId)
    {
        List<CASRecordWrapper> CASWrapperList = new List<CASRecordWrapper>();
        Set<Id> userIds = new Set<Id>();
        List<User> territoryCAS = new List<User>();
        List<Territory> TerritoryNameSelected = new List<Territory>();
        TerritoryNameSelected = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        String Profiledetails = Label.CASSelectionProfile;      
        List<String> Profilelist = Profiledetails.split(';') ;      
        for(Integer i=0; i<Profilelist.size(); i++){        
            Profilelist[i] = Profilelist[i].trim();     
        }
                
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameSelected)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   
        for(User objUser: [Select id, Name from User where Primary_Territory_OneMDCS__c =: UpdatedTerritoryName AND isActive = true AND Profile.Name IN: Profilelist ORDER BY Name])
        {
            territoryCAS.add(objUser);
        }
        territoryCAS.sort();
        if(!territoryCAS.isEmpty())
        {            
            for(User objUser : territoryCAS)
            {
                CASRecordWrapper objWrapper = new CASRecordWrapper();
                objWrapper.isSelected = false;
                objWrapper.CASName = objUser.Name;
                objWrapper.CASId = objUser.Id;
                
                CASWrapperList.add(objWrapper);
            }
        }
        return CASWrapperList;
    }
    
    //implemented for checkbox requirement to fetch accounts for the left box
    @AuraEnabled
    
    public static List<AccountRecordWrapper> getleftAccountList(String TerritoryId)
    {
        List<Territory> TerritoryNameSelected = new List<Territory>();
        TerritoryNameSelected = [SELECT Id,Name,ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        Id ParentTerId;
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameSelected)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
                ParentTerId = tr.Id;
            }
            else{
                UpdatedTerritoryName = tr.Name;
                ParentTerId = tr.ParentTerritoryId;
            }
        }   
        String JDE_JJHCS_Number = '';
        Set<String> territories = new Set<String>();
        List<AccountRecordWrapper> AccountWrapperList = new List<AccountRecordWrapper>();
        for(Territory childTerritory: [SELECT Id, Name, External_Territory_Id__c FROM Territory WHERE ParentTerritoryId =: ParentTerId ])
        {
            territories.add(childTerritory.External_Territory_Id__c);
        }
        
        List<Account> getAccountDtls = new List<Account>();
        getAccountDtls =  [Select id, Name, JDE_JJHCS_Number__c from Account where Territory__c IN: territories AND Primary_Territory__c !=:UpdatedTerritoryName ORDER BY Name];
        system.debug('getAccountDtls---> '+getAccountDtls);
        if(!getAccountDtls.isEmpty())
        {
            
            for(Account objAcc : getAccountDtls)
            {
                AccountRecordWrapper objWrapper = new AccountRecordWrapper();
                objWrapper.isSelected = false;
                if(objAcc.JDE_JJHCS_Number__c == null){
                    JDE_JJHCS_Number = 'undefined';
                }
                else{
                    JDE_JJHCS_Number = objAcc.JDE_JJHCS_Number__c;
                }
                objWrapper.AccountName = objAcc.Name + ' - ' + JDE_JJHCS_Number;
                objWrapper.AccountId = objAcc.Id;
                
                AccountWrapperList.add(objWrapper);
            }
        }
        
        
        return AccountWrapperList;
    }
    
    public class AccountRightRecordWrapper
    {
        
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public string AccountName;
        @AuraEnabled public string AccountId;
        @AuraEnabled public boolean isoutsideterritory;
        
        public AccountRightRecordWrapper()
        {
            isSelected = false;
            AccountName = '';
            AccountId = '';
            isoutsideterritory = false;
        }
    }
    
    //implemented for checkbox requirement to fetch accounts for the Right box
    @AuraEnabled
    
    public static List<AccountRightRecordWrapper> getRightAccountList(String TerritoryId)
    {
        
        
        List<Territory> TerritoryNameSelected = new List<Territory>();
        TerritoryNameSelected = [SELECT Id,Name,ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        Id ParentTerId;
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameSelected)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
                ParentTerId = tr.Id;
            }
            else{
                UpdatedTerritoryName = tr.Name;
                ParentTerId = tr.ParentTerritoryId;
            }
        }   
        Set<String> territories = new Set<String>();
        List<AccountRightRecordWrapper> AccountWrapperList = new List<AccountRightRecordWrapper>();
        String JDE_JJHCS_Number = '';
        for(Territory childTerritory: [SELECT Id, Name, External_Territory_Id__c FROM Territory WHERE ParentTerritoryId =: ParentTerId ])
        {
            territories.add(childTerritory.External_Territory_Id__c);
        }
        
        //for(Account acc: [Select id, Name from Account where Territory__c =: TerritoryNameSelected[0].External_Territory_Id__c AND Primary_Territory__c =:TerritoryNameSelected[0].Name] )
        List<Account> getAccountDtls = new List<Account>();
        List<Account> getRightAccountDtls = new List<Account>();
        getAccountDtls = [Select id, Name, JDE_JJHCS_Number__c from Account where Territory__c IN: territories AND Primary_Territory__c =:UpdatedTerritoryName AND Primary_Territory__c !='' ORDER BY Name] ;
        
        if(!getAccountDtls.isEmpty())
        {
            for(Account objAcc : getAccountDtls)
            {
                AccountRightRecordWrapper objWrapper = new AccountRightRecordWrapper();
                objWrapper.isSelected = false;
                if(objAcc.JDE_JJHCS_Number__c == null){
                    JDE_JJHCS_Number = 'undefined';
                }
                else{
                    JDE_JJHCS_Number = objAcc.JDE_JJHCS_Number__c;
                }
                objWrapper.AccountName = objAcc.Name + ' - ' + JDE_JJHCS_Number;
                objWrapper.AccountId = objAcc.Id;
                objWrapper.isoutsideterritory = false;
                
                AccountWrapperList.add(objWrapper);
            }
        }
        
        getRightAccountDtls = [Select id, Name, JDE_JJHCS_Number__c from Account where Territory__c NOT IN: territories AND Primary_Territory__c =:UpdatedTerritoryName AND Primary_Territory__c !='' ] ;
        
        if(!getRightAccountDtls.isEmpty())
        {
            for(Account objAcc : getRightAccountDtls)
            {
                AccountRightRecordWrapper objWrapper = new AccountRightRecordWrapper();
                objWrapper.isSelected = false;
                if(objAcc.JDE_JJHCS_Number__c == null){
                    JDE_JJHCS_Number = 'undefined';
                }
                else{
                    JDE_JJHCS_Number = objAcc.JDE_JJHCS_Number__c;
                }
                objWrapper.AccountName = objAcc.Name + ' - ' + JDE_JJHCS_Number;
                objWrapper.AccountId = objAcc.Id;
                objWrapper.isoutsideterritory = true;
                
                AccountWrapperList.add(objWrapper);
            }
        }
        
        return AccountWrapperList;
    }

    
    @AuraEnabled
    public static void saveCAS(String TerritoryName, String SelectedCAS, String RemoveCAS)
    {
        //get Territory Name
        List<Territory> TerritoryNameCAS = new List<Territory>();
        TerritoryNameCAS = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];
        
        String UpdatedTerritoryName = '';        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        List<Id> listedusercolormap = new List<Id>();       
        List<String> usedcolors = new List<String>();
        List<Id> existuserlist = new List<Id>();
                
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        
        for(Territory tr : TerritoryNameCAS)
        {
           if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);               
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   
        
        for (User u : [Select Id, Color__c from User where Primary_Territory_OneMDCS__c =:UpdatedTerritoryName and Color__c != null AND IsActive =: true]){
            usedcolors.add(u.Color__c);
            existuserlist.add(u.Id);
        }
        
        List<String> listToUpdateUserTerritory = new List<String>();
        List<String> listToRemoveUserTerritory = new List<String>();
        
        system.debug('SelectedCas ' +SelectedCAS);
        system.debug('RemoveCAS ' +RemoveCAS);
        
        if(SelectedCAS != null && SelectedCAS != '' && SelectedCAS.contains(';'))
        {
            listToUpdateUserTerritory = SelectedCAS.split(';');
        }
        else if(SelectedCAS != null && SelectedCAS != '')
        {
            listToUpdateUserTerritory.add(SelectedCAS);
        }
        
        if(RemoveCAS != null && RemoveCAS != '' && RemoveCAS.contains(';'))
        {
            listToRemoveUserTerritory = RemoveCAS.split(';');
        }
        else if(RemoveCAS != null && RemoveCAS != '')
        {
            listToRemoveUserTerritory.add(RemoveCAS);
        }
        Set<String> ToUpdateUserTerritory = new Set<String>();
        Set<String> ToRemoveUserTerritory = new Set<String>();
        
        ToUpdateUserTerritory.addAll(listToUpdateUserTerritory);
        
        ToRemoveUserTerritory.addAll(listToRemoveUserTerritory);
        
        List<User> updateUser = new List<User>();
        
        //Update user Territory
        for(User objUsr:[SELECT id, Primary_Territory_OneMDCS__c, Color__c from user where Id IN: ToUpdateUserTerritory AND IsActive =: true])
        {           
            if (Schema.sObjectType.user.fields.Primary_Territory_OneMDCS__c.isUpdateable())
            {
                objUsr.Primary_Territory_OneMDCS__c = UpdatedTerritoryName;                             
            }
            
            if(objUsr.Color__c != null){
                if(!existuserlist.contains(objUsr.Id)){
                    if(usedcolors.contains(objUsr.Color__c)){
                        objUsr.Color__c = '';
                        listedusercolormap.add(objUsr.Id);
                    }   
                }   
            }   
            
            updateUser.add(objUsr);
        }
        if(!updateUser.isEmpty())
        { 
            update updateUser;
        }
        colorremovalalert(listedusercolormap);
        //Remove user Territory
        updateUser = new List<User>();
        for(User objUsr:[SELECT id, Primary_Territory_OneMDCS__c,Color__c from user where Id IN: ToRemoveUserTerritory and Primary_Territory_OneMDCS__c =: UpdatedTerritoryName AND IsActive =: true])
        {
            if (Schema.sObjectType.user.fields.Primary_Territory_OneMDCS__c.isUpdateable())
            {
                objUsr.Primary_Territory_OneMDCS__c = '';
                
            }
             if (Schema.sObjectType.user.fields.Color__c.isUpdateable())
            {
                objUsr.Color__c = '';
            }    
            updateUser.add(objUsr);
        }
        if(!updateUser.isEmpty())
        { 
            update updateUser;
        }
        
        Map<String, Availability_Of_CAS_OneMDCS__c> defaultDataForCAS = new Map<String, Availability_Of_CAS_OneMDCS__c>();
        
        List<Availability_Of_CAS_OneMDCS__c> checkForDefaultData = new List<Availability_Of_CAS_OneMDCS__c>();
        List<Availability_Of_CAS_OneMDCS__c> updataCASData = new List<Availability_Of_CAS_OneMDCS__c>();
        
        List<Availability_Of_CAS_OneMDCS__c> DeleteDefaultData = new List<Availability_Of_CAS_OneMDCS__c>();
        
        Availability_Of_CAS_OneMDCS__c inserDefault;
        Availability_Of_CAS_OneMDCS__c updateDefault;
        
        for(Availability_Of_CAS_OneMDCS__c objAvlCas: [SELECT id, Afternoon_Slot_OneMDCS__c, AM_OneMDCS__c, Availability_CAS_OneMDCS__c, 
                                                       CAS_Team_OneMDCS__c, Default_OneMDCS__c, Morning_Slot_OneMDCS__c, PM_OneMDCS__c, 
                                                       Territory_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where 
                                                       CAS_Team_OneMDCS__c IN: ToUpdateUserTerritory AND Default_OneMDCS__c = 'Y'])
        {
            if(objAvlCas != null)
            {
                defaultDataForCAS.put(String.valueOf(objAvlCas.CAS_Team_OneMDCS__c),objAvlCas);
            }
        }
        
        Map<String, String> userIdVsName = new Map<String, String>();
        system.debug('-------------> ToUpdateUserTerritory '+ToUpdateUserTerritory);
        
        for(User objUser : [SELECT id, Name from User where Id IN: ToUpdateUserTerritory AND isActive = true])
        {
            userIdVsName.put(String.valueOf(objUser.Id), ObjUser.Name);
        }
        
        for(String objString: ToUpdateUserTerritory)
        {
            if(!defaultDataForCAS.containsKey(objString))
            {
                inserDefault = new Availability_Of_CAS_OneMDCS__c();
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Name.isCreateable())
                {
                    inserDefault.Name = userIdVsName.get(objString);
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Afternoon_Slot_OneMDCS__c.isCreateable())
                {
                    inserDefault.Afternoon_Slot_OneMDCS__c = '13:00;17:00';
                    
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.AM_OneMDCS__c.isCreateable())
                {
                    inserDefault.AM_OneMDCS__c = True;
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Availability_CAS_OneMDCS__c.isCreateable())
                {
                    inserDefault.Availability_CAS_OneMDCS__c = True;
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.CAS_Team_OneMDCS__c.isCreateable())
                {
                    inserDefault.CAS_Team_OneMDCS__c = Id.valueOf(objString);
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Default_OneMDCS__c.isCreateable())
                {
                    inserDefault.Default_OneMDCS__c = 'Y';
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Morning_Slot_OneMDCS__c.isCreateable())
                {
                    inserDefault.Morning_Slot_OneMDCS__c = '08:00;12:00';
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.PM_OneMDCS__c.isCreateable())
                {
                    inserDefault.PM_OneMDCS__c = True;
                }
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
                {
                    inserDefault.Territory_OneMDCS__c = UpdatedTerritoryName;
                }
                
                checkForDefaultData.add(inserDefault);
            }
            else
            {
                updateDefault = new Availability_Of_CAS_OneMDCS__c();
                updateDefault = defaultDataForCAS.get(objString);
                if (Schema.sObjectType.Availability_Of_CAS_OneMDCS__c.fields.Territory_OneMDCS__c.isUpdateable())
                {
                    updateDefault.Territory_OneMDCS__c = UpdatedTerritoryName;
                }
                updataCASData.add(updateDefault);
            }
        }
        if(!checkForDefaultData.isEmpty())
        { 
            insert checkForDefaultData;
        }
        if(!updataCASData.isEmpty())
        { 
            update updataCASData;
        }
        
        for(Availability_Of_CAS_OneMDCS__c objAvlCas: [SELECT id, Afternoon_Slot_OneMDCS__c, AM_OneMDCS__c, Availability_CAS_OneMDCS__c, 
                                                       CAS_Team_OneMDCS__c, Default_OneMDCS__c, Morning_Slot_OneMDCS__c, PM_OneMDCS__c, 
                                                       Territory_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where 
                                                       CAS_Team_OneMDCS__c IN: ToRemoveUserTerritory 
													   and Territory_OneMDCS__c =: UpdatedTerritoryName/*AND Default_OneMDCS__c = 'Y'*/])
        {
            DeleteDefaultData.add(objAvlCas);
        }
        if(!DeleteDefaultData.isEmpty())
        {
            if (Availability_Of_CAS_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
            {
                Delete DeleteDefaultData;
            }
        }
		//Delete CAS Availability if any present in Other Territory
        List<Availability_Of_CAS_OneMDCS__c> DeleteAvlCASOtherTerritory = new List<Availability_Of_CAS_OneMDCS__c>();
        
		for(Availability_Of_CAS_OneMDCS__c AvlCasOtherTerritory: [SELECT id, Afternoon_Slot_OneMDCS__c, AM_OneMDCS__c, Availability_CAS_OneMDCS__c, 
                                                       CAS_Team_OneMDCS__c, Default_OneMDCS__c, Morning_Slot_OneMDCS__c, PM_OneMDCS__c, 
                                                       Territory_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Territory_OneMDCS__c !=: UpdatedTerritoryName AND
                                                       CAS_Team_OneMDCS__c IN: ToUpdateUserTerritory AND Default_OneMDCS__c =: 'N'])
		{
			if(AvlCasOtherTerritory != null){
				DeleteAvlCASOtherTerritory.add(AvlCasOtherTerritory);
			}			
		}
		
		if(!DeleteAvlCASOtherTerritory.isEmpty()){
			if (Availability_Of_CAS_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
            {
                Delete DeleteAvlCASOtherTerritory;
            }
		}
        
    }
    
    @AuraEnabled
    public static void colorremovalalert(List<Id> listedusercolormap)
    {
        List<Messaging.SingleEmailMessage>  Emaillist = new List<Messaging.SingleEmailMessage>();       
        
        for(User useremaillist : [Select FirstName, Id from User where Id IN: listedusercolormap  AND IsActive =: true]){            
            Messaging.SingleEmailMessage oneEmail = new Messaging.SingleEmailMessage();
            oneEmail.setTargetObjectId(useremaillist.Id);
            //oneEmail.setSenderDisplayName('BWI Case Scheduler');
            oneEmail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            oneEmail.setSubject('Please Choose your color preference.');
            oneEmail.setHtmlBody('Hi '+ useremaillist.FirstName +',<br/><br/>The color you have choosen previously, it is already used by a user present in the current territory. Please choose your prefered color.<br/><br/>Regards,<br/>BWI Admin');
            oneEmail.setSaveAsActivity(false);
            Emaillist.add(oneEmail);
        }
        if(!Emaillist.isEmpty()){
            Messaging.sendEmail(Emaillist);
        }
    }   
    
    @AuraEnabled
    public static void saveAccountInfo(String TerritoryName, String SelectedCAS, String RemoveCAS)
    {
        // system.debug('SelectedCas ' +SelectedCAS);
        //get Territory Name
        List<Territory> territoryNameList = new List<Territory>();
        territoryNameList = [SELECT Id, Name FROM Territory WHERE Id =: TerritoryName limit 1];
        
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : territoryNameList)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   
    
    
        
        List<String> listToUpdateUserTerritory = new List<String>();
        List<String> listToRemoveUserTerritory = new List<String>();
        
        system.debug('SelectedCas ' +SelectedCAS);
        system.debug('RemoveCAS ' +RemoveCAS);
        
        if(SelectedCAS != null && SelectedCAS != '' && SelectedCAS.contains(';'))
        {
            listToUpdateUserTerritory = SelectedCAS.split(';');
        }
        else if(SelectedCAS != null && SelectedCAS != '')
        {
            listToUpdateUserTerritory.add(SelectedCAS);
        }
        
        if(RemoveCAS != null && RemoveCAS != '' && RemoveCAS.contains(';'))
        {
            listToRemoveUserTerritory = RemoveCAS.split(';');
        }
        else if(RemoveCAS != null && RemoveCAS != '')
        {
            listToRemoveUserTerritory.add(RemoveCAS);
        }
        Set<String> ToUpdateUserTerritory = new Set<String>();
        Set<String> ToRemoveUserTerritory = new Set<String>();
        
        ToUpdateUserTerritory.addAll(listToUpdateUserTerritory);
        
        ToRemoveUserTerritory.addAll(listToRemoveUserTerritory);
        
        List<Account> updateAccount = new List<Account>();
        
        //Update user Territory
        for(Account acc:[SELECT id, Primary_Territory__c from Account where Id IN: ToUpdateUserTerritory])
        {
            if (Schema.sObjectType.Account.fields.Primary_Territory__c.isUpdateable())
            {
                acc.Primary_Territory__c = UpdatedTerritoryName;
            }
            updateAccount.add(acc);
        }
        if(!updateAccount.isEmpty())
        { 
            update updateAccount;
        }
        //Remove user Territory
        updateAccount = new List<Account>();
        for(Account acc:[SELECT id, Primary_Territory__c from Account where Id IN: ToRemoveUserTerritory])
        {
            if (Schema.sObjectType.Account.fields.Primary_Territory__c.isUpdateable())
            {
                acc.Primary_Territory__c = '';
            }
            updateAccount.add(acc);
        }
        if(!updateAccount.isEmpty())
        {
            update updateAccount;
        }
        //return TerritoryName;
        
    }
    
    
    @AuraEnabled
    public static void saveProcedureSettings(String territoryName,String UpdateProcedure)
    {
        //get Territory Name
        /*List<Territory> TerritoryNameProcedure = new List<Territory>();
TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];*/
        if(!string.isBlank(UpdateProcedure))
        {
            List<Available_Services_OneMDCS__c> lstPositionRecords = 
                (List<Available_Services_OneMDCS__c>)
                System.JSON.deserialize(UpdateProcedure,List<Available_Services_OneMDCS__c>.class);
            //system.debug('Debug for Dsiplaying all the records : lstPositionRecords'+lstPositionRecords);    
            
            //Perform Operation with records 
            for(Available_Services_OneMDCS__c objPositionRecords:lstPositionRecords)
            {
                system.debug('Selected Record :'+objPositionRecords.Service_Hours_OneMDCS__c);
            }
            if(!lstPositionRecords.isEmpty())
            { 
                Upsert lstPositionRecords;
            }
        }
    }
    
    
    public static String getRandomNumber(Integer size)
    {
        Double randomNum = math.random() * size;
        String random = String.valueOf(randomNum);
        random = random.subString(0,6);
        return random;
    }
    
    @AuraEnabled
    public static void saveCalendarSameday(String territoryName,Boolean Sameday,  String samedayTime)
    {   //get Territory Name
        List<Territory> TerritoryNameSameDay = new List<Territory>();
        TerritoryNameSameDay = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];
        
        String UpdatedTerritoryName = '';
    
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameSameDay)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   

        //Sameday Logic
        List<Available_Services_OneMDCS__c> objServiceCalLogic = new List<Available_Services_OneMDCS__c>();
        Available_Services_OneMDCS__c objServiceSameDay = new Available_Services_OneMDCS__c();
        objServiceCalLogic = [Select Is_True_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Selected_Time_Slots_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Sameday Logic'];
        
        if(objServiceCalLogic.size() > 0)
        {
            if(Sameday == false){
                if (Available_Services_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
                {
                    delete objServiceCalLogic;
                }
            }    
            else if(Sameday == true){
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Is_True_OneMDCS__c.isUpdateable())
                {   
                    objServiceCalLogic[0].Is_True_OneMDCS__c = Sameday;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_OneMDCS__c.isUpdateable())
                {
                    objServiceCalLogic[0].Selected_Time_Slots_OneMDCS__c = samedayTime;
                }
                if(!objServiceCalLogic.isEmpty())
                { 
                    update objServiceCalLogic;
                }
            }            
        }
        else
        {
            if(Sameday == true){
                String randomSameDay = getRandomNumber(1);
                objServiceSameDay = new Available_Services_OneMDCS__c();
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Is_True_OneMDCS__c.isCreateable())
                {
                    objServiceSameDay.Is_True_OneMDCS__c = Sameday;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Type_OneMDCS__c.isCreateable())
                {
                    objServiceSameDay.Type_OneMDCS__c = 'Sameday Logic';
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_OneMDCS__c.isCreateable())
                {
                    objServiceSameDay.Selected_Time_Slots_OneMDCS__c = samedayTime;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
                {
                    objServiceSameDay.Territory_OneMDCS__c = UpdatedTerritoryName;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Name.isCreateable())
                {
                    objServiceSameDay.Name = 'Sameday Logic' + '-' +randomSameDay;
                }
                objServiceCalLogic.add(objServiceSameDay);
                if(!objServiceCalLogic.isEmpty())
                { 
                    Insert objServiceCalLogic;
                }
            }    
        }
        system.debug('*-*-*-*---*->>Sameday '+Sameday);
        system.debug('*-*-*-*---*->>samedayTime '+samedayTime);
    }
    
    @AuraEnabled
    public static void saveTime(String territoryName,String SelectedTimes)
    {
        //get Territory Name
        String SelectedSlotsAM = null;
        String SelectedSlotsPM = null;
        List<Territory> TerritoryNameTime = new List<Territory>();
        TerritoryNameTime = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];
        
        String UpdatedTerritoryName = '';
    
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameTime)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   
        
        system.debug('------->>SelectedTimes '+SelectedTimes);
        system.debug('------->>territoryName '+territoryName);
        
        String morningSlot=null;
        String afternoonSlot=null;
        if(!string.isBlank(SelectedTimes))
        {
            List<TimeRecordWrapper> lstPositionRecords = 
                (List<TimeRecordWrapper>)
                System.JSON.deserialize(SelectedTimes,List<TimeRecordWrapper>.class);
            //system.debug('Debug for Dsiplaying all the records : lstPositionRecords'+lstPositionRecords);    
            String concatenatedTimeSlots = '';
            List<String> slotAM = new List<String>();
            List<String> slotPM = new List<String>();
            //Perform Operation with records 
            for(TimeRecordWrapper objPositionRecords:lstPositionRecords)
            {
                if(objPositionRecords.isSelected)
                {
                    
                    system.debug('Selected Record :'+objPositionRecords.timeslot);
                    if(objPositionRecords.timeslot.contains('AM'))
                    {
                        if(SelectedSlotsAM ==  null)
                        {
                            SelectedSlotsAM = objPositionRecords.timeslot;
                        }
                        else
                        {
                            SelectedSlotsAM = SelectedSlotsAM + ';' + objPositionRecords.timeslot;
                        }
                    }
                    
                    if(objPositionRecords.timeslot.contains('PM'))
                    {
                        if(SelectedSlotsPM ==  null)
                        {
                            SelectedSlotsPM = objPositionRecords.timeslot;
                        }
                        else
                        {
                            SelectedSlotsPM = SelectedSlotsPM + ';' + objPositionRecords.timeslot;
                        }
                    }                    
                }
            }
            if(SelectedSlotsAM != null && SelectedSlotsAM != '')
            {
                SelectedSlotsAM = SelectedSlotsAM.removeend(';');
            }
            if(SelectedSlotsPM != null && SelectedSlotsPM != '')
            {
                SelectedSlotsPM = SelectedSlotsPM.removeend(';');
            }
        }
        //AdmincalendarLogic_OneMDCS.getsaveTimeHelper(morningSlot, afternoonSlot, TerritoryNameTime[0].Name, SelectedSlots);
        List<Available_Services_OneMDCS__c> objServiceCalLogic = new List<Available_Services_OneMDCS__c>();
        Available_Services_OneMDCS__c objService = new Available_Services_OneMDCS__c();
        objServiceCalLogic = [Select Selected_Time_Slots_AM_OneMDCS__c, Selected_Time_Slots_PM_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Slot Settings'];
        if(SelectedSlotsAM == null)
        {
            SelectedSlotsAM = '';
        }
        if(SelectedSlotsPM == null)
        {
            SelectedSlotsPM = '';
        }
        if(objServiceCalLogic.size() > 0)
        {
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_AM_OneMDCS__c.isUpdateable())
            {
                objServiceCalLogic[0].Selected_Time_Slots_AM_OneMDCS__c = SelectedSlotsAM;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_PM_OneMDCS__c.isUpdateable())
            {
                objServiceCalLogic[0].Selected_Time_Slots_PM_OneMDCS__c = SelectedSlotsPM;
            }
            if(!objServiceCalLogic.isEmpty())
            { 
                update objServiceCalLogic;
            }
        }
        else
        {
            String randomCalLogic = getRandomNumber(1);
            objService = new Available_Services_OneMDCS__c();
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_AM_OneMDCS__c.isCreateable())
            {
                objService.Selected_Time_Slots_AM_OneMDCS__c = SelectedSlotsAM;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Selected_Time_Slots_PM_OneMDCS__c.isCreateable())
            {
                objService.Selected_Time_Slots_PM_OneMDCS__c = SelectedSlotsPM;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Type_OneMDCS__c.isCreateable())
            {
                objService.Type_OneMDCS__c = 'Slot Settings';
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
            {
                objService.Territory_OneMDCS__c = UpdatedTerritoryName;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Name.isCreateable())
            {
                objService.Name = 'Slot Settings' + '-' + randomCalLogic;
            }
            objServiceCalLogic.add(objService);
            if(!objServiceCalLogic.isEmpty())
            { 
                Insert objServiceCalLogic;
            }
        }
        
        
    }
    
    @AuraEnabled
    public static void saveEmailSettingsAdmin(String territoryName, Boolean NewCase, Boolean CancelCase, Boolean ChangeCase, Boolean reassignReq, Boolean unassignReq, Boolean createdReq, Boolean modifiedReq)
    {
        
        List<String> EmailSettings = new List<String>();
        
        User userDtls=new User();
        // Id userId = UserInfo.getUserId();
        userDtls = [SELECT Id, Email_Settings_OneMDCS__c  FROM User where Id =:UserInfo.getUserId()];
        
        if(NewCase)
        {
            EmailSettings.add('New Request');
            
        }
        if(CancelCase)
        {
            EmailSettings.add('Cancelled Request');
            
        }
        if(ChangeCase)
        {
            EmailSettings.add('Change to current case');
            
        }
        if(reassignReq)
        {
            EmailSettings.add('Reassign');
            
        }
		if(createdReq){
            EmailSettings.add('Created');
        }
        if(modifiedReq){
            EmailSettings.add('Modified');
        }
        /* if(unassignReq)
         {
         EmailSettings.add('Unassigned');
        
         }*/
         //if (Schema.sObjectType.User.fields.Id.isAccessible())
         //{
         //userDtls.Id = UserInfo.getUserId();
         //}
        
        String emailSettingsStr = '';
        Boolean Start = true;
        if(!EmailSettings.isEmpty()) {           
            for(String Str : EmailSettings) {
                if(Start) {
                    emailSettingsStr = Str;
                    Start = false;
                } else {               
                    emailSettingsStr = emailSettingsStr + ';' + Str;
                }
            }
        }
        if (Schema.sObjectType.User.fields.Email_Settings_OneMDCS__c.isUpdateable())
        {
            userDtls.Email_Settings_OneMDCS__c = emailSettingsStr;
        }
        System.debug('@@@@user details::::'+emailSettingsStr+userDtls);
        if( userDtls != null )
        {
            update userDtls;
        }
        
    }
    @AuraEnabled
    public static List<Availability_Of_CAS_OneMDCS__c> getAllCAS()
    {
        return [SELECT Id, Name from Availability_Of_CAS_OneMDCS__c where Default_OneMDCS__c = 'Y' ];
    }
    
    //report
    @AuraEnabled
    public static void getReport()
    {
        /*List<AggregateResult> getServiceData= [SELECT Procedure_Name_Encrypted_OneMDCS__c,count(name) FROM Appointment_OneMDCS__c where createddate<today group by
Procedure_Name_Encrypted_OneMDCS__c] ;

List<AggregateResult> getCasData= [ SELECT Assigned_CAS_OneMDCS__r.name,count(name) FROM Appointment_OneMDCS__c where createddate<today group by
Assigned_CAS_OneMDCS__r.name];

Integer getTotalCase=[SELECT count() FROM Appointment_OneMDCS__c where createddate<today and Assigned_CAS_OneMDCS__c!=null];

JSONGenerator gen = JSON.createGenerator(true);*///true gives output in pretty print
        // Create a list of integers to write to the JSON string.
        /*
gen.writeStartObject();
gen.writeNumberField('abc', 1.21);  
gen.writeStringField('def', 'xyz');
gen.writeFieldName('ghi');


gen.writeFieldName('Object A');



gen.writeEndObject();*/
        
    }
    
    
    //get selected calendarlogic
    @AuraEnabled
    public static Boolean getSelectedCalendarLogic(String TerritoryId)
    {
        Boolean SelectedCalLogic = false;
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';

        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();

        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
        
        List<Available_Services_OneMDCS__c> getSelectedCalLogic = new List<Available_Services_OneMDCS__c>();
        getSelectedCalLogic = [Select Is_True_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Calendar Logic' limit 1];
        if(!getSelectedCalLogic.isEmpty())
        {
            SelectedCalLogic = getSelectedCalLogic[0].Is_True_OneMDCS__c;
        }
        Return SelectedCalLogic;
    }
    
    //get selected Email Settings NewCase
    @AuraEnabled
    public static Boolean getSelectedNewCaseLogic(String TerritoryId)
    {
        Boolean SelectedCalLogic = false;
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }           
        List<Available_Services_OneMDCS__c> getSelectedCalLogic = new List<Available_Services_OneMDCS__c>();
        getSelectedCalLogic = [Select Is_True_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Email Setting New Case' limit 1];
        if(!getSelectedCalLogic.isEmpty())
        {
            SelectedCalLogic = getSelectedCalLogic[0].Is_True_OneMDCS__c;
        }
        Return SelectedCalLogic;
    }
    
    //get selected Email Settings ChangeCase
    @AuraEnabled
    public static Boolean getSelectedChangeCaseLogic(String TerritoryId)
    {
        Boolean SelectedCalLogic = false;
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }        
        List<Available_Services_OneMDCS__c> getSelectedCalLogic = new List<Available_Services_OneMDCS__c>();
        getSelectedCalLogic = [Select Is_True_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Email Setting Change Case' limit 1];
        if(!getSelectedCalLogic.isEmpty())
        {
            SelectedCalLogic = getSelectedCalLogic[0].Is_True_OneMDCS__c;
        }
        Return SelectedCalLogic;
    }
    
    //get selected Email Settings CancelCase
    @AuraEnabled
    public static Boolean getSelectedCancelCaseLogic(String TerritoryId)
    {
        Boolean SelectedCalLogic = false;
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        } 
        List<Available_Services_OneMDCS__c> getSelectedCalLogic = new List<Available_Services_OneMDCS__c>();
        getSelectedCalLogic = [Select Is_True_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Email Setting Cancel Case' limit 1];
        if(!getSelectedCalLogic.isEmpty())
        {
            SelectedCalLogic = getSelectedCalLogic[0].Is_True_OneMDCS__c;
        }
        Return SelectedCalLogic;
    }
    
    //get selected Sameday & Time
    @AuraEnabled
    public static List<Available_Services_OneMDCS__c> getSelectedSamedayLogic(String TerritoryId)
    {
        Boolean SelectedCalLogic;
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        } 
        List<Available_Services_OneMDCS__c> getSelectedCalLogic = new List<Available_Services_OneMDCS__c>();
        getSelectedCalLogic = [Select Is_True_OneMDCS__c,Selected_Time_Slots_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id from Available_Services_OneMDCS__c where Territory_OneMDCS__c =: UpdatedTerritoryName AND Type_OneMDCS__c = 'Sameday Logic' limit 1];
        
        Return getSelectedCalLogic;
    }
    
    
    @AuraEnabled
    public static List<Available_Services_OneMDCS__c> getTerritoryForUser(String TerritoryName)
    {
        List<Available_Services_OneMDCS__c> getSameDayData = new List<Available_Services_OneMDCS__c>();
        getSameDayData = [Select Is_True_OneMDCS__c,Selected_Time_Slots_OneMDCS__c, Type_OneMDCS__c, Territory_OneMDCS__c, Id 
                          from Available_Services_OneMDCS__c where Territory_OneMDCS__c =:TerritoryName  AND Type_OneMDCS__c = 'Sameday Logic'];
        return getSameDayData;
    }
    
    
    @AuraEnabled
    public static List<BWI_Scheduler_Contact__c> getBWISettings(String TerritoryId)
    {    
        List<BWI_Scheduler_Contact__c> getBWIContact = new List<BWI_Scheduler_Contact__c>();	
        if(TerritoryId != '' && TerritoryId != null)
        {
            List<Territory> TerritoryName= [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
            String UpdatedTerritoryName = '';
        
            Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
            Map<String,String> renametr = new Map<String,String>();
            
            for(Combine_Territory__c ter : allterritories.values()){        
                renametr.put(ter.Old_Name__c,ter.Name);
            }
            for(Territory tr : TerritoryName)
            {
                if(renametr.containsKey(tr.Name)){
                    UpdatedTerritoryName = renametr.get(tr.Name);
                }
                else{
                    UpdatedTerritoryName = tr.Name;
                }
            }
            
            getBWIContact = [SELECT BWI_Scheduler_Email_OneMDCS__c,BWI_Scheduler_phone_OneMDCS__c,CreatedById,CreatedDate,Id, BWI_Scheduler_Name_OneMDCS__c FROM BWI_Scheduler_Contact__c where Territory__c=:UpdatedTerritoryName];
            Return getBWIContact;
        }
        else
            Return getBWIContact;
        
    }
    
    @AuraEnabled
    public static void  UpdateBWISettings(String UpdateBWIContacts,String territoryName)
    {
        
        if(!string.isBlank(UpdateBWIContacts))
        {
            List<BWI_Scheduler_Contact__c> lstPositionRecords = 
                (List<BWI_Scheduler_Contact__c>)
                System.JSON.deserialize(UpdateBWIContacts,List<BWI_Scheduler_Contact__c>.class);
            if(!lstPositionRecords.isEmpty())
            {   
                Upsert lstPositionRecords;
            }
        }
        
        
    }
    @AuraEnabled
    public static void  createBWISettings(String Email,String Phone,String TerritoryId, String Name)
    {
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
        String randomBWIAdminCase = getRandomNumber(1);
        BWI_Scheduler_Contact__c createbwi=new BWI_Scheduler_Contact__c();
        if (Schema.sObjectType.BWI_Scheduler_Contact__c.fields.BWI_Scheduler_Email_OneMDCS__c.isCreateable())
        {
            createbwi.BWI_Scheduler_Email_OneMDCS__c=Email;
        }
        if (Schema.sObjectType.BWI_Scheduler_Contact__c.fields.BWI_Scheduler_phone_OneMDCS__c.isCreateable())
        {
            createbwi.BWI_Scheduler_phone_OneMDCS__c=Phone;
        }
        if (Schema.sObjectType.BWI_Scheduler_Contact__c.fields.BWI_Scheduler_Name_OneMDCS__c.isCreateable())
        {
            createbwi.BWI_Scheduler_Name_OneMDCS__c=Name;
        }
        if (Schema.sObjectType.BWI_Scheduler_Contact__c.fields.Territory__c.isCreateable())
        {
            createbwi.Territory__c=UpdatedTerritoryName;
        }
        if (Schema.sObjectType.BWI_Scheduler_Contact__c.fields.name.isCreateable())
        {
            createbwi.name=UpdatedTerritoryName;
        }
        
        insert  createbwi;
        
        
    }
    
    
    @AuraEnabled
    public static List<Availability_Of_CAS_OneMDCS__c>  getPerDayAvlOfCAS(String TerritoryId, String DateSelected)
    {
        system.debug('------------>TerritoryId ' +TerritoryId + '--------------> DateSelected ' +DateSelected);
        
        
        List<Availability_Of_CAS_OneMDCS__c> getDailyAvlCAS = new List<Availability_Of_CAS_OneMDCS__c>();
        //getDailyAvlCAS = [SELECT CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name, Comment_OneMDCS__c, Date_assigned_OneMDCS__c, Default_OneMDCS__c, AM_OneMDCS__c, PM_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Default_OneMDCS__c = 'N' AND Date_assigned_OneMDCS__c =: Date.ValueOf(DateSelected) AND Territory_OneMDCS__c =: TerritoryId AND Date_assigned_OneMDCS__c >=: Date.today()];
        
        for(Availability_Of_CAS_OneMDCS__c objPDA: [SELECT CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name, Comment_OneMDCS__c, Date_assigned_OneMDCS__c, Default_OneMDCS__c, AM_OneMDCS__c, PM_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Default_OneMDCS__c = 'N' AND Date_assigned_OneMDCS__c =: Date.ValueOf(DateSelected) AND Territory_OneMDCS__c =: TerritoryId /*AND Date_assigned_OneMDCS__c >=: Date.today()*/])
        {
            if( (!objPDA.AM_OneMDCS__c) || (!objPDA.PM_OneMDCS__c) || (!objPDA.AM_OneMDCS__c && !objPDA.PM_OneMDCS__c) )
            {
                getDailyAvlCAS.add(objPDA);
            }
        }
        return getDailyAvlCAS;
    }
    
    @AuraEnabled
    public static List<User> getCustomerForTerritory(String primaryTerritory)
    {
        List<User> getCustomer = new List<User>();
        getCustomer = [SELECT Id, Name from User where Profile.Name = 'External User - Customer Case Scheduler' AND 
                       Primary_Territory_OneMDCS__c =: primaryTerritory AND isActive = true];
        system.debug('*-*--*--->> CustomerList '+getCustomer);
        
        return getCustomer;
        
    }
    @AuraEnabled
    public static List<BWI_Scheduler_Contact__c> getBWIInfo(String TerritoryName)
    {    
        List<BWI_Scheduler_Contact__c> getBWIContact = new List<BWI_Scheduler_Contact__c>();	
        if(TerritoryName!= '' && TerritoryName!= null)
        {
            getBWIContact= [SELECT BWI_Scheduler_Email_OneMDCS__c,BWI_Scheduler_phone_OneMDCS__c,CreatedById,CreatedDate,Id, BWI_Scheduler_Name_OneMDCS__c FROM BWI_Scheduler_Contact__c where Territory__c=:TerritoryName];
            Return getBWIContact;
        }
        else
            Return getBWIContact;
        
    }
    
    //get AppointmentList based on selected customer Current
    @AuraEnabled
    public static List<Appointment_OneMDCS__c> getAppoForCust(String CustId)
    {
        User objPrimaryTerr = [SELECT Id,Primary_Territory_OneMDCS__c from User where Id =: CustId AND IsActive =: true];
		String searchid = objPrimaryTerr.Id;
		Set<Id> linkedId = new Set<Id>();
		if(objPrimaryTerr != null){
			for(Customer_Link_OneMDCS__c ca : [SELECT Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Territory__c =: objPrimaryTerr.Primary_Territory_OneMDCS__c]){
				if(ca.Affiliations__c != null && ca.Affiliations__c != ''){
					if(ca.Affiliations__c.contains(searchid)){
						for(String uid : ca.Affiliations__c.split(';')){
							linkedId.add(uid);
						}
					}	
				}
			}
		}					
		if(linkedId.size() == 0){
			linkedId.add(objPrimaryTerr.Id);
		}
		
        List<Appointment_OneMDCS__c> AppointmentListCust = new List<Appointment_OneMDCS__c>();
        if(objPrimaryTerr.Primary_Territory_OneMDCS__c != null && objPrimaryTerr.Primary_Territory_OneMDCS__c != '')
        {
            
            Date todayDate = Date.today();
            for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Procedure_Name_Encrypted_OneMDCS__c,Appointment_Date_OneMDCS__c, Service_Hours_OneMDCS__c,
                                                Assigned_CAS_OneMDCS__r.Owner.Name, Assigned_CAS_OneMDCS__c,Location_Encrypted_OneMDCS__c, 
                                                Appointment_start_time_12hrs_OneMDCS__c, Appointment_end_time_OneMDCS__c, 
                                                Name_Of_Physician_Encrypted_OneMDCS__c ,Assigned_CAS_OneMDCS__r.Name
                                                FROM Appointment_OneMDCS__c 
                                                where Appointment_Date_OneMDCS__c >=: todayDate AND OwnerId IN: linkedId
                                                AND (Status_OneMDCS__c != 'Rejected' AND Status_OneMDCS__c != 'Cancelled') AND Territory_OneMDCS__c =: objPrimaryTerr.Primary_Territory_OneMDCS__c  
                                                ORDER BY Appointment_Date_OneMDCS__c ASC , Appointment_Start_time_OneMDCS__c ASC] )
            {
                AppointmentListCust.add(objApt);
            }
        }
        return AppointmentListCust;
    }
    
    //get AppointmentList based on selected customer past
    @AuraEnabled
    public static List<Appointment_OneMDCS__c> getAppoForCustPast(String CustId)
    {
        User objPrimaryTerr = [SELECT Id,Primary_Territory_OneMDCS__c from User where Id =: CustId AND IsActive =: true];
		String searchid = objPrimaryTerr.Id;
		Set<Id> linkedId = new Set<Id>();
		if(objPrimaryTerr != null){
			for(Customer_Link_OneMDCS__c ca : [SELECT Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Territory__c =: objPrimaryTerr.Primary_Territory_OneMDCS__c]){
				if(ca.Affiliations__c != null && ca.Affiliations__c != ''){
					if(ca.Affiliations__c.contains(searchid)){
						for(String uid : ca.Affiliations__c.split(';')){
							linkedId.add(uid);
						}
					}	
				}
			}
		}			
		if(linkedId.size() == 0){
			linkedId.add(objPrimaryTerr.Id);
		}
		
        List<Appointment_OneMDCS__c> AppointmentListCust = new List<Appointment_OneMDCS__c>();
        if(objPrimaryTerr.Primary_Territory_OneMDCS__c != null && objPrimaryTerr.Primary_Territory_OneMDCS__c != '')
        {
            
            Date todayDate = Date.today();
            for(Appointment_OneMDCS__c objApt: [ SELECT id, Name, Appointment_Date_OneMDCS__c, Assigned_CAS_OneMDCS__r.Owner.Name, Location_Encrypted_OneMDCS__c,
                                                Assigned_CAS_OneMDCS__c, Appointment_start_time_12hrs_OneMDCS__c, Procedure_Name_Encrypted_OneMDCS__c,Service_Hours_OneMDCS__c,
                                                Appointment_end_time_OneMDCS__c, Name_Of_Physician_Encrypted_OneMDCS__c  
                                                FROM Appointment_OneMDCS__c where Appointment_Date_OneMDCS__c <: todayDate AND 
                                                Territory_OneMDCS__c =: objPrimaryTerr.Primary_Territory_OneMDCS__c AND OwnerId IN: linkedId ORDER BY Appointment_Date_OneMDCS__c desc , Appointment_Start_time_OneMDCS__c ASC] )
            {
                AppointmentListCust.add(objApt);
            }
        }
        
        return AppointmentListCust;
    }
    
    @AuraEnabled
    public static User getDetailsOfCust(String CustId)
    {
        User userDtls=new User();
        userDtls = [SELECT name, email,Id,Primary_Territory_OneMDCS__c,Contact.Account.Name,Profile.Name  FROM User where Id =:Id.ValueOf(CustId) AND IsActive =: true];
        return userDtls;
    }
    
    
    @AuraEnabled
    public static List<AccountRecordWrapper> getAllAccounts(String TerritoryId)
    {
        List<AccountRecordWrapper> AccountWrapperList = new List<AccountRecordWrapper>();
        system.debug('-------------->>TerritoryId '+TerritoryId);
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
        
        List<Account> getAccountDtls = new List<Account>();
        getAccountDtls = [SELECT Id, Name, Calendar_Logic_OneMDCS__c, Primary_Territory__c from Account where Primary_Territory__c =: UpdatedTerritoryName order by Name];
        
        if(!getAccountDtls.isEmpty())
        {
            AccountWrapperList = new List<AccountRecordWrapper>();
            for(Account objAcc : getAccountDtls)
            {
                AccountRecordWrapper objWrapper = new AccountRecordWrapper();
                objWrapper.isSelected = objAcc.Calendar_Logic_OneMDCS__c;
                objWrapper.AccountName = objAcc.Name;
                objWrapper.AccountId = objAcc.Id;
                
                AccountWrapperList.add(objWrapper);
            }
        }
        return AccountWrapperList;
    }
    
    public class AccountRecordWrapper
    {
        
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public string AccountName;
        @AuraEnabled public string AccountId;
        
        public AccountRecordWrapper()
        {
            isSelected = false;
            AccountName = '';
            AccountId = '';
        }
    }
    
    @AuraEnabled
    public static List<AccountRecordWrapper> findByName(String searchKey, String accList, String TerritoryId) 
    {
        List<AccountRecordWrapper> AccountWrapperList = new List<AccountRecordWrapper>();
        system.debug('-------------->>TerritoryId '+TerritoryId);
        List<Territory> TerritoryName = new List<Territory>();
        TerritoryName = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryName)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }
        Set<Id> recordIds = new Set<Id>();
        if(!string.isBlank(searchKey))
        {
            String name = '%' + searchKey + '%';
            List<Account> getAccountDtls = new List<Account>();
            getAccountDtls = [SELECT Id, Name, Calendar_Logic_OneMDCS__c, Primary_Territory__c from Account where (Name LIKE :name OR JDE_JJHCS_Number__c LIKE :name) AND Primary_Territory__c =: UpdatedTerritoryName order by Name];
            if(!getAccountDtls.isEmpty())
            {
                AccountWrapperList = new List<AccountRecordWrapper>();
                for(Account objAcc : getAccountDtls)
                {
                    AccountRecordWrapper objWrapper = new AccountRecordWrapper();
                    objWrapper.isSelected = objAcc.Calendar_Logic_OneMDCS__c;
                    objWrapper.AccountName = objAcc.Name;
                    objWrapper.AccountId = objAcc.Id;
                    
                    AccountWrapperList.add(objWrapper);
                }
            }
        }
        else
        {
            AccountWrapperList = new List<AccountRecordWrapper>();
            AccountWrapperList = Appointment_Process_OneMDCS.getAllAccounts(TerritoryId);
        }
        return AccountWrapperList;    
    }
    
    @AuraEnabled
    public static void addAccountTerritory(String TerritoryName, String SelectedCAS)
    {
        // system.debug('SelectedCas ' +SelectedCAS);
        //get Territory Name
        List<Territory> territoryNameList = new List<Territory>();
        territoryNameList = [SELECT Id, Name FROM Territory WHERE Id =: TerritoryName limit 1];
        
        String UpdatedTerritoryName = '';
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : territoryNameList)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }   
        
        List<String> listToUpdateUserTerritory = new List<String>();
        
        system.debug('SelectedCas ' +SelectedCAS);
        
        if(SelectedCAS != null && SelectedCAS != '' && SelectedCAS.contains(';'))
        {
            listToUpdateUserTerritory = SelectedCAS.split(';');
        }
        else if(SelectedCAS != null && SelectedCAS != '')
        {
            listToUpdateUserTerritory.add(SelectedCAS);
        }
        
        Set<String> ToUpdateUserTerritory = new Set<String>();
        
        ToUpdateUserTerritory.addAll(listToUpdateUserTerritory);
        
        List<Account> updateAccount = new List<Account>();
        List<Available_Services_OneMDCS__c> updateAccountTerritory = new List<Available_Services_OneMDCS__c>();
        
        
        List<Available_Services_OneMDCS__c> deleteAccountTerritory = new List<Available_Services_OneMDCS__c>();
        deleteAccountTerritory = [SELECT Id from Available_Services_OneMDCS__c where Hospital_Id_OneMDCS__c IN: ToUpdateUserTerritory AND Type_OneMDCS__c = 'Hospital Territory'];
        
        if(!deleteAccountTerritory.isEmpty())
        {
            if (Available_Services_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
            {
                Delete deleteAccountTerritory;
            }
        }
        
        //Update user Territory
        List<Available_Services_OneMDCS__c> updateAccountCalLogicTerritory = new List<Available_Services_OneMDCS__c>();
        for(Account acc:[SELECT id, Name, Primary_Territory__c, JDE_JJHCS_Number__c from Account where Id IN: ToUpdateUserTerritory])
        {
            Available_Services_OneMDCS__c objHospTerritory = new Available_Services_OneMDCS__c();
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Hospital_Id_OneMDCS__c.isCreateable())
            {
                objHospTerritory.Hospital_Id_OneMDCS__c = acc.Id;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Hospital_Name_OneMDCS__c.isCreateable())
            {
                objHospTerritory.Hospital_Name_OneMDCS__c = acc.Name;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
            {
                objHospTerritory.Territory_OneMDCS__c = UpdatedTerritoryName;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Type_OneMDCS__c.isCreateable())
            {
                objHospTerritory.Type_OneMDCS__c = 'Hospital Territory';
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Name.isCreateable())
            {
                objHospTerritory.Name = 'HOS - ' + acc.JDE_JJHCS_Number__c;
            }
            if(objHospTerritory.Name != null)
            {
                updateAccountTerritory.add(objHospTerritory);
            }
            if (Schema.sObjectType.Account.fields.Primary_Territory__c.isUpdateable())
            {
                acc.Primary_Territory__c = UpdatedTerritoryName;
            }
            updateAccount.add(acc);
        }
        
        updateAccountCalLogicTerritory = [SELECT Id from Available_Services_OneMDCS__c where Hospital_Id_OneMDCS__c IN: ToUpdateUserTerritory AND Type_OneMDCS__c = 'Calendar Logic'];
        if (Available_Services_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
        {
            if(!updateAccountCalLogicTerritory.isEmpty())
            { 
                Delete updateAccountCalLogicTerritory;
            }
        }
        
        updateAccountCalLogicTerritory = new List<Available_Services_OneMDCS__c>();
        for(Account acc:[SELECT Id, Name, Primary_Territory__c,Calendar_Logic_OneMDCS__c, JDE_JJHCS_Number__c from Account where Id IN: ToUpdateUserTerritory])
        {
            System.debug('objUpdtAcc to be inserted@@@@'+acc.Calendar_Logic_OneMDCS__c);
            Available_Services_OneMDCS__c objUpdtAcc = new Available_Services_OneMDCS__c();
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Is_True_OneMDCS__c.isCreateable())
            {
                System.debug('objUpdtAcc to be inserted'+acc.Calendar_Logic_OneMDCS__c);
                objUpdtAcc.Is_True_OneMDCS__c = acc.Calendar_Logic_OneMDCS__c;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Hospital_Id_OneMDCS__c.isCreateable())
            {
                objUpdtAcc.Hospital_Id_OneMDCS__c = acc.Id;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Name.isCreateable())
            {
                objUpdtAcc.Name = 'CAL' + acc.JDE_JJHCS_Number__c;
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Type_OneMDCS__c.isCreateable())
            {
                objUpdtAcc.Type_OneMDCS__c = 'Calendar Logic';
            }
            if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
            {
                objUpdtAcc.Territory_OneMDCS__c = UpdatedTerritoryName;
                
            }            
            if(objUpdtAcc.Name != null)
            {
               system.debug('@@@@@Adding custom settings data');
               updateAccountCalLogicTerritory.add(objUpdtAcc);
            }
            
        }
        
        if(!updateAccountCalLogicTerritory.isEmpty())
        { 
            Insert updateAccountCalLogicTerritory;
        }
        if(!updateAccount.isEmpty())
        { 
            update updateAccount;
        }
        if(!updateAccountTerritory.isEmpty())
        { 
            Insert updateAccountTerritory;
        }
        
    }
    
    @AuraEnabled
    public static void removeAccountTerritory(String TerritoryName,String RemoveCAS)
    {
        List<String> listToRemoveUserTerritory = new List<String>();
        
        if(RemoveCAS != null && RemoveCAS != '' && RemoveCAS.contains(';'))
        {
            listToRemoveUserTerritory = RemoveCAS.split(';');
        }
        else if(RemoveCAS != null && RemoveCAS != '')
        {
            listToRemoveUserTerritory.add(RemoveCAS);
        }
        
        Set<String> ToRemoveUserTerritory = new Set<String>();
        
        ToRemoveUserTerritory.addAll(listToRemoveUserTerritory);
        
        List<Account> updateAccount = new List<Account>();
        
        for(Account acc:[SELECT id, Primary_Territory__c from Account where Id IN: ToRemoveUserTerritory])
        {
            if (Schema.sObjectType.Account.fields.Primary_Territory__c.isUpdateable())
            {
                acc.Primary_Territory__c = '';
            }
            updateAccount.add(acc);
        }
        if(!updateAccount.isEmpty())
        { 
            update updateAccount;
        }
        
        List<Available_Services_OneMDCS__c> deleteAccountTerritory = new List<Available_Services_OneMDCS__c>();
        deleteAccountTerritory = [SELECT Id from Available_Services_OneMDCS__c where Hospital_Id_OneMDCS__c IN: ToRemoveUserTerritory AND Type_OneMDCS__c = 'Hospital Territory'];
        if(!deleteAccountTerritory.isEmpty())
        {
            if (Available_Services_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
            {
                if(!deleteAccountTerritory.isEmpty())
                { 
                    Delete deleteAccountTerritory;
                }
            }
        }        
        
    }
    
    @AuraEnabled
    public static void saveCalendarAdmin(String territoryName,String AccDetils)
    {
        //get Territory Name
        List<Territory> TerritoryNameCalendar = new List<Territory>();
        TerritoryNameCalendar = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];
        String UpdatedTerritoryName = '';
    
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        for(Territory tr : TerritoryNameCalendar)
        {
            if(renametr.containsKey(tr.Name)){
                UpdatedTerritoryName = renametr.get(tr.Name);
            }
            else{
                UpdatedTerritoryName = tr.Name;
            }
        }       
        List<Account> updateAcc = new List<Account>();
        List<Available_Services_OneMDCS__c> updateAccountCalLogicTerritory = new List<Available_Services_OneMDCS__c>();
        Set<String> accIdList = new Set<String>();
        Map<String, Boolean> mapOfCalendarLogic = new Map<String, Boolean>();
        Map<String, String> mapOfJDEnumber = new Map<String, String>();
        //Save Account Details
        if(!string.isBlank(AccDetils))
        {
            List<AccountRecordWrapper> lstAccRecords = 
                (List<AccountRecordWrapper>)
                System.JSON.deserialize(AccDetils,List<AccountRecordWrapper>.class);
            for(AccountRecordWrapper objAccWrap : lstAccRecords)
            {
                accIdList.add(objAccWrap.AccountId);
                mapOfCalendarLogic.put(objAccWrap.AccountId, objAccWrap.isSelected); 
            }
            
            for(Account acc:[SELECT id, Primary_Territory__c, JDE_JJHCS_Number__c from Account where Id IN: accIdList])
            {
                mapOfJDEnumber.put(acc.id, acc.JDE_JJHCS_Number__c);
                if (Schema.sObjectType.Account.fields.Calendar_Logic_OneMDCS__c.isUpdateable())
                {
                    if( mapOfCalendarLogic.containsKey(acc.id) ) 
                    {
                        
                        acc.Calendar_Logic_OneMDCS__c = mapOfCalendarLogic.get(acc.id);
                        updateAcc.add(acc);
                    }
                }
                
            }
            
            if(!updateAcc.isEmpty())
            { 
                Update updateAcc;
            }
            
            updateAccountCalLogicTerritory = [SELECT Id from Available_Services_OneMDCS__c where Hospital_Id_OneMDCS__c IN: accIdList AND Type_OneMDCS__c = 'Calendar Logic'];
            if (Available_Services_OneMDCS__c.sObjectType.getDescribe().isDeletable()) 
            {
                if(!updateAccountCalLogicTerritory.isEmpty())
                { 
                    Delete updateAccountCalLogicTerritory;
                }
            }
            
            updateAccountCalLogicTerritory = new List<Available_Services_OneMDCS__c>();
            for(AccountRecordWrapper objAccWrap : lstAccRecords)
            {
                Available_Services_OneMDCS__c objUpdtAcc = new Available_Services_OneMDCS__c();
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Is_True_OneMDCS__c.isCreateable())
                {
                    objUpdtAcc.Is_True_OneMDCS__c = objAccWrap.isSelected;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Hospital_Id_OneMDCS__c.isCreateable())
                {
                    objUpdtAcc.Hospital_Id_OneMDCS__c = objAccWrap.AccountId;
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Name.isCreateable())
                {
                    if(mapOfJDEnumber.containsKey(objAccWrap.AccountId)){
                        objUpdtAcc.Name = 'CAL' + mapOfJDEnumber.get(objAccWrap.AccountId);
                    }   
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Type_OneMDCS__c.isCreateable())
                {
                    objUpdtAcc.Type_OneMDCS__c = 'Calendar Logic';
                }
                if (Schema.sObjectType.Available_Services_OneMDCS__c.fields.Territory_OneMDCS__c.isCreateable())
                {
                    objUpdtAcc.Territory_OneMDCS__c = UpdatedTerritoryName;
                }
                if(objUpdtAcc.Name != null)
                {
                    updateAccountCalLogicTerritory.add(objUpdtAcc);
                }
            }
            if(!updateAccountCalLogicTerritory.isEmpty())
            {
                Insert updateAccountCalLogicTerritory;
            }
            
        }
        
    }
    
    @AuraEnabled
    public static Boolean isPrimaryTerritory(){
        Boolean isPrimary;
        for(User u: [Select Primary_Territory_OneMDCS__c from User where Id =: UserInfo.getUserId() LIMIT 1]){
            if(u.Primary_Territory_OneMDCS__c != null){
                isPrimary = true;
            }
            else{
                isPrimary = false;
            }
        }
        return isPrimary;
    }

    @AuraEnabled
    public static List<String> getcolorlist()
    {       
        List<String> remaincolorlist = new List<String>();
        List<String> usedcolorlist = new List<String>();
        List<String> Territories = new List<String>();
        List<Id> territoryidlist = new List<Id>();
        Map<String, Color_List_OneMDCS__c> colormap = Color_List_OneMDCS__c.getAll();
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
                
        for(User u : [Select Primary_Territory_OneMDCS__c,Color__c from User where Id =: UserInfo.getUserId() and Primary_Territory_OneMDCS__c != null LIMIT 1]){
            Territories.add(u.Primary_Territory_OneMDCS__c);
        }
        
        if(!Territories.isEmpty() ){
            for (User u : [Select Color__c from User where Primary_Territory_OneMDCS__c IN:Territories and Color__c != null AND IsActive =: true]){
                    usedcolorlist.add(u.Color__c);
                }
        }
        if(!usedcolorlist.isEmpty()){
            for(Color_List_OneMDCS__c cl : colormap.values()){
                if(!usedcolorlist.contains(cl.Hexacode__c)){
                    remaincolorlist.add(cl.Hexacode__c);
                }
            }
        }
        else{
            for(Color_List_OneMDCS__c cl : colormap.values()){
                remaincolorlist.add(cl.Hexacode__c);
            }    
        }
        return remaincolorlist;
    }
    @AuraEnabled
    public static void addcolortouser(String colorcode)
    {
        List<User> loginuserlist = new List<User>();
        for(User u: [Select Color__c,Id from User where Id =: UserInfo.getUserId() LIMIT 1]){
            u.Color__c = colorcode;
            loginuserlist.add(u);
        }
        update loginuserlist;
    }
    @AuraEnabled
    public static String iscoloradded()
    {
        String isadded;
        system.debug('UserInfo.getUserId()-->'+UserInfo.getUserId());
        for(User u: [Select Color__c from User where Id =: UserInfo.getUserId() LIMIT 1]){
            if(u.Color__c != null){
                system.debug('u.Color__c-->'+u.Color__c);
                isadded = u.Color__c;
            }
            else{
                isadded = null;
            }
        }
        return isadded;
    }
   
    
    @AuraEnabled
    public static List<Finalize_Schedule_Per_Territory_OneMDCS__c> finalzedSchedulePerTerritory(String TerritoryId,String DateSelected){
         Date tempdate=date.ValueOf(DateSelected);
        
        return [Select Date_OneMDCS__c,Finalized_OneMDCS__c,Finalized_Note_OneMDCS__c from Finalize_Schedule_Per_Territory_OneMDCS__c where name  =: TerritoryId and Date_OneMDCS__c=:tempdate LIMIT 1];
    }
    
      @AuraEnabled
    public static void createfinalzedSchedule(Finalize_Schedule_Per_Territory_OneMDCS__c scheduledata){
        
       
        system.debug('scheduledata.Date_OneMDCS__c data'+scheduledata);
       
       insert scheduledata;
    }
      @AuraEnabled
    public static void  UpdatefinalSchedule(String UpdateFinalSchedule,String datefinal)
    {
        
        if(!string.isBlank(UpdateFinalSchedule))
        {
            List<Finalize_Schedule_Per_Territory_OneMDCS__c> lstPositionRecords = 
                (List<Finalize_Schedule_Per_Territory_OneMDCS__c>)
                System.JSON.deserialize(UpdateFinalSchedule,List<Finalize_Schedule_Per_Territory_OneMDCS__c>.class);
            if(!lstPositionRecords.isEmpty())
            {   
                Upsert lstPositionRecords;
            }
        }
        
   
        
    }
    
     public class updateMyCASWrapper{
        
        @TestVisible private String recID ;
        @TestVisible private String casLookupid ;
        @TestVisible private String Header_Note ;
        @TestVisible private String Detailed_Note ;
    }
    
    @AuraEnabled
     public static void updateNote( String appointmentIDJSON  ){
         System.debug('JsonData for Note'+ appointmentIDJSON);
        List<updateMyCASWrapper> assignCASWrapperObj =(List<updateMyCASWrapper>)JSON.deserialize(appointmentIDJSON,List<updateMyCASWrapper>.class);
        List<Appointment_OneMDCS__c> selectedappointList = new List<Appointment_OneMDCS__c>() ;
                Appointment_OneMDCS__c appoObj ;
        
       
       
        for( updateMyCASWrapper objwrap :  assignCASWrapperObj ){
            
            appoObj = new Appointment_OneMDCS__c();
            appoObj.Id = objwrap.recID ;
            appoObj.Header_Note_OneMDCS__c = objwrap.Header_Note ;
            appoObj.Detailed_Note_OneMDCS__c = objwrap.Detailed_Note ;            
            selectedappointList.add( appoObj ) ;
            system.debug('*-*-*->selectedappointList '+selectedappointList);
        }
        update selectedappointList ;
        
    }
    
    @AuraEnabled
    public static List<String> getselectOptions(String field)
    {
        List <String> allOpts = new list <String> ();  
        map < String, Schema.SObjectField > fieldMap = Availability_Of_CAS_OneMDCS__c.getSObjectType().getDescribe().fields.getMap();       
        list < Schema.PicklistEntry > values = fieldMap.get(field).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        return allOpts;
    }

    
	@AuraEnabled
    public static String getSelectedDate( String selectedDay )
    {
        System.debug('#### selectedDay ::::'+ selectedDay );
        
        Date selectedDate = Date.valueOf(selectedDay) ;  
        return selectedDay;
    }
	
    @AuraEnabled
    public static String sendemailtoteam(List<Appointment_OneMDCS__c> appointmentlist, List<Availability_Of_CAS_OneMDCS__c> availabilitylist, String territory, String formateddate)
    {
        String htmlBody = '';
        String comment;
        for(Availability_Of_CAS_OneMDCS__c avlbl : availabilitylist){
            comment = ' - ' + avlbl.Comment_OneMDCS__c;
            if(avlbl.Comment_OneMDCS__c == null){
                comment = '';
            }
            
            if(avlbl.PM_OneMDCS__c == true && avlbl.AM_OneMDCS__c == false ){                      
                htmlBody = htmlBody + avlbl.CAS_Team_OneMDCS__r.Name + ' is off AM'+ comment +'.</br>';
            }
            if(avlbl.PM_OneMDCS__c == false && avlbl.AM_OneMDCS__c == true ){
                htmlBody = htmlBody + avlbl.CAS_Team_OneMDCS__r.Name + ' is off PM'+ comment +'.</br>';
            }
            if(avlbl.PM_OneMDCS__c == false && avlbl.AM_OneMDCS__c == false ){
                htmlBody = htmlBody + avlbl.CAS_Team_OneMDCS__r.Name + ' is off AM and PM'+ comment +'.</br>';
            }            
        }
        htmlBody = htmlBody + '</br></br><table border="1" style="border-collapse: collapse"><caption>Daily Appointment Summary Data '+formateddate+'</caption><tr><th>Header Note</th><th>CAS Assign</th><th>Secondary CAS Assign</th><th>Time</th><th>Account</th><th>Physician</th><th>Procedure</th><th>Booking Id</th><th>Detailed Note</th></tr>';
        for(Appointment_OneMDCS__c appo : appointmentlist){

            String HeaderNote = appo.Header_Note_OneMDCS__c; 
            if(appo.Header_Note_OneMDCS__c == null){
                HeaderNote = '';
            }
            
            String CASAssign = appo.Assigned_CAS_OneMDCS__r.Name;
            if(appo.Assigned_CAS_OneMDCS__r.Name == null){
                CASAssign = 'Open';
            }
            
            String SecCASAssign = appo.Assigned_CAS_Secondary_OneMDCS__r.Name;
            if(appo.Assigned_CAS_Secondary_OneMDCS__r.Name == null){
                SecCASAssign = '';
            }
            
            String Appotime = appo.Appointment_start_time_12hrs_OneMDCS__c;
            if(appo.Appointment_start_time_12hrs_OneMDCS__c == null){
                Appotime = '';
            }
            
            String Account = appo.Location_Encrypted_OneMDCS__c;
            if(appo.Location_Encrypted_OneMDCS__c == null){
                Account = '';
            }
            
            String Physician = appo.Name_Of_Physician_Encrypted_OneMDCS__c;
            if(appo.Name_Of_Physician_Encrypted_OneMDCS__c == null){
                Physician = '';
            }
            
            String Procedure = appo.Procedure_Name_Encrypted_OneMDCS__c;
            if(appo.Procedure_Name_Encrypted_OneMDCS__c == null){
                Procedure = '';
            }
            
            String BookingId = appo.Name;
            if(appo.Name == null){
                BookingId = '';
            }
            
            String DetailedNote = appo.Detailed_Note_OneMDCS__c;
            if(appo.Detailed_Note_OneMDCS__c == null){
                DetailedNote = '';
            }
            
            htmlBody += '<tr><td>' + HeaderNote + '</td><td>' + CASAssign + '</td><td>' + SecCASAssign + '</td><td>' + Appotime + '</td><td>' + Account + '</td><td>' + Physician + '</td><td>' + Procedure + '</td><td>' + BookingId + '</td><td>' + DetailedNote + '</td></tr>';

        }
        htmlBody += '</table>';
        system.debug('Email Body: ' + htmlBody); 
        
        List<Messaging.SingleEmailMessage> maillist = new List<Messaging.SingleEmailMessage>();
		
		List<String> UpdatedTerritoryName = new List<String>{territory};
    
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        
        for(Combine_Territory__c ter : allterritories.values()){        
            if(ter.Name == territory){
                UpdatedTerritoryName.clear();
                UpdatedTerritoryName = ter.Territory__c.split(';');
            }
        }
        
                
        //ADUV-301
        for(UserTerritory userIdMail : [SELECT UserId FROM UserTerritory WHERE TerritoryId IN (SELECT Id FROM Territory WHERE Name IN: UpdatedTerritoryName) 
                                        AND UserId IN (SELECT Id FROM User WHERE Profile.Name = 'Territory Manager' AND IsActive =: true) AND IsActive =: true])
        {
            if(userIdMail.UserId != null){
                Messaging.SingleEmailMessage newMail = new Messaging.SingleEmailMessage();            
                newMail.setTargetObjectId(userIdMail.UserId);
                //newMail.setSenderDisplayName('BWI Case Scheduler');
                newMail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
                newMail.setSubject('Appointment Details List');
                newMail.setHtmlBody(htmlBody);
                newMail.setSaveAsActivity(false);
                maillist.add(newMail);
            }            
        }  
        
        List<Id> trid = new List<Id>();
        for(Territory tr : [SELECT Id,ParentTerritoryId FROM Territory where Name IN: UpdatedTerritoryName]){
            if(!trid.Contains(tr.Id)){
                trid.add(tr.Id);
            }
            if(!trid.Contains(tr.ParentTerritoryId)){
                trid.add(tr.ParentTerritoryId);
            }
        }
                
        for(UserTerritory userIdMail : [SELECT UserId FROM UserTerritory where TerritoryId IN: trid
                                        AND UserId IN (SELECT Id FROM User WHERE Profile.Name = 'Regional Business Director' AND IsActive =: true) AND IsActive =: true]){
            if(userIdMail.UserId != null){
                Messaging.SingleEmailMessage newMail = new Messaging.SingleEmailMessage();            
                newMail.setTargetObjectId(userIdMail.UserId);
                //newMail.setSenderDisplayName('BWI Case Scheduler');
                newMail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
                newMail.setSubject('Appointment Details List');
                newMail.setHtmlBody(htmlBody);
                newMail.setSaveAsActivity(false);
                maillist.add(newMail);
            }            
        }  
		
        List<String> profilelist = new List<String>{'Custom SP Profile','Clinical Account Specialist','BWI Case Scheduler'};
        List<Profile> profileidlist = [Select Id from Profile where Name IN: profilelist];
        for(User u : [SELECT Email FROM User WHERE Primary_Territory_OneMDCS__c =: territory and ProfileId IN: profileidlist AND IsActive =: true]){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            mail.setTargetObjectId(u.Id);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('Appointment Details List');
            mail.setHtmlBody(htmlBody);
            mail.setSaveAsActivity(false);
            maillist.add(mail);
        }   
        Messaging.sendEmail(maillist);
        return htmlBody;
    }
	// For Events scheduled per day
    @AuraEnabled
    public static List<Finalize_Schedule_Per_Territory_OneMDCS__c> getEventListonDay( String selectedDay, String customerTeritory )
    {
        System.debug('#### selectedDay ::::'+ selectedDay );
        
        Date selectedDate = Date.valueOf(selectedDay) ;
        List<Finalize_Schedule_Per_Territory_OneMDCS__c> eventList = new List<Finalize_Schedule_Per_Territory_OneMDCS__c>();
        //Date todayDate = Date.today();
        for(Finalize_Schedule_Per_Territory_OneMDCS__c objEvt: [ SELECT Id,Date_OneMDCS__c,Description_OneMDCS__c,End_Time__c,State_Time__c,Subject__c FROM Finalize_Schedule_Per_Territory_OneMDCS__c where Territory_OneMDCS__c =: customerTeritory AND Date_OneMDCS__c=: selectedDate
                                             ORDER BY State_Time__c  asc])
        {
            eventList.add(objEvt);
        }
        return eventList;    
    }
    
	// For Event Record Deletion
    @AuraEnabled
    public static Boolean EventDeletion( String eventrecord )
    {
        Boolean isdelete = false;
        List<Finalize_Schedule_Per_Territory_OneMDCS__c> eventList = new List<Finalize_Schedule_Per_Territory_OneMDCS__c>();
        for(Finalize_Schedule_Per_Territory_OneMDCS__c objEvt: [ SELECT Id FROM Finalize_Schedule_Per_Territory_OneMDCS__c where Id =: eventrecord])
        {
            eventList.add(objEvt);
        }
        
        if(!eventList.isEmpty()){
            delete eventList;   
            isdelete = true;
        }
        return isdelete;
    }
	//Added for updating reason in cancel Modal
	@AuraEnabled
    public static void updateReason( String appoId, String reason  ){
         
		Appointment_OneMDCS__c appoObj = new Appointment_OneMDCS__c(); 
		appoObj.Id = appoId ;
		appoObj.Reason_OneMDCS__c = reason ;
		appoObj.Status_OneMDCS__c = 'Cancelled';
		appoObj.Change_Type_of_Request_OneMDCS__c = 'Cancel';

		update appoObj ;
        
    } 
	
	@AuraEnabled
    public static String getProfile()
    {
      
        List<User> userList = [SELECT name, email,Id,Primary_Territory_OneMDCS__c,Profile.Name  FROM User where Id =:UserInfo.getUserId() ];
        system.debug('profile Name'+userList[0].Profile.Name);
        return userList[0].Profile.Name;
    }
}