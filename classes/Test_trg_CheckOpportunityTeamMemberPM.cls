@isTest
public class Test_trg_CheckOpportunityTeamMemberPM
{

    static testMethod void TestOpportunityTeamMember()
    {
        CreateOpp();
        String opType= [Select Opportunity_type__c from Opportunity Limit 1].Opportunity_type__c;
        System.assertEquals('cannibalization', opType);
        
    }
    static void CreateOpp()
    {
      
        Account objAccount=  new Account(Name='test');
        insert objAccount;
       
       Opportunity objOpp =  new Opportunity(Name='test',StageName='Interest',Opportunity_type__c='cannibalization', AccountId=objAccount.Id,closedate=Date.Today());
        insert objOpp;
        
        
       
        
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', Department='GL_MID_MIN' ,UserName='standardusersdfsdffdddfdfdfdfdfdfd@testorg.com',
      CompanyName = 'ABC Comapany',External_User_Id__c = '1234567');
        
        insert objUser;
 
        
         OpportunityTeamMember objTM =  new OpportunityTeamMember();
       //objTM.OpportunityAccessLevel='read';
       objTM.OpportunityId=objOpp.Id;
      objTM.UserId= objUser.Id;
      try
      {
      insert objTM;
      }
      catch(Exception e)
      {
      
      System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                 e.getDmlStatusCode(0) );
     }   
       
        
        
               
    }
}