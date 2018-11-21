public class bwicaseCommunityLoader_OneMDCS
{
   
    @AuraEnabled
    public static string getSpecificProfileName()
    {
        List<User> userList = new List<User>();
        string profId ='';
        string profName='';
        userList = [SELECT ProfileId from User where id=:userInfo.getUserId() Limit 1];
        if(!userList.isEmpty())
        {
            profId = userList[0].profileId;
        }
        Profile prof = new Profile();
        prof = [SELECT NAME FROM PROFILE WHERE ID=:profId limit 1];
        if(prof!=null)
        {
            profName = prof.Name;
        }
        return profName;
    }
    
 
    
    
}