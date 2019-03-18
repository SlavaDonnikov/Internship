({
    getFields: function(component, receivedSObjectName) {
      var action = component.get("c.getAnySObjectFieldNames");

      action.setParams({
        "selectedSObject": receivedSObjectName
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {

              var list1Child = component.find('list1');
              list1Child.onSObjectChange(result);

              var list2Child = component.find('list2');
              list2Child.onSObjectChange([]);
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors && Array.isArray(errors) && errors.length > 0) {
            for (let i = 0; i < errors.length; i++) {
              var message =  '[ sObject Fields List ]' + '\n' +
                             '<-- Error #' + i + ' --->' + '\n' +
                             'Error message: [ ' + errors[i].message + ' ]' + '\n';
            }
            console.error(message);
          }
        }
      });

      $A.enqueueAction(action);
    },

    transferSeveralFields: function(component, list) {
      var childList = component.find(list);
      childList.onMoveSeveralFieldsButtonPress(list);
    },

    transferAllFields: function(component, list) {
      var childList = component.find(list);
      childList.onMoveAllFieldsButtonPress(list);
    },
})