sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller,JSONModel) {
    "use strict";

    return Controller.extend("maykarteui.controller.Bookings", {

        onInit: function () {
            // No model creation here (inherited)
            const oView = this.getView(); //Give me the view that this controller controls (oView = Bookings.view.xml)
 
            //this can be used when u want to enable a button only when a row is selected 
            this.oUIModel = new JSONModel({
                oContext: null,   // selected row, current context
                iMessages: 0     // message count, error count, etc.
            });
            oView.setModel(this.oUIModel, "Bookings");

        },

        onRefresh: function () {
            const oTable = this.byId("bookingsTable");
            /** oTable = {
  id: "bookingsTable",
  columns: [...],
  items: [...],           // UI row controls
  bindings: {
    items: oBinding       // <-- important
  }
}
 */
            const oBinding = oTable.getBinding("items");
            /** oBinding = {
  sPath: "/Bookings",
  oModel: ODataModel,
  aContexts: [ Context, Context, ... ],
  refresh: function() { ... }
}
 */

            if (oBinding) {
                oBinding.refresh(); // equivalen to GET /odata/v4/ticketing/Bookings
            }
        },

        formatStatusState: function (sStatus) {
            switch (sStatus) {
                case "CONFIRMED":
                    return "Success";
                case "CANCELLED":
                    return "Error";
                case "DRAFT":
                    return "Warning";
                default:
                    return "None";
            }
        },

        onListItemPress : function(oEvent){
            const oItem = oEvent.getSource();
            const oContext = oItem.getBindingContext();
            const sBookingId = oContext.getProperty("ID");
            this.getOwnerComponent().getRouter().navTo("RouteBookingObject",{bookingId : sBookingId});

        }

    });
});



