public class appointmentProcess_Admin_Helper_OneMDCS{


    //::::::::::::::::::::::::::::::::::::   This method returns all the Appointments ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    public List<Appointment_OneMDCS__c> getAllAppointmentList( String customerTerritory ){
        
        
        
        Set<String>  appointmentstatus = new Set<String>();
        
        appointmentstatus.add( 'Rejected' );
        appointmentstatus.add( 'Cancelled' );
        
        List<Appointment_OneMDCS__c> appointmentList = [SELECT Appointment_Start_time_OneMDCS__c,Appointment_end_time_OneMDCS__c,Appointment_Date_OneMDCS__c,Territory_OneMDCS__c,                  
                            Assigned_CAS_OneMDCS__c,Location_Encrypted_OneMDCS__c,Name_Of_Physician_Encrypted_OneMDCS__c,
                            Procedure_Name_Encrypted_OneMDCS__c,Service_Hours_OneMDCS__c , Status_OneMDCS__c
                            FROM Appointment_OneMDCS__c WHERE 
                            Appointment_Date_OneMDCS__c >= TODAY AND Territory_OneMDCS__c =:customerTerritory 
                            //AND Location__c =: customerLocation
                            AND Status_OneMDCS__c not in: appointmentstatus ] ;
        
        
        return  appointmentList ;
    }
     // :::: Populated Booked slot
   // public Set<BookPTOWrapper>  getBookedDateString( String customerTerritory ){
      public String  getBookedDateString( String customerTerritory ){
        
        
        //Set<BookPTOWrapper> BookWrapList2 = new Set<BookPTOWrapper>();
        List<BookPTOWrapper> BookWrapList2 = new List<BookPTOWrapper>();
                    
        List<Appointment_OneMDCS__c> appointmentList = getAllAppointmentList( customerTerritory ) ;   
        
        if( appointmentList !=null && appointmentList.size()>0 ){
            
            for( Appointment_OneMDCS__c  appo : appointmentList ){
                
                String appostartString = String.valueOf( appo.Appointment_Date_OneMDCS__c ) + 'T' +  appo.Appointment_Start_time_OneMDCS__c  + ':00' ;
                String appoendString = String.valueOf( appo.Appointment_Date_OneMDCS__c ) + 'T'  + appo.Appointment_end_time_OneMDCS__c  + ':00' ;
                BookWrapList2.add( new BookPTOWrapper( appostartString , appoendString , appo.Location_Encrypted_OneMDCS__c , appo.Procedure_Name_Encrypted_OneMDCS__c  ) ) ;
            }
        }
                    
                    // BookWrapList2.add( new BookPTOWrapper( String.valueOf(evItr.StartDateTime) , String.valueOf( evItr.EndDateTime) ) ) ;
    
        //return BookWrapList2 ;
        return JSON.serialize(BookWrapList2);
    }
    


    public class BookPTOWrapper{
        public String startString    {get;set;}
        public String endString    {get;set;}
        public String location    {get;set;}
        public String procedureType    {get;set;}
        
        public BookPTOWrapper( String startString, String endString , String location , String procedureType ){
            this.startString = startString ;
            this.endString = endString ;
            this.location = location ;
            this.procedureType = procedureType ;
        }
    
    }

}