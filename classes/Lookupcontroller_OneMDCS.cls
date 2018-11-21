public without sharing class Lookupcontroller_OneMDCS {
    public Lookupcontroller_OneMDCS() {

    }
    @AuraEnabled
    public static List<sObject> querySalesforceRecord(String queryString) {
        system.debug('---->queryString '+queryString);
        String escqueryString = String.escapeSingleQuotes(queryString);
        return Database.query(escqueryString);
    }
	
	@AuraEnabled
    public static List<sObject> queryAccountRecord(String searchKeyWord, String objectName, String TerritoryId) {
         List<Territory> TerritoryNameSelected = new List<Territory>();
        TerritoryNameSelected = [SELECT Id,Name,ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        
        Id ParentTerId;
        
        Map<String, Combine_Territory__c> allterritories = Combine_Territory__c.getAll();
		Set<String> hiretrset = new Set<String>();
		
		for(Combine_Territory__c ter : allterritories.values()){		
			hiretrset.add(ter.Old_Name__c);
		}
        for(territory tr : TerritoryNameSelected){
            if(hiretrset.contains(tr.Name)){		
                ParentTerId = tr.Id;               
            }
            else{
                ParentTerId = tr.ParentTerritoryId;
            }
        }
        
        
        Set<String> territories = new Set<String>();
        List<Account> listAccount = new List<Account>();
        for(Territory childTerritory: [SELECT Id, Name, External_Territory_Id__c FROM Territory WHERE ParentTerritoryId =: ParentTerId ])
        {
            territories.add(childTerritory.External_Territory_Id__c);
        }
        
        
        system.debug('ObjectName-->' + objectName);
        system.debug('TerritoryId-->' + TerritoryId);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        String sCondition= String.escapeSingleQuotes('(Name LIKE: searchKey OR JDE_JJHCS_Number__c LIKE: searchKey) AND Territory__c Not IN:territories  order by Name limit 10');
        String sQuery =  'select id, Name, JDE_JJHCS_Number__c from ' +objectName + ' where ';
        List < sObject > lstOfRecords = Database.query(sQuery+sCondition);
        //List < sObject > lstOfRecords = [select id, Name from Account where Name LIKE:' +searchKey+ ' order by createdDate DESC limit 5'];
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<sObject> queryAccountRecordforAppointment(String searchKeyWord, String objectName, List<Appointment_OneMDCS__c> CurrentAppointmentList) {
        Set<String> AccountNames = new Set<String>();
		for(Appointment_OneMDCS__c appo : CurrentAppointmentList)
		{
            if(appo.Location_Encrypted_OneMDCS__c != null){
				AccountNames.add(appo.Location_Encrypted_OneMDCS__c);
            }    
		}
        
        system.debug('ObjectName-->' + objectName);
        system.debug('AccountNames-->' + AccountNames);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        String Scondition=String.escapeSingleQuotes('(Name LIKE: searchKey OR JDE_JJHCS_Number__c LIKE: searchKey) AND Name IN:AccountNames  order by Name limit 10');
        String sQuery =  'select id, Name, JDE_JJHCS_Number__c from ' +objectName + ' where ';
        List < sObject > lstOfRecords = Database.query(sQuery+Scondition);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}