({
    selectAndMark: function(component, event) {
      var selectedField = event.target;
      if (selectedField && selectedField.dataset) {
        var value = selectedField.dataset.id;

        var allThElements = component.find('thId');

        for (var i = 0; i < allThElements.length; i++) {
          var elementValue = allThElements[i].getElement().getAttribute('data-id');

          if (elementValue == value) {
          $A.util.toggleClass(allThElements[i], "list-element-selected");
          }
        }
        this.togglePushField(component, value);
      }
    },

    togglePushField: function(component, fieldName) {
      var currentSelectedFields = component.get("v.selectedFields");
      var array = [];
      if (!$A.util.isEmpty(currentSelectedFields) && !$A.util.isUndefinedOrNull(currentSelectedFields)) {
        this.toArray(currentSelectedFields, array);
      }

      var isDeleted = false;
      for (let i = array.length - 1; i >= 0; i--) {
        if(array[i] === fieldName) {
          array.splice(i, 1);
          isDeleted = true;
        }
      }

      if (!isDeleted) {
        array.push(fieldName);
      }

      array.sort(this.compare);
      component.set("v.selectedFields", array);
    },

    removeColorSelection: function(component) {
      var currentSObjectFields = component.get("v.sObjectFields");
      if (!$A.util.isEmpty(currentSObjectFields) && !$A.util.isUndefinedOrNull(currentSObjectFields)) {
        var allThElements = component.find('thId');

        for (let i = 0; i < allThElements.length; i++) {
          $A.util.removeClass(allThElements[i], "list-element-selected");
        }
      }
    },

    clearSelectedFieldsArray: function(component) {
      component.set("v.selectedFields", []);
    },

    clearSObjectFieldsArray: function(component) {
      component.set("v.sObjectFields", []);
    },

    getNewSObjectFields: function(component, event) {
      var param = event.getParam('arguments');
      var receivedFields = param.sObjectFieldsMethodParam;

      component.set("v.sObjectFields", receivedFields);
    },

    sendSelectedFieldsInParent: function(component, selectedFields, list) {
      var evt = component.getEvent("transferSeveralFields");

      var array = [];
      this.toArray(selectedFields, array);
      array.sort(this.compare);

      evt.setParams({
        "fieldsInTransfer": array,
        "list": list
      });

      evt.fire();
    },

    sendAllFieldsInParent: function(component, allFields, list) {
      var evt = component.getEvent("transferAllFields");

      var array = [];
      this.toArray(allFields, array);
      array.sort(this.compare);

      evt.setParams({
        "fieldsInTransfer": array,
        "list": list
      });

      evt.fire();
    },

    getTransferredFields: function(component, event) {
      var param = event.getParam('arguments');
      var transferredFields = param.transferredFields;

      this.removeColorSelection(component);

      var currentFields = component.get("v.sObjectFields");

      var array = [];
      this.toArray(currentFields, array);

      this.toArray(transferredFields, array);

      array.sort(this.compare);

      component.set("v.sObjectFields", array);
    },

    deleteTransferredFields: function(component) {
      var selectedFields = component.get("v.selectedFields");
      var allFields = component.get("v.sObjectFields");

      var selectedFieldsArray = [];
      this.toArray(selectedFields, selectedFieldsArray);

      var allFieldsArray = [];
      this.toArray(allFields, allFieldsArray);

      for (var i = 0; i < allFieldsArray.length; i++) {
        for (let j = 0; j < selectedFieldsArray.length; j++) {
          if (allFieldsArray[i] === selectedFieldsArray[j]) {
            allFieldsArray.splice(i, 1);
          }
        }
      }

      allFieldsArray.sort(this.compare);

      component.set("v.sObjectFields", allFieldsArray);
    },

    // -----------------------------------------

    compare: function(a,b) {
      var strA = a.toUpperCase();
      var strB = b.toUpperCase();
      return strA.localeCompare(strB);
    },

    toArray: function(from, array) {
      from.forEach(function(item) {
        array.push(item);
      });
    },
})