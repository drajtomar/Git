public class AffiliationTriggerHelper {
	//Insert records in the Contact Detail Custom Settings
    public static void UpdateContactDetails(list<Affiliation__c> Affiliationlst)
    {
        List <Contact_Details_OneMDCS__c> contListToCreate = new List <Contact_Details_OneMDCS__c> ();
        Map<ID, Contact> conMap = new Map<ID, Contact>();
        Set<String> conId = new Set<String>();
        for (Affiliation__c aff : Affiliationlst) {
        
            conId.add(aff.Physician__c);
        }
        if(conId.size()>0){
          conMap = new Map<ID, Contact>([SELECT Id, Name FROM Contact WHERE ID IN :conId ]);
        }
        
        List<Contact_Details_OneMDCS__c> cdlist = [SELECT Id, Name FROM Contact_Details_OneMDCS__c];
        Integer maxval;
        
        if(cdlist.size() > 0){
            Integer[] cdl = new List<Integer>();
            Integer cdval;
            
            for(Contact_Details_OneMDCS__c cd : cdlist){
                String cdname =  cd.name.substring(4);
                cdval = integer.valueof(cdname);
                cdl.add(cdval);
            }        
            cdl.sort();
            maxval = cdl[cdl.size()-1]; 
        }
        else{
            maxval = 0;
        }
        
        if (Trigger.isInsert) {
            
            for (Affiliation__c a : Affiliationlst) {
            
                Contact_Details_OneMDCS__c contactToCreate = new Contact_Details_OneMDCS__c();
                maxval = maxval + 1;
				contactToCreate.Name = 'CON-'+maxval;
				
				if (Schema.sObjectType.Contact_Details_OneMDCS__c.fields.contact_id_onemdcs__c.isCreateable()){
				  contactToCreate.Contact_Id_OneMDCS__c = a.Physician__c;
				}
				if (Schema.sObjectType.Contact_Details_OneMDCS__c.fields.contact_name__c.isCreateable()){
				  contactToCreate.Contact_Name__c = conMap.get(a.Physician__c).Name;
				}
				if (Schema.sObjectType.Contact_Details_OneMDCS__c.fields.contact_type_onemdcs__c.isCreateable()){
				  contactToCreate.Contact_Type_OneMDCS__c = a.Contact_Type__c;
				}
				if (Schema.sObjectType.Contact_Details_OneMDCS__c.fields.hospital_id_onemdcs__c.isCreateable()){
				  contactToCreate.Hospital_Id_OneMDCS__c = a.Hospital__c;
				}
                contListToCreate.add(contactToCreate);
            }
            insert contListToCreate;
    
        }
    }  
	//Delete records from the Contact Detail Custom Settings on affiliation record deletion
    public static void DeleteContactDetails(list<Affiliation__c> Affiliationlst)
    {
        map<id,id> mapOfAccIdConId = new map<id,id>();
        for(Affiliation__c aff : Affiliationlst){
    
        mapOfAccIdConId.put(aff.Hospital__c,aff.Physician__c);
        } 
        
        List<Contact_Details_OneMDCS__c> conlistForDelete = new List<Contact_Details_OneMDCS__c>();
        List<Contact_Details_OneMDCS__c> conlist = [SELECT Id, Name,Contact_Id_OneMDCS__c,Hospital_Id_OneMDCS__c FROM Contact_Details_OneMDCS__c where Hospital_Id_OneMDCS__c in:mapOfAccIdConId.keyset()];
        for(Contact_Details_OneMDCS__c con : conlist)
        {
            if(mapOfAccIdConId.containsKey(con.Hospital_Id_OneMDCS__c))
            {
                if(mapOfAccIdConId.get(con.Hospital_Id_OneMDCS__c).equals(con.Contact_Id_OneMDCS__c))
                {
                    conlistForDelete.add(con);
                }
            }
            
        }
        if(!conlistForDelete.isEmpty())
        {
            delete conlistForDelete;
        }
    }        
  
}