sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/routing/History"
], function (Controller, History) {
    "use strict";

    return Controller.extend("maykarteui.controller.BookingObject", {

        onInit: function () {
            this.getOwnerComponent().getRouter().getRoute("RouteBookingObject")
                   .attachPatternMatched(this._onObjectMatched, this);
        },

        _onObjectMatched: function (oEvent) {
            const sBookingId = oEvent.getParameter("arguments").bookingId;
            this.getView().bindElement({
                path: `/Bookings(${sBookingId})`,
            });
        },

        onNavBack: function () {
            const oHistory = History.getInstance();
            const sPreviousHash = oHistory.getPreviousHash();

            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("RouteMayKarteView");
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
        }
    });
});
