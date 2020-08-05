({
    doInit: function(component, event, helper) {
        helper.getData(component);
    },
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Transaction__c"
        });
        createRecordEvent.fire();
        helper.refresh();
    },
    editRecord : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": event.getSource().get("v.value")
        });
        editRecordEvent.fire();
        helper.refresh();
    },
    deleteRecord : function(component, event, helper) {
		helper.deleteRecord(component, event);
        helper.refresh();
    }
})