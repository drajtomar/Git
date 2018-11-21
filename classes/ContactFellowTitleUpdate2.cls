public class ContactFellowTitleUpdate2 {
    //This statement is to set testing in production equal to false
    public Boolean isTest = false;
    //This method is to be called from the TestContactFellowTitleUpdate2 test class for testing only
    public void isTesting ()
    {
        isTest = true;
    }
    //This method will execeut and update the fellow titles to their next stage every July 1st
    public void UpdateFellowTitle2(){
		
        Date todaysDate = Date.today();
        system.debug('todaysDate' + todaysDate);
		//This condition will execute if isTest is true only when running a test to complete code coverage
		//In product the month of todays date should be July in order to update the Fellow titles
        if(todaysDate.month() == 7 || isTest == true )
        {
        	List<Contact> secondYearFellowList = [SELECT ID, Custom_Title__c FROM Contact WHERE Custom_Title__c = 'Second Year EP Fellow'];
            system.debug('secondYearFellowList' + secondYearFellowList);
        	For(Contact c2 : secondYearFellowList)
        	{
            	c2.Custom_Title__c = 'Attending';
        	}
        
        	List<Contact> firstYearFellowList = [SELECT ID, Custom_Title__c FROM Contact WHERE Custom_Title__c= 'First Year EP Fellow'];
            system.debug('firstYearFellowList' + firstYearFellowList);
        	for(Contact c1: firstYearFellowList)
        	{
            	c1.Custom_Title__c = 'Second Year EP Fellow';
        	}

        	Update secondYearFellowList;
            system.debug('secondYearFellowList update' + secondYearFellowList);
        	Update firstYearFellowList;
            system.debug('firstYearFellowList update' + firstYearFellowList);
        }
        
    }

}