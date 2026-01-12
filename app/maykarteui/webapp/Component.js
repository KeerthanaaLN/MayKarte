//main file that starts the app and prepares everything
sap.ui.define([
    "sap/ui/core/UIComponent", //read manifest.json, create models, setup routing, manage lifecycle 
    "maykarteui/model/models" //importing own models
], (UIComponent, models) => {
    "use strict";

    return UIComponent.extend("maykarteui.Component", {
        metadata: {
            manifest: "json", //tell ui to read app data from mainfest.json
            interfaces: [
                "sap.ui.core.IAsyncContentCreation" //makes app load faster, asynchronously
            ]
        },


        //this init() fn runs once when the app starts before screen is shown
        init() {
            // call the base component's init function
            //this line means - Do all your default startup work first.
            UIComponent.prototype.init.apply(this, arguments);

            // set the device model
            //create device model, has info like desktop/mobile, and make it avaliable to whole app
            this.setModel(models.createDeviceModel(), "device");

            // enable routing
            //routing to booking page main page (used routing config from manifest.json)
            this.getRouter().initialize();
        }
    });
});