public class PaginatorController {
    public Integer pageNumber { get; set; }
    public Integer inputPageSize { get; set; }
    public List <PaginationTableObjectWrapper> objectWrappers { get; set; }
    public String sortByField {get; set;}
    public String sortDirection {get; set;}
    public Integer selectedPageSize {get; set;}

    public PaginatorController(){
        pageNumber = 1;
        sortDirection = 'DESC';
    }

    public Integer getTotalPages() {
        return Integer.valueof(Math.ceil((Double) objectWrappers.size() / (Double) getPageSize()));
    }

    public Integer getResultSize() {
        return objectWrappers.size();
    }
    
    public Boolean getHasPrevious() {
        return(pageNumber != 1);
    }

    public Boolean getHasNext() {
        return(pageNumber != getTotalPages());
    }
    
    public Pagereference previous() {
        if (getHasPrevious()) pageNumber--;
        return null;
    }
    public Pagereference next() {
        if (getHasNext()) pageNumber++;
        return null;
    }

    public void first() {
        pageNumber = 1;
    }

    public void last() {
        pageNumber = getTotalPages();
    }

    public void sortList(){
        for(PaginationTableObjectWrapper paginatedRecord : objectWrappers){
            paginatedRecord.setSortParameters(sortByField, sortDirection);
        }
        objectWrappers.sort();
    }

    public List<String> getDisplayFieldsList() {
        List<String> field_labels = new List<String>();
        if (this.getPaginatedRecords().size() > 0) {
            for (PaginationTableObjectWrapper.FieldWrapper wrapper : getPaginatedRecords()[0].fieldsList) {
                field_labels.add(wrapper.label);
            }
            if (sortByField == null) {
                sortByField = field_labels[0];
                selectedPageSize = inputPageSize;
                sortList();
            }
        }
        return field_labels;
    }

    public List<SelectOption> getPageSizeOptions() {
        List<SelectOption> page_size_options = new List<SelectOption>();
        page_size_options.add(new SelectOption('5','5'));
        page_size_options.add(new SelectOption('10','10'));
        page_size_options.add(new SelectOption('25','25'));
        page_size_options.add(new SelectOption('50','50'));
        return page_size_options;
    }

    public Integer getPageSize() {
        if (selectedPageSize == null) {
            return inputPageSize;
        } else {
            return selectedPageSize;
        }
    }

    public Integer getMinViewedRecords() {
        return (pageNumber-1) * getPageSize() + 1;
    }

    public Integer getMaxViewedRecords() {
        if ((pageNumber * getPageSize()) > getResultSize()){
            return getResultSize();
        } else {
            return (pageNumber * getPageSize());
        }
    }

    public void refreshSize() {
        pageNumber = 1;
    }

    public List <PaginationTableObjectWrapper> getPaginatedRecords() {
        List <PaginationTableObjectWrapper> paginated_records = new List<PaginationTableObjectWrapper>();
        Integer firstRecordPosition =  getMinViewedRecords() - 1;
        Integer lastRecordPosition =  getMaxViewedRecords() - 1;

        for (integer counter = firstRecordPosition; counter <= lastRecordPosition; counter++) {
            paginated_records.add(objectWrappers[counter]);
        }
        return paginated_records;
    }
}