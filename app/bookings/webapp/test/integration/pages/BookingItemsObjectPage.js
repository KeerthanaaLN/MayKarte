sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'maykarte.bookings.bookings',
            componentId: 'BookingItemsObjectPage',
            contextPath: '/Bookings/items'
        },
        CustomPageDefinitions
    );
});