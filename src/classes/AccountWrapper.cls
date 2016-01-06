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