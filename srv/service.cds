using {MayKarte.db as db} from '../db/schema';

service TicketBookingService @(path: '/ticketing') {

    @odata.draft.enabled
    entity Events       as projection on db.Events
        actions {
            action completeEvent() returns Events;
            action cancelEvent()   returns Events;

        };

    entity SeatTypes    as
        projection on db.SeatTypes {
            *,
            event.eventName as eventName
        };

    // // @odata.draft.enabled
    entity Customers    as projection on db.Customers;

    // @odata.draft.enabled
    entity Bookings     as projection on db.Bookings
        actions {
            action confirmBooking() returns String;
            action cancelBooking()  returns String;
        };

    entity BookingItems as projection on db.BookingItems;

    entity Status       as projection on db.Status;
}
