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
            component.set("v.sObjectName", receivedSObjectName);
            component.set("v.sObjectFields", result);
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

    selectAndMark: function(component, selectedField) {
      if (selectedField && selectedField.dataset) {
        var id = selectedField.dataset.id;

        var allThElements = component.find('thId');

        for (var i = 0; i < allThElements.length; i++) {
          var elementValue = allThElements[i].getElement().getAttribute('data-id');

          if (elementValue == id) {
          $A.util.toggleClass(allThElements[i], "list-element-selected");
          }
        }
      }
    },

    removeSelection: function(component) {
      var currentSObjectFields = component.get("v.sObjectFields");
      if (!$A.util.isEmpty(currentSObjectFields) && !$A.util.isUndefinedOrNull(currentSObjectFields)) {
        var allThElements = component.find('thId');

        allThElements.forEach(function(th) {
          $A.util.removeClass(th, "list-element-selected");
        });
      }
    },

    showFieldsDescriptionEvent: function(component, selectedField) {
      if (selectedField && selectedField.dataset) {
        var sObjectFieldName = selectedField.dataset.id;
        var sObjectName = component.get("v.sObjectName");

        var evt = component.getEvent("sendSelectedField");
        evt.setParams({
          "sObjectName": sObjectName,
          "sObjectFieldName": sObjectFieldName
        });
        evt.fire();
      }
    },
})