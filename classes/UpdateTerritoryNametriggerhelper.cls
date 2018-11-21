/**
* -------------------------------------------------------------------------------------------------+
* This class is used as helper class of User Trigger.
*
* --------------------------------------------------------------------------------------------------
* @author         Souvik Kundu   
* @modifiedBy     Souvik Kundu   
* @maintainedBy   Souvik Kundu 
* @version        1.1
* @created        2018-02-28
* @modified       2018-08-28                
* -------------------------------------------------------------------------------------------------+
*/

public class UpdateTerritoryNametriggerhelper{
    //Fetching combine Territory values
    public static Map<String,String> getcombineterritory(){
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
        Map<String,String> hierarchytr = new Map<String,String>();  
        for(Combine_Territory__c ter : allterritories.values()){        
            List<String> territories = ter.Territory__c.split(';') ;
            for(String terstr : territories){
                hierarchytr.put(terstr.trim(), ter.Name);
            }
        }
        return hierarchytr;
    }
    //Updating primary territory for User
    public static void UpdateTerritoryName(List<User> userlist){
        Set<id> ProfileIds = new Set<id>();
        Set<id> ContactIds = new Set<id>();
        for (User u : userlist)
        {
            ProfileIds.add(u.ProfileId);   
            ContactIds.add(u.ContactId); 
        }
        Map<id, Profile> Profiles = new Map<id, Profile>([Select Name from Profile Where Id in :ProfileIds]);  
        list<Contact> Contactslist = [Select Account.Territory__c from Contact Where Id in :ContactIds]; // Campaign sObjects we are dealing with
        map<Id, String> mapContacts = new map<Id, String>(); // Mapping Campaign Names to Campaign IDs
        
        for (Contact c:Contactslist){
            mapContacts.put(c.Id,c.Account.Territory__c);
        }
        list<Territory> theTerritories = [SELECT External_Territory_Id__c,Name FROM Territory where External_Territory_Id__c in :mapContacts.values()];
        map<String, String> mapTerritories = new map<String, String>(); // Mapping Campaign Names to Campaign IDs
        Map<String,String> hierarchytr = getcombineterritory();
        String UpdatedTerritoryName = '';
        for (Territory t:theTerritories) {
            if(hierarchytr.containsKey(t.Name)){
                UpdatedTerritoryName = hierarchytr.get(t.Name);
            }
            else{
                UpdatedTerritoryName = t.Name;
            }
            mapTerritories.put(t.External_Territory_Id__c,UpdatedTerritoryName);
        }
        for (User u : userlist){     
            if(Profiles.get(u.ProfileId).Name.equals('External User - Customer Case Scheduler')){           
                if(!Contactslist.isEmpty() && mapContacts.get(u.ContactId) != null && mapContacts.get(u.ContactId)!= '')
                {             
                    if(!theTerritories.isEmpty() && mapTerritories.get(mapContacts.get(u.ContactId)) != null && mapTerritories.get(mapContacts.get(u.ContactId)) != '')
                    {
                        u.Primary_Territory_OneMDCS__c = mapTerritories.get(mapContacts.get(u.ContactId));
                        
                    }
                }           
            }
        }
    }
    
    //Delete Availability of CAS data when a user is inactive.
    public static void DeleteCASavlforinactiveuser(List<User> userlist){
		List<Id> inactiveuserlist = new List<Id>();		
        for(User u : userlist){
			if(u.IsActive == false){
				inactiveuserlist.add(u.Id);
			}
		}
		if(!inactiveuserlist.isEmpty()){
            deletecasavlinfuture(inactiveuserlist);			
		}
		
    }
	
    //Delete Availability of CAS data when a user is inactive through future method to avoid mixed DML.
    @future
    public static void deletecasavlinfuture(List<Id> inactiveuserlist){
        List<Availability_Of_CAS_OneMDCS__c> AvlCASlist = new List<Availability_Of_CAS_OneMDCS__c>();
    	for(Availability_Of_CAS_OneMDCS__c avl : [SELECT Id FROM Availability_Of_CAS_OneMDCS__c WHERE CAS_Team_OneMDCS__c IN: inactiveuserlist]){
            if(avl.Id != null){
                AvlCASlist.add(avl);
            }
        }
    	if(!AvlCASlist.isEmpty()){
			Delete AvlCASlist;
		}
    }    
}