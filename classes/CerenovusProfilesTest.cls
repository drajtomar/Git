/*Created By   : Balu Venkateshwarlu
Description  : Test class for CerenovusProfiles
Created Date : 10th oct 2018
*/
@isTest()
 public class CerenovusProfilesTest{
 
  static testMethod void getCNvProfilesIds(){
      List<id> lst=new List<id>();
   	  List<String> allCNV=new List<String>();
      for(Cerenovus_Profiles__mdt profi:[SELECT Label FROM Cerenovus_Profiles__mdt]){
       allCNV.add(profi.Label);
      }
      for(Profile p : [SELECT Id,Name FROM Profile WHERE Name In: allCNV]){
          lst.add(p.id);
      }
      Profile pr = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',CompanyName='testcmp',External_User_Id__c='123212test',
            LocaleSidKey='en_US', ProfileId = lst[0], 
            TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduser@testorg.com');
       system.assertEquals(lst.isEmpty(),False);
      system.runas(u){
       CerenovusProfiles cnv=new CerenovusProfiles();
      }
  }
}