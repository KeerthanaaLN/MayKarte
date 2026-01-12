namespace MayKarte.db;

using {
    cuid,
    managed
} from '@sap/cds/common';

//Events
entity Events : cuid, managed {
            eventID                 : String(20)  @readonly;
            eventName               : String(100) @mandatory;
            eventType               : String      @assert.range enum {
                WORKSHOP;
                MUSIC_SHOW;
                COMEDY_SHOW;
                EXHIBITION;
                MEETUPS
            };
            eventDate               : DateTime    @mandatory   @cds.search;
            venue                   : String(200);
            location                : String(100);
            imageUrl                   : String;
            status                  : String(20)  @cds.search  @assert.range  enum {
                ACTIVE;
                CANCELLED;
                COMPLETED
            } default 'ACTIVE';

    virtual totalCapacity           : Integer;
    virtual totalAvailable          : Integer;
    virtual statusCriticality       : Integer;
    virtual availabilityCriticality : Integer;
            // virtual eventTypeCriticality : Integer;

            seatTypes               : Composition of many SeatTypes
                                          on seatTypes.event = $self;
}

//Seat Types
entity SeatTypes : cuid {
            event                       : Association to Events @mandatory;
            seatType                    : String(50)            @assert.range enum {
                VIP;
                REGULAR;
                PREMIUM;
                ECONOMY
            } not null;
            totalSeats                  : Integer               @mandatory;
            availableSeats              : Integer               @mandatory;
            price                       : Decimal(10, 2)        @mandatory;

    virtual seatAvailabilityCriticality : Integer;
}

//Customers
entity Customers : cuid, managed {
    customerID  : String(20)   @readonly;
    firstName   : String(50)   @mandatory;
    lastName    : String(50)   @mandatory;
    email       : String(100)  @mandatory  @assert.unique;
    phoneNumber : String(15);

    bookings    : Composition of many Bookings
                      on bookings.customer = $self;
}

//Bookings - MAIN ENTITY
entity Bookings : cuid, managed {
            bookingNumber     : String(20)               @readonly;
            bookingDate       : DateTime                 @readonly;
            customer          : Association to Customers @mandatory;
            totalAmount       : Decimal(10, 2)           @readonly;
            status            : String(20)               @assert.range enum {
                DRAFT;
                CONFIRMED;
                CANCELLED
            } default 'DRAFT';

    virtual statusCriticality : Integer;

            items             : Composition of many BookingItems
                                    on items.booking = $self;
}

//Booking Items
entity BookingItems : cuid {
    booking    : Association to Bookings  @mandatory;
    event      : Association to Events    @mandatory;
    seatType   : Association to SeatTypes @mandatory;
    quantity   : Integer                  @mandatory;
    unitPrice  : Decimal(10, 2)           @readonly;
    totalPrice : Decimal(10, 2)           @readonly;
}

entity Status{
    key code : String;
    name : String;
}
