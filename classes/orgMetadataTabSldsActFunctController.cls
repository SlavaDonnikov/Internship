public with sharing class orgMetadataTabSldsActFunctController {

    /**
     * List's of the Standard & Custom sObjects.
     */
    private List<SObjectWrapper> standardSObjects { get; set; }
    private List<SObjectWrapper> customSObjects { get; set; }


    /**
     * Selected in selectList Standard & Custom sObjects.
     */
    public String selectedStandardSObject { get; set; }
    public String selectedCustomSObject { get; set; }

    private List<String> standardSObjectFields { get; set; }
    private List<String> customSObjectFields { get; set; }

    /**
     * All selected sObject fields.
     */
    private List<FieldDetails> standardSObjectFieldDetails { get; set; }
    private List<FieldDetails> customSObjectFieldDetails { get; set; }

    /**
     * Selected sObject field as a param in actionFunction.
     */
    public String selectedOneFieldOfStandardSObject { get; set; }
    public String selectedOneFieldOfCustomSObject { get; set; }

    /**
     * Lists of fields of the selected Standard & Custom sObject.
     */
    public List<String> selectedFieldsOfStandardSObject { get; set; }
    public List<String> selectedFieldsOfCustomSObject { get; set; }

// ----------------------------------------------------

    /**
     * Variables are used as a params in <apex:param> in <apex:actionFunction>'s :
     * transferSeveralStandardFieldsForwardAF(fields);
     * transferSeveralStandardFieldsBackAF(fields);
     * transferSeveralCustomFieldsForwardAF(fields);
     * transferSeveralCustomFieldsBackAF(fields);
     *
     * All this <apex:actionFunction>'s called from JS function - transferSeveralFieldsJS(event);
     */
    public String selectedStandardSObjectFieldsCSVLikeForward { get; set; }
    public String selectedStandardSObjectFieldsCSVLikeBack { get; set; }

    public String selectedCustomSObjectFieldsCSVLikeForward { get; set; }
    public String selectedCustomSObjectFieldsCSVLikeBack { get; set; }

    /**
    * This variables are used as a private container for
    * selectedStandardSObjectFieldsCSVLikeForward,
    * selectedStandardSObjectFieldsCSVLikeBack,
    * selectedCustomSObjectFieldsCSVLikeForward,
    * selectedCustomSObjectFieldsCSVLikeBack variables.
    */
    private List<String> selectedStandardSObjectFieldsTransferToolForward { get; set; }
    private List<String> selectedStandardSObjectFieldsTransferToolBack { get; set; }

    private List<String> selectedCustomSObjectFieldsTransferToolForward { get; set; }
    private List<String> selectedCustomSObjectFieldsTransferToolBack { get; set; }


    /**
     * Variables are used as a value in transfer methods in 'Transfer Tool' block
     * in both Custom sObjects & Standard sObjects tabs.
     */
    private List<String> fieldsToInitialListStandardSObjects { get; set; }
    private List<String> fieldsToDestinationListStandardSObjects { get; set; }
    private Set<String> fieldsInTransferForwardStandardSObjects { get; set; }
    private Set<String> fieldsInTransferBackStandardSObjects { get; set; }

    private List<String> fieldsToInitialListCustomSObjects { get; set; }
    private List<String> fieldsToDestinationListCustomSObjects { get; set; }
    private Set<String> fieldsInTransferForwardCustomSObjects { get; set; }
    private Set<String> fieldsInTransferBackCustomSObjects { get; set; }


    public orgMetadataTabSldsActFunctController() {
        getOrgMetadata();
    }


    // -------------------------------- Transfer Tool Methods ------------------------------------------------------------------------------------------------------
    // 'Transfer' Tool it's my custom name of a block at visualforce page, which is located in 2nd nested tab called 'Standard/Custom sObject Fields Transfer Tool'.


    /**
     * Methods are used as a value in <apex:repeat> in
     * Initial List ( id="standard_objects_list_transferTool_initialList" & id="custom_objects_list_transferTool_initialList" )	and
     * Destination List ( id="standard_objects_list_transferTool_destinationList" & id="custom_objects_list_transferTool_destinationList" )
     * in visualforce page, 'Transfer Tool' block.
     *
     * @return List<String> fieldsToInitialListStandardSObjects & List<SelectOption> 'fieldsToDestinationListStandardSObjects' variables in case of standard objects.
     * @return List<String> fieldsToInitialListCustomSObjects & List<SelectOption> 'fieldsToDestinationListCustomSObjects' variables in case of custom objects.
     */
    public List<String> getStandardSObjectFieldsToInitialList() {
        if (fieldsInTransferForwardStandardSObjects == null) {
            return fieldsToInitialListStandardSObjects = getStandardSObjectFields();
        } else {
            return fieldsToInitialListStandardSObjects;
        }
    }
    public List<String> getStandardSObjectFieldsToDestinationList() {
        return fieldsToDestinationListStandardSObjects;
    }

    public List<String> getCustomSObjectFieldsToInitialList() {
        if (fieldsInTransferForwardCustomSObjects == null) {
            return fieldsToInitialListCustomSObjects = getCustomSObjectFields();
        } else {
            return fieldsToInitialListCustomSObjects;
        }
    }
    public List<String> getCustomSObjectFieldsToDestinationList() {
        return fieldsToDestinationListCustomSObjects;
    }


    /**
    * Transfer selected fields from 'initial' selectList to
    * 'destination' selectList.
    */
    public void transferSeveralStandardFieldsForward() {

        if (fieldsToInitialListStandardSObjects == null) {
            fieldsToInitialListStandardSObjects = new List<String>();
        }

        if (fieldsToDestinationListStandardSObjects == null) {
            fieldsToDestinationListStandardSObjects = new List<String>();
        }

        if (fieldsInTransferForwardStandardSObjects == null) {
            fieldsInTransferForwardStandardSObjects = new Set<String>();
        }

        if (fieldsInTransferBackStandardSObjects == null) {
            fieldsInTransferBackStandardSObjects = new Set<String>();
        }

        if (selectedStandardSObjectFieldsTransferToolForward == null) {
            selectedStandardSObjectFieldsTransferToolForward = new List<String>();
        } else {
            selectedStandardSObjectFieldsTransferToolForward.clear();
        }

        selectedStandardSObjectFieldsTransferToolForward = selectedStandardSObjectFieldsCSVLikeForward.split(',');

        if (selectedStandardSObjectFieldsTransferToolForward.size() > 0) {
            for (String anSelectedField : selectedStandardSObjectFieldsTransferToolForward) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedStandardSObject, this.standardSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                fieldsInTransferForwardStandardSObjects.add(fieldDescribe.getLabel());
            }

            for (String str : fieldsInTransferForwardStandardSObjects) {
                Integer fIndex = fieldsToInitialListStandardSObjects.indexOf(str);
                fieldsToInitialListStandardSObjects.remove(fIndex);
                fieldsToDestinationListStandardSObjects.add(str);

                fieldsInTransferForwardStandardSObjects.remove(str);
            }
        }
    }

    public void transferSeveralCustomFieldsForward() {

        if (fieldsToInitialListCustomSObjects == null)
            fieldsToInitialListCustomSObjects = new List<String>();

        if (fieldsToDestinationListCustomSObjects == null) {
            fieldsToDestinationListCustomSObjects = new List<String>();
        }

        if (fieldsInTransferForwardCustomSObjects == null)
            fieldsInTransferForwardCustomSObjects = new Set<String>();

        if (fieldsInTransferBackCustomSObjects == null)
            fieldsInTransferBackCustomSObjects = new Set<String>();

        if (selectedCustomSObjectFieldsTransferToolForward == null) {
            selectedCustomSObjectFieldsTransferToolForward = new List<String>();
        } else {
            selectedCustomSObjectFieldsTransferToolForward.clear();
        }

        selectedCustomSObjectFieldsTransferToolForward = selectedCustomSObjectFieldsCSVLikeForward.split(',');

        if (selectedCustomSObjectFieldsTransferToolForward.size() > 0) {
            for (String anSelectedField : selectedCustomSObjectFieldsTransferToolForward) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedCustomSObject, this.customSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                fieldsInTransferForwardCustomSObjects.add(fieldDescribe.getLabel());
            }

            for (String str : fieldsInTransferForwardCustomSObjects) {
                Integer fIndex = fieldsToInitialListCustomSObjects.indexOf(str);
                fieldsToInitialListCustomSObjects.remove(fIndex);
                fieldsToDestinationListCustomSObjects.add(str);

                fieldsInTransferForwardCustomSObjects.remove(str);
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
            fieldsInTransferBackStandardSObjects = new Set<String>();
        }

        if (selectedStandardSObjectFieldsTransferToolForward == null) {
            selectedStandardSObjectFieldsTransferToolForward = new List<String>();
        } else {
            selectedStandardSObjectFieldsTransferToolForward.clear();
        }

        selectedStandardSObjectFieldsTransferToolBack = selectedStandardSObjectFieldsCSVLikeBack.split(',');

        if (selectedStandardSObjectFieldsTransferToolBack.size() > 0) {
            for (String anSelectedField : selectedStandardSObjectFieldsTransferToolBack) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedStandardSObject, this.standardSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                fieldsInTransferBackStandardSObjects.add(fieldDescribe.getLabel());
            }

            for (String str : fieldsInTransferBackStandardSObjects) {
                Integer fIndex = fieldsToDestinationListStandardSObjects.indexOf(str);
                fieldsToDestinationListStandardSObjects.remove(fIndex);
                fieldsToInitialListStandardSObjects.add(str);

                fieldsInTransferBackStandardSObjects.remove(str);
            }
        }
    }

    public void transferSeveralCustomFieldsBack() {
        if (fieldsInTransferForwardCustomSObjects == null) return;

        if (fieldsInTransferBackCustomSObjects == null) {
            fieldsInTransferBackCustomSObjects = new Set<String>();
        }

        if (selectedCustomSObjectFieldsTransferToolForward == null) {
            selectedCustomSObjectFieldsTransferToolForward = new List<String>();
        } else {
            selectedCustomSObjectFieldsTransferToolForward.clear();
        }

        selectedCustomSObjectFieldsTransferToolBack = selectedCustomSObjectFieldsCSVLikeBack.split(',');

        if (selectedCustomSObjectFieldsTransferToolBack.size() > 0) {
            for (String anSelectedField : selectedCustomSObjectFieldsTransferToolBack) {
                Schema.SObjectField field = getUniqueSObjectField(anSelectedField, this.selectedCustomSObject, this.customSObjects);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                fieldsInTransferBackCustomSObjects.add(fieldDescribe.getLabel());
            }

            for (String str : fieldsInTransferBackCustomSObjects) {
                Integer fIndex = fieldsToDestinationListCustomSObjects.indexOf(str);
                fieldsToDestinationListCustomSObjects.remove(fIndex);
                fieldsToInitialListCustomSObjects.add(str);

                fieldsInTransferBackCustomSObjects.remove(str);
            }
        }
    }



    /**
     * Transfer all fields from 'initial' selectList to
     * 'destination' selectList.
     */
    public void transferAllStandardFieldsForward() {
        if (fieldsInTransferForwardStandardSObjects == null) {
            fieldsInTransferForwardStandardSObjects = new Set<String>();
        } else {
            fieldsInTransferForwardStandardSObjects.clear();
        }

        if(fieldsToDestinationListStandardSObjects == null) {
            fieldsToDestinationListStandardSObjects = new List<String>();
        } else {
            fieldsToDestinationListStandardSObjects.clear();
        }

        List<String> allFields = justStandardSObjectFields();
        fieldsInTransferForwardStandardSObjects.addAll(allFields);

        fieldsToInitialListStandardSObjects.clear();
        fieldsToDestinationListStandardSObjects = allFields;

        fieldsInTransferForwardStandardSObjects.clear();
    }

    public void transferAllCustomFieldsForward() {
        if (fieldsInTransferForwardCustomSObjects == null) {
            fieldsInTransferForwardCustomSObjects = new Set<String>();
        } else {
            fieldsInTransferForwardCustomSObjects.clear();
        }

        if(fieldsToDestinationListCustomSObjects == null) {
            fieldsToDestinationListCustomSObjects = new List<String>();
        } else {
            fieldsToDestinationListCustomSObjects.clear();
        }

        List<String> allFields = justCustomSObjectFields();
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
            fieldsInTransferBackStandardSObjects = new Set<String>();
        } else {
            fieldsInTransferBackStandardSObjects.clear();
        }

        List<String> allFields = justStandardSObjectFields();
        fieldsInTransferBackStandardSObjects.addAll(allFields);

        fieldsToInitialListStandardSObjects = allFields;
        fieldsToDestinationListStandardSObjects.clear();

        fieldsInTransferBackStandardSObjects.clear();
    }

    public void transferAllCustomFieldsBack() {
        if (fieldsInTransferBackCustomSObjects == null) {
            fieldsInTransferBackCustomSObjects = new Set<String>();
        } else {
            fieldsInTransferBackCustomSObjects.clear();
        }

        List<String> allFields = justCustomSObjectFields();
        fieldsInTransferBackCustomSObjects.addAll(allFields);

        fieldsToInitialListCustomSObjects = allFields;
        fieldsToDestinationListCustomSObjects.clear();

        fieldsInTransferBackCustomSObjects.clear();
    }


    // -------------------------------- Methods that returns metadata in VF page (except Transfer Tool) ------------------------------------------------------------


    /**
     * Clear selected fields, field details, transfer tool picklist's when reselect sObject.
     */
    public void ClearStandard() {
        if (selectedFieldsOfStandardSObject != null) {
            selectedFieldsOfStandardSObject = null;
        }

        if (fieldsToInitialListStandardSObjects != null) {
            fieldsToInitialListStandardSObjects.clear();
        }
        fieldsToInitialListStandardSObjects = getStandardSObjectFields();

        if(fieldsToDestinationListStandardSObjects != null) {
            fieldsToDestinationListStandardSObjects.clear();
        }

        fieldsInTransferForwardStandardSObjects = null;
        fieldsInTransferBackStandardSObjects = null;
    }

    public void ClearCustom() {
        if (selectedFieldsOfCustomSObject != null) {
            selectedFieldsOfCustomSObject = null;
        }

        if (fieldsToInitialListCustomSObjects != null) {
            fieldsToInitialListCustomSObjects.clear();
        }
        fieldsToInitialListCustomSObjects = getCustomSObjectFields();

        if(fieldsToDestinationListCustomSObjects != null) {
            fieldsToDestinationListCustomSObjects.clear();
        }

        fieldsInTransferForwardCustomSObjects = null;
        fieldsInTransferBackCustomSObjects = null;
    }



    /**
    * @return List<FieldDetails>, which contains
    * description of selected sObject fields.
    */
    public List<FieldDetails> getStandardSObjectFieldDetails() {
        return standardSObjectFieldDetails;
    }

    public List<FieldDetails> getCustomSObjectFieldDetails() {
        return customSObjectFieldDetails;
    }

    /**
     * Populate List<FieldDetails> standardSObjectFieldDetails & List<FieldDetails> customSObjectFieldDetails
     * private variables with the Schema.SObjectField objects, which contains a methods that returne fields description.
     *
     * @return void
     */
    public void processStandardSObjectFieldDetails() {
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();

        if (selectedFieldsOfStandardSObject == null) {
            selectedFieldsOfStandardSObject = new List<String>();
        }

        Set<String> tmp = new Set<String>(selectedFieldsOfStandardSObject);
        if (tmp.contains(selectedOneFieldOfStandardSObject) == false) {
            selectedFieldsOfStandardSObject.add(selectedOneFieldOfStandardSObject);
        }

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedStandardSObject, this.standardSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            for (String fieldLabel : selectedFieldsOfStandardSObject) {
                if (fieldDescribe.getLabel() == fieldLabel)  {
                    selectedFieldDetails.add(new FieldDetails(field));
                }
            }
        }

        selectedFieldDetails.sort();
        standardSObjectFieldDetails = selectedFieldDetails;
    }

    public void processCustomSObjectFieldDetails() {
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();

        if (selectedFieldsOfCustomSObject == null) {
            selectedFieldsOfCustomSObject = new List<String>();
        }

        Set<String> tmp = new Set<String>(selectedFieldsOfCustomSObject);
        if (tmp.contains(selectedOneFieldOfCustomSObject) == false) {
            selectedFieldsOfCustomSObject.add(selectedOneFieldOfCustomSObject);
        }

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedCustomSObject, this.customSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            for (String fieldLabel : selectedFieldsOfCustomSObject) {
                if (fieldDescribe.getLabel() == fieldLabel)  {
                    selectedFieldDetails.add(new FieldDetails(field));
                }
            }
        }

        selectedFieldDetails.sort();
        customSObjectFieldDetails = selectedFieldDetails;
    }



    /**
     * Methods returns lists of sObject fields.
     * Methods are used in 'STANDARD SOBJECT FIELDS AND FIELDS DESCRIPTION' &
     * 'CUSTOM SOBJECT FIELDS AND FIELDS DESCRIPTION' apex:repeat.
     *
     * @return List<String>
     */
    public List<String> getStandardSObjectFields() {
        return standardSObjectFields;
    }

    public List<String> getCustomSObjectFields() {
        return customSObjectFields;
    }

    /**
     * Populate List<String> standardSObjectFields & List<String> customSObjectFields
     * private variables with the fields of the selected sObject.
     *
     * Call clear function.
     *
     * Methods just for calling from apex:actionFunction
     *
     * @return void
     */
    public void processStandardSObjectFields() {
        ClearStandard();

        standardSObjectFields = justStandardSObjectFields();
    }

    public void processCustomSObjectFields() {
        ClearCustom();

        customSObjectFields = justCustomSObjectFields();
    }

    /**
     *  @return List<String> of selected sObject fields.
     */
    private List<String> justStandardSObjectFields() {
        List<String> selectedSObjectFields = new List<String>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedStandardSObject, this.standardSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedSObjectFields.add(fieldDescribe.getLabel());
        }

        selectedSObjectFields.sort();
        return selectedSObjectFields;
    }

    private List<String> justCustomSObjectFields() {
        List<String> selectedSObjectFields = new List<String>();

        List<Schema.SObjectField> sObjectFields = this.getAllSObjectFields(this.selectedCustomSObject, this.customSObjects);

        for (Schema.SObjectField field : sObjectFields) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedSObjectFields.add(fieldDescribe.getLabel());
        }

        selectedSObjectFields.sort();
        return selectedSObjectFields;
    }



    /**
     * @return List<String> with Labels (standard sObjects) & API names (custom sObjects)
     * of sObjects from 'standardSObjects' & 'customSObjects' variables.
     */
    public List<String> getAllStandardSObjects() {
        List<String> allStandardObjectsNames = new List<String>();

        List<SObjectWrapper> sObjects = standardSObjects;

        for (SObjectWrapper anSObjectName: sObjects) {
            allStandardObjectsNames.add(anSObjectName.label);
        }

        return allStandardObjectsNames;
    }

    public List<String> getAllCustomSObjects() {
        List<String> allCustomObjectsNames = new List<String>();

        List<SObjectWrapper> sObjects = customSObjects;

        for (SObjectWrapper anSObjectName: sObjects) {
            allCustomObjectsNames.add(anSObjectName.api);
        }

        return allCustomObjectsNames;
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


    // -------------------------------- Universal methods ----------------------------------------------------------------------------------------------------------


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


    // -------------------------------- Support classes ------------------------------------------------------------------------------------------------------------

    /**
     * Class for unique field details [ Name, Label, Type, FLS ].
     *
     * Implements Comparable interface, which allows sort records by label.
     */
    public class FieldDetails implements Comparable {
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