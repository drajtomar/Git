public class customLookUpController {
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String searchForProfile) 
    {
        system.debug('ObjectName--> ' + ObjectName);
        system.debug('searchForProfile--> ' + searchForProfile);
        String searchKey = searchKeyWord + '%';
        //String profileName = 'Clinical Account Specialist';
        List<ID> getCASProfId = new List<Id>();
        if(searchForProfile != null && searchForProfile != '')
        {
            if(searchForProfile == 'Out of Territory CAS')
            {	
                //UltraSound Profile to be Added
                for(Profile pf:[SELECT Id from Profile where Name IN ('Clinical Account Specialist','BWI Case Scheduler','Custom SP Profile','Ultra Sound CAS')])
                {
                    getCASProfId.add(pf.Id);
                }
            }
            if(searchForProfile == 'Trainee CAS')
            {
                //Trainee Cas Profile & UltraSound Profile to be Added 
                for(Profile pf:[SELECT Id from Profile where Name IN ('Trainee CAS','Ultra Sound CAS','Clinical Account Specialist','BWI Case Scheduler','Custom SP Profile')])
                {
                    getCASProfId.add(pf.Id);
                }
            }
        }
        
        
        system.debug('******>>>>getCASProfId '+getCASProfId);
        List < sObject > returnList = new List < sObject > ();
        String sQuery;
        String DefaultCheckBox = 'Y';
        
        String sCondition=String.escapeSingleQuotes('Name LIKE: searchKey AND ProfileId IN : getCASProfId AND isActive = true order by createdDate DESC limit 10');
        sQuery =  'select id, Name from ' +ObjectName + ' where ';
        system.debug('**************>>>>> '+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery+sCondition);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}