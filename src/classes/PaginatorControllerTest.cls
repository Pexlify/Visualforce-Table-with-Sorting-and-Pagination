@isTest
public class PaginatorControllerTest {
    private static final Integer DEFAULT_PAGE_SIZE = 10;

    private static testMethod void testGetPagesCountShouldReturn10WhenPageSizeIs10AndRecordsCountIs100(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            Test.startTest();
                setupData.initController(DEFAULT_PAGE_SIZE);
            Test.stopTest();
            System.assertEquals(10, setupData.controller.getTotalPages());
        }
    }

    private static testMethod void testGetHasNextShouldReturnTrueWhenItIsFirstPageAndDataPagesCountIs10(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                Boolean hasNext = setupData.controller.getHasNext();
            Test.stopTest();
            System.assertEquals(true, hasNext);
        }
    }

    private static testMethod void testLastShouldSetCurrentPageToLastWhenItIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.last();
                Boolean hasNext = setupData.controller.getHasNext();
            Test.stopTest();
            System.assertEquals(false, hasNext);
            System.assertEquals(10, setupData.controller.pageNumber);
        }
    }

    private static testMethod void testGetHasPreviousShouldReturnFalseWhenItIsFirstPage(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                Boolean hasPrev = setupData.controller.getHasPrevious();
            Test.stopTest();
            System.assertEquals(false, hasPrev);
        }
    }

    private static testMethod void testFirstShouldSetCurrentPageToFirstWhenItIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.first();
                Boolean hasPrev = setupData.controller.getHasNext();
            Test.stopTest();
            System.assertEquals(true, hasPrev);
            System.assertEquals(1, setupData.controller.pageNumber);
        }
    }

    private static testMethod void testGetDisplayFieldsListShouldReturnValidLabelsWhenItIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                List<String> displayFieldsList = setupData.controller.getDisplayFieldsList();
            Test.stopTest();
            System.assertEquals('Name', displayFieldsList[0]);
        }
    }

    private static testMethod void testRefreshSizeShouldChangePageSizeAndSetPageToFirstWhenItIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.selectedPageSize = 5;
                setupData.controller.refreshSize();
            Test.stopTest();
            System.assertEquals(5, setupData.controller.getPageSize());
            System.assertEquals(1, setupData.controller.pageNumber);
        }
    }

    private static testMethod void testRefreshSizeShouldChangeTotalPagesWhenItIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.selectedPageSize = 5;
                setupData.controller.refreshSize();
            Test.stopTest();
            System.assertEquals(20, setupData.controller.getTotalPages());
        }
    }

    private static testMethod void testGetMinViewedRecordsShouldReturn1WhenOnFirstPage(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                Integer minViewed = setupData.controller.getMinViewedRecords();
            Test.stopTest();
            System.assertEquals(1, minViewed);
        }
    }

    private static testMethod void testGetMaxViewedRecordsShouldReturn10WhenOnFirstPage(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                Integer maxViewed = setupData.controller.getMaxViewedRecords();
            Test.stopTest();
            System.assertEquals(10, maxViewed);
        }
    }

    private static testMethod void testGetMinViewedRecordsShouldReturn91WhenOnLastPage(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.last();
                Integer minViewed = setupData.controller.getMinViewedRecords();
            Test.stopTest();
            System.assertEquals(91, minViewed);
        }
    }

    private static testMethod void testGetMaxViewedRecordsShouldReturn100WhenOnLastPage(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.last();
                Integer maxViewed = setupData.controller.getMaxViewedRecords();
            Test.stopTest();
            System.assertEquals(100, maxViewed);
        }
    }

    private static testMethod void testGetPageSizeOptionsShouldReturnValidValuesWhenCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                List<SelectOption> options = setupData.controller.getPageSizeOptions();
            Test.stopTest();
            System.assertEquals(4, options.size());
            System.assertEquals('5', options.get(0).getLabel());
            System.assertEquals('5', options.get(0).getValue());
        }
    }

    private static testMethod void testSortListShouldSortPaginatedRecordsWhenParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.sortByField = 'Name';
                setupData.controller.sortDirection = 'DESC';
                setupData.controller.sortList();
                List<PaginationTableObjectWrapper> wrappers = setupData.controller.getPaginatedRecords();
            Test.stopTest();
            for (Integer i = 0; i < DEFAULT_PAGE_SIZE-1; i++) {
                System.assert(((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i)).Name >= ((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i+1)).Name);
            }
        }
    }

    private static testMethod void testSortListShouldSortPaginatedRecordsWhenNoParamsSpecified(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                List<String> displayFieldsList = setupData.controller.getDisplayFieldsList();
                List<PaginationTableObjectWrapper> wrappers = setupData.controller.getPaginatedRecords();
            Test.stopTest();
            for (Integer i = 0; i < DEFAULT_PAGE_SIZE-1; i++) {
                System.assert(((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i)).Name >= ((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i+1)).Name);
            }
        }
    }

    private static testMethod void testNextShouldChangeCurrentPageToTheNextWhenNextIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.next();
                setupData.controller.next();
                setupData.controller.next();
                List<PaginationTableObjectWrapper> wrappers = setupData.controller.getPaginatedRecords();
            Test.stopTest();
            for (Integer i = 0; i < DEFAULT_PAGE_SIZE; i++) {
                System.assertEquals((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i), setupData.objectsToPaginate.get(i+30));
            }
        }
    }

    private static testMethod void testPreviousShouldChangeCurrentPageToThePreviousWhenNextIsCalled(){
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            setupData.initController(DEFAULT_PAGE_SIZE);
            Test.startTest();
                setupData.controller.last();
                setupData.controller.previous();
                setupData.controller.previous();
                List<PaginationTableObjectWrapper> wrappers = setupData.controller.getPaginatedRecords();
            Test.stopTest();
            for (Integer i = 0; i < DEFAULT_PAGE_SIZE; i++) {
                System.assertEquals((PaginatorControllerTest.TestWrapperImplementation) wrappers.get(i), setupData.objectsToPaginate.get(i+70));
            }
        }
    }

    public class SetupData {
        public PaginatorController controller;
        public List<PaginationTableObjectWrapper> objectsToPaginate;
        public User runningUser;

        public SetupData() {
            runningUser = TestUserBuilder.getBuilder().save().getRecord();
            objectsToPaginate = new List<PaginatorControllerTest.TestWrapperImplementation>();
            for (Integer i = 0; i < 100; i++) {
                objectsToPaginate.add(new PaginatorControllerTest.TestWrapperImplementation(new Account(Name = 'TestAccount#' + String.valueOf(i))));
            }
        }

        public void initController(Integer pagesize) {
            controller = new PaginatorController();
            controller.objectWrappers = objectsToPaginate;
            controller.inputPageSize = pagesize;
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