public class JNJ_Admin_Calender_Controller_OneMDCS{
    
    
    
    @AuraEnabled
    public static User userDetails()
    {
        User userDtls=new User();
        Id userId = UserInfo.getUserId();
        userDtls = [SELECT name, email,Id,Primary_Territory_OneMDCS__c,Profile.Name  FROM User where Id =:userId limit 1];
        return userDtls;
    }
    
    
     @AuraEnabled
    public static String getProfileName()
    {
      
        List<User> userList = [SELECT name, email,Id,Primary_Territory_OneMDCS__c,Profile.Name  FROM User where Id =:UserInfo.getUserId() ];
        system.debug('profile Name'+userList[0].Profile.Name);
        return userList[0].Profile.Name;
    }
    @AuraEnabled
    public static String getBookedAppointment( String customerTerritory  ) {
        
        
        JNJ_Admin_Calender_helper_OneMDCS sc = new JNJ_Admin_Calender_helper_OneMDCS();
        return sc.getBookedDateString( customerTerritory ) ;
        
        
        
    }
    
    //get all the territory name
    @AuraEnabled
    public static List<TerritoryRecordWrapper> getTerritories()
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
        
        List<territory> prterr = new List<territory>();
        
        List<TerritoryRecordWrapper> wrapterritorylist = new List<TerritoryRecordWrapper>();
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        
        Map<String,String> hierarchytr = new Map<String,String>();
        Map<String,String> renametr = new Map<String,String>();
        
        for(Combine_Territory__c ter : allterritories.values()){
            List<String> territories = ter.Territory__c.split(';') ;
            for(String terstr : territories){
                hierarchytr.put(terstr.trim(), ter.Old_Name__c);
            }
            system.debug('hierarchytr-->'+hierarchytr);
            renametr.put(ter.Old_Name__c,ter.Name);
        }
        
        
        
        //Set to get the parent territory 
        Set<String> Terset = new Set<String>(); 
        
        //List to get lowest Territory Details
        List<Territory> getTerritory = new List<Territory>();       
         
