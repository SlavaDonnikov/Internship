public with sharing class orgMetadataTabSldsController {

    /**
     * List's of the Standard & Custom sObjects.
     */
    private List<SObjectWrapper> standardSObjects { get; set; }
    private List<SObjectWrapper> customSObjects { get; set; }

    /**
     * Selected in selectList Standard & Custom sObjects.
     */
    public String selectedCustomSObject { get; set; }
    public String selectedStandardSObject { get; set; }

    /**
     * Lists of fields of the selected Standard & Custom sObject.
     */
    public List<String> selectedFieldsOfStandardSObject { get; set; }
    public List<String> selectedFieldsOfCustomSObject { get; set; }

    /**
    * Variables are used as a value in <apex:selectList value="" /> in
    * Initial List ( id="standard_objects_list_transferTool_initialList" & id="custom_objects_list_transferTool_initialList")	and
    * Destination List ( id="standard_objects_list_transferTool_destinationList" & id="custom_objects_list_transferTool_destinationList")
    * in visualforce page, 'Transfer Tool' block.
    */
    public List<String> selectedStandardSObjectFieldsTransferToolForward { get; set; }
    public List<String> selectedStandardSObjectFieldsTransferToolBack { get; set; }

    public List<String> selectedCustomSObjectFieldsTransferToolForward { get; set; }
    public List<String> selectedCustomSObjectFieldsTransferToolBack { get; set; }


    /**
    * Variables are used as a value in transfer methods in 'Transfer Tool' block
    * in both Custom sObjects & Standard sObjects tabs.
    */
    private List<SelectOption> fieldsToInitialListStandardSObjects { get; set; }
    private List<SelectOption> fieldsToDestinationListStandardSObjects { get; set; }
    private Set<SelectOption> fieldsInTransferForwardStandardSObjects { get; set; }
    private Set<SelectOption> fieldsInTransferBackStandardSObjects { get; set; }

    private List<SelectOption> fieldsToInitialListCustomSObjects { get; set; }
    private List<SelectOption> fieldsToDestinationListCustomSObjects { get; set; }
    private Set<SelectOption> fieldsInTransferForwardCustomSObjects { get; set; }
    private Set<SelectOption> fieldsInTransferBackCustomSObjects { get; set; }

    public orgMetadataTabSldsController() {
        getOrgMetadata();
    }


    // -------------------------------- Transfer Tool Methods -------------------------------------------------------------------------
    // 'Transfer' Tool it's my custom name of a block at visualforce page, which is located in 2nd nested tab called 'Standard/Custom sObject Fields Transfer Tool'.

    /**
    * Methods are used as a value in <apex:selectOptions value="" /> in
    * Initial List ( id="standard_objects_list_transferTool_initialList" & id="custom_objects_list_transferTool_initialList" )	and
    * Destination List ( id="standard_objects_list_transferTool_destinationList" & id="custom_objects_list_transferTool_destinationList" )
    * in visualforce page, 'Transfer Tool' block.
    *
    * @return List<SelectOption> fieldsToInitialListStandardSObjects & List<SelectOption> 'fieldsToDestinationListStandardSObjects' variables in case of standard objects.
    * @return List<SelectOption> fieldsToInitialListCustomSObjects & List<SelectOption> 'fieldsToDestinationListCustomSObjects' variables in case of custom objects.
    */
    public List<SelectOption> getStandardSObjectFieldsToInitialList() {
        if (fieldsInTransferForwardStandardSObjects == null) {
            return fieldsToInitialListStandardSObjects = getStandardSObjectFields();
        } else {
            return fieldsToInitialListStandardSObjects;
        }
    }
    public List<SelectOption> getStandardSObjectFieldsToDestinationList() {
        return fieldsToDestinationListStandardSObjects;
    }

    public List<SelectOption> getCustomSObjectFieldsToInitialList() {
        if (fieldsInTransferForwardCustomSObjects == null) {
            return fieldsToInitialListCustomSObjects = getCustomSObjectFields();
        } else {
            return fieldsToInitialListCustomSObjects;
        }
    }
    public List<SelectOption> getCustomSObjectFieldsToDestinationList() {
        return fieldsToDestinationListCustomSObjects;
    }


    /**
    * Transfer selected fields from 'initial' selectList to
    * 'destination' selectList.
    */
    public void transferSeveralStandardFieldsForward() {

        if (fieldsToInitialListStandardSObjects == null) {
            fieldsToInitialListStandardSObjects = new List<SelectOption>();
        }

        if (fieldsToDestinationListStandardSObjects == null) {
            fieldsToDestinationListStandardSObjects = new List<SelectOption>();
        }

        if (fieldsInTransferForwardStandardSObjects == null) {
            fieldsInTransferForwardStandardSObjects = new Set<SelectOption>();
        }

        if (fieldsInTransferBackStandardSObjects == null) {
            fieldsInTransferBackStandardSObjects = new Set<SelectOption>();
        }

        if (selectedStandardSObjectFieldsTransferToolForward != null) {
            for (String anSelectedField : selectedStandardSObjectFieldsTransferToolForward) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedStandardSObject, this.standardSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());

                fieldsInTransferForwardStandardSObjects.add(field_SelOpt);
            }

            for (SelectOption selOpt : fieldsInTransferForwardStandardSObjects) {
                Integer fIndex = fieldsToInitialListStandardSObjects.indexOf(selOpt);
                fieldsToInitialListStandardSObjects.remove(fIndex);
                fieldsToDestinationListStandardSObjects.add(selOpt);

                fieldsInTransferForwardStandardSObjects.remove(selOpt);
            }
        }
    }

    public void transferSeveralCustomFieldsForward() {

        if (fieldsToInitialListCustomSObjects == null)
            fieldsToInitialListCustomSObjects = new List<SelectOption>();

        if (fieldsToDestinationListCustomSObjects == null) {
            fieldsToDestinationListCustomSObjects = new List<SelectOption>();
        }

        if (fieldsInTransferForwardCustomSObjects == null)
            fieldsInTransferForwardCustomSObjects = new Set<SelectOption>();

        if (fieldsInTransferBackCustomSObjects == null)
            fieldsInTransferBackCustomSObjects = new Set<SelectOption>();

        if (selectedCustomSObjectFieldsTransferToolForward != null) {
            for (String anSelectedField : selectedCustomSObjectFieldsTransferToolForward) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedCustomSObject, this.customSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());

                fieldsInTransferForwardCustomSObjects.add(field_SelOpt);
            }

            for (SelectOption selOpt : fieldsInTransferForwardCustomSObjects) {
                Integer fIndex = fieldsToInitialListCustomSObjects.indexOf(selOpt);
                fieldsToInitialListCustomSObjects.remove(fIndex);
                fieldsToDestinationListCustomSObjects.add(selOpt);

                fieldsInTransferForwardCustomSObjects.remove(selOpt);
            }
        }
    }


    /**
     * Transfer selected fields from 'destination' selectList to
     * 'initial' selectList.
     */
    public void transferSeveralStandardFieldsBack() {
        if (fieldsInTransferForwardStandardSObjects == null) return;

        if (fieldsInTransferBackStandardSObjects == null) {
            fieldsInTransferBackStandardSObjects = new Set<SelectOption>();
        }

        if (selectedStandardSObjectFieldsTransferToolBack != null) {
            for (String anSelectedField : selectedStandardSObjectFieldsTransferToolBack) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedStandardSObject, this.standardSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());

                fieldsInTransferBackStandardSObjects.add(field_SelOpt);
            }

            for (SelectOption selOpt : fieldsInTransferBackStandardSObjects) {
                Integer fIndex = fieldsToDestinationListStandardSObjects.indexOf(selOpt);
                fieldsToDestinationListStandardSObjects.remove(fIndex);
                fieldsToInitialListStandardSObjects.add(selOpt);

                fieldsInTransferBackStandardSObjects.remove(selOpt);
            }
        }
    }

    public void transferSeveralCustomFieldsBack() {
        if (fieldsInTransferForwardCustomSObjects == null) return;

        if (fieldsInTransferBackCustomSObjects == null) {
            fieldsInTransferBackCustomSObjects = new Set<SelectOption>();
        }

        if (selectedCustomSObjectFieldsTransferToolBack != null) {
            for (String anSelectedField : selectedCustomSObjectFieldsTransferToolBack) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedCustomSObject, this.customSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());

                fieldsInTransferBackCustomSObjects.add(field_SelOpt);
            }

            for (SelectOption selOpt : fieldsInTransferBackCustomSObjects) {
                Integer fIndex = fieldsToDestinationListCustomSObjects.indexOf(selOpt);
                fieldsToDestinationListCustomSObjects.remove(fIndex);
                fieldsToInitialListCustomSObjects.add(selOpt);

                fieldsInTransferBackCustomSObjects.remove(selOpt);
            }
        }
    }


    /**
     * Transfer all fields from 'initial' selectList to
     * 'destination' selectList.
     */
    public void transferAllStandardFieldsForward() {
        if (fieldsInTransferForwardStandardSObjects == null) {
            fieldsInTransferForwardStandardSObjects = new Set<SelectOption>();
        } else {
            fieldsInTransferForwardStandardSObjects.clear();
        }

        List<SelectOption> allFields = getStandardSObjectFields();
        fieldsInTransferForwardStandardSObjects.addAll(allFields);

        fieldsToInitialListStandardSObjects.clear();
        fieldsToDestinationListStandardSObjects = allFields;

        fieldsInTransferForwardStandardSObjects.clear();
    }

    public void transferAllCustomFieldsForward() {
        if (fieldsInTransferForwardCustomSObjects == null) {
            fieldsInTransferForwardCustomSObjects = new Set<SelectOption>();
        } else {
            fieldsInTransferForwardCustomSObjects.clear();
        }

        List<SelectOption> allFields = getCustomSObjectFields();
        fieldsInTransferForwardCustomSObjects.addAll(allFields);

        fieldsToInitialListCustomSObjects.clear();
        fieldsToDestinationListCustomSObjects = allFields;

        fieldsInTransferForwardCustomSObjects.clear();
    }


    /**
     * Transfer all fields from 'destination' selectList to
     * 'initial' selectList.
     */
    public void transferAllStandardFieldsBack() {
        if (fieldsInTransferBackStandardSObjects == null) {
            fieldsInTransferBackStandardSObjects = new Set<SelectOption>();
        } else {
            fieldsInTransferBackStandardSObjects.clear();
        }

        List<SelectOption> allFields = getStandardSObjectFields();
        fieldsInTransferBackStandardSObjects.addAll(allFields);

        fieldsToInitialListStandardSObjects = allFields;
        fieldsToDestinationListStandardSObjects.clear();

        fieldsInTransferBackStandardSObjects.clear();
    }

    public void transferAllCustomFieldsBack() {
        if (fieldsInTransferBackCustomSObjects == null) {
            fieldsInTransferBackCustomSObjects = new Set<SelectOption>();
        } else {
            fieldsInTransferBackCustomSObjects.clear();
        }

        List<SelectOption> allFields = getCustomSObjectFields();
        fieldsInTransferBackCustomSObjects.addAll(allFields);

        fieldsToInitialListCustomSObjects = allFields;
        fieldsToDestinationListCustomSObjects.clear();

        fieldsInTransferBackCustomSObjects.clear();
    }


    // -------------------------------- Methods that returns metadata in VF page (except Transfer Tool) ----------------------------------------------------------

    /**
     * Clear selected fields and field details when reselect sObject.
     */
    public void ClearStandardSelectedFields() {
        if (selectedFieldsOfStandardSObject != null) {
            selectedFieldsOfStandardSObject = null;
        }

        if (fieldsToInitialListStandardSObjects != null) {
            fieldsToInitialListStandardSObjects.clear();
        }

        fieldsToInitialListStandardSObjects = getStandardSObjectFields();

        if (fieldsToDestinationListStandardSObjects != null) {
            fieldsToDestinationListStandardSObjects.clear();
        }
    }

    public void ClearCustomSelectedFields() {
        if (selectedFieldsOfCustomSObject != null) {
            selectedFieldsOfCustomSObject = null;
        }

        if (fieldsToInitialListCustomSObjects != null) {
            fieldsToInitialListCustomSObjects.clear();
        }

        fieldsToInitialListCustomSObjects = getCustomSObjectFields();

        if (fieldsToDestinationListCustomSObjects != null) {
            fieldsToDestinationListCustomSObjects.clear();
        }
    }


    /**
    * @return List<FieldDetails>, which contains
    * description of selected sObject fields.
    */
    public List<FieldDetails> getStandardSObjectFieldDetails() {
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedStandardSObject, this.standardSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            for (String fieldLabel : selectedFieldsOfStandardSObject) {
                if (fieldDescribe.getLabel() == fieldLabel)  {
                    selectedFieldDetails.add(new FieldDetails(field));
                }
            }
        }

        return selectedFieldDetails;
    }

    public List<FieldDetails> getCustomSObjectFieldDetails() {
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedCustomSObject, this.customSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            for (String fieldLabel : selectedFieldsOfCustomSObject) {
                if (fieldDescribe.getLabel() == fieldLabel)  {
                    selectedFieldDetails.add(new FieldDetails(field));
                }
            }
        }

        return selectedFieldDetails;
    }


    /**
     * @return List<SelectOption>, which contains
     * list of fields of the selected sObject.
     */
    public List<SelectOption> getStandardSObjectFields() {
        List<SelectOption> selectedOptionFields = new List<SelectOption>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedStandardSObject, this.standardSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedOptionFields.add(new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel()));
        }

        selectedOptionFields.sort();
        return selectedOptionFields;
    }

    public List<SelectOption> getCustomSObjectFields() {
        List<SelectOption> selectedOptionFields = new List<SelectOption>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedCustomSObject, this.customSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedOptionFields.add(new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel()));
        }

        selectedOptionFields.sort();
        return selectedOptionFields;
    }


    /**
     * @return List<SelectOption> for sObjects from
     * 'standardSObjects' & 'customSObjects' variables.
     */
    public List<SelectOption> getAllStandardSObjects() {
        List<SelectOption> allStandardObjectsSelOpts = new List<SelectOption>();

        List<SObjectWrapper> sObjects = standardSObjects;

        for (SObjectWrapper anSObjectName: sObjects) {
            allStandardObjectsSelOpts.add(new SelectOption(anSObjectName.label, anSObjectName.label));
        }

        return allStandardObjectsSelOpts;
    }

    public List<SelectOption> getAllCustomSObjects() {
        List<SelectOption> allCustomObjectsSelOpts = new List<SelectOption>();

        List<SObjectWrapper> sObjects = customSObjects;

        for (SObjectWrapper anSObjectName: sObjects) {
            allCustomObjectsSelOpts.add(new SelectOption(anSObjectName.api, anSObjectName.api));
        }

        return allCustomObjectsSelOpts;
    }


    /**
     * All org custom & standard sObjects.
     *
     * Methods retrieve standard & custom org sObject's wrapped in
     * SObjectWrapper class (contains just Label & API name), and
     * populate 'standardSObjects' & 'customSObjects' variables, which are
     * used in other methods.
     */
    public void getOrgMetadata() {
        List<SObjectWrapper> standardSObjectList = new List<SObjectWrapper>();
        List<SObjectWrapper> customSObjectList = new List<SObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribeResult = Schema.getGlobalDescribe();
        List<Schema.SObjectType> globalDescribeValues = globalDescribeResult.Values();
        for (Schema.SObjectType sObj : globalDescribeValues)
        {
            Schema.DescribeSObjectResult sObjResult = sObj.getDescribe();

            SObjectWrapper anObjWrp = new SObjectWrapper();
            anObjWrp.label = sObjResult.getLabel();
            anObjWrp.api = sObjResult.getName();

            if (sObjResult.isCustom()){
                customSObjectList.add(anObjWrp);
            } else {
                standardSObjectList.add(anObjWrp);
            }
        }

        standardSObjectList.sort();
        customSObjectList.sort();
        standardSObjects = standardSObjectList;
        customSObjects = customSObjectList;
    }


    // -------------------------------- Universal methods ------------------------------------------------------------------------------------------


    /**
     * The method finds all the sObject fields by sObject Label (in case of standard sObject) or by sObject API name (in case of custom sObject).
     *
     * @return List<Schema.SObjectField> with sObject fields.
     * @param selectedStandardOrCustomSObjectLabel String - sObject Label / API name,
     * @param objects List<SObjectWrapper> - this.standardSObjects or this.customSObjects variable.
     */
    public List<Schema.SObjectField> getAllSObjectFields (String selectedStandardOrCustomSObjectLabel, List<SObjectWrapper> objects) {

        List<Schema.SObjectField> allObjectFields = new List<Schema.SObjectField>();

        SObjectWrapper anObject = new SObjectWrapper();

        if (objects == this.customSObjects) {
            for (SObjectWrapper sObj : objects) {
                if (sObj.api == selectedStandardOrCustomSObjectLabel) {
                    anObject = sObj;
                }
            }
        } else if (objects == this.standardSObjects) {
            for (SObjectWrapper sObj : objects) {
                if (sObj.label == selectedStandardOrCustomSObjectLabel) {
                    anObject = sObj;
                }
            }
        }

        Schema.DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(anObject.api).getDescribe();
        Map<String, Schema.SObjectField> sObjectFieldsMap = objResult.fields.getMap();

        allObjectFields = sObjectFieldsMap.Values();

        return allObjectFields;
    }

    /**
     * The method looks for a unique sObject field.
     *
     * @return Schema.SObjectField variable.
     * @param fieldName String - target field name (Label),
     * @param selectedStandardOrCustomSObjectLabel String - sObject Label / API name,
     * @param objects List<SObjectWrapper> - this.standardSObjects or this.customSObjects variable.
     */
    public Schema.SObjectField getUniqueSObjectField (String fieldName, String selectedStandardOrCustomSObjectLabel, List<SObjectWrapper> objects) {

        Schema.SObjectField result;

        List<Schema.SObjectField> sObjectFields = new List<Schema.SObjectField>();

        /*
        if(objects == this.customSObjects) {
            sObjectFields = this.getAllSObjectFields(this.selectedCustomSObject, this.customSObjects);

        } else if (objects == this.standardSObjects) {
            sObjectFields = this.getAllSObjectFields(this.selectedStandardSObject, this.standardSObjects);
        }
        */

        sObjectFields = this.getAllSObjectFields(selectedStandardOrCustomSObjectLabel, objects);

        for(Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if(fieldDescribe.getLabel() == fieldName) {
                result = field;
            }
        }

        return result;
    }


    // ------------------------------- Support classes -----------------------------------------------------------------------------------------------

    /**
     * Class for unique field details [ Name, Label, Type, FLS ].
     */
    public class FieldDetails {
        private Schema.SObjectField field;

        public FieldDetails(Schema.SObjectField field) {
            this.field = field;
        }

        public String name {
            get {
                return this.field.getDescribe().getName();
            }
        }

        public String label {
            get {
                return this.field.getDescribe().getLabel();
            }
        }

        public Schema.DisplayType type {
            get {
                return this.field.getDescribe().getType();
            }
        }

        public Boolean isAccessible {
            get {
                return this.field.getDescribe().isAccessible();
            }
        }

        public Boolean isCreateable {
            get {
                return this.field.getDescribe().isCreateable();
            }
        }

        public Boolean isUpdateable {
            get {
                return this.field.getDescribe().isUpdateable();
            }
        }
    }

    /**
     * Wrap class for standard and custom sObjects.
     *
     * Contains sObject Label and API name.
     *
     * Implements Comparable interface, which allows sort records by name.
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