sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], function (Controller, JSONModel, MessageToast) {
    "use strict";

    return Controller.extend("maykarteui.controller.Header1", {

        onInit: function () {
            // Initialize model for header state
            const oHeaderModel = new JSONModel({
                selectedCity: "CHENNAI",
                selectedTab: "movies"
            });
            
            // Set model to the view
            this.getView().setModel(oHeaderModel);
        },

        // 🏠 Logo Press - Navigate to home page
        onLogoPress: function () {
            try {
                // Navigate to main route
                this.getOwnerComponent()
                    .getRouter()
                    .navTo("RouteMain");
            } catch (error) {
                MessageToast.show("Navigating to Home");
            }
        },

        // 🔍 Search Handler - Search for movies, events, etc.
        onSearch: function (oEvent) {
            const sQuery = oEvent.getParameter("newValue");
            
            if (sQuery && sQuery.trim()) {
                // Get current selected tab
                const oModel = this.getView().getModel();
                const sCurrentTab = oModel.getProperty("/selectedTab");
                
                MessageToast.show(`Searching for: "${sQuery}" in ${sCurrentTab}`);
                
                // TODO: Implement actual search logic
                // You can filter content, call OData service, etc.
                // Example: this._filterContent(sQuery, sCurrentTab);
            }
        },

        // 📑 Tab Selection Handler - Switch between categories
        onTabSelect: function (oEvent) {
            const sSelectedKey = oEvent.getParameter("key");
            const sTabText = oEvent.getParameter("item").getText();
            
            // Update model
            const oModel = this.getView().getModel();
            oModel.setProperty("/selectedTab", sSelectedKey);
            
            MessageToast.show(`Switched to ${sTabText}`);
            
            // TODO: Load content based on selected tab
            // Example: this._loadTabContent(sSelectedKey);
        },

        // 🌆 City Change Handler - Update location
        onCityChange: function (oEvent) {
            const oSelectedItem = oEvent.getParameter("selectedItem");
            const sSelectedCity = oSelectedItem.getKey();
            const sCityName = oSelectedItem.getText();
            
            // Update model
            const oModel = this.getView().getModel();
            oModel.setProperty("/selectedCity", sSelectedCity);
            
            MessageToast.show(`Location changed to ${sCityName}`);
            
            // TODO: Reload content based on city
            // Example: this._loadCityContent(sSelectedCity);
        },

        // 👤 Sign In Handler - Open sign-in dialog
        onSignInPress: function () {
            MessageToast.show("Sign In feature - Coming Soon!");
            
            // TODO: Implement sign-in functionality
            // Options:
            // 1. Navigate to sign-in page
            // 2. Open sign-in dialog
            // 3. Open sign-in popover
            
            // Example navigation:
            // this.getOwnerComponent().getRouter().navTo("RouteSignIn");
        },

        // ☰ Menu Handler - Open menu
        onMenuPress: function (oEvent) {
            MessageToast.show("Menu opened");
            
            // TODO: Implement menu functionality
            // You can create a popover, dialog, or side navigation
            
            // Example: Open a simple menu popover
            this._openMenuPopover(oEvent.getSource());
        },

        // 📋 Private method to open menu popover
        _openMenuPopover: function (oButton) {
            // Create popover if it doesn't exist
            if (!this._oMenuPopover) {
                // Load fragment
                this._oMenuPopover = sap.ui.xmlfragment(
                    "maykarteui.view.MenuPopover",
                    this
                );
                this.getView().addDependent(this._oMenuPopover);
            }
            
            // Open popover - or show simple menu for now
            // this._oMenuPopover.openBy(oButton);
        }
    });
});