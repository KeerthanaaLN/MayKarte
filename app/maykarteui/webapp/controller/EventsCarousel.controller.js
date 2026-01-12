sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast"
], function (Controller, MessageToast) {
    "use strict";

    return Controller.extend("maykarteui.controller.EventsCarousel", {

        onInit: function () {
            // No special init needed – carousel is bound via XML
            // This hook is kept for future enhancements (filters, lazy load)
        },

        /**
         * Fired when user clicks "Book Now"
         */
        onBookNow: function (oEvent) {
            const oButton = oEvent.getSource();
            const oContext = oButton.getBindingContext();

            if (!oContext) {
                MessageToast.show("Event data not available");
                return;
            }

            const oEventData = oContext.getObject();

            MessageToast.show(
                "Booking event: " + oEventData.eventName
            );

            // 🔮 Future navigation example
            // this.getOwnerComponent()
            //     .getRouter()
            //     .navTo("eventDetails", {
            //         eventId: oEventData.ID
            //     });
        },

        /**
         * Optional: Image fallback if imageUrl is empty
         */
        formatImageUrl: function (sUrl) {
            return sUrl || "images/event-placeholder.jpg";
        }

    });
});
