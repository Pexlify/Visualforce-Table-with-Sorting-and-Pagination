@isTest
public class PaginationExampleControllerTest {
    private static testMethod void testGetWrappersShouldBeInitializedWhenObjectCreated() {
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            Test.startTest();
                setupData.initController();
            Test.stopTest();
            System.assertEquals(setupData.controller.wrappers.size(), 100);
        }
    }

    private static testMethod void testGetPageSizeShouldHaveDefaultValueWhenObjectCreated() {
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            Test.startTest();
                setupData.initController();
            Test.stopTest();
                System.assertEquals(setupData.controller.pageSize, 5);
        }
    }

    private static testMethod void testGetPageSizeShouldChangeValueWhenSetterIsCalled() {
        SetupData setupData = new SetupData();
        System.runAs(setupData.runningUser) {
            Test.startTest();
                setupData.initController();
                setupData.controller.pageSize = 10;
            Test.stopTest();
                System.assertEquals(setupData.controller.pageSize, 10);
        }
    }

    public class SetupData {
        public PaginationExampleController controller;
        public List<Account> objectsToPaginate;
        public User runningUser;

        public SetupData() {
            runningUser = TestUserBuilder.getBuilder().save().getRecord();
            objectsToPaginate = new List<Account>();
            for (Integer i = 0; i < 100; i++) {
                objectsToPaginate.add(new Account(Name = 'TestAccount#' + String.valueOf(i), Phone = String.valueOf(i*i*i)));
            }
            insert objectsToPaginate;
        }

        public void initController() {
            controller = new PaginationExampleController();
        }
    }
}