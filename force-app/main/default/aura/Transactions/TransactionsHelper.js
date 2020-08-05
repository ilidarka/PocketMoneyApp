({
    getData : function(component) {
        var action = component.get("c.getData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.transactionWrapper", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    deleteRecord : function(component, event) {
        var action = component.get("c.deleteRecordFromTable"); 
        action.setParams({
            "idRecordToDelete" : event.getSource().get("v.value")
        });
        console.log(event.getSource().get("v.value"));
        action.setCallback(this, function(response) {
            console.log(response.getState());
        });
        $A.enqueueAction(action);
    },
    refresh : function(component) {
        var action = component.get('c.getData');
        action.setCallback(component,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   $A.get('e.force:refreshView').fire();
                               }
                           }
                          );
        $A.enqueueAction(action);
    }
})