@isTest
public class TestTradeInTrigger {
    Static testMethod void InsertNewOpp() {
   		//Create the test account
   		  Account AccToCreate = new Account();
        	AccToCreate.Name='BWIAcc';
       	   Insert AccToCreate;
		//Create the test opportunity
        Opportunity OppToCreate = new Opportunity();
        OppToCreate.Name='Test1';
        OppToCreate.AccountId = AccToCreate.Id;
        OppToCreate.Opportunity_Type__c = 'Gain - New Physician';
        OppToCreate.StageName = 'Opportunity Identification';
        OppToCreate.CloseDate = date.newinstance(2017,1,24);
        Insert OppToCreate;
    
   		//Create the test Proposal
        Apttus_Proposal__Proposal__c PropToCreate = New Apttus_Proposal__Proposal__c();
        PropToCreate.Apttus_Proposal__Proposal_Name__c = 'TestProp';
        PropToCreate.Apttus_Proposal__Opportunity__c = OppToCreate.id;
        Insert PropToCreate;
		
		//Create the test Product
        Product2 demop= new Product2();
        demop.Name= 'Demo Product';
        demop.ProductCode = 'BWT-003';
        Insert demop;
        
        //Create the test Trade-In
        Trade_In__c TradeInToCreate = New Trade_In__c();
        TradeInToCreate.Quote_Proposal__c = PropToCreate.id;
        TradeInToCreate.Product__c= demop.Id;
        TradeInToCreate.Original_Install_Date__c = date.newinstance(2017,1,4);
        TradeInToCreate.Serial_Number__c = 'T-1111';
        TradeInToCreate.Anticipated_Trade_In_Date__c= date.newinstance(2017,1,4);
        Insert TradeInToCreate;
		Id tradeId= [Select id from Trade_In__c].id;
        System.assertEquals(TradeInToCreate.Id, tradeId);
    }

}