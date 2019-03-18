({
    receiveSObject: function(component, event, helper) {
      helper.clear(component);

      var receivedSObjectName = event.getParam("sObjectName");

      var receivedComponentKey = event.getParam("componentKey");
      var componentKey = component.get("v.componentKey");

      if (componentKey == receivedComponentKey) {
        helper.getFields(component, receivedSObjectName);
      }
    },

    handleChange: function (component, event, helper) {
      var currentValues = component.get("v.selectedValues");
      var options = [];
      currentValues.forEach(function(item)  {
        options.push({ value: item, label: item});
      });

      var selectedValues = event.getParam("value");
      selectedValues.forEach(function(item) {
        options.push({ value: item, label: item});
      });

      component.set("v.selectedValues", selectedValues);
    },
})