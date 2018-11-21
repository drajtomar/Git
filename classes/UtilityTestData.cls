@istest
public class UtilityTestData {    
    
    /***************************************************************************************************
* Method name  : createUser
* Description  : Create User
***************************************************************************************************/
    
    public static User createUser(Boolean isInsert, String firstName, String lastName, Id profileId) {
        
        String fullName = firstName + '.' + lastname;
        User user = new User();
        user.FirstName = firstName;
        user.LastName = lastName;
        user.Email = fullName + '@cerenovous.com';
        user.UserName = fullName + '@cerenovous.com';
        user.Alias = lastname;
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.ProfileId = profileId;
        if (isInsert) {
            insert user;
        }
        return user;
    }    
    
    
    /***************************************************************************************************
* Method name  : createAccount
* Description  : Create Account
***************************************************************************************************/
    
    public static Account createAccount(Boolean isInsert, string name, string accNumber) {
        Account a = new Account();
        a.Name = name;
        a.AccountNumber = accNumber;
        if (isInsert) {
            insert a;
        }
        return a;
    }
    
    
    /***************************************************************************************************
* Method name  : createContact
* Description  : Create Contact
***************************************************************************************************/
    
    public static Contact createContact(Boolean isInsert, string phon, string lastname, Id accId, string email) {
        
        contact c = new contact();
        c.phone = phon;
        c.LastName = lastname;
        c.AccountId = accId;
        c.Email = email;
        if(isInsert) {
            insert c;
        }
        return c;
    }
    
    /***************************************************************************************************
* Method name  : createTerritory
* Description  : Create Territory 
***************************************************************************************************/
    public static Territory createTerritory(Boolean isInsert, String DeveloperName, String Description) {
        Territory ter = new Territory();
        ter.DeveloperName = DeveloperName;
        ter.Description = Description;
        if(isInsert) {
            insert ter;
        }
        return ter;        
    }

/***************************************************************************************************
* Method name  : CreateUserTerritory
* Description  : Create UserTerritory 
***************************************************************************************************/
    public static UserTerritory createUserTerritory(Boolean isInsert, Id territoryId, Id userIds) {
        UserTerritory usrTerritory = new UserTerritory();
        usrTerritory.TerritoryId = territoryId;
        usrTerritory.UserId = userIds;
        return usrTerritory;
    }
}