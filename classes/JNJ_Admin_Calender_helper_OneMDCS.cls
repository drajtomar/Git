/**
* -------------------------------------------------------------------------------------------------+
* This class is helper class of JNJ_Admin_Calender_Controller class. It returns booked appointment data to display on Calendar.
*
* --------------------------------------------------------------------------------------------------
* @author         Souvik Kundu   
* @modifiedBy     Souvik Kundu   
* @maintainedBy   Souvik Kundu 
* @version        1.1
* @created        2017-08-17
* @modified       2018-05-27
* --------------------------------------------------------------------------------------------------
* @changes
* v1.0            Souvik Kundu 
* 2017-08-17      This class is helper class of JNJ_Admin_Calender_Controller class. It returns appointment data to display on Calendar.
*                 
*
* v1.1            Souvik Kundu 
* 2018-05-27      Fetches booked Event data and return to JNJ_Admin_Calender_Controller class to show the data in Calendar.
*                 
* -------------------------------------------------------------------------------------------------+
*/
public class JNJ_Admin_Calender_helper_OneMDCS{

    // :::: Populated Booked slot of Appointment
    public String  getBookedDateString( String customerTerritory ){
        
        Set<BookPTOWrapper> BookWrapList2 = new Set<BookPTOWrapper>();
		List<Appointment_OneMDCS__c> appomap = new List<Appointment_OneMDCS__c>();
        Set<String>  appointmentstatus = new Set<String>();
            appointmentstatus.add( 'Unassigned' );
            appointmentstatus.add( 'Confirmed' );
            appointmentstatus.add( 'High Competetion Zone' );
                    
		Integer next_days = Integer.valueOf(label.next_n_days);                    
        Integer last_days = Integer.valueOf(label.last_n_days);   
        appomap = Database.query('SELECT Id,Appointment_Start_time_OneMDCS__c,Appointment_end_time_OneMDCS__c,Appointment_Date_OneMDCS__c,Name,Territory_OneMDCS__c,Location_Encrypted_OneMDCS__c,Assigned_CAS_OneMDCS__c,Assigned_CAS_OneMDCS__r.Name,Procedure_Name_Encrypted_OneMDCS__c,Header_Note_OneMDCS__c, Request_OneMDCS__c,Status_OneMDCS__c,Assigned_CAS_OneMDCS__r.Color_of_User__c, Name_Of_Physician_Encrypted_OneMDCS__c FROM Appointment_OneMDCS__c WHERE (Appointment_Date_OneMDCS__c = NEXT_N_DAYS : '+next_days+' OR Appointment_Date_OneMDCS__c = LAST_N_DAYS: '+ last_days +') AND Territory_OneMDCS__c =:customerTerritory  AND Status_OneMDCS__c in: appointmentstatus ') ;
                   
        if( !appomap.IsEmpty() ){
                        
            for( Appointment_OneMDCS__c  appo : appomap ){
                            
                String appostartString = String.valueOf( appo.Appointment_Date_OneMDCS__c ) + 'T' +  appo.Appointment_Start_time_OneMDCS__c  + ':00' ;
                String appoendString = String.valueOf( appo.Appointment_Date_OneMDCS__c ) + 'T'  + appo.Appointment_end_time_OneMDCS__c  + ':00' ;
                BookWrapList2.add( new BookPTOWrapper( appostartString , appoendString, appo.Location_Encrypted_OneMDCS__c, appo.Procedure_Name_Encrypted_OneMDCS__c, appo.Assigned_CAS_OneMDCS__r.Name,appo.Assigned_CAS_OneMDCS__r.Color_of_User__c ,appo.Header_Note_OneMDCS__c,appo.Name_Of_Physician_Encrypted_OneMDCS__c ) ) ;
                }
        }
                    
                    // BookWrapList2.add( new BookPTOWrapper( String.valueOf(evItr.StartDateTime) , String.valueOf( evItr.EndDateTime) ) ) ;
    
        return JSON.serialize(BookWrapList2) ;
    }
    
    
    public class BookPTOWrapper{
        public String startString    {get;set;}
        public String endString    {get;set;}
        public String location    {get;set;}
        public String procedureType    {get;set;}
        public String casName    {get;set;}
        public String color {get;set;}
        public String headernote    {get;set;}
		public String physician {get;set;}

        
        public BookPTOWrapper( String startString, String endString, String location, String procedureType, String casName, String color,String headernote, String physician){
            this.startString = startString ;
            this.endString = endString ;
            this.location = location ;
            this.procedureType = procedureType;
            this.physician = physician;
          
            if(casName != null && casName != ''){
                this.casName = casName;
            }
            else{
                this.casName = '';
			}	
            this.color = color;
            if(headernote!= null && headernote!= ''){            
                this.headernote= headernote;
            }
             else{
                this.headernote= '';
            }            	
        }    
    }
	
	//Returns booked event data
	public String  getEventString( String Territory ){
		List<bookevent> bookeventlist = new List<bookevent>();
		
		for(Finalize_Schedule_Per_Territory_OneMDCS__c objPDA: [SELECT Subject__c, Date_OneMDCS__c, State_Time__c, End_Time__c, Description_OneMDCS__c from Finalize_Schedule_Per_Territory_OneMDCS__c where Territory_OneMDCS__c =: Territory ])
        {
			String starttime = objPDA.State_Time__c;
			String endtime = objPDA.End_Time__c;
			if(starttime.contains('PM')){
				if(starttime.substring(0,2) != '12'){
					starttime = String.valueOf(Integer.valueOf(starttime.substring(0,2)) + 12) + starttime.substring(2,5);
				}
				else{
					starttime = starttime.substring(0,5);
				}
			}
			else{
				starttime = starttime.substring(0,5);
			}
			
			if(endtime.contains('PM')){
				if(endtime.substring(0,2) != '12'){
					endtime = String.valueOf(Integer.valueOf(endtime.substring(0,2)) + 12) + endtime.substring(2,5);
				}
				else{
					endtime = endtime.substring(0,5);
				}
			}
			else{
				endtime = endtime.substring(0,5);
			}
			
			String eventstart = String.valueOf( objPDA.Date_OneMDCS__c ) + 'T' +  starttime  + ':00' ;
			String eventend = String.valueOf( objPDA.Date_OneMDCS__c ) + 'T' +  endtime  + ':00' ;
			bookeventlist.add(new bookevent(objPDA.Subject__c,eventstart,eventend,objPDA.Description_OneMDCS__c));
        }
		return JSON.serialize(bookeventlist) ;
	}
	
	public class bookevent{
        public String eventsubject    {get;set;}
        public String eventstart   {get;set;}		
		public String eventend    {get;set;}
		public String eventdescription    {get;set;}
		
		public bookevent(String eventsubject, String eventstart, String eventend, String eventdescription ){
			this.eventstart = eventstart;
			this.eventend = eventend;
			this.eventsubject = eventsubject;

            if(eventdescription!= null && eventdescription!= ''){            
                this.eventdescription= eventdescription;
            }
            else{
                this.eventdescription= '';
            }    
            
		}
	}
}