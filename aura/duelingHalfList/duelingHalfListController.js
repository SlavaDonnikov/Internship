({
    onSObjectChange: function(component, event, helper) {
      helper.removeColorSelection(component);
      helper.clearSelectedFieldsArray(component);
      helper.getNewSObjectFields(component, event);
    },

    onSelect: function(component, event, helper) {
      helper.selectAndMark(component, event);
    },

    onMoveSeveralFieldsButtonPress: function(component, event, helper) {
      var param = event.getParam('arguments');
      var list = param.list;

      // get fields, selected in child component
      var selectedFields = component.get("v.selectedFields");
      if (!$A.util.isEmpty(selectedFields) && !$A.util.isUndefinedOrNull(selectedFields)) {
        // clear them from selection
        helper.removeColorSelection(component);

        // delete from child
        helper.deleteTransferredFields(component);

        // clear massive with selected fields
        helper.clearSelectedFieldsArray(component);

        // send in parent by component event
        helper.sendSelectedFieldsInParent(component, selectedFields, list);
      }
    },

    onMoveAllFieldsButtonPress: function(component, event, helper) {
      var param = event.getParam('arguments');
      var list = param.list;

      var allFields = component.get("v.sObjectFields");
      if (!$A.util.isEmpty(allFields) && !$A.util.isUndefinedOrNull(allFields)) {
        helper.removeColorSelection(component);

        // clear all (sObjectFields) array
        helper.clearSObjectFieldsArray(component);

        // send all currently displayed fields in another list
        helper.sendAllFieldsInParent(component, allFields, list);
      }
    },

    onReceivingTransferredFields: function(component, event, helper) {
      helper.getTransferredFields(component, event);
    },

    onReceivingTransferredFieldsAll: function(component, event, helper) {
      helper.getTransferredFields(component, event);
    },
})