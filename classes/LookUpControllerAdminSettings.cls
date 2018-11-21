public class LookUpControllerAdminSettings {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,String TerritoryId) {
        
        List<Territory> TerritoryNameSelected = new List<Territory>();
        TerritoryNameSelected = [SELECT Id,Name,ParentTerritoryId FROM Territory WHERE Id =: TerritoryId limit 1];
        
        Set<String> territories = new Set<String>();
        List<Account> listAccount = new List<Account>();
        for(Territory childTerritory: [SELECT Id, Name, External_Territory_Id__c FROM Territory WHERE ParentTerritoryId =: TerritoryNameSelected[0].ParentTerritoryId ])
        {
            territories.add(childTerritory.External_Territory_Id__c);
        }
        
        
        system.debug('ObjectName-->' + ObjectName);
        system.debug('TerritoryId-->' + TerritoryId);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        String sCondition= String.escapeSingleQuotes('(Name LIKE: searchKey OR JDE_JJHCS_Number__c LIKE: searchKey) AND Territory__c Not IN:territories  order by Name limit 10');
        String sQuery =  'select id, Name, JDE_JJHCS_Number__c from ' +ObjectName + ' where ';
        List < sObject > lstOfRecords = Database.query(sQuery+sCondition);
        //List < sObject > lstOfRecords = [select id, Name from Account where Name LIKE:' +searchKey+ ' order by createdDate DESC limit 5'];
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}