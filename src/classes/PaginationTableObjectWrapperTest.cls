@isTest
public class PaginationTableObjectWrapperTest {
    private static testMethod void testCompareToShouldConsiderAllObjectsAreEqualWhenNoParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                Integer comparsionResult = setupData.TestWrapperImplementationRecord.compareTo(setupData.TestWrapperImplementationWithBiggerValues);
            Test.stopTest();
            System.assertEquals(0, comparsionResult);
        }
    }

    private static testMethod void testCompareToShouldWorkAsExcepctedWhenAllParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                setupData.TestWrapperImplementationRecord.setSortParameters('Name', 'DESC');
                Boolean testWrapperSmallerThantWrapperWithSmallerValues = setupData.TestWrapperImplementationRecord.compareTo(setupData.TestWrapperImplementationSmallValues) < 0;
                setupData.TestWrapperImplementationRecord.setSortParameters('Name', 'ASC');
                Boolean testWrapperBiggerThantWrapperWithSmallerValues = setupData.TestWrapperImplementationRecord.compareTo(setupData.TestWrapperImplementationSmallValues) > 0;
                setupData.TestWrapperImplementationSmallValuesCopy.setSortParameters('Phone', 'ASC');
                Boolean testWrapperWithSmallerValuesIsEqualToItsCopy = setupData.TestWrapperImplementationSmallValuesCopy.compareTo(setupData.TestWrapperImplementationSmallValues) == 0;
            Test.stopTest();
            System.assert(testWrapperSmallerThantWrapperWithSmallerValues);
            System.assert(testWrapperBiggerThantWrapperWithSmallerValues);
            System.assert(testWrapperWithSmallerValuesIsEqualToItsCopy);
        }
    }

    private static testMethod void testFieldListShouldBePopulatedWhenWrappersCreated(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initWrappers();
            Test.startTest();
                Integer fieidListSize = setupData.TestWrapperImplementationSmallValues.fieldsList.size();
                String fieldLabel = setupData.TestWrapperImplementationSmallValues.fieldsList[0].label;
                String fieldlValue = setupData.TestWrapperImplementationSmallValues.fieldsList[0].value;
            Test.stopTest();
            System.assertEquals(1, fieidListSize);
            System.assertEquals('Name', fieldLabel);
            System.assertEquals('A', fieldlValue);
        }
    }

    public class SetupData {
        public Account testAccountWithSmallerValues;
        public Account testAccountWithSmallerValuesCopy;
        public Account testAccount;
        public Account testAccountWithBiggerValues;
        public PaginationTableObjectWrapperTest.TestWrapperImplementation TestWrapperImplementationSmallValues;
        public PaginationTableObjectWrapperTest.TestWrapperImplementation TestWrapperImplementationSmallValuesCopy;
        public PaginationTableObjectWrapperTest.TestWrapperImplementation TestWrapperImplementationRecord;
        public PaginationTableObjectWrapperTest.TestWrapperImplementation TestWrapperImplementationWithBiggerValues;
        
        public User runningUser;

        public SetupData() {
            runningUser = TestUserBuilder.getBuilder().save().getRecord();
            testAccountWithSmallerValues = new Account(Name = 'A'); 
            testAccountWithSmallerValuesCopy = new Account(Name = 'A'); 
            testAccount = new Account(Name = 'B'); 
            testAccountWithBiggerValues = new Account(Name = 'C'); 
        }

        public void initWrappers() {
            TestWrapperImplementationSmallValues = new PaginationTableObjectWrapperTest.TestWrapperImplementation(testAccountWithSmallerValues);
            TestWrapperImplementationSmallValuesCopy = new PaginationTableObjectWrapperTest.TestWrapperImplementation(testAccountWithSmallerValuesCopy);
            TestWrapperImplementationRecord = new PaginationTableObjectWrapperTest.TestWrapperImplementation(testAccount);
            TestWrapperImplementationWithBiggerValues = new PaginationTableObjectWrapperTest.TestWrapperImplementation(testAccountWithBiggerValues);
        }
    }

    public class TestWrapperImplementation extends PaginationTableObjectWrapper {
        public String Name {get; private set;}

        public TestWrapperImplementation (Account acc){
            this.Name = acc.Name;
            populateFields();
        }

        public override Integer compareTo(Object compareTo){
            TestWrapperImplementation otherTestWrapperImplementation = (TestWrapperImplementation) compareTo;
            Integer directionMultiplier = (sortDirection == 'ASC') ? 1 : -1;
            if(sortByField == 'Name'){
                return ComparisonUtility.compareStrings(this.Name, otherTestWrapperImplementation.Name, directionMultiplier);
            }
            return 0;
        }

        private void populateFields() {
            fieldsList = new List<PaginationTableObjectWrapper.FieldWrapper>();
            fieldsList.add(new PaginationTableObjectWrapper.FieldWrapper('Name', this.Name));
        }
    }
}