/*
Created By   : Balu Venkateshwarlu
Description  : Redirecting to dashboards tab based on logged in user
Created Date : 10th oct 2018
*/
  public class CerenovusProfiles {
    public List<String> allProfileCNV{get;set;}
     public CerenovusProfiles(){
      allProfileCNV=new List<String>();
    
    
    /*
    Method Description: Fetching all the profile Names from MetaData 
    Param1:             Assigned Profile Names to list
    */
    
    allProfileCNV=new List<String>();
        List<String> AllProfileNames = new List<String>();
         for(Cerenovus_Profiles__mdt profilesCNV:[SELECT Label FROM Cerenovus_Profiles__mdt])
        {
            if(profilesCNV.Label != null)
                AllProfileNames.add(profilesCNV.Label);
        }
        //get All the Cerenovus ProfileId from profile
        for(Profile pro:[SELECT Id,Name FROM Profile where Name In: AllProfileNames]){
            if(pro.id != null)
                allProfileCNV.add(pro.id);
        }
     }
       
}