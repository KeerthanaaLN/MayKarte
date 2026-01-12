sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
    "use strict";

    return Controller.extend("maykarteui.controller.Footer", {

        onInit: function () {
            // Footer is static for now
            // Hook kept for future (navigation, analytics, links)
        },

        // Optional: handle footer link navigation later
        onNavigate: function (oEvent) {
            const sText = oEvent.getSource().getText();
            console.log("Footer link clicked:", sText);

            // Example future routing:
            // this.getOwnerComponent().getRouter().navTo("about");
        }

    });
});
