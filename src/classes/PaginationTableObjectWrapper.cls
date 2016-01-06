public abstract class PaginationTableObjectWrapper implements Comparable {
    public List<FieldWrapper> fieldsList {get; set;}
    @TestVisible protected String sortByField;
    @TestVisible protected String sortDirection;

    public abstract Integer compareTo(Object compareTo);
        
    public void setSortParameters(String sortByField, String sortDirection){
        this.sortByField = sortByField;
        this.sortDirection = sortDirection;
    }

    public class FieldWrapper {
        public String label {get; set;}
        public String value {get; set;}
        
        public FieldWrapper (String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}