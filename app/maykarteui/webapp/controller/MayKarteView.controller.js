// sap.ui.define([
//     "sap/ui/core/mvc/Controller",
//     "sap/ui/model/odata/v4/ODataModel"
// ], (Controller,ODataModel) => {
//     "use strict";

//     return Controller.extend("maykarteui.controller.MayKarteView", {
//         //onInit is called when is view is created 
//         onInit: function () {
//             // Create OData V4 model ONCE
//             //getOwnerCOmponenet - give me the component that owns the view
//             //getModel - give me the global odata model created in component.js
//             const oModel = this.getOwnerComponent().getModel(); //this oModel containt he logic to fetch the data when needed


//             /** 
//              * oModel = {
//   // --- OData connection info ---
//   sServiceUrl: "/odata/v4/ticketing/",
//   mHeaders: {
//     "Content-Type": "application/json"
//   },

//   // --- Model settings ---
//   bAutoExpandSelect: true,
//   sOperationMode: "Server",
//   bEarlyRequests: true,

//   // --- Metadata ---
//   oMetaModel: {
//     // contains entity definitions:
//     // Bookings, Customers, Events, etc.
//   },

//   // --- Cache & bindings ---
//   mBindingContexts: {},
//   mListBindings: {},
//   mContextBindings: {},

//   // --- Internal request handling ---
//   oRequestor: {
//     // handles $metadata and data requests
//   }
// };

//              */

//             // Set model at view level (child views inherit it)
//             this.getView().setModel(oModel);
//         }
//     });
// });


sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/odata/v4/ODataModel",
    "sap/ui/model/json/JSONModel"
], (Controller, ODataModel, JSONModel) => {
    "use strict";

    return Controller.extend("maykarteui.controller.MayKarteView", {

        //onInit is called when is view is created 
        onInit: function () {
            // Create OData V4 model ONCE
            //getOwnerCOmponenet - give me the component that owns the view
            //getModel - give me the global odata model created in component.js
            const oModel = this.getOwnerComponent().getModel(); //this oModel containt he logic to fetch the data when needed

            /** 
             * oModel = {
             *   sServiceUrl: "/odata/v4/ticketing/",
             *   ...
             * };
             */

            // Set model at view level (child views inherit it)
            this.getView().setModel(oModel);

            /* ============================= */
            /* UI MODEL FOR CAROUSEL IMAGES  */
            /* ============================= */
            const oUIModel = new JSONModel({
                slide1Image: "image/Landscape-template-of-art-and-culture-workshop-5-large.jpg",
                slide2Image: "image/Landscape-template-of-enjoy-the-beats-live-music-concert-8-large.jpg",
                slide3Image: "image/aus_918_px_edit_ne_1.jpg",
                slide4Image: "image/Cover (7)-149cdeb0-dd81-11f0-bc8c-59ed3a19c8cc.jpg"
            });

            this.getView().setModel(oUIModel, "ui");

            /* ============================= */
            /* AUTO PLAY CAROUSEL            */
            /* ============================= */
            this._iCarouselIndex = 0;
            this._iCarouselTimer = setInterval(() => {
                const oCarousel = this.byId("movieCarousel");
                if (!oCarousel) {
                    return;
                }

                oCarousel.next();

                const aPages = oCarousel.getPages();
                this._iCarouselIndex =
                    (this._iCarouselIndex + 1) % aPages.length;

                // oCarousel.setActivePage(aPages[this._iCarouselIndex]);
            }, 3000); // 5 seconds
        },

        /* ============================= */
        /* CAROUSEL EVENTS               */
        /* ============================= */
        onCarouselPageChanged: function (oEvent) {
            const oNewPage = oEvent.getParameter("newActivePage");
            const oCarousel = this.byId("movieCarousel");
            this._iCarouselIndex = oCarousel.indexOfPage(oNewPage);
        },

        /* ============================= */
        /* BUTTON HANDLERS               */
        /* ============================= */
        onBookNow: function () {
            sap.m.MessageToast.show("Book Movies clicked");
        },

        onExploreEvent: function () {
            sap.m.MessageToast.show("Explore Events clicked");
        },

        onViewSports: function () {
            sap.m.MessageToast.show("View Sports clicked");
        },

        onViewPlays: function () {
            sap.m.MessageToast.show("View Plays clicked");
        },

        onExploreEvents: function () {
            const oEventsSection = this.byId("eventsSection");

            oEventsSection.setVisible(true);

            // Smooth scroll to events section
            oEventsSection.getDomRef().scrollIntoView({
                behavior: "smooth"
            });
        },

        onExploreEvents: function () {
            const oEventsSection = this.byId("eventsSection");
            if (!oEventsSection) {
                return;
            }

            oEventsSection.setVisible(true);

            setTimeout(() => {
                oEventsSection.getDomRef()?.scrollIntoView({
                    behavior: "smooth"
                });
            }, 0);
        },

        /* ============================= */
        /* CLEANUP                       */
        /* ============================= */
        onExit: function () {
            if (this._iCarouselTimer) {
                clearInterval(this._iCarouselTimer);
            }
        }
    });
});
