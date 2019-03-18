public with sharing class WrapperClasses {

    /**
     * Wrapper class for unique sObject (metadata) field details [ Name, Label, Type, FLS ].
     *
     * Implements Comparable interface, which allows sort records by label.
     */
    public class FieldDetails implements Comparable {

        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public Boolean isAccessible { get; set; }
        @AuraEnabled public Boolean isCreateable { get; set; }
        @AuraEnabled public Boolean isUpdateable { get; set; }

        public FieldDetails(String name, String label, String type, Boolean isAccessible, Boolean isCreateable, Boolean isUpdateable) {
            this.name = name;
            this.label = label;
            this.type = type;
            this.isAccessible = isAccessible;
            this.isCreateable = isCreateable;
            this.isUpdateable = isUpdateable;
        }

        public Integer compareTo(Object objToCompare) {
            FieldDetails sObjectField = (FieldDetails)objToCompare;
            return(this.label.compareTo(sObjectField.label));
        }
    }

    /**
     * Wrapper class for standard and custom sObjects.
     *
     * Contains sObject Label and API name.
     *
     * Implements Comparable interface, which allows sort records by label.
     */
    public class SObjectWrapper implements Comparable {
        public String label { get; set; }
        public String api { get; set; }

        public Integer compareTo(Object objToCompare) {
            SObjectWrapper sow = (SObjectWrapper)objToCompare;
            return(this.label.compareTo(sow.label));
        }
    }
}