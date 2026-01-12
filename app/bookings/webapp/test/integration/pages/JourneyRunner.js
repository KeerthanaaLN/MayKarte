sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"maykarte/bookings/bookings/test/integration/pages/BookingsList",
	"maykarte/bookings/bookings/test/integration/pages/BookingsObjectPage",
	"maykarte/bookings/bookings/test/integration/pages/BookingItemsObjectPage"
], function (JourneyRunner, BookingsList, BookingsObjectPage, BookingItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('maykarte/bookings/bookings') + '/test/flp.html#app-preview',
        pages: {
			onTheBookingsList: BookingsList,
			onTheBookingsObjectPage: BookingsObjectPage,
			onTheBookingItemsObjectPage: BookingItemsObjectPage
        },
        async: true
    });

    return runner;
});

