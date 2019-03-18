({
    clear: function(component) {
      var options = component.get("v.listOptions");
      if (!$A.util.isEmpty(options) && !$A.util.isUndefinedOrNull(options)) {
        component.set("v.listOptions", []);
      }
    },

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
            var resultArray = response.getReturnValue();
            var options = [];
            resultArray.forEach(function(result)  {
              options.push({ value: result, label: result});
            });
            component.set("v.listOptions", options);
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
})