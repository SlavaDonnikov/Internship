public class orgMetadataController {
	
    /*
     * All org sObjects description variable.
	 */
    private Map<String, Schema.SObjectType> globalDescribe { get; set; }
    
    /*
     * List's of Standart & Custom sObjects.
	 */
	private List<SObjectWrapper> StandartObjects { get; set; } 
    private List<SObjectWrapper> CustomObjects { get; set; }
    
    
    /*     
     * Selected in selectList Standart & Custom sObjects.
	 */
    public String selectedCustomObject { get; set; }
    public String selectedStandartObject { get; set; }
    
    /*
     * Lists of fields of the selected Standart & Custom sObject.
	 */   
    public List<String> selectedFieldsOfStandartObject { get; set; }
    public List<String> selectedFieldsOfCustomObject { get; set; }
    
    
    /*
     * Variables are used as a value in <apex:selectList value="" /> in 
     * Initial List ( id="standart_objects_list_transferTool_initialList" & id="custom_objects_list_transferTool_initialList")	and
     * Destination List ( id="standart_objects_list_transferTool_destinationList" & id="custom_objects_list_transferTool_destinationList")
     * in visualforce page, 'Transfer Tool' block.
	 */
    public List<String> selectedStandartSObjectFields_TransferTool_Forward { get; set; }
    public List<String> selectedStandartSObjectFields_TransferTool_Back { get; set; }
    
    public List<String> selectedCustomSObjectFields_TransferTool_Forward { get; set; }
    public List<String> selectedCustomSObjectFields_TransferTool_Back { get; set; }
    
    /*
     * Variables are used as a value in transfer methods in 'Transfer Tool' block 
     * in both Custom sObjects & Standart sObjects tabs.
	 */
    private List<SelectOption> fields_to_initialList_StandartSObjects { get; set; } 
    private List<SelectOption> fields_to_destinationList_StandartSObjects { get; set; }
    private Set<SelectOption> fields_in_transfer_forward_StandartSObjects { get; set; }
    private Set<SelectOption> fields_in_transfer_back_StandartSObjects { get; set; }
    
    private List<SelectOption> fields_to_initialList_CustomSObjects { get; set; } 
    private List<SelectOption> fields_to_destinationList_CustomSObjects { get; set; }
    private Set<SelectOption> fields_in_transfer_forward_CustomSObjects { get; set; }
    private Set<SelectOption> fields_in_transfer_back_CustomSObjects { get; set; }
    
    
    public orgMetadataController() {
        globalDescribe = Schema.getGlobalDescribe();
        StandartObjects = getStandartSObjectsMetadata();
        CustomObjects = getCustomSObjectsMetadata();
    }  
    
    
    // -------------------------------- Transfer Tool Methods -------------------------------------------------------------------------
    // 'Transfer' Tool it's my custom name of a block at visualforce page, which is located in 2nd nested tab called 'Standart/Custom sObject Fields Transfer Tool'.
       
    /*
     * Methods are used as a value in <apex:selectOptions value="" /> in 
     * Initial List ( id="standart_objects_list_transferTool_initialList" & id="custom_objects_list_transferTool_initialList" )	and
     * Destination List ( id="standart_objects_list_transferTool_destinationList" & id="custom_objects_list_transferTool_destinationList" )
     * in visualforce page, 'Transfer Tool' block.
     * Returns 'fields_to_initialList_StandartSObjects' & 'fields_to_destinationList_StandartSObjects' variables in case of standart objects.
     * Returns 'fields_to_initialList_CustomSObjects' & 'fields_to_destinationList_CustomSObjects' variables in case of custom objects.
	 */
    public List<SelectOption> getStandartObjectFields_InitialList() {        
        if(fields_in_transfer_forward_StandartSObjects == null) {
            return fields_to_initialList_StandartSObjects = getStandartObjectFields(); 
        } else {
            return fields_to_initialList_StandartSObjects;
        } 
    }
    public List<SelectOption> getStandartObjectFields_DestinationList() {        
        return fields_to_destinationList_StandartSObjects;
    }
    
    public List<SelectOption> getCustomObjectFields_InitialList() {
        if(fields_in_transfer_forward_CustomSObjects == null) {
            return fields_to_initialList_CustomSObjects = getCustomObjectFields();
        } else {
            return fields_to_initialList_CustomSObjects;
        }
    }
    public List<SelectOption> getCustomObjectFields_DestinationList() {        
        return fields_to_destinationList_CustomSObjects;
    }
    
    
    /*
     * Transfer selected fields from 'initial' selectList to 
     * 'destination' selectList.
	 */
    public void transferSeveralStandartFieldsForward() {        
       
        if(fields_to_initialList_StandartSObjects == null)
            fields_to_initialList_StandartSObjects = new List<SelectOption>();
        
        if(fields_to_destinationList_StandartSObjects == null) {
            fields_to_destinationList_StandartSObjects = new List<SelectOption>();
        }
        
		if(fields_in_transfer_forward_StandartSObjects == null) 
            fields_in_transfer_forward_StandartSObjects = new Set<SelectOption>();  
        
        if(fields_in_transfer_back_StandartSObjects == null) 
            fields_in_transfer_back_StandartSObjects = new Set<SelectOption>();
                              
        if(selectedStandartSObjectFields_TransferTool_Forward != null) {
            for(String anSelectedField : selectedStandartSObjectFields_TransferTool_Forward) {
                Schema.SObjectField field = getUniqSObjectField (anSelectedField, this.selectedStandartObject, this.StandartObjects);                
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());
                
                fields_in_transfer_forward_StandartSObjects.add(field_SelOpt);
            }

            for(SelectOption selOpt : fields_in_transfer_forward_StandartSObjects) {
                Integer fIndex = fields_to_initialList_StandartSObjects.indexOf(selOpt);
                fields_to_initialList_StandartSObjects.remove(fIndex); 
                fields_to_destinationList_StandartSObjects.add(selOpt);                
               
                fields_in_transfer_forward_StandartSObjects.remove(selOpt);
            }
        }
    }
    
    public void transferSeveralCustomFieldsForward() {
        
        if(fields_to_initialList_CustomSObjects == null)
            fields_to_initialList_CustomSObjects = new List<SelectOption>();
        
        if(fields_to_destinationList_CustomSObjects == null) {
            fields_to_destinationList_CustomSObjects = new List<SelectOption>();
        }
        
		if(fields_in_transfer_forward_CustomSObjects == null) 
            fields_in_transfer_forward_CustomSObjects = new Set<SelectOption>();  
        
        if(fields_in_transfer_back_CustomSObjects == null) 
            fields_in_transfer_back_CustomSObjects = new Set<SelectOption>();
        
        if(selectedCustomSObjectFields_TransferTool_Forward != null) {
            for(String anSelectedField : selectedCustomSObjectFields_TransferTool_Forward) {
                Schema.SObjectField field = getUniqSObjectField (anSelectedField, this.selectedCustomObject, this.CustomObjects);                
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());
                
                fields_in_transfer_forward_CustomSObjects.add(field_SelOpt);
            }

            for(SelectOption selOpt : fields_in_transfer_forward_CustomSObjects) {
                Integer fIndex = fields_to_initialList_CustomSObjects.indexOf(selOpt);
                fields_to_initialList_CustomSObjects.remove(fIndex); 
                fields_to_destinationList_CustomSObjects.add(selOpt);                
               
                fields_in_transfer_forward_CustomSObjects.remove(selOpt);
            }
        }
    }
    
    
     /*
      * Transfer selected fields from 'destination' selectList to 
      * 'initial' selectList.
	  */
    public void transferSeveralStandartFieldsBack() {
        if(fields_in_transfer_forward_StandartSObjects == null) return;  
        
        if(fields_in_transfer_back_StandartSObjects == null) 
            fields_in_transfer_back_StandartSObjects = new Set<SelectOption>();
        
        if(selectedStandartSObjectFields_TransferTool_Back != null) {
            for(String anSelectedField : selectedStandartSObjectFields_TransferTool_Back) {
                Schema.SObjectField field = getUniqSObjectField (anSelectedField, this.selectedStandartObject, this.StandartObjects);                
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());
                
                fields_in_transfer_back_StandartSObjects.add(field_SelOpt);                
            }
            
            for(SelectOption selOpt : fields_in_transfer_back_StandartSObjects) {
                Integer fIndex = fields_to_destinationList_StandartSObjects.indexOf(selOpt);
                fields_to_destinationList_StandartSObjects.remove(fIndex);
                fields_to_initialList_StandartSObjects.add(selOpt);
                
                fields_in_transfer_back_StandartSObjects.remove(selOpt);
            }
        }
    }
    
    public void transferSeveralCustomFieldsBack() {
        if(fields_in_transfer_forward_CustomSObjects == null) return;  
        
        if(fields_in_transfer_back_CustomSObjects == null) 
            fields_in_transfer_back_CustomSObjects = new Set<SelectOption>();
        
        if(selectedCustomSObjectFields_TransferTool_Back != null) {
            for(String anSelectedField : selectedCustomSObjectFields_TransferTool_Back) {
                Schema.SObjectField field = getUniqSObjectField (anSelectedField, this.selectedCustomObject, this.CustomObjects);                
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                SelectOption field_SelOpt = new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel());
                
                fields_in_transfer_back_CustomSObjects.add(field_SelOpt);                
            }
            
            for(SelectOption selOpt : fields_in_transfer_back_CustomSObjects) {
                Integer fIndex = fields_to_destinationList_CustomSObjects.indexOf(selOpt);
                fields_to_destinationList_CustomSObjects.remove(fIndex);
                fields_to_initialList_CustomSObjects.add(selOpt);
                
                fields_in_transfer_back_CustomSObjects.remove(selOpt);
            }
        }
    }
    
    
    /*
     * Transfer all fields from 'initial' selectList to 
     * 'destination' selectList.
	 */
    public void transferAllStandartFieldsForward() {
        if(fields_in_transfer_forward_StandartSObjects == null) {
             fields_in_transfer_forward_StandartSObjects = new Set<SelectOption>();
        } else {
            fields_in_transfer_forward_StandartSObjects.clear();
        }        
        
        List<SelectOption> allFields = getStandartObjectFields();
        fields_in_transfer_forward_StandartSObjects.addAll(allFields);
        
		fields_to_initialList_StandartSObjects.clear();      
        fields_to_destinationList_StandartSObjects = allFields;
        
        fields_in_transfer_forward_StandartSObjects.clear();            
    }
    
    public void transferAllCustomFieldsForward() {
        if(fields_in_transfer_forward_CustomSObjects == null) {
             fields_in_transfer_forward_CustomSObjects = new Set<SelectOption>();
        } else {
            fields_in_transfer_forward_CustomSObjects.clear();
        }        
        
        List<SelectOption> allFields = getCustomObjectFields();
        fields_in_transfer_forward_CustomSObjects.addAll(allFields);
        
		fields_to_initialList_CustomSObjects.clear();      
        fields_to_destinationList_CustomSObjects = allFields;
        
        fields_in_transfer_forward_CustomSObjects.clear();
    }
    
    
    /*
     * Transfer all fields from 'destination' selectList to 
     * 'initial' selectList.
	 */
    public void transferAllStandartFieldsBack() {        
        if(fields_in_transfer_back_StandartSObjects == null) {
             fields_in_transfer_back_StandartSObjects = new Set<SelectOption>();
        } else {
            fields_in_transfer_back_StandartSObjects.clear();
        }
        
        List<SelectOption> allFields = getStandartObjectFields();
        fields_in_transfer_back_StandartSObjects.addAll(allFields);
        
        fields_to_initialList_StandartSObjects = allFields;      
        fields_to_destinationList_StandartSObjects.clear();
        
        fields_in_transfer_back_StandartSObjects.clear(); 
    }        
    
    public void transferAllCustomFieldsBack() {
        if(fields_in_transfer_back_CustomSObjects == null) {
             fields_in_transfer_back_CustomSObjects = new Set<SelectOption>();
        } else {
            fields_in_transfer_back_CustomSObjects.clear();
        }
        
        List<SelectOption> allFields = getCustomObjectFields();
        fields_in_transfer_back_CustomSObjects.addAll(allFields);
        
        fields_to_initialList_CustomSObjects = allFields;      
        fields_to_destinationList_CustomSObjects.clear();
        
        fields_in_transfer_back_CustomSObjects.clear(); 
    }
    
    // -------------------------------- Methods that returns metadata in VF page (except Transfer Tool) ----------------------------------------------------------
        
    /*
     * Clear selected fields, field details when reselect sObject.
	 */    
    public void ClearStandartSelectedFields() {      
        if(selectedFieldsOfStandartObject != null)
            selectedFieldsOfStandartObject = null;
        
         if(fields_to_initialList_StandartSObjects != null)
             fields_to_initialList_StandartSObjects.clear();
        	 fields_to_initialList_StandartSObjects = getStandartObjectFields();
        
        if(fields_to_destinationList_StandartSObjects != null) 
            fields_to_destinationList_StandartSObjects.clear();
    }
    
    public void ClearCustomSelectedFields() {
        if(selectedFieldsOfCustomObject != null)
            selectedFieldsOfCustomObject = null;
        
        if(fields_to_initialList_CustomSObjects != null)
             fields_to_initialList_CustomSObjects.clear();
        	 fields_to_initialList_CustomSObjects = getCustomObjectFields();
        
        if(fields_to_destinationList_CustomSObjects != null) 
            fields_to_destinationList_CustomSObjects.clear();
    }
    
    
    /*
     * Methods return list of SelectOption's for sObjects from
     * getCustomSObjectsMetadata() & getStandartSObjectsMetadata() methods.
	 */
    public List<SelectOption> getAllCustomObjects() {       
        List<SelectOption> allCustomObjectsSelOpts = new List<SelectOption>();
    	//allCustomObjectsSelOpts.add(new SelectOption('None','-- None --'));
        
        List<SObjectWrapper> sObjects = CustomObjects;       
        
        for(SObjectWrapper anSObjectName: sObjects) {
           allCustomObjectsSelOpts.add(new SelectOption(anSObjectName.API, anSObjectName.API));     
        }
                
        return allCustomObjectsSelOpts;
    }
    
    public List<SelectOption> getAllStandartObjects() {
        List<SelectOption> allStandartObjectsSelOpts = new List<SelectOption>();
		//allStandartObjectsSelOpts.add(new SelectOption('None','-- None --'));  
        
        List<SObjectWrapper> sObjects = StandartObjects;
        
        for(SObjectWrapper anSObjectName: sObjects) {
           allStandartObjectsSelOpts.add(new SelectOption(anSObjectName.Label, anSObjectName.Label));     
        }
        
        return allStandartObjectsSelOpts;
    }
    
    
    /*
     * Methods return standart & custom org sObject's wrapped in
     * SObjectWrapper class (contains just Label & API name).
	 */
    public List<SObjectWrapper> getCustomSObjectsMetadata() {
        List<SObjectWrapper> customSObjectList = new List<SObjectWrapper>();
        
        for(String anObject : globalDescribe.keySet()) {
            if(anObject.endsWith('__c')){
                Schema.DescribeSObjectResult objResult = globalDescribe.get(anObject).getDescribe();
                
                SObjectWrapper anObjWrp = new SObjectWrapper();
                anObjWrp.Label = objResult.getLabel();
                anObjWrp.API = objResult.getName();
                
                customSObjectList.add(anObjWrp);
            }
        }
        
        customSObjectList.sort();
        return customSObjectList;
    }
    
    public List<SObjectWrapper> getStandartSObjectsMetadata() {        
        List<SObjectWrapper> standartSObjectsList = new List<SObjectWrapper>();
        
        for(String anObject : globalDescribe.keySet()) {
            if(!anObject.endsWith('__c')){
                Schema.DescribeSObjectResult objResult = globalDescribe.get(anObject).getDescribe();
                                
                SObjectWrapper anObjWrp = new SObjectWrapper();
                anObjWrp.Label = objResult.getLabel();
                anObjWrp.API = objResult.getName();
                
                standartSObjectsList.add(anObjWrp);
            }
        }
               
        standartSObjectsList.sort();
        return standartSObjectsList;
    }
    
    
    /*
     * Methods returns list of SelectOption, which contains
     * list of fields selected sObject.
	 */
    public List<SelectOption> getStandartObjectFields() {
                       
        List<SelectOption> selectedOptionFields = new List<SelectOption>();        
           
        List<Schema.SObjectField> sObjectFilelds = this.getAllSObjectFields(this.selectedStandartObject, this.StandartObjects);
                
        for(Schema.SObjectField field : sObjectFilelds) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedOptionFields.add(new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel()));                    
        }        
        
        return selectedOptionFields;        
    }
    
    public List<SelectOption> getCustomObjectFields() {
                
        List<SelectOption> selectedOptionFields = new List<SelectOption>();   
        
        List<Schema.SObjectField> sObjectFilelds = this.getAllSObjectFields(this.selectedCustomObject, this.CustomObjects);
        
        for(Schema.SObjectField field : sObjectFilelds) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            selectedOptionFields.add(new SelectOption(fieldDescribe.getLabel(), fieldDescribe.getLabel()));                    
        }
        
        return selectedOptionFields;
    }

    
    /*
     * Methods returns List of 'FieldDetails' objects, which contains
     * description of selected sObject fields.
	 */
    public List<FieldDetails> getStandartObjectFieldDetails() {
        
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();
                
       	List<Schema.SObjectField> sObjectFilelds = this.getAllSObjectFields(this.selectedStandartObject, this.StandartObjects);    
        
        for(Schema.SObjectField field : sObjectFilelds) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();            
            for(String fieldLablel : selectedFieldsOfStandartObject) {
                if(fieldDescribe.getLabel() == fieldLablel)  {
                	selectedFieldDetails.add(new FieldDetails(field));
            	} 
            }            
        }
        
        return selectedFieldDetails;
    }
    
    public List<FieldDetails> getCustomObjectFieldDetails() {
        
        List<FieldDetails> selectedFieldDetails = new List<FieldDetails>();
                
        List<Schema.SObjectField> sObjectFilelds = this.getAllSObjectFields(this.selectedCustomObject, this.CustomObjects);
        
        for(Schema.SObjectField field : sObjectFilelds) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            for(String fieldLablel : selectedFieldsOfCustomObject) {
                if(fieldDescribe.getLabel() == fieldLablel)  {
                	selectedFieldDetails.add(new FieldDetails(field));
            	} 
            }              
        }
        
        return selectedFieldDetails;
    }
    
    
    // -------------------------------- Universal methods --------------------------------------------------------------------------------------
        
    /*
     * The method finds all the sObject fields by sObject Label (in case of standart sObject) or by sObject API name (in case of custom sObject).
     * Return List<Schema.SObjectField> with sObject fields.
     * First input parameter - String - sObject Label / API name, 
     * secont input parameter - List<SObjectWrapper> - this.StandartObjects or this.CustomObjects variable.
	 */
    public List<Schema.SObjectField> getAllSObjectFields (String selectedStandartOrCustomSObjectLabel, List<SObjectWrapper> objects) {
        
        List<Schema.SObjectField> allObjectFields = new List<Schema.SObjectField>();
        
        SObjectWrapper anObject = new SObjectWrapper();                
           
        if(objects == this.CustomObjects) {
            for(SObjectWrapper sObj : objects) {
                if(sObj.API == selectedStandartOrCustomSObjectLabel) {
                    anObject = sObj;
                }
        	}            
        } else if (objects == this.StandartObjects) {
            for(SObjectWrapper sObj : objects) {
                if(sObj.Label == selectedStandartOrCustomSObjectLabel) {
                    anObject = sObj;
                }
        	}
        }        
        
        Schema.DescribeSObjectResult objResult = globalDescribe.get(anObject.API).getDescribe();
        Map<String, Schema.SObjectField> sObjectFileldsMap = objResult.fields.getMap();
        
        allObjectFields = sObjectFileldsMap.Values();
        
        return allObjectFields;
    }
    
    
    /*
     * The method looks for a unique sObject field.
     * Return Schema.SObjectField variable.
     * First input parameter - String - target field name (Label),
     * second input parameter - String - sObject Label / API name, 
     * third input parameter - List<SObjectWrapper> - this.StandartObjects or this.CustomObjects variable.
	 */
    public Schema.SObjectField getUniqSObjectField (String fieldName, String selectedStandartOrCustomSObjectLabel, List<SObjectWrapper> objects) {
        
        Schema.SObjectField result;
        
        List<Schema.SObjectField> sObjectFilelds = new List<Schema.SObjectField>();
        
        if(objects == this.CustomObjects) {            
            sObjectFilelds = this.getAllSObjectFields(this.selectedCustomObject, this.CustomObjects);
                       
        } else if (objects == this.StandartObjects) {            
            sObjectFilelds = this.getAllSObjectFields(this.selectedStandartObject, this.StandartObjects);
        }  
        
        for(Schema.SObjectField field : sObjectFilelds) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();            
            if(fieldDescribe.getLabel() == fieldName) {
                 result = field;
            }                    
        }
        
        return result;
    }
    
    
    // ------------------------------- Support classes -----------------------------------------------------------------------------------------------
    
    /* 
     * Class for unique field details [ Name, Lable, Type, FLS ].
	 */
    public class FieldDetails {
        private Schema.SObjectField field;
                
        public FieldDetails(Schema.SObjectField field) {
            this.field = field;
        }
        
        public String Name {
            get {
                return this.field.getDescribe().getName();
            }
        }
        
        public String Label {
            get {
                return this.field.getDescribe().getLabel();
            }
        }
        
        public Schema.DisplayType Type {
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
    
    
    /* 
     * Wrap class for standart and custom sObjects.
     * Contains sObject Label and API name.	
     * Implements Comparable interface, which allows sort records by name.
	 */
    public class SObjectWrapper implements Comparable {
        public String Label { get; set; }
        public String API { get; set; }        
       
        public Integer compareTo(Object objToCompare) {
            SObjectWrapper sow = (SObjectWrapper)objToCompare;
            return(this.Label.compareTo(sow.Label));
        }        
    }
}