public class PaginationExampleController {
    public List<PaginationTableObjectWrapper> wrappers {get; set;}
    public Integer pageSize {get; set;}

    public PaginationExampleController() {
        pageSize = 5;
        wrappers = new List<AccountWrapper>();
        List<Account> all_accounts = [SELECT Name, Phone, Id FROM Account LIMIT 1000];
        for(Account acc : all_accounts){
            wrappers.add(new AccountWrapper(acc));
        }
    }
}