# Visualforce-Table-with-Sorting-and-Pagination

All of the standard lists in Salesforce have the ability to sort and paginate. However, when you create a table in Visualforce it’s not that easy to add sorting or pagination on it. For pagination there is StandardSetController which helps implementing pagination for a list of standard sObjects but there isn’t a simple solution for custom objects.

 

We’ve created a common component for ourselves that implements pagination, sorting and allows the user to change the number of rows in each page. We made it so it’s easy to use on every list of objects.

 

sorting and pagination visualforce table

 

The way it works is that each list of objects you would like to display in the list you will need to create a wrapper class for it. We created a base wrapper class so it’s easy to create a new wrapper class in the future:

 
```
public class AccountWrapper extends PaginationTableObjectWrapper {
    public String Name {get; private set;}
    public String Phone {get; private set;}

    public AccountWrapper (Account acc){
            this.Name = acc.Name;
            this.Phone = acc.Phone;
            if (this.Phone == null) {
                this.Phone = '';
            }
            populateFields();
    }

    public override Integer compareTo(Object compareTo){
        AccountWrapper otherAccountWrapper = (AccountWrapper) compareTo;
        Integer directionMultiplier = (sortDirection == 'ASC') ? 1 : -1;
        if(sortByField == 'Name'){
            return this.Name.compareTo(otherAccountWrapper.Name)*directionMultiplier;
        } else if(sortByField == 'Phone'){
            return this.Phone.compareTo(otherAccountWrapper.Phone)*directionMultiplier;
        }
        return 0;
    }

    private void populateFields() {
        fieldsList = new List<PaginationTableObjectWrapper.FieldWrapper>();
        fieldsList.add(new PaginationTableObjectWrapper.FieldWrapper('Name', this.Name));
        fieldsList.add(new PaginationTableObjectWrapper.FieldWrapper('Phone', this.Phone));
    }
}
``` 

The wrapper class would be able to tell how to sort the objects based on each column by implementing the compareTo method.

 

In our example we’re creating a table of accounts and allowing the user to sort the table by each of the Name and Phone columns. Our page controller would query all of the accounts we would like to display and create a wrapper instance for each of them.

 
```
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
``` 

Then all our Visualforce page needs to do is call our Paginator component to generate the table and that’s it! We need to pass to the Visualforce component the list of wrapper instances and the default size of every page.

 
```
<apex:page controller="PaginationExampleController">
    <apex:form >
        <apex:pageBlock >
             <c:Paginator Records="{!wrappers}" PageLength="{!pageSize}"/>
        </apex:pageBlock>
    </apex:form>
</apex:page>
``` 

This works with a common component we have called Paginator and we can use it for every table we would like to have sorting and pagination in it. The Paginator component has a controller called PaginatorController. All of the logic for the pagination is held in our PaginatorController class, this class has hold list of wrapper classes, the pagination methods and the sorting method. Another class that we have created is the base class of the wrapper class called PaginationTableObjectWrapper.