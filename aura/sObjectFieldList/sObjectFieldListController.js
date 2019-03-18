({
    getSObjectFields: function(component, event, helper) {
      // Remove the blue color selection from all selected
      // fields when they are changed (when sObject changed)
      helper.removeSelection(component);

      var receivedSObjectName = event.getParam("sObjectName");

      var receivedComponentKey = event.getParam("componentKey");
      var componentKey = component.get("v.componentKey");

      if (componentKey == receivedComponentKey) {
        helper.getFields(component, receivedSObjectName);
      }
    },

    showFieldsDescription: function(component, event, helper) {
      var selectedField = event.target;

      helper.selectAndMark(component, selectedField);

      helper.showFieldsDescriptionEvent(component, selectedField);
    },

    onSObjectChange: function(component, event, helper) {
      var evt = component.getEvent("sObjectChange").fire();
    },
})