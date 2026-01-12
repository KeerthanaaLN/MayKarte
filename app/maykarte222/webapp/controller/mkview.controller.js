//this runs when a view is created - get models, set default value, prepare formatters

sap.ui.define([
    "sap/ui/core/mvc/Controller",
    //Adding odatav4 model
    "sap/ui/model/odata/v4/ODataModel",
    //Control and events
    "sap/m/MessageToast",
    //filters
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator"

], function (Controller,ODataModel,MessageToast,Filter,FilterOperator) {
    "use strict";

    return Controller.extend("maykarte222.controller.mkview", {
        onInit() {
            //setModel
            var oModel = new ODataModel({
                serviceUrl: "/ticketing/",
            });
            this.getView().setModel(oModel);
        },

        onLogoPress: function(){
            MessageToast.show("MayKarte Home clicked");
        },

        onSearch: function(oEvent){
            let sQuery = oEvent.getParameter("newValue"); //oEvent - typed txt, control info, source control
            let oTable = this.byId("bookingTable");
            let oBinding = oTable.getBinding("items"); //return listbinding
            
            if(!sQuery){
                oBinding.filter([]);
                return; 
            }

            let oFilter = new Filter({
                filters:[
                    new Filter("bookingNumber",FilterOperator.Contains,sQuery),
                    new Filter("status",FilterOperator.Contains,sQuery)
                ],
                and: false
            });
            oBinding.filter(oFilter);
        },

        formatStatusState: function(sStatus){
            switch(sStatus){
                case "CONFIRMED": return "Success";
                case "DRAFT": return "Warning";
                case "CANCELLED": return "Error";
                default: return "Grey"; 
            }
        }

    });
});