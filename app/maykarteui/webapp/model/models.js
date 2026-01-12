//this model.js create models 
//models in ui5 means - a container to hold the data for the ui (odatamodel, jsonmodel, devciemodel)

sap.ui.define([
    "sap/ui/model/json/JSONModel",
    "sap/ui/Device"
], 
function (JSONModel, Device) {
    "use strict";

    return {
        /**
         * Provides runtime information for the device the UI5 app is running on as a JSONModel.
         * @returns {sap.ui.model.json.JSONModel} The device model.
         */

        //create a device model
        createDeviceModel: function () {
            var oModel = new JSONModel(Device); //phone,laptop,desktop 

            //this is what oModel contain
            /** oModel = {
                      data: Device,
                      bindingMode: "OneWay",
                      type: "JSONModel"
                    };
            */

            oModel.setDefaultBindingMode("OneWay"); //oneway from model -> ui
            return oModel;
        }
    };

});