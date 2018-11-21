@isTest
public class bwicaseCommunityLoader_OneMDCS_TEST 
{
    /*
        *******************************************  This is a Test Class of bwicaseCommunityLoader_OneMDCS ***************************
        Main Class : bwicaseCommunityLoader_OneMDCS
        Created date : 08/16/2017
        Created By : Capgemini
    */
    
    
    public static testMethod void doTest()
    {
        User uatUser= [Select Name from User where Profile.Name= 'System Administrator' AND IsActive =true Limit 1];
        System.runAs(uatUser)
        {
        test.startTest();
        string profName = '';
        profName = bwicaseCommunityLoader_OneMDCS.getSpecificProfileName();
        System.assertEquals('System Administrator', profName);
        test.stopTest();
        }
    }
    
}