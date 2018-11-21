@isTest
public class JnJ_Admin_LinkCustomer_OneMDCS_Test {

    public static User adminuser(){
        return [Select Id from user where profile.Name = 'System Administrator' and isActive = true limit 1];
    }    
    
	public static Territory createTerritoryTestData() {        
        Territory territoryData = new Territory();
        territoryData.External_Territory_Id__c = 'test1';
        territoryData.Name = 'Test Territory';
        insert territoryData;
        return territoryData ;
    } 
    
	public static Account insertaccount(){
        Territory tr = createTerritoryTestData();
        User u = adminuser();
        Account acc = new Account();
        system.runAs(u){            
            acc.Name = 'Test1 Acc1';
            acc.Primary_Territory__c = tr.Name;
            insert acc;
        }    
		return acc;
	}
	
	public static Contact insertcontact(){
        Account acc = insertaccount();
		Contact con = new Contact();
        User u = adminuser();
        system.runAs(u){
            con.FirstName = 'Test';
            con.LastName = 'Con1';
            con.Email = 'test1@test.com';
            con.NPI__c = '1232333333';
            con.AccountId = acc.Id;
            insert con;
        }    
        return con ;
	}
    
	public static Contact_Details_OneMDCS__c insertcontdetail(){
		Contact_Details_OneMDCS__c cd = new Contact_Details_OneMDCS__c();
        Contact con = insertContact();
        Account acc = insertAccount();
		cd.name = 'CON-5644';
		cd.Contact_Id_OneMDCS__c = con.id;
		cd.Hospital_Id_OneMDCS__c = acc.id;
		cd.Contact_Type_OneMDCS__c = 'EP';
		cd.Contact_Name__c = [SELECT Name FROM Contact WHERE id =: con.Id].Name;
		insert cd;
		return cd;
	}	
    
	public static User getUserRecord(String profileName){
		String uatProfileId = [SELECT Id FROM Profile WHERE Name =: profileName ].Id;
        Contact con = insertcontact();
		User uatuser = new User();        
		uatuser.CompanyName = 'J&J Application Services' ;
		uatuser.External_User_Id__c =  '643019306' ;
		uatuser.LastName = 'last'+System.currentTimeMillis();
        uatuser.FirstName = 'First';
		uatuser.Email = 'puser000@amamama.com';
		uatuser.Username = 'puser000@amamama.com' + System.currentTimeMillis() ;
		uatuser.CompanyName = 'TEST' ;
		uatuser.Title = 'title' ;
		uatuser.Alias = 'alias' ;
		uatuser.TimeZoneSidKey = 'America/Los_Angeles' ; 
		uatuser.EmailEncodingKey = 'UTF-8' ; 
		uatuser.LanguageLocaleKey = 'en_US' ;
		uatuser.LocaleSidKey = 'en_US' ; 
        uatuser.ContactId = con.Id;
		uatuser.ProfileId = uatProfileId ;       
		insert uatuser ;        
		return uatuser  ;    
	}
    
	public static Appointment_OneMDCS__c createAppointmentTestData(Date appoDate,String location,String physicianName,String procedureName,String serviceHours,
	String status,String email,String additionalEmail,String additionalEmailOther,String appoStartTime12Hours,String appoEndTime12Hours,String appoStartTime,String appoEndTime,String territory, String ownerid, String accid)
	{
		Appointment_OneMDCS__c objAppFuture = new Appointment_OneMDCS__c();
		objAppFuture.Appointment_Date_OneMDCS__c = appoDate;
		objAppFuture.Location_Encrypted_OneMDCS__c = location;
		objAppFuture.Name_Of_Physician_Encrypted_OneMDCS__c = physicianName;
		objAppFuture.Procedure_Name_Encrypted_OneMDCS__c = procedureName;
		objAppFuture.Service_Hours_OneMDCS__c = serviceHours;
		objAppFuture.Status_OneMDCS__c = status;
		objAppFuture.Email_OneMDCS__c = email;
		objAppFuture.Additional_Email_OneMDCS__c = additionalEmail;
        objAppFuture.Additional_Email_Other_OneMDCS__c = additionalEmailOther;
		objAppFuture.Appointment_start_time_12hrs_OneMDCS__c = appoStartTime12Hours;
		objAppFuture.Appointment_end_time_12_hrs_OneMDCS__c = appoEndTime12Hours;
		objAppFuture.Appointment_Start_time_OneMDCS__c = appoStartTime;
		objAppFuture.Appointment_end_time_OneMDCS__c = appoEndTime;
		objAppFuture.Territory_OneMDCS__c = territory;
        objAppFuture.Reason_OneMDCS__c = 'Test Reason';
		objAppFuture.OwnerID = ownerid;
        objAppFuture.Account_Information_OneMDCS__c = accid;
		insert objAppFuture;
        return objAppFuture;
	}
	
