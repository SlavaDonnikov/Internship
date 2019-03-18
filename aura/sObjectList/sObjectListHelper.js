({
    getListOfSObjects: function(component, sObjectType) {
      var method;
      switch(sObjectType) {
        case "Standard":
          method = "c.getAllStandardSObjectNames";
          break;
        case "Custom":
          method = "c.getAllCustomSObjectNames";
          break;
        case "Both":
          method = "c.getAllOrgSObjectNames";
          break;
      }
      var action = component.get(method);

      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
            component.set("v.sObjects", result);
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors && Array.isArray(errors) && errors.length > 0) {
            for (let i = 0; i < errors.length; i++) {
              var message = '[ sObjects List ]' + '\n' +
                            '<-- Error #' + i + ' --->' + '\n' +
                            'Error message: [ ' + errors[i].message + ' ]' + '\n';
            }
            console.error(message);
          }
        }
      });

      $A.enqueueAction(action);
    },

    selectAndMark: function(component, selectedSObject) {
      if (selectedSObject && selectedSObject.dataset) {
        var id = selectedSObject.dataset.id;

        var allThElements = component.find('thId');

        for (var i = 0; i < allThElements.length; i++) {
          var elementValue = allThElements[i].getElement().getAttribute('data-id');

          $A.util.removeClass(allThElements[i], "list-element-selected");

          if (elementValue == id) {
            $A.util.addClass(allThElements[i], "list-element-selected");
          }
        }
      }
    },

    sendEvent: function(component, selectedSObject) {
      if (selectedSObject && selectedSObject.dataset) {
        var sObjectName = selectedSObject.dataset.id;
        var componentKey = component.get("v.componentKey");

        var evt = $A.get("e.c:sendSObjectEvent");
        evt.setParams({
          "sObjectName": sObjectName,
          "componentKey": componentKey
        });
        evt.fire();
      }
    },
})