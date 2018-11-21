public with sharing class JnJ_Admin_LinkCustomer_OneMDCS_Helper {
	    
    public class entityWrapper
    {
        
        @AuraEnabled public string entityName;
        @AuraEnabled public string entityId;
        
        public entityWrapper()
        {
            entityName = '';
            entityId = '';
        }
    }
	
	//Fetch Account data if Entity type is Hospital. If entity type is Physician then values from Contact Detail custom settings are fetches.
    @AuraEnabled
    public static List<entityWrapper> fetchentityval(String entitytype, String territoryName){
        List<entityWrapper> entitylist =  new List<entityWrapper>();
        Map<String, String> entityoldmap =  new Map<String, String>();
        List<Id> acclist = new List<Id>();        
        String UpdatedTerritoryName = fetchterritory(territoryName);
    
        for(Account ac : [SELECT Id,Name FROM Account WHERE Primary_Territory__c =:UpdatedTerritoryName]){
            if( ac.Id != null ){
                acclist.add(ac.Id);
                entityWrapper enw = new entityWrapper();
				enw.entityName = ac.Name;
				enw.entityId = ac.Id;
				entitylist.add(enw);
            }    
        }
        if(entitytype == 'Physician'){
            entitylist.clear();
            if(!acclist.isEmpty()){
                for(Contact_Details_OneMDCS__c cd : [SELECT Id, Contact_Name__c, Contact_Id_OneMDCS__c FROM Contact_Details_OneMDCS__c WHERE Hospital_Id_OneMDCS__c IN: acclist AND Contact_Type_OneMDCS__c = 'EP' ORDER BY Contact_Name__c]){                    					
                    if(!entityoldmap.containsKey(cd.Contact_Id_OneMDCS__c)){
                        entityoldmap.put(cd.Contact_Id_OneMDCS__c, cd.Contact_Name__c);
                    }                   
                }
                system.debug('entityoldmap-->'+entityoldmap);
                for(String conId : entityoldmap.keySet()){
                    entityWrapper enw = new entityWrapper();					
					enw.entityId = conId;
                    enw.entityName = entityoldmap.get(conId);
                    entitylist.add(enw);
                }
                system.debug('entitylist-->'+entitylist);
        	}
        }
        return entitylist;
    }
	
	//Check if it's a combined territory and return the name of the territory.
	@AuraEnabled
    public static String fetchterritory(String territoryName){		        
		String UpdatedTerritoryName = '';		
		List<Territory> TerritoryNameCalendar = [SELECT Id, Name, ParentTerritoryId FROM Territory WHERE Id =: territoryName limit 1];
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
		return UpdatedTerritoryName;
	}
	
	public class custWrapper
    {
        
        @AuraEnabled public string custName;
        @AuraEnabled public string custId;
		@AuraEnabled public boolean isSelected;
        
        public custWrapper()
        {
            custName = '';
            custId = '';
			isSelected = false;
        }
    }
	
	//If any customer working on the selected Hospital or Physician then fetch those customers.
    @AuraEnabled
    public static List<custWrapper> fetchcustomerlist(String entitytype,String entityvalue,String territoryName){
		List<custWrapper> userlist = new List<custWrapper>();
		Set<Id> userset = new Set<Id>();
        Set<User> accuserset = new Set<User>();
		//Profile pf = [SELECT Id FROM Profile WHERE name =:'External User - Customer Case Scheduler'];
        List<String> statuslist = new List<String>{'Rejected','Cancelled'};
		String UpdatedTerritoryName = fetchterritory(territoryName);
        
        List<Customer_Link_OneMDCS__c> custlinkedlist = new List<Customer_Link_OneMDCS__c>();
        for(Customer_Link_OneMDCS__c cl : [SELECT Id, Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Entity_Type__c =:entitytype AND Entity_Name__c =: entityvalue and Territory__c =: UpdatedTerritoryName]){
            if(cl.Id != null){
                custlinkedlist.add(cl);
            }
        }    
		
		if(entitytype == 'Physician'){
			for(Appointment_OneMDCS__c appo : [SELECT Name_Of_Physician_Encrypted_OneMDCS__c, OwnerID, Id FROM Appointment_OneMDCS__c WHERE Territory_OneMDCS__c =:UpdatedTerritoryName AND Status_OneMDCS__c NOT IN:statuslist]){
				if(appo.Name_Of_Physician_Encrypted_OneMDCS__c == entityvalue){
					userset.add(appo.OwnerID);
				}	
			}
			
			if(!userset.isEmpty()){
				for(User cust : [SELECT Id, Name from User WHERE profile.Name =:'External User - Customer Case Scheduler' AND Id IN: userset]){	
                    if(!custlinkedlist.isEmpty()){
                        for(Integer i = 0; i<custlinkedlist.size(); i++){
                            if(!custlinkedlist[i].Affiliations__c.contains(cust.Id)){
                                custWrapper cw = new custWrapper();
                                cw.custName = cust.Name;
                                cw.custId = cust.Id;
                                cw.isSelected = false;
                                userlist.add(cw);
                            }      
                        } 
                    }
                    else{
                        custWrapper cw = new custWrapper();
                        cw.custName = cust.Name;
                        cw.custId = cust.Id;
                        cw.isSelected = false;
                        userlist.add(cw);
                    }                 
				}
			}
		}
		else{
			String accid = '%'+entityvalue;
			for(User u : [SELECT Id, Name from User WHERE profile.Name =:'External User - Customer Case Scheduler' AND Id IN (SELECT OwnerID FROM Appointment_OneMDCS__c WHERE Account_Information_OneMDCS__c LIKE :accid AND Territory_OneMDCS__c =:UpdatedTerritoryName)]){
				if(u.Id != null){
					accuserset.add(u);
				}
			}
			if(!accuserset.isEmpty()){
				for(User cust : accuserset){
                    if(!custlinkedlist.isEmpty()){
                        for(Integer i = 0; i<custlinkedlist.size(); i++){
                            if(!custlinkedlist[i].Affiliations__c.contains(cust.Id)){
                                custWrapper cw = new custWrapper();
                                cw.custName = cust.Name;
                                cw.custId = cust.Id;
                                cw.isSelected = false;
                                userlist.add(cw);
                            }      
                        } 
                    }
                    else{
                        custWrapper cw = new custWrapper();
                        cw.custName = cust.Name;
                        cw.custId = cust.Id;
                        cw.isSelected = false;
                        userlist.add(cw);
                    }        
				}
			}
		}
		return userlist;     
    }
    
    //Insert Customer Link data
    @AuraEnabled
    public static Boolean savelinkedcustomer(String entitytype,String entityvalue,String territoryName,String affiliations){
        String UpdatedTerritoryName = fetchterritory(territoryName);
        List<Customer_Link_OneMDCS__c> custlinkedlist = new List<Customer_Link_OneMDCS__c>();
        for(Customer_Link_OneMDCS__c cl : [SELECT Id, Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Entity_Type__c =:entitytype AND Entity_Name__c =: entityvalue and Territory__c =: UpdatedTerritoryName]){
            if(cl.Id != null){
                cl.Affiliations__c = cl.Affiliations__c + ';' + affiliations;
                custlinkedlist.add(cl);
            }
        }
        if(!custlinkedlist.isEmpty()){
            update custlinkedlist;
        }
        else{
        	Customer_Link_OneMDCS__c cl = new Customer_Link_OneMDCS__c();
            cl.Affiliations__c = affiliations;
            cl.Entity_Type__c = entitytype;
            cl.Entity_Name__c = entityvalue;
            cl.Territory__c = fetchterritory(territoryName);
            insert cl; 	   
        }       
        return true;
    }
    
    public class custlinkWrapper
    {
        
        @AuraEnabled public string custLinkName;
        @AuraEnabled public string custLinkId;
		@AuraEnabled public boolean isSelected;
        
        public custlinkWrapper()
        {
            custLinkName = '';
            custLinkId = '';
			isSelected = false;
        }
    }
    
    //Fetch Customer Link data for slected entity
    @AuraEnabled
    public static List<custlinkWrapper> fetchlinkedcustomerlist(String entitytype,String entityvalue,String territoryName){
        List<custlinkWrapper> custlinklist = new List<custlinkWrapper>();
        
        Map<String,String> usermap = new Map<String,String>();        
        String selectedloc = fetchterritory(territoryName);
        
        
        for(User u : [SELECT Id, Name from User WHERE profile.Name =:'External User - Customer Case Scheduler']){
            usermap.put(u.Id, u.Name);
        }
        
        for(Customer_Link_OneMDCS__c cl : [SELECT Id, Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Entity_Type__c =:entitytype AND Entity_Name__c =: entityvalue and Territory__c =: selectedloc]){
            if(cl.Id != null){
                String affiliations = '';
                List<String> exuserlist = cl.Affiliations__c.split(';');
                for(String usrid : exuserlist){
                    if(usermap.containsKey(usrid)){
                        affiliations = affiliations + usermap.get(usrid) + ', ';
                    }
                }
                custlinkWrapper clw = new custlinkWrapper();
                clw.custLinkName = affiliations.substring(0, affiliations.length()-2);
                clw.custLinkId = cl.Id;
                clw.isSelected = false;
                custlinklist.add(clw);
            }
        }
        return custlinklist;
    }
    //Delete Customer linked records.
    @AuraEnabled
    public static Boolean removelinkedcustomer(String affiliationid, String custlist){
        List<Customer_Link_OneMDCS__c> custlinklist = new List<Customer_Link_OneMDCS__c>();
        
        String affiliation = '';
        if(custlist != ''){
            List<String> Linkedcustlist = custlist.split(', ');        
            for(User u : [SELECT Id, Name from User WHERE profile.Name =:'External User - Customer Case Scheduler']){
                if(Linkedcustlist.contains(u.Name)){
                    affiliation = affiliation + u.Id + ';';
                }
            }
            affiliation = affiliation.substring(0,affiliation.length()-1);
        }
        
        if(affiliationid != null){
            for(Customer_Link_OneMDCS__c custlink : [SELECT Id,Affiliations__c FROM Customer_Link_OneMDCS__c WHERE Id =: affiliationid]){
                if(custlink.Id != null){
                    if(affiliation != ''){
                        custlink.Affiliations__c = affiliation;
                    }                    
                	custlinklist.add(custlink);    
                }                
            }
        }
        if(!custlinklist.isEmpty()){
            if(affiliation == '' || affiliation == null || !affiliation.containsAny(';')){
            	delete custlinklist;
            }    
            else{
                update custlinklist;
            }    
        }
        return true;
    }
    
}