        //Get Level 1 Territory Id
        for(UserTerritory objUserTerr: [SELECT Id, TerritoryId FROM UserTerritory WHERE UserId =: currentUserId])
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
            getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel4 order by Name];
        }
        else
        {
            if(!territoryIdslevel3.isEmpty())
            {
                getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel3 order by Name];
            }
            else
            {
                if(!territoryIdslevel2.isEmpty())
                {
                    getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel2 order by Name];
                }
                else
                {
                    if(!territoryIdslevel1.isEmpty())
                    {
                        getTerritory = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id IN : territoryIdslevel1 order by Name];
                    }
                }
            }
        }
        if(!getTerritory.isEmpty()){
            for (Territory listedter : getTerritory){
                if(hierarchytr.containsKey(listedter.Name)){
                    Terset.add(hierarchytr.get(listedter.Name));
                }
                else{
                    
                    TerritoryRecordWrapper objWrapper = new TerritoryRecordWrapper();
                    
                    objWrapper.Name = listedter.Name;
                    objWrapper.Id = listedter.Id;
                    objWrapper.ParentTerritoryId = listedter.ParentTerritoryId;
                    
                    wrapterritorylist.add(objWrapper);
                }                       
            }
        }       
        
        if(!Terset.isEmpty()){
            prterr = [Select Id, Name, ParentTerritoryId FROM Territory WHERE Name IN : Terset order by Name];
        }
        
        if(!prterr.isEmpty()){
            for(territory terlist1 : prterr){
                TerritoryRecordWrapper objWrapper = new TerritoryRecordWrapper();
                if(renametr.containsKey(terlist1.Name)){
                    objWrapper.Name = renametr.get(terlist1.Name);
                }   
                objWrapper.Id = terlist1.Id;
                objWrapper.ParentTerritoryId = terlist1.ParentTerritoryId;
                
                wrapterritorylist.add(objWrapper);
            }
        }
       
        wrapterritorylist.sort();
        return wrapterritorylist;        
        
    } 
    
    public class TerritoryRecordWrapper implements Comparable {

        @AuraEnabled public string ParentTerritoryId;
        @AuraEnabled public string Name;
        @AuraEnabled public string Id;
            
        public TerritoryRecordWrapper(){
            ParentTerritoryId = '';
            Name = '';
            Id = '';        
        }
        
        public TerritoryRecordWrapper(String ParentTerritoryId, String Name, String Id){
            this.ParentTerritoryId = ParentTerritoryId;
            this.Name = Name;
            this.Id = Id;          
        }

        public Integer compareTo(Object objToCompare) {
            return Name.compareTo(((TerritoryRecordWrapper)objToCompare).Name);     
        }
    }
    
   /* @AuraEnabled
    public static ReportWrapper getFiveDaysReport(String startDate, String endDate) {
        
        ReportWrapper report = new  ReportWrapper ();   
        report.dateRange = '2017-09-04 to 2017-09-21';
        List<Appointment_OneMDCS__c> listAppointment = [SELECT Appointment_Date_OneMDCS__c,Appointment_Start_time_OneMDCS__c,Assigned_CAS_OneMDCS__c,Service_Name_OneMDCS__c,Territory_OneMDCS__c,Assigned_CAS_OneMDCS__r.Name FROM Appointment_OneMDCS__c WHERE Appointment_Date_OneMDCS__c >=: Date.valueOf(startDate) AND Appointment_Date_OneMDCS__c <=: Date.valueOf(endDate)];
        report.ScheduledCases = listAppointment.size();
        //report.ScheduledCases =[SELECT Count() FROM Appointment_OneMDCS__c WHERE Appointment_Date_OneMDCS__c >= 2017-09-04 AND Appointment_Date_OneMDCS__c <= 2017-09-13];
        Integer mocase = 0;
        Integer evcase = 0;
        for (Appointment_OneMDCS__c li : listAppointment)
        {
            if(li.Appointment_Start_time_OneMDCS__c < '12')
            {
                mocase++;
            }
            else
            {
                evcase++;
            }
        }
        report.MorningCases =mocase;
        report.AfternoonCases =evcase;
        system.debug('-------> mcase '+mocase);
        system.debug('-------> evcase '+evcase);
        
        Map<String,Integer> procedureCount = new Map<String,Integer>();
        for (Appointment_OneMDCS__c key : listAppointment)
        {
            if(!procedureCount.containsKey(String.ValueOf(key.Service_Name_OneMDCS__c))){
                procedureCount.put(String.ValueOf(key.Service_Name_OneMDCS__c),0);
            }
            Integer currentInt=procedureCount.get(String.ValueOf(key.Service_Name_OneMDCS__c))+1;
            procedureCount.put(String.ValueOf(key.Service_Name_OneMDCS__c),currentInt);
        }
        
        system.debug('-------> procedureCount '+procedureCount);
         report.procedureList =procedureCount;
        
        
         Map<String,Integer> casCount = new Map<String,Integer>();
        for (Appointment_OneMDCS__c key : listAppointment)
        {
            if((String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name))!=null && (String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name))!='')
            {
            if(!casCount.containsKey(String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name))){
                casCount.put(String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name),0);
            }
            Integer currentInt=casCount.get(String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name))+1;
            casCount.put(String.ValueOf(key.Assigned_CAS_OneMDCS__r.Name),currentInt);
           }
        }
        
        system.debug('-------> casCount '+casCount);
        report.casList =casCount;
        
       /* system.debug('------->dateRange '+report.AfternoonCases);
        List<AggregateResult> groupedResults = [SELECT Procedure_Name_One_MDCS__c FROM Available_Services_OneMDCS__c GROUP BY Procedure_Name_One_MDCS__c];   
        List<String> listProcedureName = new List<String>();
        system.debug('------->groupedResults Size '+groupedResults.size()); 
        for (AggregateResult ar : groupedResults)
        {
            if(ar.get('Procedure_Name_One_MDCS__c') != null)
            {
                system.debug('------->groupedResults@@@@ '+ar.get('Procedure_Name_One_MDCS__c'));     
                listProcedureName.add((String)ar.get('Procedure_Name_One_MDCS__c'));
                
            }
        }
        system.debug('------->listProcedureName Size '+listProcedureName.size()); */
        
        
       /* return report;
    }*/
    
    /*public class ReportWrapper
    {
        @AuraEnabled public Date AssignedDate {get; set;}
        @AuraEnabled public Integer ScheduledCases {get; set;}
        @AuraEnabled public Integer MorningCases {get; set;}
        @AuraEnabled public Integer AfternoonCases {get; set;}
        @AuraEnabled public String dateRange {get; set;}
        @AuraEnabled public String Email {get; set;}
        @AuraEnabled public <String,Integer> procedureList {get; set;}
        @AuraEnabled public Map<String,Integer> casList {get; set;}
        
    }*/
    @AuraEnabled
    public static string  getPerDayAvlOfCAS(String TerritoryId, String DateSelected)
    {
        system.debug('------------>TerritoryId ' +TerritoryId + '--------------> DateSelected ' +DateSelected);
        
        
        List<Availability_Of_CAS_OneMDCS__c> getDailyAvlCAS = new List<Availability_Of_CAS_OneMDCS__c>();
        
        for(Availability_Of_CAS_OneMDCS__c objPDA: [SELECT CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name, Comment_OneMDCS__c, Date_assigned_OneMDCS__c,AM_Boolean_to_Text_OneMDCS__c, PM_Boolean_to_Text_OneMDCS__c, Default_OneMDCS__c, AM_OneMDCS__c, PM_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Default_OneMDCS__c = 'N' AND Territory_OneMDCS__c =: TerritoryId /*AND Date_assigned_OneMDCS__c >=: Date.today()*/])
        {
            if( (!objPDA.AM_OneMDCS__c) || (!objPDA.PM_OneMDCS__c) || (!objPDA.AM_OneMDCS__c && !objPDA.PM_OneMDCS__c) )
            {
                getDailyAvlCAS.add(objPDA);
            }
        }
       return  JSON.serialize(getDailyAvlCAS);
    }
     @AuraEnabled
    public static List<String> customEventSlot()
    {
        
        List<String> eventSlot=new List<String>();
        String totalslot='';
        Available_Services_OneMDCS__c avlservice=[SELECT Selected_Time_Slots_AM_OneMDCS__c,Selected_Time_Slots_PM_OneMDCS__c FROM Available_Services_OneMDCS__c WHERE Name =: 'Default Slot Settings']; 
        totalslot=avlservice.Selected_Time_Slots_AM_OneMDCS__c+';'+avlservice.Selected_Time_Slots_PM_OneMDCS__c;
        system.debug(totalslot);
        eventSlot= totalslot.split(';');
        if(eventSlot.contains('04:00 AM')){
        	eventSlot.remove(eventSlot.indexOf('04:00 AM'));	    
        }
        if(eventSlot.contains('04:30 AM')){
        	eventSlot.remove(eventSlot.indexOf('04:30 AM'));	    
        }
        return eventSlot;           
        
    }
    public class EventWrapper{
        
        @TestVisible private Date eventdate ;
        @TestVisible private String startTime ;
        @TestVisible private String endTime ;
        @TestVisible private String eventName;
        @TestVisible private String territory;
		@TestVisible private String eventDescription;
    }
    
    @AuraEnabled
    public static Boolean customEventCreate(String eventdetail){
        List<EventWrapper> eventwrapObjlist =(List<EventWrapper>)JSON.deserialize(eventdetail,List<EventWrapper>.class);
        List<Finalize_Schedule_Per_Territory_OneMDCS__c> eventList = new List<Finalize_Schedule_Per_Territory_OneMDCS__c>() ;
                
        for( EventWrapper evnt : eventwrapObjlist){
            Finalize_Schedule_Per_Territory_OneMDCS__c eventObj = new Finalize_Schedule_Per_Territory_OneMDCS__c();
            eventObj.Subject__c = evnt.eventName;
            eventObj.Date_OneMDCS__c = evnt.eventdate;
            eventObj.State_Time__c = evnt.startTime;
            eventObj.End_Time__c = evnt.endTime;
            eventObj.Territory_OneMDCS__c = evnt.territory;
			eventObj.Description_OneMDCS__c = evnt.eventDescription;
            eventList.add(eventObj);
        }
        insert eventList;
        return true;
    }
    
    @AuraEnabled
    public static String getEventlist( String Territory){
        return(new JNJ_Admin_Calender_helper_OneMDCS().getEventString(Territory));
    }

    
    // For Event Record Updation
    @AuraEnabled
    public static Finalize_Schedule_Per_Territory_OneMDCS__c EventUpdation( String eventrecordupdate )
    {
        Finalize_Schedule_Per_Territory_OneMDCS__c lstPositionRecord = new Finalize_Schedule_Per_Territory_OneMDCS__c();
        if(!string.isBlank(eventrecordupdate))
        {
            lstPositionRecord = (Finalize_Schedule_Per_Territory_OneMDCS__c)System.JSON.deserialize(eventrecordupdate,Finalize_Schedule_Per_Territory_OneMDCS__c.class);
            if(lstPositionRecord != null)
            {   
                Update lstPositionRecord;
            }
        }
        return lstPositionRecord;
    }
}