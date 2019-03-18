({
    showFieldInfo: function(component, event, handler) {
      var receivedFieldName = event.getParam("sObjectFieldName");
      var receivedSObjectName = event.getParam("sObjectName");

      var action = component.get("c.getSObjectFieldDetails");

      action.setParams({
        "selectedFieldName": receivedFieldName,
        "selectedSObjectName": receivedSObjectName
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {

            var currentFieldsArray = [];
            var fields = component.get("v.fields");

            fields.forEach(function(item) {
              currentFieldsArray.push(item);
            });

            var resultObject = result[0];
            var isDeleted = false;

            for(let i = currentFieldsArray.length - 1; i >= 0; --i) {
              if (currentFieldsArray[i].label === resultObject.label) {
                currentFieldsArray.splice(i, 1);
                isDeleted = true;
              }
            }

            if (!isDeleted) {
              currentFieldsArray.push(resultObject);
            }

            currentFieldsArray.sort(
              function (a, b) {
                var objA = a.label.toUpperCase();
                var objB = b.label.toUpperCase();
                return objA.localeCompare(objB);
              }
            );

            component.set("v.fields", currentFieldsArray);
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors && Array.isArray(errors) && errors.length > 0) {
            for (let i = 0; i < errors.length; i++) {
              var message = '[ sObjects Fields Description Table ]' + '\n' +
                            '<-- Error #' + i + ' --->' + '\n' +
                            'Error message: [ ' + errors[i].message + ' ]' + '\n';
            }
            console.error(message);
          }
        }
      });

      $A.enqueueAction(action);
    },

    onSObjectChange: function(component, event, helper) {
      var currentFields = component.get("v.fields");
      if (!$A.util.isEmpty(currentFields) && !$A.util.isUndefinedOrNull(currentFields)) {
        component.set("v.fields", []);
      }
    },
})