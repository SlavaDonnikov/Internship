public with sharing class metadataJSRemotingVFController {

    public metadataJSRemotingVFController() {}

    /**
     * @RemoteAction
     *
     * @param selectedFieldName String - name of the field of the selected sObject.
     * @param selectedSObjectName String - name of the selected sObject.
     *
     * @return List<FieldDetails> with the FieldDetails custom objects, which contains string description
     * [ name, label, type, FLS(isAccessible, isCreateable, isUpdateable) ] of the selected field.
     */
    @RemoteAction
    public static List<FieldDetails> getStandardSObjectFieldDetails(String selectedFieldName, String selectedSObjectName) {
        List<FieldDetails> selectedFieldsDetails = new List<FieldDetails>();

        List<Schema.SObjectField> sObjectFields = getStandardSObjectFields(selectedSObjectName);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (selectedFieldName == fieldDescribe.getLabel()) {
                selectedFieldsDetails.add(
                    new FieldDetails(
                        fieldDescribe.getName(),
                        fieldDescribe.getLabel(),
                        String.valueOf(fieldDescribe.getType()),
                        fieldDescribe.isAccessible(),
                        fieldDescribe.isCreateable(),
                        fieldDescribe.isUpdateable()
                    )
                );
            }
        }

        selectedFieldsDetails.sort();
        return selectedFieldsDetails;
    }

    @RemoteAction
    public static List<FieldDetails> getCustomSObjectFieldDetails(String selectedFieldName, String selectedSObjectName) {
        List<FieldDetails> selectedFieldsDetails = new List<FieldDetails>();

        List<Schema.SObjectField> sObjectFields = getCustomSObjectFields(selectedSObjectName);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (selectedFieldName == fieldDescribe.getLabel()) {
                selectedFieldsDetails.add(
                    new FieldDetails(
                        fieldDescribe.getName(),
                        fieldDescribe.getLabel(),
                        String.valueOf(fieldDescribe.getType()),
                        fieldDescribe.isAccessible(),
                        fieldDescribe.isCreateable(),
                        fieldDescribe.isUpdateable()
                    )
                );
            }
        }

        selectedFieldsDetails.sort();
        return selectedFieldsDetails;
    }


    /**
     * @RemoteAction
     *
     * @param selectedSObject String - name of the selected sObject.
     *
     * @return List<String> with all fields of the selected sObject.
     */
    @RemoteAction
    public static List<String> getStandardSObjectFieldNames(String selectedSObject) {
        List<String> selectedSObjectFields = new List<String>();

        List<Schema.SObjectField> sObjectFields = getStandardSObjectFields(selectedSObject);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedSObjectFields.add(fieldDescribe.getLabel());
        }

        selectedSObjectFields.sort();
        return selectedSObjectFields;
    }

    @RemoteAction
    public static List<String> getCustomSObjectFieldNames(String selectedSObject) {
        List<String> selectedSObjectFields = new List<String>();

        List<Schema.SObjectField> sObjectFields = getCustomSObjectFields(selectedSObject);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedSObjectFields.add(fieldDescribe.getLabel());
        }

        selectedSObjectFields.sort();
        return selectedSObjectFields;
    }


    /**
     * @param selectedSObject String - name of the selected sObject.
     *
     * @return List<Schema.SObjectField> with all fields of the selected sObject.
     */
    public static List<Schema.SObjectField> getStandardSObjectFields(String selectedSObject) {
        List<Schema.SObjectField> allObjectFields = new List<Schema.SObjectField>();

        SObjectWrapper targetSObject = new SObjectWrapper();
        List<SObjectWrapper> standardSObjects = getAllStandardSObjects();

        for (SObjectWrapper sObj : standardSObjects) {
            if (sObj.label == selectedSObject) {
                targetSObject = sObj;
            }
        }

        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(targetSObject.api).getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldsMap = objResult.fields.getMap();

        allObjectFields = sObjectFieldsMap.Values();

        return allObjectFields;
    }

    public static List<Schema.SObjectField> getCustomSObjectFields(String selectedSObject) {
        List<Schema.SObjectField> allObjectFields = new List<Schema.SObjectField>();

        SObjectWrapper targetSObject = new SObjectWrapper();
        List<SObjectWrapper> customSObjects = getAllCustomSObjects();

        for (SObjectWrapper sObj : customSObjects) {
            if (sObj.api == selectedSObject) {
                targetSObject = sObj;
            }
        }

        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(targetSObject.api).getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldsMap = objResult.fields.getMap();

        allObjectFields = sObjectFieldsMap.Values();

        return allObjectFields;
    }


    /**
     * @RemoteAction
     *
     * @return List<String> with Labels (standard sObjects) & API names (custom sObjects)
     * of the all org sObjects.
     */
    @RemoteAction
    public static List<String> getAllStandardSObjectNames() {
        List<String> allStandardObjectsNames = new List<String>();

        List<SObjectWrapper> standardSObjectList = getAllStandardSObjects();

        for (SObjectWrapper anSObjectName: standardSObjectList) {
            allStandardObjectsNames.add(anSObjectName.label);
        }

        allStandardObjectsNames.sort();
        return allStandardObjectsNames;
    }

    @RemoteAction
    public static List<String> getAllCustomSObjectNames() {
        List<String> allCustomObjectsNames = new List<String>();

        List<SObjectWrapper> customSObjectList = getAllCustomSObjects();

        for (SObjectWrapper anSObjectName: customSObjectList) {
            allCustomObjectsNames.add(anSObjectName.api);
        }

        allCustomObjectsNames.sort();
        return allCustomObjectsNames;
    }

    /**
     * @return List<SObjectWrapper> with the all org standard & custom sObjects, wrapped in
     * SObjectWrapper inner class.
     */
    public static List<SObjectWrapper> getAllStandardSObjects() {
        List<SObjectWrapper> standardSObjectList = new List<SObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribeResult = Schema.getGlobalDescribe();
        List<Schema.SObjectType> globalDescribeValues = globalDescribeResult.Values();

        for (Schema.SObjectType sObj : globalDescribeValues)
        {
            Schema.DescribeSObjectResult sObjResult = sObj.getDescribe();

            if (sObjResult.isCustom() == false){
                SObjectWrapper anObjWrp = new SObjectWrapper();
                anObjWrp.label = sObjResult.getLabel();
                anObjWrp.api = sObjResult.getName();

                standardSObjectList.add(anObjWrp);
            }
        }

        standardSObjectList.sort();
        return standardSObjectList;
    }

    public static List<SObjectWrapper> getAllCustomSObjects() {
        List<SObjectWrapper> customSObjectList = new List<SObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribeResult = Schema.getGlobalDescribe();
        List<Schema.SObjectType> globalDescribeValues = globalDescribeResult.Values();

        for (Schema.SObjectType sObj : globalDescribeValues)
        {
            Schema.DescribeSObjectResult sObjResult = sObj.getDescribe();

            if (sObjResult.isCustom()){
                SObjectWrapper anObjWrp = new SObjectWrapper();
                anObjWrp.label = sObjResult.getLabel();
                anObjWrp.api = sObjResult.getName();

                customSObjectList.add(anObjWrp);
            }
        }

        customSObjectList.sort();
        return customSObjectList;
    }


    // -------------------------------- Support classes ------------------------------------------------------------------------------------------------------------

    /**
     * Class for unique field details [ Name, Label, Type, FLS ].
     *
     * Implements Comparable interface, which allows sort records by label.
     */
    public class FieldDetails implements Comparable {

        public String name { get; set; }
        public String label { get; set; }
        public String type { get; set; }
        public Boolean isAccessible { get; set; }
        public Boolean isCreateable { get; set; }
        public Boolean isUpdateable { get; set; }

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
     * Wrap class for standard and custom sObjects.
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