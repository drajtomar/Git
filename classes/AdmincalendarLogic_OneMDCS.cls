public class AdmincalendarLogic_OneMDCS{


    public static Boolean getcalendarSettings( String accountId ){
    
        Boolean isCalendarLogicTrue = false ;
        
        //::::::::::::::: Get Custom setting value :::::::::::::::::::::::::::
        List<Available_Services_OneMDCS__c> objCalLogic = new List<Available_Services_OneMDCS__c>();
        objCalLogic = [SELECT Id, Is_True_OneMDCS__c from Available_Services_OneMDCS__c where Hospital_Id_OneMDCS__c =: accountId AND Type_OneMDCS__c = 'Calendar Logic'];
        //system.debug('------>>==== '+objCalLogic[0].Is_True_OneMDCS__c);
        if(!objCalLogic.isEmpty())
        {
            isCalendarLogicTrue = objCalLogic[0].Is_True_OneMDCS__c;
        }
        
        return isCalendarLogicTrue ;
    }
}