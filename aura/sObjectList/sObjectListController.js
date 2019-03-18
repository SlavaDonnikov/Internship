({
    doInit: function(component, event, helper) {
      var sObjectType = component.get("v.sObjectType");
      helper.getListOfSObjects(component, sObjectType);
    },

    selectAndSend: function(component, event, helper) {
      var selectedSObject = event.target;

      helper.selectAndMark(component, selectedSObject);

      helper.sendEvent(component, selectedSObject);
    },
})