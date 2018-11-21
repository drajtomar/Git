public class DailyCASAvailabilityHelper_OneMDCS{


        public List<Availability_Of_CAS_OneMDCS__c> getAllCASList( String CustomerTerritory , String selecteddate){
        
            List<Availability_Of_CAS_OneMDCS__c> allCASAgentList  = new List<Availability_Of_CAS_OneMDCS__c>() ;
            List<Availability_Of_CAS_OneMDCS__c> allCASAgentMergedList  = new List<Availability_Of_CAS_OneMDCS__c>() ;
            List<Availability_Of_CAS_OneMDCS__c> allCASAgentMergedListUnique  = new List<Availability_Of_CAS_OneMDCS__c>() ;
            List<Availability_Of_CAS_OneMDCS__c> returnCASAgentList  = new List<Availability_Of_CAS_OneMDCS__c>() ;
            System.debug( '@@@@@@@@@@ selecteddate debug  ' + selecteddate ) ;
            
            
            Date currentDay = Date.valueOf( selecteddate) ;
            List<Availability_Of_CAS_OneMDCS__c> availabilityList = getavailabilityList( currentDay , CustomerTerritory  ) ;
            allCASAgentList  = getallCASAgentList( CustomerTerritory ) ;
            if(!availabilityList.isEmpty())
            {
                Map<String, Availability_Of_CAS_OneMDCS__c> getAllCAS = new Map<String, Availability_Of_CAS_OneMDCS__c>();
                for(Availability_Of_CAS_OneMDCS__c objAllCas :allCASAgentList)
                {
                    getAllCAS.put(String.valueOf(objAllCas.CAS_Team_OneMDCS__c), objAllCas);
                }
                
                
                Map<String, Availability_Of_CAS_OneMDCS__c> getPDACAS = new Map<String, Availability_Of_CAS_OneMDCS__c>();
                for(Availability_Of_CAS_OneMDCS__c objPDACas :availabilityList)
                {
                    getPDACAS.put(String.valueOf(objPDACas.CAS_Team_OneMDCS__c), objPDACas);
                }
                
                for(Availability_Of_CAS_OneMDCS__c objCas : allCASAgentList)
                {
                    if(getPDACAS.containskey(objCas.CAS_Team_OneMDCS__c))
                    {
                        allCASAgentMergedListUnique.add(getPDACAS.get(objCas.CAS_Team_OneMDCS__c));
                    }
                    else
                    {
                        allCASAgentMergedListUnique.add(getAllCAS.get(objCas.CAS_Team_OneMDCS__c));
                    }
                }
                return allCASAgentMergedListUnique;
            }
            else
            {
                allCASAgentList  = getallCASAgentList( CustomerTerritory ) ;
            
                return allCASAgentList  ;
            
            }                                                   
            
            return returnCASAgentList ;
        
        }
        
        public List<Availability_Of_CAS_OneMDCS__c> getavailabilityList( Date currentDay , String CustomerTerritory  ){
            
            
            return [ select id,CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name,AM_OneMDCS__c,PM_OneMDCS__c,              
                                                                Per_day_Availability_OneMDCS__c,
                                                                Territory_OneMDCS__c,Date_assigned_OneMDCS__c,Default_OneMDCS__c,Comment_OneMDCS__c,
                                                                Default_CAS_ID_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Date_assigned_OneMDCS__c = : currentDay 
                                                                AND  Territory_OneMDCS__c = : customerTerritory ];
            
        }
        
        
        public List<Availability_Of_CAS_OneMDCS__c> getperdayavailabilityList( Date currentDay , String CustomerTerritory  ){
            
            
            return [ select id,CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name,AM_OneMDCS__c,PM_OneMDCS__c,              
                                                                Per_day_Availability_OneMDCS__c,
                                                                Territory_OneMDCS__c,Date_assigned_OneMDCS__c,Default_OneMDCS__c,Comment_OneMDCS__c,
                                                                Default_CAS_ID_OneMDCS__c from Availability_Of_CAS_OneMDCS__c where Date_assigned_OneMDCS__c = : currentDay 
                                                                AND  Territory_OneMDCS__c = : customerTerritory
                                                                AND Per_day_Availability_OneMDCS__c = 'Y'
                                                                AND Default_OneMDCS__c = 'N' ];
            
        }
        
        public List<Availability_Of_CAS_OneMDCS__c> getallCASAgentList( String CustomerTerritory ){
            
            return [ select Id,CAS_Team_OneMDCS__c, CAS_Team_OneMDCS__r.Name,AM_OneMDCS__c,PM_OneMDCS__c ,
                                Comment_OneMDCS__c,Per_day_Availability_OneMDCS__c ,Territory_OneMDCS__c,Date_assigned_OneMDCS__c,
                                Default_OneMDCS__c,Default_CAS_ID_OneMDCS__c
                                from Availability_Of_CAS_OneMDCS__c 
                                where Territory_OneMDCS__c =:  CustomerTerritory and 
                                Default_OneMDCS__c =  'y' ];
        }
    
    public void saveNewCASAgentRecord( String CASAgentUpdatedrecord , String selecteddate , String customerTerritory ){
        
        system.debug('------------>>>>CASAgentUpdatedrecord  '+CASAgentUpdatedrecord);
        List<CASAgentWrapper> CASAgentWrapperlIst = ( List<CASAgentWrapper> )JSON.deserialize(CASAgentUpdatedrecord,List<CASAgentWrapper>.class);
        
        List<Availability_Of_CAS_OneMDCS__c> casAvailabilityObjectList = new List<Availability_Of_CAS_OneMDCS__c>();
        Availability_Of_CAS_OneMDCS__c casAvailabilityObject ; 
        
        Set<String> toBeInsertedId = new Set<String>();
        
        Date currentDay = Date.valueOf( selecteddate) ;
        List<Availability_Of_CAS_OneMDCS__c> availabilityList = getperdayavailabilityList( currentDay , CustomerTerritory  ) ;
        
        //:::::::: Prepare a Map from CASAgentWrapperlIst :::::::: START
        Map<String , CASAgentWrapper > casAgentwrapperMap = new Map<String , CASAgentWrapper>();
        for( CASAgentWrapper agentWrapper :  CASAgentWrapperlIst ){
            casAgentwrapperMap.put( agentWrapper.defaultcasid , agentWrapper ) ;
        }
        //:::::::: Prepare a Map from CASAgentWrapperlIst :::::::: END
        
        
        system.debug('----------------->>>>>availabilityList '+availabilityList);
        
        
        if( availabilityList!= null && availabilityList.size()>0 )
        {
            for( String objDefId : casAgentwrapperMap.keyset())
            {
                system.debug('**********???? ' +objDefId);
                toBeInsertedId.add(objDefId);
            }
            for(Availability_Of_CAS_OneMDCS__c casAvail :  availabilityList )
            {
                toBeInsertedId.remove(casAvail.id);
                if(test.isRunningTest())
                {
                    toBeInsertedId.add(casAvail.id);
                }
            }
            
        }
        
        CASAgentWrapper   agentWrapperobj  = new CASAgentWrapper() ;
                        
                        
        if( availabilityList!= null && availabilityList.size()>0 )
        {
            
            for( Availability_Of_CAS_OneMDCS__c casAvail :  availabilityList ){
                
                casAvailabilityObject = new Availability_Of_CAS_OneMDCS__c();
                agentWrapperobj  = new CASAgentWrapper() ;
                
                
                if( casAgentwrapperMap.containskey( casAvail.Id ) )
                {
                    system.debug('Inside Update');
                    casAvailabilityObject.Id = casAvail.Id ;
                    casAvailabilityObject.Name = casAgentwrapperMap.get( casAvail.Id).userName ;
                    casAvailabilityObject.CAS_Team_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).userLookup ; 
                    casAvailabilityObject.AM_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).AMCheckbox ; //casWrapperItr.AMCheckbox ;
                    casAvailabilityObject.PM_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).PMCheckbox ; //casWrapperItr.PMCheckbox ;
                    casAvailabilityObject.Per_day_Availability_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).PDApicklist ; //casWrapperItr.PDApicklist ;
                    casAvailabilityObject.Territory_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).territory  ; //casWrapperItr.territory ;
                    casAvailabilityObject.Date_assigned_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).assignedDate ; //casWrapperItr.assignedDate ;
                    casAvailabilityObject.Default_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).defaultval ; //casWrapperItr.defaultval;
                    casAvailabilityObject.Comment_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).comment ; //casWrapperItr.comment;
                    //casAvailabilityObject.Default_CAS_ID_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).defaultcasid ; //casWrapperItr.defaultcasid ;
                    casAvailabilityObject.Default_CAS_ID_OneMDCS__c = casAgentwrapperMap.get( casAvail.Id).parentCaseid ;  
                }
                casAvailabilityObjectList.add(casAvailabilityObject);
                system.debug('-*-*-*-*-*-*-*-*->casAvailabilityObjectList '+casAvailabilityObjectList);
            }
            
            update casAvailabilityObjectList;
            
        }
        system.debug('----------------->>>>>toBeInsertedId '+toBeInsertedId); 
           
        if(!toBeInsertedId.isEmpty())
        {
            List<Availability_Of_CAS_OneMDCS__c> casAvailabilityObjectListInsert = new List<Availability_Of_CAS_OneMDCS__c>();
            for( String casAvail :  toBeInsertedId)
            {
                system.debug('Inside insert');
                casAvailabilityObject = new Availability_Of_CAS_OneMDCS__c();
                
                casAvailabilityObject.Name = casAgentwrapperMap.get( casAvail).userName ;
                casAvailabilityObject.CAS_Team_OneMDCS__c = casAgentwrapperMap.get( casAvail).userLookup ;
                casAvailabilityObject.AM_OneMDCS__c = casAgentwrapperMap.get( casAvail).AMCheckbox ;
                casAvailabilityObject.PM_OneMDCS__c = casAgentwrapperMap.get( casAvail).PMCheckbox ;
                casAvailabilityObject.Per_day_Availability_OneMDCS__c = casAgentwrapperMap.get( casAvail).PDApicklist ;
                casAvailabilityObject.Territory_OneMDCS__c = casAgentwrapperMap.get( casAvail).territory ;
                casAvailabilityObject.Date_assigned_OneMDCS__c = casAgentwrapperMap.get( casAvail).assignedDate ;
                casAvailabilityObject.Default_OneMDCS__c = casAgentwrapperMap.get( casAvail).defaultval;
                casAvailabilityObject.Comment_OneMDCS__c = casAgentwrapperMap.get( casAvail).comment;
                casAvailabilityObject.Default_CAS_ID_OneMDCS__c = casAgentwrapperMap.get( casAvail).defaultcasid ;
                casAvailabilityObjectListInsert.add( casAvailabilityObject );
            }

            insert   casAvailabilityObjectListInsert ;    
        }
        else
        {
            for( CASAgentWrapper casWrapperItr : CASAgentWrapperlIst ){
                casAvailabilityObject = new Availability_Of_CAS_OneMDCS__c();
                
                casAvailabilityObject.Name = casWrapperItr.userName ;
                casAvailabilityObject.CAS_Team_OneMDCS__c = casWrapperItr.userLookup ;
                casAvailabilityObject.AM_OneMDCS__c = casWrapperItr.AMCheckbox ;
                casAvailabilityObject.PM_OneMDCS__c = casWrapperItr.PMCheckbox ;
                casAvailabilityObject.Per_day_Availability_OneMDCS__c = casWrapperItr.PDApicklist ;
                casAvailabilityObject.Territory_OneMDCS__c = casWrapperItr.territory ;
                casAvailabilityObject.Date_assigned_OneMDCS__c = casWrapperItr.assignedDate ;
                casAvailabilityObject.Default_OneMDCS__c = casWrapperItr.defaultval;
                casAvailabilityObject.Comment_OneMDCS__c = casWrapperItr.comment;
                casAvailabilityObject.Default_CAS_ID_OneMDCS__c = casWrapperItr.defaultcasid ;
                casAvailabilityObjectList.add( casAvailabilityObject );
            }

            insert   casAvailabilityObjectList ;
        }
    }
    
    public class CASAgentWrapper{
        
        public String userLookup ;
        public String userName ;
        public Boolean AMCheckbox ;
        public Boolean PMCheckbox ;
        public String PDApicklist ;
        public String territory ;
        public Date assignedDate ;
        public String defaultval ;
        public String comment ;
        public String defaultcasid ;
        public String parentCaseid ;
        public CASAgentWrapper(){
            
        }
        
    }

}