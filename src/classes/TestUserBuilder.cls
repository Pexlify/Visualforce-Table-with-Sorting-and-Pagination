@isTest
public class TestUserBuilder {
    public static String STANDARD_USER = 'Standard User';
    public static Builder getBuilder(){
        return new Builder();
    }

    public class Builder{
        private User Record;

        public Builder(){
            Record = new User();
            String random_email = generateRandomString(20) + '@' + generateRandomString(10) + '.com';
            Record.Username = random_email;
            Record.Email = random_email;
            String random_string = generateRandomString(8);
            Record.LastName = random_string;
            Record.Alias = random_string;
            Record.CommunityNickname = random_string;
            Record.TimeZoneSidKey = 'GMT';
            Record.LocaleSidKey = 'en_US';
            Record.EmailEncodingKey = 'UTF-8';
            Record.LanguageLocaleKey = 'en_US';
            String profile_id = [SELECT Name, Id FROM Profile WHERE Name = :STANDARD_USER LIMIT 1][0].id;
            Record.ProfileId = profile_id;
        }

        public Builder save(){
            insert Record;
            Record = [SELECT Name, Id, Email, LastName, ProfileId FROM User WHERE Id = :Record.Id];
            return this;
        }

        public User getRecord(){
            return Record;
        }
    }

    private static String generateRandomString(Integer length_of_string) {
        final String possible_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String random_string = '';
        while (random_string.length() < length_of_string) {
           Integer index_of_random_char = Math.mod(Math.abs(Crypto.getRandomInteger()), possible_chars.length());
           random_string += possible_chars.substring(index_of_random_char, index_of_random_char + 1);
        }
        return random_string; 
    }
}