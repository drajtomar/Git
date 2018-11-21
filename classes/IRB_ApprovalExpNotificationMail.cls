/* Class Name       : IRB_ApprovalExpNotificationMail
 * Created By       : Suresh Nelamsetti
 * Created Date     : 10/10/2018
 * Description      : This Batch class is used to send email notification to Territory managers and Cerenovus Clinical Operations Admin Users,
                      and based on expiry date fields - IRB_Approval_Exp_Date_Enterprise__c and IRB_Approval_Exp_Date_PulseRider__c (before 60days, 30days, expiry next day).
 */
public class IRB_ApprovalExpNotificationMail implements Database.Batchable<sObject>, Database.Stateful {
    
    List<Account> Exp60daysacclist = new List<Account>();
    List<Account> Exp30daysacclist = new List<Account>();
    List<Account> Exp1dayacclist = new List<Account>();
    Set<String> TerritoryIds = new Set<String>();
    Map<String,Id> TerrMap = new Map<String,Id>();
    Map<Id,List<Id>> TerrUserMap = new Map<Id,List<Id>>();
    Map<Id,Set<String>> UserEmailMap = new Map<Id,Set<String>>();
    list<String> FinalEmailIds = new list<String>();
    Set<String> EmailAddresses = new Set<String>();
    Set<String> CcoaMailids = new Set<String>();
    Id TargetObjectId; 
    string CcoAdmin='Cerenovus Clinical Operations Admin';
    string CtManger='Cerenovus Territory Manager';
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        //query to fetch all the cerenovus account data where IRB approval expiration dates are not null
        String query = 'select id,owner.email,OwnerId,IRB_Approval_Date_Enterprise__c,IRB_Approval_Date_Pulse_Rider__c,IRB_Approval_Exp_Date_Enterprise__c,IRB_Approval_Exp_Date_PulseRider__c,Territory_Name_Cere__c,Territory__c from account where IRB_Approval_Exp_Date_Enterprise__c != null OR IRB_Approval_Exp_Date_PulseRider__c != null';
    
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc,List<Account> lstScope){
        
        for(Account acc:lstscope){
            // fetch account records based on IRB Approval enterprise and pulserider expiration date is before 60 days            
            if(acc.IRB_Approval_Exp_Date_Enterprise__c==system.today()+60 || acc.IRB_Approval_Exp_Date_PulseRider__c==system.today()+60){                      
                Exp60daysacclist.add(acc);       
                if(acc.territory__c!= null){
                    TerritoryIds.add(acc.territory__c);         
                }  
            }            
            // fetch account records based on IRB Approval enterprise and pulerider expiration date is before 30 days
            if(acc.IRB_Approval_Exp_Date_Enterprise__c==system.today()+30 || acc.IRB_Approval_Exp_Date_PulseRider__c==system.today()+30){
                Exp30daysacclist.add(acc);
                if(acc.territory__c!= null){
                    TerritoryIds.add(acc.territory__c);     
                }
            }
            // fetch account records based on IRB Approval enterprise and pulerider date is after one day from expiration
           if(acc.IRB_Approval_Exp_Date_Enterprise__c==system.today()-1 || acc.IRB_Approval_Exp_Date_PulseRider__c==system.today()-1){
                Exp1dayacclist.add(acc);
                if(acc.territory__c!= null){
                    TerritoryIds.add(acc.territory__c);     
                }
            }            
        }        
        // fetch territories records based on account territory External Ids 
        for(Territory terr : [select id,External_Territory_Id__c from territory where External_Territory_Id__c IN: TerritoryIds])
        {
            TerrMap.put(terr.External_Territory_Id__c,terr.id);
        }
        
        // Fetch Users Ids assigned to territories from userTerritory object 
        for(UserTerritory ut : [select userid,territoryid from userTerritory where territoryid IN: TerrMap.values()])
        {     
            if(ut.territoryid!=null){
                if(!TerrUserMap.containskey(ut.territoryid)){   
                        TerrUserMap.put(ut.territoryid,new List<Id> {ut.userid});
                    }
                else{                   
                        TerrUserMap.get(ut.territoryid).add(ut.userid);
                    }
            }
        }
        /* Creating a Map of userid and user's email and user's manager's email as the values. 
        Also, fetching emails of Clinical Operations admin profile users */
        for(User user : [select id,email,manager.email,profile.name from user where profile.name =: CtManger 
                         OR profile.name =: CcoAdmin])
        {    
            for(List<Id> userlst : TerrUserMap.values())
            {
                    if(userlst.contains(user.id)){
                     UserEmailMap.put(user.id,new Set<String> {user.email,user.manager.email});
                     break;
                    }                
            }
            if(user.profile.name == CcoAdmin)
            {
                CcoaMailids.add(user.email);
                
            }                    
        }   
    }
    
    // Sending Emails to Clinical operations admin users, Account's Territory Manager and Regional Business Director    
    public void finish(Database.BatchableContext bc){
        //list to send all emails of 60days,30days and after 1day
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        //email template for 60days
        EmailTemplate et_sixty =  [select id from EmailTemplate where developername='IRB_Notification_1'];
        //email template for 30days
        EmailTemplate et_thirty =  [select id from EmailTemplate where developername='IRB_Notification_2'];
        //email template after 1day from expiry date
        EmailTemplate et_one =  [select id from EmailTemplate where developername='IRB_Notification_3'];
        
        system.debug('EmailAddresses60v0...'+EmailAddresses);
       //Preparing email message for accounts 60 days before IRB expiration date
        for(Account acc : Exp60daysacclist)
        {   
            EmailAddresses.addall(CcoaMailids);
            if(TerrUserMap.size()>0 && TerrMap != null && (TerrMap.get(acc.territory__c)!=null)){
                if(TerrUserMap.get(TerrMap.get(acc.territory__c))!=null)
                {   system.debug('Checkdp'+TerrUserMap.get(TerrMap.get(acc.territory__c)));
                    for(Id userid : TerrUserMap.get(TerrMap.get(acc.territory__c)))
                    {   TargetObjectId = userid;
                        if(userid != null){
                        system.debug('checkdp1'+userid);
                            if(UserEmailMap.containskey(userid))
                            {   
                                if(UserEmailMap.get(userid)!=null){                                 
                                EmailAddresses.addall(UserEmailMap.get(userid)); 
                                    system.debug('EmailAddresses60...'+EmailAddresses);
                                }
                            }
                        }
                    }
                }
            }
                FinalEmailIds.addall(EmailAddresses);  
                system.debug('FinalEmailIds60...'+FinalEmailIds);
                system.debug('Targetobjectid60---'+TargetObjectId);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(et_sixty.Id);
                mail.setToAddresses(FinalEmailIds);
                mail.setSaveAsActivity(false);
                mail.setWhatId(acc.id);
                mail.setTargetObjectId(TargetObjectId);
                mail.setTreatTargetObjectAsRecipient(true);
                mail.setOrgWideEmailAddressId(Label.Cerenovous_Organization_Wide_Addresses);                
                allmsg.add(mail); 
                EmailAddresses.clear();
                FinalEmailIds.clear();                                   
        }
        system.debug('Allmsgdp'+allmsg);
        EmailAddresses.clear();
        FinalEmailIds.clear();
        //Preparing email message for accounts 30 days before IRB expiration date
        for(Account acc : Exp30daysacclist)
        {   EmailAddresses.addall(CcoaMailids);
            if(TerrUserMap.size()>0 && TerrMap != null && (TerrMap.get(acc.territory__c)!=null)){
                if(TerrUserMap.get(TerrMap.get(acc.territory__c))!=null)
                {
                    for(Id userid : TerrUserMap.get(TerrMap.get(acc.territory__c)))
                    {   TargetObjectId = userid;
                        if(userid != null){
                            if(UserEmailMap.containskey(userid))
                            {   
                                if(UserEmailMap.get(userid)!=null){                            
                                EmailAddresses.addall(UserEmailMap.get(userid));  
                                    system.debug('EmailAddresses30....'+EmailAddresses);
                                }
                            }
                        }
                    }
                } 
            }
                FinalEmailIds.addall(EmailAddresses);        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(et_thirty.Id);
                mail.setToAddresses(FinalEmailIds);
                mail.setSaveAsActivity(false);
                mail.setWhatId(acc.id);
                mail.setTargetObjectId(TargetObjectId);
                mail.setTreatTargetObjectAsRecipient(true);
                mail.setOrgWideEmailAddressId(Label.Cerenovous_Organization_Wide_Addresses);
                allmsg.add(mail);  
                EmailAddresses.clear();
                FinalEmailIds.clear();                 
        } 
        
        EmailAddresses.clear();
        FinalEmailIds.clear();
        //Preparing email message for accounts 1 day after IRB expiration date
        for(Account acc : Exp1dayacclist)
        {   
            EmailAddresses.addall(CcoaMailids);
            if(TerrUserMap.size()>0 && TerrMap != null && (TerrMap.get(acc.territory__c)!=null)){
                if(TerrUserMap.get(TerrMap.get(acc.territory__c))!=null)
                {
                    for(Id userid : TerrUserMap.get(TerrMap.get(acc.territory__c)))
                    {   TargetObjectId = userid;
                        if(userid != null){
                            if(UserEmailMap.containskey(userid))
                            {   
                                if(UserEmailMap.get(userid)!=null){
                                EmailAddresses.addall(UserEmailMap.get(userid));  
                                    system.debug('EmailAddresses1.....'+EmailAddresses);
                                }
                            }
                        }
                    }
                } 
        }
                FinalEmailIds.addall(EmailAddresses);        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(et_one.Id);
                mail.setToAddresses(FinalEmailIds);
                mail.setSaveAsActivity(false);
                mail.setWhatId(acc.id);
                mail.setTargetObjectId(TargetObjectId);
                mail.setTreatTargetObjectAsRecipient(true);
                mail.setOrgWideEmailAddressId(Label.Cerenovous_Organization_Wide_Addresses);
                allmsg.add(mail);       
                EmailAddresses.clear();
                FinalEmailIds.clear();            
        }
        
        // sending email at the end
        try {
            if(allmsg.size()>0){
                Messaging.sendEmail(allmsg);  
            }    
        } catch (Exception e) {
            System.debug(e.getMessage());
        }        
    }
}