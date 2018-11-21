@isTest
public class test_trg_New_UpdateSalesFunnel {
    public static testmethod void insertpricebook(){
        User u = [Select Id from user where profile.Name = 'System Administrator' and IsActive = true limit 1];
        system.runas(u){
            Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
            insert prod;
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            Pricebook2 customPB = new Pricebook2(Name='CPQ Pricebook', isActive=true);
            insert customPB;
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true);
            insert customPrice;
            Integer countpricebook = [Select count() from PricebookEntry ];
            System.assertEquals(2, countpricebook);
        }
    }
    static testmethod void UpdateSalesFunnelAfterInsert_Change()
    {   
        insertpricebook();
        List<Sale__c> lstInsert = new List<Sale__c>();
        Sale__c objSale = new Sale__c();
        objSale.Product_type__c ='DX';
        objSale.Territory__c='GL_MID_MIN';
        objSale.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='DX';
        objSale1.Territory__c='GL_MID_MIN';
        objSale1.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale1.External_Sales_Id__c='GL_MID_MID_DX';
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
        Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='DX';
        objSale2.Territory__c='GL_MID';
        objSale2.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale2.External_Sales_Id__c='GL_MID';
        lstInsert.add(objSale2);
        
        Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MID';
        objSale3.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert.add(objSale3);
        insert lstInsert;
        
        List<SalesMTD__c> lstInsert2 = new List<SalesMTD__c>();
        SalesMTD__c objSale4 = new SalesMTD__c();
        objSale4.Product_type__c ='DX';
        objSale4.Territory__c='GL_MID_MIN';
        objSale4.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        //External_Sales_Id__c
        objSale4.External_Sales_Id__c='GL_MID_MID';
        
        SalesMTD__c objSale5 = new SalesMTD__c();
        objSale5.Product_type__c ='DX';
        objSale5.Territory__c='GL_MID_MIN';
        objSale5.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale5.External_Sales_Id__c='GL_MID_MID_DX';
        lstInsert2.add(objSale4);
        lstInsert2.add(objSale5);
        
        SalesMTD__c objSale6 = new SalesMTD__c();
        objSale6.Product_type__c ='DX';
        objSale6.Territory__c='GL_MID';
        objSale6.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale6.External_Sales_Id__c='GL_MID';
        lstInsert2.add(objSale6);
        
        SalesMTD__c objSale7 = new SalesMTD__c();
        objSale7.Product_type__c ='NAV/TX';
        objSale7.Territory__c='GL_MID';
        objSale7.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale7.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert2.add(objSale7);
        insert lstInsert2;  
        
        if(Test.IsRunningTest()&&Limits.getFutureCalls() >= Limits.getLimitFutureCalls())
        {
            system.debug('skip');
        }
        else
        {
            update lstInsert;
            update lstInsert2;
        }
        
        
        
        try
        {
            String exe = '';
            String abc = exe.toLowerCase();
        }
        catch(Exception e)
        {
            EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
        } 
        
        Account acc2 = new Account();
        acc2.Name = 'Test';
        acc2.territory__c='GL_MIN_MID';
        RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account' limit 1];
        acc2.RecordTypeId =rt2[0].Id;
        
        insert acc2;//
        
        Opportunity Opp = new Opportunity();
        Opp.Name='test';
        Opp.StageName='Opportunity Identification';
        Opp.CloseDate= Date.newInstance(2018, 5, 24);//Updating dates to reflect fiscal year
        Opp.AccountId= acc2.Id;
        insert Opp;//
        System.debug('newOpportunity'+Opp);
        
        List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability,IsClosed, CloseDate from Opportunity where Id = :Opp.Id and IsClosed=false limit 1];
        System.debug('list not empty'+lstOpp);
        
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
        PriceBookEntry  pbe = [Select Id,pricebook2.Name from PriceBookEntry where IsActive=true and pricebook2.Name='CPQ Pricebook' limit 1];
        Period fc = [Select Id from Period limit 1];
        system.debug('pricebook is'+pbe.Pricebook2Id);
        
        for(integer i=1;i<6;i++)
        {
            OpportunityLineItem OppLineItem = new OpportunityLineItem();
            OppLineItem.OpportunityId = lstOpp[0].Id;
            // OppLineItem.TotalPrice = i*1000;
            
            OppLineItem.UnitPrice = 1000;
            OppLineItem.Quantity = 1;
            if(i==1)
                OppLineItem.Product_Type__c = 'HSS';
            else if(i==2)
                OppLineItem.Product_Type__c = 'NAV';
            else if(i==3)
                OppLineItem.Product_Type__c = 'DX';
            else if(i==4)
                OppLineItem.Product_Type__c = 'TX';
            else if(i==5)
                OppLineItem.Product_Type__c = 'LSS';
            OppLineItem.PriceBookEntryId=pbe.id;
            
            
            
            oppLineItems.add(OppLineItem);
        }
        insert oppLineItems;//
        
        
        
        Test.startTest();
        List<OpportunityLineItem> oppLine = new List<OpportunityLineItem>();
        oppLine = [Select id,Product_Type__c from OpportunityLineItem];
        System.assertEquals(5,oppLine.size());
        System.debug('started testing');        
        Opp.CloseDate= Date.newInstance(2019, 5, 24);
        update Opp;
        System.debug('Updated Opp' + Opp);
        /*Opp.CloseDate= Date.newInstance(2018, 9, 5);
update Opp;
/*Opp.CloseDate = Date.newInstance(2018, 10, 20);//Sergio adding to add more code coverage 1/23
update Opp;
Opp.CloseDate = Date.newInstance(2018, 9, 5);//Sergio adding to add more code coverage 1/23
System.debug('Updated Opp' + Opp);*/
        Test.stopTest();
        
        
    }  
    
    static testmethod void UpdateSalesFunnelAfterInsert_Change2()

    {
        insertpricebook();
        List<Sale__c> lstInsert = new List<Sale__c>();
        Sale__c objSale = new Sale__c();
        objSale.Product_type__c ='DX';
        objSale.Territory__c='GL_MID_MIN';
        objSale.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='DX';
        objSale1.Territory__c='GL_MID_MIN';
        objSale1.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale1.External_Sales_Id__c='GL_MID_MID_DX';
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
        Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='DX';
        objSale2.Territory__c='GL_MID';
        objSale2.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale2.External_Sales_Id__c='GL_MID';
        lstInsert.add(objSale2);
        
        Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MID';
        objSale3.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert.add(objSale3);
        insert lstInsert;
        
        List<SalesMTD__c> lstInsert2 = new List<SalesMTD__c>();
        SalesMTD__c objSale4 = new SalesMTD__c();
        objSale4.Product_type__c ='DX';
        objSale4.Territory__c='GL_MID_MIN';
        objSale4.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        //External_Sales_Id__c
        objSale4.External_Sales_Id__c='GL_MID_MID';
        
        SalesMTD__c objSale5 = new SalesMTD__c();
        objSale5.Product_type__c ='DX';
        objSale5.Territory__c='GL_MID_MIN';
        objSale5.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale5.External_Sales_Id__c='GL_MID_MID_DX';
        lstInsert2.add(objSale4);
        lstInsert2.add(objSale5);
        
        SalesMTD__c objSale6 = new SalesMTD__c();
        objSale6.Product_type__c ='DX';
        objSale6.Territory__c='GL_MID';
        objSale6.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale6.External_Sales_Id__c='GL_MID';
        lstInsert2.add(objSale6);
        
        SalesMTD__c objSale7 = new SalesMTD__c();
        objSale7.Product_type__c ='NAV/TX';
        objSale7.Territory__c='GL_MID';
        objSale7.Fiscal_period__c='201809';//Updating dates to reflect fiscal year
        objSale7.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert2.add(objSale7);
        insert lstInsert2;  
        
        if(Test.IsRunningTest()&&Limits.getFutureCalls() >= Limits.getLimitFutureCalls())
        {
            system.debug('skip');
        }
        else
        {
            update lstInsert;
            update lstInsert2;
        }
        
        
        
        try
        {
            String exe = '';
            String abc = exe.toLowerCase();
        }
        catch(Exception e)
        {
            EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
        } 
        
        Account acc2 = new Account();
        acc2.Name = 'Test';
        acc2.territory__c='GL_MIN_MID';
        RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account' limit 1];
        
        acc2.RecordTypeId =rt2[0].Id;
        
        insert acc2;//
        
        Opportunity Opp = new Opportunity();
        Opp.Name='test';
        Opp.StageName='Opportunity Identification';
        Opp.CloseDate= Date.newInstance(2019, 5, 24);//Updating dates to reflect fiscal year
        Opp.AccountId= acc2.Id;
        insert Opp;//
        System.debug('newOpportunity'+Opp);
        
        List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability,IsClosed, CloseDate from Opportunity where Id = :Opp.Id and IsClosed=false limit 1];
        System.debug('list not empty'+lstOpp);
        
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        PriceBookEntry  pbe = [Select Id,pricebook2.Name from PriceBookEntry where IsActive=true and pricebook2.Name='CPQ Pricebook' limit 1];
        Period fc = [Select Id from Period limit 1];
        system.debug('pricebook is'+pbe.Pricebook2Id);
        
        for(integer i=1;i<6;i++)
        {
            OpportunityLineItem OppLineItem = new OpportunityLineItem();
            OppLineItem.OpportunityId = lstOpp[0].Id;
            // OppLineItem.TotalPrice = i*1000;
            
            OppLineItem.UnitPrice = 1000;
            OppLineItem.Quantity = 1;
            if(i==1)
                OppLineItem.Product_Type__c = 'HSS';
            else if(i==2)
                OppLineItem.Product_Type__c = 'NAV';
            else if(i==3)
                OppLineItem.Product_Type__c = 'DX';
            else if(i==4)
                OppLineItem.Product_Type__c = 'TX';
            else if(i==5)
                OppLineItem.Product_Type__c = 'LSS';
            OppLineItem.PriceBookEntryId=pbe.id;
            
            
            
            oppLineItems.add(OppLineItem);
        }
        insert oppLineItems;//
        
        
        
        Test.startTest();  
        System.debug('started testing');        
        Opp.CloseDate= Date.newInstance(2018, 5, 24);
        update Opp;
        System.debug('Updated Opp' + Opp);
        List<OpportunityLineItem> oppLine = new List<OpportunityLineItem>();
        oppLine = [Select id,Product_Type__c from OpportunityLineItem];
        System.assertEquals(5,oppLine.size());
        /*Opp.CloseDate= Date.newInstance(2018, 9, 5);
update Opp;
/*Opp.CloseDate = Date.newInstance(2018, 10, 20);//Sergio adding to add more code coverage 1/23
update Opp;
Opp.CloseDate = Date.newInstance(2018, 9, 5);//Sergio adding to add more code coverage 1/23
System.debug('Updated Opp' + Opp);*/
        Test.stopTest();
        
        
    }
    
    
    static testmethod void UpdateSalesFunnelOnDelete()
    {
        insertpricebook();
        List<Sale__c> lstInsert = new List<Sale__c>();
        Sale__c objSale = new Sale__c();
        objSale.Product_type__c ='HSS';
        objSale.Territory__c='GL_MID_MIN';
        objSale.Fiscal_period__c='201403';
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='HSS';
        objSale1.Territory__c='GL_MID_MIN';
        objSale1.Fiscal_period__c='201403';
        objSale1.External_Sales_Id__c='GL_MID_MID_HSS';
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
        Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='HSS';
        objSale2.Territory__c='GL_MID';
        objSale2.Fiscal_period__c='201403';
        objSale2.External_Sales_Id__c='GL_MID';
        lstInsert.add(objSale2);
        
        Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MID';
        objSale3.Fiscal_period__c='201403';
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert.add(objSale3);
        insert lstInsert;
        
        Sale__c objSale4 = [SELECT Id FROM Sale__c Limit 1 ];
        objsale4.Fiscal_Period__c = '201809';//Updating dates to reflect fiscal year
        update ObjSale4;
        
        List<String> ptypeList= new List<String>();
		for (Sale__c stype : [Select Product_type__c from Sale__c])
        {
            String pName= stype.Product_Type__c;
            ptypeList.add(pName);
        }
        System.assert(ptypeList.contains('HSS'));
        
        if(Test.IsRunningTest()&&Limits.getFutureCalls() >= Limits.getLimitFutureCalls())
        {
            system.debug('skip');
        }
        else
        {
            update lstInsert;
        }
        
        
        
        try
        {
            String exe = '';
            String abc = exe.toLowerCase();
        }
        catch(Exception e)
        {
            EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
        } 
        
        Account acc2 = new Account();
        acc2.Name = 'Test';
        acc2.territory__c='GL_MIN_MID';
        
        RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account' limit 1];
        
        acc2.RecordTypeId =rt2[0].Id;
        
        insert acc2;//
        
        Opportunity Opp = new Opportunity();
        Opp.Name='test';
        Opp.StageName='Opportunity Identification';
        Opp.CloseDate=Date.Valueof('2018-01-23T20:58:55.000+0000');//Updating dates to reflect fiscal year
        Opp.AccountId= acc2.Id;
        insert Opp;//
        
        List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability,IsClosed from Opportunity where Id = :Opp.Id and IsClosed=false limit 1];
        System.debug('list not empty'+lstOpp);
        
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        PriceBookEntry  pbe = [Select Id,pricebook2.Name from PriceBookEntry where IsActive=true and pricebook2.Name='CPQ Pricebook' limit 1];
        Period fc = [Select Id from Period limit 1];
        system.debug('pricebook is'+pbe.Pricebook2Id);
        
        for(integer i=1;i<6;i++)
        {
            OpportunityLineItem OppLineItem = new OpportunityLineItem();
            OppLineItem.OpportunityId = lstOpp[0].Id;
            // OppLineItem.TotalPrice = i*1000;
            
            OppLineItem.UnitPrice = 1000;
            OppLineItem.Quantity = 1;
            if(i==1)
                OppLineItem.Product_Type__c = 'HSS';
            else if(i==2)
                OppLineItem.Product_Type__c = 'NAV';
            else if(i==3)
                OppLineItem.Product_Type__c = 'DX';
            else if(i==4)
                OppLineItem.Product_Type__c = 'TX';
            else if(i==5)
                OppLineItem.Product_Type__c = 'LSS';
            OppLineItem.PriceBookEntryId=pbe.id;
            
            
            
            oppLineItems.add(OppLineItem);
        }
        insert oppLineItems;//
        
        
        Test.startTest();                           
        delete oppLineItems;//
        Test.stopTest();
        
        
    }
    static testmethod void UpdateSalesFunnelWhenClosed()
    {
        insertpricebook();
        List<Sale__c> lstInsert = new List<Sale__c>();
        Sale__c objSale = new Sale__c();
        objSale.Product_type__c ='HSS';
        objSale.Territory__c='GL_MID_MIN';
        objSale.Fiscal_period__c='201403';
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='HSS';
        objSale1.Territory__c='GL_MID_MIN';
        objSale1.Fiscal_period__c='201403';
        objSale1.External_Sales_Id__c='GL_MID_MID_HSS';
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
        Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='HSS';
        objSale2.Territory__c='GL_MID';
        objSale2.Fiscal_period__c='201403';
        objSale2.External_Sales_Id__c='GL_MID';
        lstInsert.add(objSale2);
        
        Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MID';
        objSale3.Fiscal_period__c='201403';
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert.add(objSale3);
        
        
        
        insert lstInsert;
        //update lstInsert;
        
        try
        {
            String exe = '';
            String abc = exe.toLowerCase();
        }
        catch(Exception e)
        {
            EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
        }
        
        Account acc2 = new Account();
        acc2.Name = 'Test';
        acc2.territory__c='GL_MID_MIN';
        RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
        
        acc2.RecordTypeId =rt2[0].Id;
        insert acc2;
        
        Opportunity Opp = new Opportunity();
        Opp.Name='test';
        Opp.StageName='Opportunity Identification';
        Opp.CloseDate=Date.Valueof('2018-01-23T20:58:55.000+0000');//Updating dates to reflect fiscal year
        Opp.AccountId= acc2.Id;
        insert Opp;
        
        List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability,IsClosed from Opportunity where Id = :Opp.Id and IsClosed=false ];
        System.debug('list not empty'+lstOpp);
        
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
        PriceBookEntry  pbe = [Select Id,pricebook2.Name from PriceBookEntry where IsActive=true and pricebook2.Name='CPQ Pricebook' limit 1];
        Period fc = [Select Id from Period limit 1];
        
        for(integer i=1;i<6;i++)
        {
            OpportunityLineItem OppLineItem = new OpportunityLineItem();
            OppLineItem.OpportunityId = lstOpp[0].Id;
            // OppLineItem.TotalPrice = i*1000;
            
            OppLineItem.UnitPrice = 1000;
            OppLineItem.Quantity = 1;
            if(i==1)
                OppLineItem.Product_Type__c = 'HSS';
            else if(i==2)
                OppLineItem.Product_Type__c = 'NAV';
            else if(i==3)
                OppLineItem.Product_Type__c = 'DX';
            else if(i==4)
                OppLineItem.Product_Type__c = 'TX';
            else if(i==5)
                OppLineItem.Product_Type__c = 'LSS';
            OppLineItem.PriceBookEntryId=pbe.id;
            
            oppLineItems.add(OppLineItem);
        }
        
        
        
        insert oppLineItems;
        
        
        Opp.StageName= 'Closed/Lost';
        Opp.Reason_for_Close_and_Lost__c = 'Service/Support';
        Test.startTest();
        update Opp;
        String oppStage=[Select StageName from Opportunity Limit 1].StageName;
        System.assertEquals(Opp.StageName, oppStage);
        Test.stopTest();
    }
}