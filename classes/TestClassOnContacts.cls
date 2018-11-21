@istest
public class TestClassOnContacts
{
   static testmethod void GetProfileName()
  {
       PageReference pageRef;
       string userprof;
       userprof=[select u.Profile.Name, id from User u where u.id = :Userinfo.getUserId()].Profile.Name;
       Profile__c pro=new Profile__c(name='System Administrator');
       insert pro;
       Profile__c pr=new Profile__c(name='Territory Manager');
       insert pr;
       
       Test.StartTest();
       
       System.assertEquals('Territory Manager', pr.Name);
       pageRef= new PageReference('/003');
       pageRef.getParameters().put('id', String.valueOf(pr.Id));
       Test.setCurrentPage(pageRef);
       
       
      ClassVfpageAsPerProfile testAccPlan = new ClassVfpageAsPerProfile();
      testAccPlan.Mymethod();
      Test.StopTest();
   }
 }