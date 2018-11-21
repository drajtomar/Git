public with sharing class ClassVfpageAsPerProfile 
{
    public ClassVfpageAsPerProfile() 
        {
    userprofile=[select u.Profile.Name, id from User u where u.id = :Userinfo.getUserId()].Profile.Name;
     ExcludefromContactSharing=false;
        }

   public string userprofile;
    public boolean ExcludefromContactSharing;
   
    public pagereference Mymethod()
   {
    PageReference p ;
    list<Profile__c> listProfile=[select id,name from Profile__c];
  
    for(Profile__c  profile : listProfile)
     {
       if(userprofile==Profile.Name)
       {           
            ExcludefromContactSharing=true;
       }
     }
  
    
    if(ExcludefromContactSharing)
    {
        p = new PageReference('/003');
    }    
   else
    {
          p = new PageReference('/apex/ContactsView');
     }
       return p;
     }
}