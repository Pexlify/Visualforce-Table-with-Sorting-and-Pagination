@isTest
public class AccountWrapperTest {

    private static testMethod void testCompareToShouldConsiderAllObjectsAreEqualWhenNoParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                Integer comparsionResult = setupData.testAccountWrapper.compareTo(setupData.testAccountWrapperWithBiggerValues);
            Test.stopTest();
            System.assertEquals(0, comparsionResult);
        }
    }

    private static testMethod void testCompareToShouldWorkAsExcepctedWhenAllParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                setupData.testAccountWrapper.setSortParameters('Name', 'DESC');
                Boolean testWrapperSmallerThantWrapperWithSmallerValues = setupData.testAccountWrapper.compareTo(setupData.testAccountWrapperSmallerValues) < 0;
                setupData.testAccountWrapper.setSortParameters('Name', 'ASC');
                Boolean testAccountWrapperBiggerThantestAccountWrapperSmallerValues = setupData.testAccountWrapper.compareTo(setupData.testAccountWrapperSmallerValues) > 0;
                setupData.testAccountWrapperSmallerValuesCopy.setSortParameters('Phone', 'ASC');
                Boolean testAccountWrapperSmallerValuesEqualtsToItsCopy = setupData.testAccountWrapperSmallerValuesCopy.compareTo(setupData.testAccountWrapperSmallerValues) == 0;
            Test.stopTest();
            System.assert(testWrapperSmallerThantWrapperWithSmallerValues);
            System.assert(testAccountWrapperBiggerThantestAccountWrapperSmallerValues);
            System.assert(testAccountWrapperSmallerValuesEqualtsToItsCopy);
        }
    }

    private static testMethod void testFieldListShouldBePopulatedWhenWrappersCreated(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                Integer fieidListSize = setupData.testAccountWrapperSmallerValues.fieldsList.size();
                String firstFieldLabel = setupData.testAccountWrapperSmallerValues.fieldsList[0].label;
                String firstFieldlValue = setupData.testAccountWrapperSmallerValues.fieldsList[0].value;
                String secondFieldLabel = setupData.testAccountWrapperSmallerValues.fieldsList[1].label;
                String secondFieldlValue = setupData.testAccountWrapperSmallerValues.fieldsList[1].value;
            Test.stopTest();
            System.assertEquals(2, fieidListSize);
            System.assertEquals('Name', firstFieldLabel);
            System.assertEquals('A', firstFieldlValue);
            System.assertEquals('Phone', secondFieldLabel);
            System.assertEquals('5555', secondFieldlValue);
        }
    }


    public class SetupData {
        public Account testAccountWithSmallerValues;
        public Account testAccountWithSmallerValuesCopy;
        public Account testAccount;
        public Account testAccountWithBiggerValues;
        public AccountWrapper testAccountWrapperSmallerValues;
        public AccountWrapper testAccountWrapperSmallerValuesCopy;
        public AccountWrapper testAccountWrapper;
        public AccountWrapper testAccountWrapperWithBiggerValues;
        
        public User runningUser;

        public SetupData() {
            runningUser = TestUserBuilder.getBuilder().save().getRecord();
            testAccountWithSmallerValues = new Account(Name = 'A', Phone = '5555'); 
            testAccountWithSmallerValuesCopy = new Account(Name = 'A', Phone = '5555'); 
            testAccount = new Account(Name = 'B', Phone = '6666'); 
            testAccountWithBiggerValues = new Account(Name = 'C'); 
        }

        public void initWrappers() {
            testAccountWrapperSmallerValues = new AccountWrapper(testAccountWithSmallerValues);
            testAccountWrapperSmallerValuesCopy = new AccountWrapper(testAccountWithSmallerValuesCopy);
            testAccountWrapper = new AccountWrapper(testAccount);
            testAccountWrapperWithBiggerValues = new AccountWrapper(testAccountWithBiggerValues);
        }
    }
}