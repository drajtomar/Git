@isTest
private class IRB_ApprovalExpNotificationMail_TestOne {
   @testSetup static void setup()  {
        list<account> acclistall=new list<account>();
        for(integer i=0;i>200;i++){
               Account accall =new account(Name='Name'+i,Territory__c='Territory'+i);
               acclistall.add(accall);
        }
       insert acclistall;
     
    }
    
    @isTest
    static void one_30_60_days() {
        string CcoAdmin='Cerenovus Clinical Operations Admin';
        string CtManger='Cerenovus Territory Manager';
        Set<String> TerritoryIdss = new Set<String>();
        Profile pf1= [Select Id from profile where Name='Cerenovus Clinical Operations Admin']; 
        Profile pf2= [Select Id from profile where Name='Cerenovus Territory Manager']; 
       
        User usr1 = UtilityTestData.createUser(false, 'testName13456', 'lastName', pf1.Id);
        usr1.CompanyName = 'JnJ1';
        usr1.External_User_Id__c = '1234567809';
        insert usr1;   
        
        User usr2 = UtilityTestData.createUser(false, 'testName26544', 'lastName', pf2.Id);
        usr2.CompanyName = 'JnJ2';
        usr2.External_User_Id__c = '1234567790';
        insert usr2;   
        
        Territory ter = UtilityTestData.createTerritory(false, 'CNV_Southeast_Division1', 'Description');
        ter.Name = 'CNV_Southeast_Division1';
        ter.External_Territory_Id__c = '1234567890';
        insert ter;
      
        
        Account acc = UtilityTestData.createAccount(false, 'name', '1234567890');
        acc.Territory__c = ter.Id;
        acc.IRB_Approval_Exp_Date_Enterprise__c = system.today() + 30;
        acc.IRB_Approval_Exp_Date_PulseRider__c = system.today() + 30;
            
        
        Account acc1 = UtilityTestData.createAccount(false, 'name', '1234567890');
        acc1.Territory__c = ter.Id;
        acc1.IRB_Approval_Exp_Date_Enterprise__c = system.today() - 1;
        acc1.IRB_Approval_Exp_Date_PulseRider__c = system.today() - 1;
        
        
        Account acc2 = UtilityTestData.createAccount(false, 'name', '1234567890');
        acc2.Territory__c = ter.Id;
        acc2.IRB_Approval_Exp_Date_Enterprise__c = system.today() + 60;
        acc2.IRB_Approval_Exp_Date_PulseRider__c = system.today() + 60;
      
        System.RunAs(usr1) {
            Insert acc;
        }
        
        System.RunAs(usr2) {
            Insert acc1;
        }
        
        System.RunAs(usr2) {
            Insert acc2;
        }
        //insert acc;
        system.assertEquals(acc.Name!=null,true);
       
        test.startTest();
        System.RunAs(usr1) {
        IRB_ApprovalExpNotificationMail IRB = NEW IRB_ApprovalExpNotificationMail();
        DataBase.executeBatch(IRB);
        Integer beforeInvocations = Limits.getEmailInvocations();
         System.assertEquals(0,beforeInvocations,'no email sent');
            test.stopTest();
           
            
        }       
    
       
    }
    
}