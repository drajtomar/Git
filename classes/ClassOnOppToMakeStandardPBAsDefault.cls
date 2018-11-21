//Auto-populate the CPQ price book while creating an opportunity.
public class ClassOnOppToMakeStandardPBAsDefault
{
    public static void PriceBookMethod(list<opportunity> Listopp)
    { 
        try  {
                List<String> AllRecordTypeOpp = new List<String>();//To store Record Type of cerenovus
                Map<String,Id> Pbook =new  Map<String,Id>();//To create map of key as System Name(BWI & CNV) and Price Book Id As value
                
                //Get all the Record Type of cerenovus from CustomeMetadata
                for(Cerenovus_Opportunity_Record_Type__mdt OppoRT : [SELECT Label FROM Cerenovus_Opportunity_Record_Type__mdt])
                {
                    AllRecordTypeOpp.add(OppoRT.Label);
                }
                //Get All opportunity Recordtype Id of Cerenovus
                map<Id,RecordType> CNVOppoRTIds=new map<Id,RecordType>([SELECT Id,Name FROM RecordType WHERE SobjectType = 'Opportunity' and Name IN: AllRecordTypeOpp]);
                for(Pricebook2 pb :([SELECT Id,name,System_Name_Cere__c FROM Pricebook2]))
                {
                    Pbook.put(pb.System_Name_Cere__c,pb.Id);
                }
                for(Opportunity opp:Listopp)
                {
                    if(!CNVOppoRTIds.keySet().contains(opp.RecordTypeId))//check for Cerenovus Opportunity
                    {
                        if(Pbook.get('BWI') != Null &&opp.OppPtdCount__c==0)
                            opp.Pricebook2id=Pbook.get('BWI'); 
                    }
                    else{
                        if(Pbook.get('Cerenovus') != Null && opp.OppPtdCount__c==0)
                            opp.Pricebook2id=Pbook.get('Cerenovus');
                    }
                }
            }
        catch(Exception ex){PriceBook__c pb=new PriceBook__c();}
    }  
}