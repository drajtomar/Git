/**
* -------------------------------------------------------------------------------------------------+
* This class is used for sending an email after appointment creation, appointment modification, appointment cancellation, CAS assignment and Secondary CAS assignment.
*
* --------------------------------------------------------------------------------------------------
* @author         Souvik Kundu   
* @modifiedBy     Souvik Kundu   
* @maintainedBy   Souvik Kundu 
* @version        1.1
* @created        2017-09-13
* @modified       2018-08-08
* --------------------------------------------------------------------------------------------------
* @changes
* v1.0            Souvik Kundu 
* 2017-09-13      This class is used for sending an email after appointment creation, appointment modification, appointment cancellation, CAS assignment and Secondary CAS assignment.
*                 
*
* v1.1            Souvik Kundu 
* 2018-08-08      Sending email to Territory Manager and BWI case Scheduler profile Users. 
*                 
* -------------------------------------------------------------------------------------------------+
*/

public class SendEmailToAdminHelper_OneMDCS
{    
    //Method to send email to admin for new case
    public static void sendEmailToAdminNewCase(List<Appointment_OneMDCS__c> newCaseAppo, Set<Id> UserId, String EmailAddresses)
    {
        List<String> sendTo = new List<String>();
        List<User> getUserDtls = new List<User>();
        User getNameOfUser;
		
        getUserDtls = [SELECT Id, Name, Email_Settings_OneMDCS__c, Email from User where Id IN: UserId AND IsActive =: true];
        sendTo = sendEmailTo(getUserDtls);
                
        if(newCaseAppo[0].For_Customer_OneMdcs__c == null)
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName from User where id =:newCaseAppo[0].OwnerId  AND IsActive =: true];
        }
        else
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName from User where id =:newCaseAppo[0].For_Customer_OneMdcs__c AND IsActive =: true];
        }
        
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
        
        List<Appointment_OneMDCS__c> newCaseAppoDateTime = new List<Appointment_OneMDCS__c>();
        newCaseAppoDateTime = [SELECT Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where Id=:newCaseAppo[0].Id];
        
        
		DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
		system.debug('formattedDate-->'+formattedDate);
		String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
           	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CARTO® Case '+newCaseAppo[0].Name + ' Successfully Scheduled for Dr. ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c);
            mail.setHtmlBody('Hello,<br/><br/>' + 'Thank you for scheduling a case with the Biosense Webster, Inc. team for Dr.' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '.' + '<br/><br/><br/>Your case ID # in the Biosense Webster scheduling application is: ' + newCaseAppo[0].Name +'.' + '<br/> <br/>'+ 'Date and Time :     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>Physician :     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>Location :     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c + '<br/><br/>If you need to make changes to your scheduled case, please log into: www.biosensewebster.com.' + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. representative. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team' + '<br/><br/><font size="1">Note: This is a system generated message. Please do not reply to this email.</font>' + '<br><br><a target="_blank" href="https://jnjinstitute.myabsorb.com/files/0dc2848e-2ebd-4c6e-9cb1-b2870d7c380f/JJPrivacy Policy.pdf"><font size="1">Privacy Policy</font></a>' + '<br/><br/>' 
                             +'<font size="1">© Johnson & Johnson Services, Inc. 2017. All rights reserved. <br/>080207-170912</font>');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    
    //Method to send email for Cancelled appointments.
    public static void sendEmailToAdminCancelCase(List<Appointment_OneMDCS__c> cancelCaseAppo, Set<Id> UserId, String EmailAddresses)
    {
        List<String> sendTo = new List<String>();
        List<User> getUserDtls = new List<User>();
        User getNameOfUser;
		
        getUserDtls = [SELECT Id, Name, Email_Settings_OneMDCS__c, Email from User where Id IN: UserId AND IsActive =: true];
        sendTo = sendEmailTo(getUserDtls);
        
        if(cancelCaseAppo[0].For_Customer_OneMdcs__c == null)
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName, Name from User where id =:cancelCaseAppo[0].OwnerId AND IsActive =: true];
        }
        else
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName, Name from User where id =:cancelCaseAppo[0].For_Customer_OneMdcs__c AND IsActive =: true];
        }
        
        String Request = '';
        if(cancelCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = cancelCaseAppo[0].Request_OneMDCS__c;
        }
        
        List<Appointment_OneMDCS__c> cancelCaseAppoDateTime = new List<Appointment_OneMDCS__c>();
        cancelCaseAppoDateTime = [SELECT Appointment_Date_OneMDCS__c from Appointment_OneMDCS__c where Id=:cancelCaseAppo[0].Id];
        
        // Datetime formattedDate = (DateTime)cancelCaseAppoDateTime[0].Appointment_Date_OneMDCS__c;
        
        DateTime formattedDate = datetime.newInstance(cancelCaseAppoDateTime[0].Appointment_Date_OneMDCS__c.Year(),cancelCaseAppoDateTime[0].Appointment_Date_OneMDCS__c.month(),cancelCaseAppoDateTime[0].Appointment_Date_OneMDCS__c.day()) ;
        system.debug('formattedDate-->'+formattedDate);
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CARTO® Case ' + cancelCaseAppo[0].Name + ' for Dr. ' + cancelCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + ' Successfully Cancelled' );
            mail.setHtmlBody('Hello,<br/><br/>' + 'Please use this email as confirmation of the cancellation of case ' + cancelCaseAppo[0].Name + ' for Dr. '  + cancelCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + ',you previously scheduled with the Biosense Webster, Inc. team.<br/><br/>'+ 'Date and Time :     ' + formattedDateString + ':'+ cancelCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + cancelCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>Physician :     ' + cancelCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>Location :     ' + cancelCaseAppo[0].Location_Encrypted_OneMDCS__c + '<br/><br/>Reason for cancellation : '+ cancelCaseAppo[0].Reason_OneMDCS__c + '<br/><br/>To reserve a new case please login to: www.biosensewebster.com and check for availability.' + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. representative. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team' + '<br/><br/><font size="1">Note: This is a system generated message. Please do not reply to this email.</font>' + '<br><br><a target="_blank" href="https://jnjinstitute.myabsorb.com/files/0dc2848e-2ebd-4c6e-9cb1-b2870d7c380f/JJPrivacy Policy.pdf"><font size="1">Privacy Policy</font></a>' + '<br/><br/>' 
                             +'<font size="1">© Johnson & Johnson Services, Inc. 2017. All rights reserved. <br/>080207-170912</font>');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    
    //Method to send email for appointment modification.
    public static void sendEmailToAdminModifiedCase(List<Appointment_OneMDCS__c> newModifyCaseAppo, List<Appointment_OneMDCS__c> oldModifyCaseAppo, Set<Id> UserId, String EmailAddresses)
    {
        List<String> sendTo = new List<String>();
        List<User> getUserDtls = new List<User>();
        User getNameOfUser;
		
        getUserDtls = [SELECT Id, Name, Email_Settings_OneMDCS__c, Email from User where Id IN: UserId AND IsActive =: true];
        sendTo = sendEmailTo(getUserDtls);
        
        if(newModifyCaseAppo[0].For_Customer_OneMdcs__c == null)
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName, Name from User where id =:newModifyCaseAppo[0].OwnerId AND IsActive =: true];
        }
        else
        {
            getNameOfUser = new User();
            getNameOfUser = [Select Id, FirstName, LastName, Name from User where id =:newModifyCaseAppo[0].For_Customer_OneMdcs__c AND IsActive =: true];
        }
        
        String RequestNew = '';
        if(newModifyCaseAppo[0].Request_OneMDCS__c != null)
        {
            RequestNew = newModifyCaseAppo[0].Request_OneMDCS__c;
        }
        
        String RequestOld = '';
        if(oldModifyCaseAppo[0].Request_OneMDCS__c != null)
        {
            RequestOld = oldModifyCaseAppo[0].Request_OneMDCS__c;
        }
        
        // Datetime formattedDateNew = (DateTime)newModifyCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDateNew = datetime.newInstance(newModifyCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newModifyCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newModifyCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateStringNew = formattedDateNew.format('MM/dd/yyyy');
        
        // Datetime formattedDateOld = (DateTime)oldModifyCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDateOld = datetime.newInstance(oldModifyCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),oldModifyCaseAppo[0].Appointment_Date_OneMDCS__c.month(),oldModifyCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateStringOld = formattedDateOld.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CARTO® Case' + newModifyCaseAppo[0].Name + ' for Dr. ' + newModifyCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + ' Successfully Changed' );
            mail.setHtmlBody('Hello,<br/><br/>' + 'Please use this email as confirmation to the changes you made to case ' + newModifyCaseAppo[0].Name + ' for Dr. '  + newModifyCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + ',you reserved with the Biosense Webster, Inc. team.<br/><br/>' + 'Date and Time :     ' + formattedDateStringNew + ':'+ newModifyCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newModifyCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>Physician :     ' + newModifyCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>Location :     ' + newModifyCaseAppo[0].Location_Encrypted_OneMDCS__c  +'<br/><br/>Reason for Modification : '+ newModifyCaseAppo[0].Reason_OneMDCS__c+ '<br/><br/>To make further changes, please log into: www.biosensewebster.com.' + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. representative. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team' + '<br/><br/><font size="1">Note: This is a system generated message. Please do not reply to this email.</font>' + '<br><br><a target="_blank" href="https://jnjinstitute.myabsorb.com/files/0dc2848e-2ebd-4c6e-9cb1-b2870d7c380f/JJPrivacy Policy.pdf"><font size="1">Privacy Policy</font></a>' + '<br/><br/>' 
                             +'<font size="1">© Johnson & Johnson Services, Inc. 2017. All rights reserved. <br/>080207-170912</font>');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email to CAS for CAS assignment to case.
    public static void sendEmailToCASAssigned(List<Appointment_OneMDCS__c> newCaseAppo,Set<String> UserId, Availability_Of_CAS_OneMDCS__c NewDetails)
    {        
        List<String> sendTo = new List<String>();
        sendTo.AddAll(UserId);        
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }        
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        system.debug('formattedDate-->'+formattedDate);
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS assigned');
            mail.setHtmlBody('Dear ' + NewDetails.CAS_Team_OneMDCS__r.Name +' <br/><br/>' + 'Please use this email as confirmation of the case assigned to you.<br/><br/>' + '<br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email to CAS for CAS re-assignment to case.
    public static void sendEmailToCASReAssigned(List<Appointment_OneMDCS__c> newCaseAppo, List<Appointment_OneMDCS__c> oldCaseAppo, Set<String> UserId, Availability_Of_CAS_OneMDCS__c NewDetails, Availability_Of_CAS_OneMDCS__c OldDetails)
    {
        
        List<String> sendTo = new List<String>();
        sendTo.AddAll(UserId);
        
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }        
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS assigned');
            mail.setHtmlBody('Dear ' + NewDetails.CAS_Team_OneMDCS__r.Name +' <br/><br/>' + 'Please use this email as confirmation that the following case is now assigned to ' + OldDetails.CAS_Team_OneMDCS__r.Name + '<br/><br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    //Method to send email for CAS cancelling a case.
    public static void sendEmailToCASCancel(List<Appointment_OneMDCS__c> newCaseAppo,Set<String> UserEmail, Availability_Of_CAS_OneMDCS__c objAvlCAS)
    {
        List<String> sendTo = new List<String>();
        sendTo.AddAll(UserEmail);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            //mail.setSubject('CAS cancelled');
            mail.setSubject('Case ' + newCaseAppo[0].Name + ' is cancelled'); // change for ADUV-175
            mail.setHtmlBody('Dear ' + objAvlCAS.CAS_Team_OneMDCS__r.Name +' <br/><br/>' + 'Please use this email as confirmation of the cancellation of the case you were assigned.<br/><br/>' +'Reason for Cancellation : '+ newCaseAppo[0].Reason_OneMDCS__c + '<br/><br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email when CAS modified a case.
    public static void sendEmailToCASModified(List<Appointment_OneMDCS__c> newCaseAppo, List<Appointment_OneMDCS__c> oldCaseAppo, Set<String> UserId, Availability_Of_CAS_OneMDCS__c objAvlCAS)
    {
        List<String> sendTo = new List<String>();
        sendTo.AddAll(UserId);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
                
        Datetime formattedDateOld = (DateTime)oldCaseAppo[0].Appointment_Date_OneMDCS__c;
        String formattedDateStringOld = formattedDateOld.format('MM/dd/yyyy');
        
        String RequestOld = '';
        if(oldCaseAppo[0].Request_OneMDCS__c != null)
        {
            RequestOld = oldCaseAppo[0].Request_OneMDCS__c;
        }
                
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS case modified');
            mail.setHtmlBody('Dear ' + objAvlCAS.CAS_Team_OneMDCS__r.Name +' <br/><br/>' + 'Please use this email as confirmation of the modification to a case you were assigned to.<br/><br/>' +'Reason for Modification : '+ newCaseAppo[0].Reason_OneMDCS__c + '<br/><br/><b>Details of updated case below:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/><b>Details of original case below :</b><br/> <br/>' 
                             + 'EMAIL:     ' + oldCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateStringOld + ':'+ oldCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + oldCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + oldCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + oldCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + oldCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + RequestOld + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email for secondary CAS modification.
    public static void sendEmailToCASModifiedSecondary(List<Appointment_OneMDCS__c> newCaseAppo, List<Appointment_OneMDCS__c> oldCaseAppo, User objUserDtls)
    {
        List<String> sendTo = new List<String>();
        sendTo.Add(objUserDtls.Email);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
                
        Datetime formattedDateOld = (DateTime)oldCaseAppo[0].Appointment_Date_OneMDCS__c;
        String formattedDateStringOld = formattedDateOld.format('MM/dd/yyyy');
        
        String RequestOld = '';
        if(oldCaseAppo[0].Request_OneMDCS__c != null)
        {
            RequestOld = oldCaseAppo[0].Request_OneMDCS__c;
        }
                
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS case modified');
            mail.setHtmlBody('Dear ' + objUserDtls.Name +' <br/><br/>' + 'Please use this email as confirmation of the modification to a case you were assigned to.<br/><br/>' +'Reason for Modification : ' + newCaseAppo[0].Reason_OneMDCS__c + '<br/><br/><b>Details of updated case below:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/><b>Details of original case below :</b><br/> <br/>' 
                             + 'EMAIL:     ' + oldCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateStringOld + ':'+ oldCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + oldCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + oldCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + oldCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + oldCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + RequestOld + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email on cancellation for secondary CAS.
    public static void sendEmailToCASCancelSecondary(List<Appointment_OneMDCS__c> newCaseAppo, User objUserDtls)
    {
        List<String> sendTo = new List<String>();
        sendTo.Add(objUserDtls.Email);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
                
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            //mail.setSubject('CAS cancelled');
            mail.setSubject('Case ' + newCaseAppo[0].Name + ' is cancelled'); // change for ADUV-175
            mail.setHtmlBody('Dear ' + objUserDtls.Name +' <br/><br/>' + 'Please use this email as confirmation of the cancellation of the case you were assigned.<br/><br/>' +'Reason for Cancellation : ' + newCaseAppo[0].Reason_OneMDCS__c + '<br/><br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email to CAS for CAS assignment to case.
    public static void sendEmailToCASAssignedSecondary(List<Appointment_OneMDCS__c> newCaseAppo, User objUserDtls)
    {
        List<String> sendTo = new List<String>();
        sendTo.Add(objUserDtls.Email);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
                
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS assigned');
            mail.setHtmlBody('Dear ' + objUserDtls.Name +' <br/><br/>' + 'Please use this email as confirmation of the case assigned to you.<br/><br/>' + '<br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //Method to send email to Secondary CAS for secondary CAS re-assignment to case.
    public static void sendEmailToCASReAssignedSecondary(List<Appointment_OneMDCS__c> newCaseAppo, User objUserDtlsNew, User objUserDtls)
    {
        List<String> sendTo = new List<String>();
        sendTo.Add(objUserDtls.Email);
        sendTo.Add(objUserDtlsNew.Email);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
        
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS assigned');
            mail.setHtmlBody('Dear ' + objUserDtls.Name +' <br/><br/>' + 'Please use this email as confirmation that the following case is now assigned to ' + objUserDtlsNew.Name + '<br/><br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    
    //ADUV-213
    //Method to send email to CAS for CAS unassignment to case.
    public static void sendEmailToCASUnAssigned(List<Appointment_OneMDCS__c> newCaseAppo, Set<String> userEmail, Availability_Of_CAS_OneMDCS__c NewDetails)
    {
        List<String> sendTo = new List<String>();
        sendTo.AddAll(userEmail);
        String Request = '';
        if(newCaseAppo[0].Request_OneMDCS__c != null)
        {
            Request = newCaseAppo[0].Request_OneMDCS__c;
        }
        
        // Datetime formattedDate = (DateTime)newCaseAppo[0].Appointment_Date_OneMDCS__c;
        DateTime formattedDate = datetime.newInstance(newCaseAppo[0].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[0].Appointment_Date_OneMDCS__c.month(),newCaseAppo[0].Appointment_Date_OneMDCS__c.day()) ;
        String formattedDateString = formattedDate.format('MM/dd/yyyy');
        if(!sendTo.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
            //mail.setSenderDisplayName('BWI Case Scheduler');
            mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
            mail.setSubject('CAS Unassigned');
            mail.setHtmlBody('Dear ' + NewDetails.Name +' <br/><br/>' + 'Please use this email as confirmation that the following case is now unassigned from you. ' + '<br/><br/><b>Details about your scheduled case:</b><br/> <br/>' 
                             + 'EMAIL:     ' + newCaseAppo[0].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[0].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[0].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[0].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[0].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[0].Location_Encrypted_OneMDCS__c
                             +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }    
    }
    //Send Email to Territory Manager on Case Cancellation
    public static void sendEmailToTMCancelCase(List<Appointment_OneMDCS__c> newCaseAppo)
    {	
        List<Messaging.SingleEmailMessage> maillist = new List<Messaging.SingleEmailMessage>();
        Map<String,String> terusermap = new Map<String,String>();
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<Id, String> terr = new Map<Id, String>();
        List<Id> userlist = new List<Id>();
        List<Id> emailsetuser = new List<Id>();
        for(Territory tr : [SELECT Id,Name FROM Territory]){
            terr.put(tr.Id, tr.Name);
        }		
        
        for(UserTerritory userterr : [SELECT TerritoryId,UserId FROM UserTerritory WHERE IsActive = true AND UserId IN (SELECT Id FROM User WHERE Profile.Name IN ('Territory Manager'))]){
            if(terr.containsKey(userterr.TerritoryId)){
                String uster = userterr.UserId+'-'+userterr.TerritoryId;
                terusermap.put(uster,terr.get(userterr.TerritoryId));
            }  
            if(!userlist.contains(userterr.UserId)){
                userlist.add(userterr.UserId);
            }
        }
        
        for(User objUser: [SELECT Id, Email_Settings_OneMDCS__c from User where Id IN: userlist  AND IsActive =: true])
        {    
            Set<String> sendToEmailPrefSet = new Set<String>();
            if(objUser.Email_Settings_OneMDCS__c != null)
            {
                sendToEmailPrefSet.addAll(objUser.Email_Settings_OneMDCS__c.split(';'));
            }
            if(sendToEmailPrefSet.contains('Cancelled Request'))
            {
                emailsetuser.add(objUser.Id);
            }            
        }
        
        for(Integer i=0; i<newCaseAppo.size(); i++){
            
            List<String> UpdatedTerritoryName = new List<String>{newCaseAppo[i].Territory_OneMDCS__c};    
                String Request = '';
            
            if(newCaseAppo[i].Request_OneMDCS__c != null){
                Request = newCaseAppo[i].Request_OneMDCS__c;
            }
            	
            DateTime formattedDate = datetime.newInstance(newCaseAppo[i].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[i].Appointment_Date_OneMDCS__c.month(),newCaseAppo[i].Appointment_Date_OneMDCS__c.day()) ;
            String formattedDateString = formattedDate.format('MM/dd/yyyy');
            
            
            for(Combine_Territory__c ter : allterritories.values()){        
                if(ter.Name == newCaseAppo[i].Territory_OneMDCS__c){
                    UpdatedTerritoryName.clear();
                    UpdatedTerritoryName = ter.Territory__c.split(';');
                }
            }
            
            for(String userId : terusermap.keySet()){
                if(UpdatedTerritoryName.contains(terusermap.get(userId))){					
                    List<String> userkey = userId.split('-');
                    if(emailsetuser.contains(userkey[0])){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        mail.setTargetObjectId(userkey[0]);	   
                        mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
                        mail.setSubject('Case ' + newCaseAppo[i].Name + ' is cancelled'); // change for ADUV-175
                        mail.setHtmlBody('Hello, <br/><br/>' + 'Case ' + newCaseAppo[i].Name + ' is cancelled.<br/><br/>'  +'Reason for Cancellation : '+ newCaseAppo[i].Reason_OneMDCS__c + '<br/><br/><b>Details about the case:</b><br/> <br/>' 
                                         + 'EMAIL:     ' + newCaseAppo[i].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[i].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[i].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[i].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[i].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[i].Location_Encrypted_OneMDCS__c
                                         +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
                        mail.setSaveAsActivity(false);
                        maillist.add(mail);
                    }	
                }	
            }
        }
        Messaging.sendEmail(maillist);
    }
    
    //Send Email to Territory Manager and BWI Case Scheduler on Case Creation
    public static void sendEmailToTMandBCSNewCase(List<Appointment_OneMDCS__c> newCaseAppo)
    {
        List<Messaging.SingleEmailMessage> maillist = new List<Messaging.SingleEmailMessage>();
        Map<String,String> terusermap = new Map<String,String>();
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<Id, String> terr = new Map<Id, String>();
        List<Id> userlist = new List<Id>();
        List<Id> emailsetuser = new List<Id>();
        for(Territory tr : [SELECT Id,Name FROM Territory]){
            terr.put(tr.Id, tr.Name);
        }
        
        
        for(UserTerritory userterr : [SELECT TerritoryId,UserId FROM UserTerritory WHERE IsActive = true AND UserId IN (SELECT Id FROM User WHERE Profile.Name IN ('Territory Manager','BWI Case Scheduler'))]){
            if(terr.containsKey(userterr.TerritoryId)){
                String uster = userterr.UserId+'-'+userterr.TerritoryId;
                terusermap.put(uster,terr.get(userterr.TerritoryId));
            }  
            if(!userlist.contains(userterr.UserId)){
                userlist.add(userterr.UserId);
            }
        }
        
        for(User objUser: [SELECT Id, Email_Settings_OneMDCS__c from User where Id IN: userlist AND IsActive =: true])
        {   
            Set<String> sendToEmailPrefSet = new Set<String>();
            if(objUser.Email_Settings_OneMDCS__c != null)
            {
                sendToEmailPrefSet.addAll(objUser.Email_Settings_OneMDCS__c.split(';'));
            }
            if(sendToEmailPrefSet.contains('Created'))
            {
                emailsetuser.add(objUser.Id);
            }            
        }
        system.debug('emailsetuser-->'+emailsetuser);
        for(Integer i=0; i<newCaseAppo.size(); i++){
            
            List<String> UpdatedTerritoryName = new List<String>{newCaseAppo[i].Territory_OneMDCS__c};    
                String Request = '';
            
            if(newCaseAppo[i].Request_OneMDCS__c != null){
                Request = newCaseAppo[i].Request_OneMDCS__c;
            }
            	
            DateTime formattedDate = datetime.newInstance(newCaseAppo[i].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[i].Appointment_Date_OneMDCS__c.month(),newCaseAppo[i].Appointment_Date_OneMDCS__c.day()) ;
            String formattedDateString = formattedDate.format('MM/dd/yyyy');
            
            for(Combine_Territory__c ter : allterritories.values()){        
                if(ter.Name == newCaseAppo[i].Territory_OneMDCS__c){
                    UpdatedTerritoryName.clear();
                    UpdatedTerritoryName = ter.Territory__c.split(';');
                }
            }
            
            for(String userId : terusermap.keySet()){
                system.debug('terusermap-->'+userId+'-->'+terusermap.get(userId));
                if(UpdatedTerritoryName.contains(terusermap.get(userId))){	
                    
                    List<String> userkey = userId.split('-');
                    if(emailsetuser.contains(userkey[0])){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        mail.setTargetObjectId(userkey[0]);	   
                        mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
                        mail.setSubject('New Case ' + newCaseAppo[i].Name + ' is created');
                        mail.setHtmlBody('Hello,<br/><br/> ' + 'A new Case ' + newCaseAppo[i].Name + ' is created.<br/><br/>' + '<br/><b>Details about the case:</b><br/> <br/>' 
                                         + 'EMAIL:     ' + newCaseAppo[i].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[i].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[i].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[i].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[i].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[i].Location_Encrypted_OneMDCS__c
                                         +'<br/><br/>REQUEST:     ' + Request + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
                        mail.setSaveAsActivity(false);
                        maillist.add(mail);
                    }	
                }	
            }
        }
        Messaging.sendEmail(maillist);
    }
    
    //Send Email to Territory Manager for modify Case
    public static void sendEmailToTMModifiedCase(List<Appointment_OneMDCS__c> newCaseAppo, Map<Id, Appointment_OneMDCS__c> oldCaseAppo)
    {
        List<Messaging.SingleEmailMessage> maillist = new List<Messaging.SingleEmailMessage>();
        Map<String,String> terusermap = new Map<String,String>();
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<Id, String> terr = new Map<Id, String>();
        List<Id> userlist = new List<Id>();
        List<Id> emailsetuser = new List<Id>();
        
        for(Territory tr : [SELECT Id,Name FROM Territory]){
            terr.put(tr.Id, tr.Name);
        }
        
        for(UserTerritory userterr : [SELECT TerritoryId,UserId FROM UserTerritory WHERE IsActive = true AND UserId IN (SELECT Id FROM User WHERE Profile.Name IN ('Territory Manager'))]){
            if(terr.containsKey(userterr.TerritoryId)){
                String uster = userterr.UserId+'-'+userterr.TerritoryId;
                terusermap.put(uster,terr.get(userterr.TerritoryId));
            }  
            if(!userlist.contains(userterr.UserId)){
                userlist.add(userterr.UserId);
            }
        }
        
        for(User objUser: [SELECT Id, Email_Settings_OneMDCS__c from User where Id IN: userlist AND IsActive =: true])
        {        
            Set<String> sendToEmailPrefSet = new Set<String>();
            if(objUser.Email_Settings_OneMDCS__c != null)
            {
                sendToEmailPrefSet.addAll(objUser.Email_Settings_OneMDCS__c.split(';'));
            }
            if(sendToEmailPrefSet.contains('Modified'))
            {
                emailsetuser.add(objUser.Id);
            }               
        }
        
        for(Integer i=0; i<newCaseAppo.size(); i++){
            
            List<String> UpdatedTerritoryName = new List<String>{newCaseAppo[i].Territory_OneMDCS__c};    
                
            String Request = '';
            if(newCaseAppo[i].Request_OneMDCS__c != null)
            {
                Request = newCaseAppo[i].Request_OneMDCS__c;
            }
            
            String RequestOld = '';
            if(oldCaseAppo.get(newCaseAppo[i].Id).Request_OneMDCS__c != null)
            {
                RequestOld = oldCaseAppo.get(newCaseAppo[i].Id).Request_OneMDCS__c;
            }
            
            for(Combine_Territory__c ter : allterritories.values()){        
                if(ter.Name == newCaseAppo[i].Territory_OneMDCS__c){
                    UpdatedTerritoryName.clear();
                    UpdatedTerritoryName = ter.Territory__c.split(';');
                }
            }					
            
            Datetime formattedDateOld = (DateTime)oldCaseAppo.get(newCaseAppo[i].Id).Appointment_Date_OneMDCS__c;
            String formattedDateStringOld = formattedDateOld.format('MM/dd/yyyy');
            
            DateTime formattedDate = datetime.newInstance(newCaseAppo[i].Appointment_Date_OneMDCS__c.Year(),newCaseAppo[i].Appointment_Date_OneMDCS__c.month(),newCaseAppo[i].Appointment_Date_OneMDCS__c.day()) ;
            String formattedDateString = formattedDate.format('MM/dd/yyyy');
            
            for(String userId : terusermap.keySet()){
                if(UpdatedTerritoryName.contains(terusermap.get(userId))){					
                    List<String> userkey = userId.split('-');
                    if(emailsetuser.contains(userkey[0])){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        mail.setTargetObjectId(userkey[0]);	   
                        mail.setOrgWideEmailAddressId(System.Label.Organization_Wide_Addresses);
                        mail.setSubject('Case ' + newCaseAppo[i].Name + ' is modified.');
                        mail.setHtmlBody('Hello, <br/><br/>' + 'Case ' + newCaseAppo[i].Name + ' is modified.<br/><br/>' +'Reason for Modification : '+ newCaseAppo[i].Reason_OneMDCS__c + '<br/><br/><b>Details of updated case below:</b><br/> <br/>' 
                                         + 'EMAIL:     ' + newCaseAppo[i].Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateString + ':'+ newCaseAppo[i].Appointment_start_time_12hrs_OneMDCS__c + '-' + newCaseAppo[i].Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + newCaseAppo[i].Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + newCaseAppo[i].Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + newCaseAppo[i].Location_Encrypted_OneMDCS__c
                                         +'<br/><br/>REQUEST:     ' + Request + '<br/><br/><b>Details of original case below :</b><br/> <br/>' 
                                         + 'EMAIL:     ' + oldCaseAppo.get(newCaseAppo[i].Id).Email_OneMDCS__c + '<br/><br/>DATE AND TIME:     ' + formattedDateStringOld + ':'+ oldCaseAppo.get(newCaseAppo[i].Id).Appointment_start_time_12hrs_OneMDCS__c + '-' + oldCaseAppo.get(newCaseAppo[i].Id).Appointment_end_time_12_hrs_OneMDCS__c + '<br/><br/>PHYSICIAN:     ' + oldCaseAppo.get(newCaseAppo[i].Id).Name_Of_Physician_Encrypted_OneMDCS__c + '<br/><br/>PROCEDURE TYPE:     ' + oldCaseAppo.get(newCaseAppo[i].Id).Procedure_Name_Encrypted_OneMDCS__c + '<br/><br/>LOCATION:     ' + oldCaseAppo.get(newCaseAppo[i].Id).Location_Encrypted_OneMDCS__c
                                         +'<br/><br/>REQUEST:     ' + RequestOld + '<br/><br/>If you have any questions, please contact your Biosense Webster, Inc. scheduling admin. ' + '<br/><br/>Thank You,' + '<br/><br/>Biosense Webster, Inc. Team');
                        mail.setSaveAsActivity(false);
                        maillist.add(mail);
                    }	
                }	
            }
        }
        Messaging.sendEmail(maillist);
    }	    
    //Return Additional Email
    Public Static String AdditionalEmail(List<Appointment_OneMDCS__c> newappodata){
        String EmailsFromRequest = null;
        if(newappodata[0].Additional_Email_OneMDCS__c != null && newappodata[0].Additional_Email_OneMDCS__c != '')
        {
            if(newappodata[0].Additional_Email_OneMDCS__c.Contains(';'))
            {
                List<String> getAdditionalEmail = new List<String>();
                getAdditionalEmail = newappodata[0].Additional_Email_OneMDCS__c.Split(';');
                for(String objEmailStr : getAdditionalEmail)
                {
                    if(EmailsFromRequest == null)
                    {
                        EmailsFromRequest = objEmailStr;
                    }       
                    else
                    {
                        EmailsFromRequest = EmailsFromRequest + ',' + objEmailStr;
                    }
                }
            }
            else
            {
                EmailsFromRequest = newappodata[0].Additional_Email_OneMDCS__c;
            }
        }
        EmailsFromRequest = EmailsFromRequest + ',' + newappodata[0].Email_OneMDCS__c;
        return EmailsFromRequest;
    }
	// Return email list to whom mail will be sent
	Public Static List<String> sendEmailTo(List<User> getUserDtls){
		Set<String> sendToEmailSet = new Set<String>();
		List<String> sendTo = new List<String>();
		Set<String> sendToEmailPrefSet = new Set<String>();
        List<String> getUserPrefEmail = new List<String>();
		String EmailAddresses;
		for(User objUser: getUserDtls)
		{
			sendToEmailPrefSet = new Set<String>();
			if(objUser.Email_Settings_OneMDCS__c != null)
			{
				sendToEmailPrefSet.addAll(objUser.Email_Settings_OneMDCS__c.split(';'));
			}
			if(sendToEmailPrefSet.contains('New Request'))
			{
				sendToEmailSet.add(objUser.email);
			}
		}
		
		if(EmailAddresses != null && EmailAddresses != '')
		{
			getUserPrefEmail = new List<String>();
			if(EmailAddresses.contains(','))
			{
				getUserPrefEmail = EmailAddresses.split(',');
			}
			else
			{
				getUserPrefEmail.add(EmailAddresses);
			}
			if(!getUserPrefEmail.isEmpty())
			{
				sendToEmailSet.addAll(getUserPrefEmail);
			}
		}
		
		if(!sendToEmailSet.isEmpty())
		{
			for(String objStrEmail: sendToEmailSet)
			{
				
				if(objStrEmail != 'null' && objStrEmail != '')
				{
					sendTo.add(objStrEmail);
				}
			}
		}
		system.debug('---------Send to Email '+sendTo);
		return sendTo;
	}	
	 
}