public with sharing class MetadataProcessingController {

    public MetadataProcessingController() {}


    /**
     * @AuraEnabled
     *
     * @param selectedFieldName String - name of the field of the selected sObject.
     * @param selectedSObjectName String - name of the selected sObject.
     *
     * @return List<FieldDetails> with the FieldDetails custom objects, which contains string description
     * [ name, label, type, FLS(isAccessible, isCreateable, isUpdateable) ] of the selected field.
     */
    @AuraEnabled
    public static List<WrapperClasses.FieldDetails> getSObjectFieldDetails(String selectedFieldName, String selectedSObjectName) {
        List<WrapperClasses.FieldDetails> selectedFieldsDetails = new List<WrapperClasses.FieldDetails>();

        List<Schema.SObjectField> sObjectFields = getAnySObjectFields(selectedSObjectName);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (selectedFieldName == fieldDescribe.getLabel()) {
                selectedFieldsDetails.add(
                    new WrapperClasses.FieldDetails(
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
     * @AuraEnabled
     *
     * @param selectedSObject String - name of the selected sObject.
     *
     * @return List<String> with all fields of the selected sObject.
     */
    @AuraEnabled
    public static List<String> getAnySObjectFieldNames(String selectedSObject) {
        List<String> selectedSObjectFields = new List<String>();

        List<Schema.SObjectField> sObjectFields = getAnySObjectFields(selectedSObject);

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

        WrapperClasses.SObjectWrapper targetSObject = new WrapperClasses.SObjectWrapper();
        List<WrapperClasses.SObjectWrapper> standardSObjects = getAllStandardSObjects();

        for (WrapperClasses.SObjectWrapper sObj : standardSObjects) {
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

        WrapperClasses.SObjectWrapper targetSObject = new WrapperClasses.SObjectWrapper();
        List<WrapperClasses.SObjectWrapper> customSObjects = getAllCustomSObjects();

        for (WrapperClasses.SObjectWrapper sObj : customSObjects) {
            if (sObj.api == selectedSObject) {
                targetSObject = sObj;
            }
        }

        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(targetSObject.api).getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldsMap = objResult.fields.getMap();

        allObjectFields = sObjectFieldsMap.Values();

        return allObjectFields;
    }

    public static List<Schema.SObjectField> getAnySObjectFields(String selectedSObject) {
        List<Schema.SObjectField> allObjectFields = new List<Schema.SObjectField>();

        WrapperClasses.SObjectWrapper targetSObject = new WrapperClasses.SObjectWrapper();
        List<WrapperClasses.SObjectWrapper> orgSObjects = getAllOrgSObjects();

        for (WrapperClasses.SObjectWrapper sObj : orgSObjects) {
            if (sObj.label == selectedSObject || sObj.api == selectedSObject ) {
                targetSObject = sObj;
            }
        }

        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(targetSObject.api).getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldsMap = objResult.fields.getMap();

        allObjectFields = sObjectFieldsMap.Values();

        return allObjectFields;
    }


    /**
     * @AuraEnabled
     *
     * @return List<String> with Labels (standard sObjects) & API names (custom sObjects)
     * of the all org sObjects. Or return both standard & custom sObjects labels/apis.
     */
    @AuraEnabled
    public static List<String> getAllStandardSObjectNames() {
        List<String> allStandardObjectsNames = new List<String>();

        List<WrapperClasses.SObjectWrapper> standardSObjectList = getAllStandardSObjects();

        for (WrapperClasses.SObjectWrapper anSObjectName: standardSObjectList) {
            allStandardObjectsNames.add(anSObjectName.label);
        }

        allStandardObjectsNames.sort();
        return allStandardObjectsNames;
    }

    @AuraEnabled
    public static List<String> getAllCustomSObjectNames() {
        List<String> allCustomObjectsNames = new List<String>();

        List<WrapperClasses.SObjectWrapper> customSObjectList = getAllCustomSObjects();

        for (WrapperClasses.SObjectWrapper anSObjectName: customSObjectList) {
            allCustomObjectsNames.add(anSObjectName.api);
        }

        allCustomObjectsNames.sort();
        return allCustomObjectsNames;
    }

    @AuraEnabled
    public static List<String> getAllOrgSObjectNames() {
        List<String> allOrgSObjectNames = new List<String>();
        List<String> allStandardObjectsNames = new List<String>();
        List<String> allCustomObjectsNames = new List<String>();

        List<WrapperClasses.SObjectWrapper> standardSObjectList = getAllStandardSObjects();
        List<WrapperClasses.SObjectWrapper> customSObjectList = getAllCustomSObjects();


        for (WrapperClasses.SObjectWrapper anSObjectName: standardSObjectList) {
            allStandardObjectsNames.add(anSObjectName.label);
        }

        for (WrapperClasses.SObjectWrapper anSObjectName: customSObjectList) {
            allCustomObjectsNames.add(anSObjectName.api);
        }

        allOrgSObjectNames.addAll(allStandardObjectsNames);
        allOrgSObjectNames.addAll(allCustomObjectsNames);

        allOrgSObjectNames.sort();
        return allOrgSObjectNames;
    }

    /**
     * @return List<WrapperClasses.SObjectWrapper> with the all org standard & custom sObjects, wrapped in
     * WrapperClasses.SObjectWrapper inner class.
     */
    public static List<WrapperClasses.SObjectWrapper> getAllStandardSObjects() {
        List<WrapperClasses.SObjectWrapper> standardSObjectList = new List<WrapperClasses.SObjectWrapper>();
        Set<WrapperClasses.SObjectWrapper> tmp = new Set<WrapperClasses.SObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribeResult = Schema.getGlobalDescribe();
        List<Schema.SObjectType> globalDescribeValues = globalDescribeResult.Values();

        for (Schema.SObjectType sObj : globalDescribeValues)
        {
            Schema.DescribeSObjectResult sObjResult = sObj.getDescribe();

            if (sObjResult.isCustom() == false){
                WrapperClasses.SObjectWrapper anObjWrp = new WrapperClasses.SObjectWrapper();
                anObjWrp.label = sObjResult.getLabel();
                anObjWrp.api = sObjResult.getName();

                standardSObjectList.add(anObjWrp);
            }
        }

        standardSObjectList.sort();
        return standardSObjectList;
    }

    public static List<WrapperClasses.SObjectWrapper> getAllCustomSObjects() {
        List<WrapperClasses.SObjectWrapper> customSObjectList = new List<WrapperClasses.SObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribeResult = Schema.getGlobalDescribe();
        List<Schema.SObjectType> globalDescribeValues = globalDescribeResult.Values();

        for (Schema.SObjectType sObj : globalDescribeValues)
        {
            Schema.DescribeSObjectResult sObjResult = sObj.getDescribe();

            if (sObjResult.isCustom()){
                WrapperClasses.SObjectWrapper anObjWrp = new WrapperClasses.SObjectWrapper();
                anObjWrp.label = sObjResult.getLabel();
                anObjWrp.api = sObjResult.getName();

                customSObjectList.add(anObjWrp);
            }
        }

        customSObjectList.sort();
        return customSObjectList;
    }

    public static List<WrapperClasses.SObjectWrapper> getAllOrgSObjects() {
        List<WrapperClasses.SObjectWrapper> allOrgSObjects = new List<WrapperClasses.SObjectWrapper>();
        List<WrapperClasses.SObjectWrapper> standardSObjectList = getAllStandardSObjects();
        List<WrapperClasses.SObjectWrapper> customSObjectList = getAllCustomSObjects();

        allOrgSObjects.addAll(standardSObjectList);
        allOrgSObjects.addAll(customSObjectList);

        allOrgSObjects.sort();
        return allOrgSObjects;
    }
}