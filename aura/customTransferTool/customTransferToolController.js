({
    getSObjectFields: function(component, event, helper) {
      var receivedSObjectName = event.getParam("sObjectName");

      var receivedComponentKey = event.getParam("componentKey");
      var componentKey = component.get("v.componentKey");

      if (componentKey == receivedComponentKey) {
        helper.getFields(component, receivedSObjectName);
      }
    },

    severalForward: function(component, event, helper) {
      var list = 'list1';
      helper.transferSeveralFields(component, list);
    },

    severalBack: function(component, event, helper) {
      var list = 'list2';
      helper.transferSeveralFields(component, list);
    },

    allForward: function(component, event, helper) {
      var list = 'list1';
      helper.transferAllFields(component, list);
    },

    allBack: function(component, event, helper) {
      var list = 'list2';
      helper.transferAllFields(component, list);
    },

    processTransferredFields: function(component, event, helper) {
      var receivedFields = event.getParam("fieldsInTransfer");
      var list = event.getParam("list");

      var childList;
      if (list === 'list1') {
        childList = component.find('list2');
      } else if (list === 'list2') {
        childList = component.find('list1');
      }

      childList.onReceivingTransferredFields(receivedFields);
    },

    processTransferredAllFields: function(component, event, helper) {
      var receivedFields = event.getParam("fieldsInTransfer");
      var list = event.getParam("list");

      var childList;
      if (list === 'list1') {
        childList = component.find('list2');
      } else if (list === 'list2') {
        childList = component.find('list1');
      }

      childList.onReceivingTransferredFieldsAll(receivedFields);
    },
})