    public static testMethod void insertcustomerlink(){
		List<Customer_Link_OneMDCS__c> cllist = new List<Customer_Link_OneMDCS__c>();
        Territory terr;
        Contact con;
        Account ac;
        User u1;
        User u2; 
        User u3;
        User u = adminuser();
        system.runAs(u){    
            terr = createTerritoryTestData();
            con = insertcontact();
            ac = insertaccount();
            
            u1 = getUserRecord('External User - Customer Case Scheduler');
            u2 = getUserRecord('External User - Customer Case Scheduler');        
            u3 = getUserRecord('External User - Customer Case Scheduler');
            
            String affilation = u1.Id+';'+u2.Id;
                
            Customer_Link_OneMDCS__c cl1 = new Customer_Link_OneMDCS__c();
            cl1.Affiliations__c = affilation;
            cl1.Entity_Name__c = con.Name;
            cl1.Entity_Type__c = 'Physician';
            cl1.Territory__c = terr.Name;
            cllist.add(cl1);
            
            Customer_Link_OneMDCS__c c2 = new Customer_Link_OneMDCS__c();
            c2.Affiliations__c = affilation;
            c2.Entity_Name__c = ac.Id;
            c2.Entity_Type__c = 'Hospital';
            c2.Territory__c = terr.Name;
            cllist.add(c2);
            insert cllist;	
            String accnameid = ac.Name+':'+ac.Id;
            Appointment_OneMDCS__c appo = createAppointmentTestData(date.Today(),ac.Name,con.Name,'Test Procedure','4 Hours','Unassigned',
            'test@test.test','test@test.test;test@test.test;test@test.test','test@test.test','04:00 AM','08:00 AM','04:00','08:00',terr.Name,u1.Id,accnameid);
            Appointment_OneMDCS__c appo1 = createAppointmentTestData(date.Today(),ac.Name,con.Name,'Test1 Procedure','4 Hours','Assigned',
            'test@test.test','test@test.test;test@test.test;test@test.test','test@test.test','04:00 AM','08:00 AM','04:00','08:00',terr.Name,u2.Id,accnameid);
            Appointment_OneMDCS__c appo2 = createAppointmentTestData(date.Today(),ac.Name,con.Name,'Test1 Procedure','4 Hours','Assigned',
            'test@test.test','test@test.test;test@test.test;test@test.test','test@test.test','04:00 AM','08:00 AM','04:00','08:00',terr.Name,u3.Id,accnameid);
        }
		Test.startTest();
		JnJ_Admin_LinkCustomer_OneMDCS_Helper jnjlnkcst = new JnJ_Admin_LinkCustomer_OneMDCS_Helper();
		
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.entityWrapper> cslnkaccentval = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchentityval('Hospital',terr.Id);
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.entityWrapper> cslnkconentval = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchentityval('Physician',terr.Id);
		        
		Customer_Link_OneMDCS__c cls = [SELECT Id,Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Entity_Type__c = 'Hospital' limit 1];
		Boolean bn2 = JnJ_Admin_LinkCustomer_OneMDCS_Helper.savelinkedcustomer('Hospital',ac.Id,terr.Id,cls.Affiliations__c);
        String Affiliations = cls.Affiliations__c+';'+u2.Id;
        Boolean bn1 = JnJ_Admin_LinkCustomer_OneMDCS_Helper.savelinkedcustomer('Hospital',ac.Id,terr.Id,Affiliations);
        
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.custWrapper> cslnkacccst = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchcustomerlist('Hospital',ac.Id,terr.Id);
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.custWrapper> cslnkconcst = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchcustomerlist('Physician',con.Name,terr.Id);
		System.assertEquals(1, cslnkacccst.size());
				
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.custlinkWrapper> cslnkacccstlink = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchlinkedcustomerlist('Hospital',ac.Id,terr.Id);
		List<JnJ_Admin_LinkCustomer_OneMDCS_Helper.custlinkWrapper> cslnkconcstlink = JnJ_Admin_LinkCustomer_OneMDCS_Helper.fetchlinkedcustomerlist('Physician',con.Name,terr.Id);
		String users = [Select Name from User where Id =: u1.Id].Name;
        Customer_Link_OneMDCS__c cstlnk = [SELECT Id,Affiliations__c FROM Customer_Link_OneMDCS__c limit 1];
		Boolean bn3 = JnJ_Admin_LinkCustomer_OneMDCS_Helper.removelinkedcustomer(cstlnk.Id, users);
		Test.stopTest();
    }
         
}