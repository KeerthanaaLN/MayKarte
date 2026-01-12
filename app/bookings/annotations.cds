using {TicketBookingService as service} from '../../srv/service';

// Entity labels
annotate service.Events with @(
    Common.Label      : 'Events',
    UI.TextArrangement: #TextFirst
);

annotate service.SeatTypes with @(
    Common.Label      : 'Seat Types',
    UI.TextArrangement: #TextFirst
);

annotate service.Customers with @(
    Common.Label      : 'Customers',
    UI.TextArrangement: #TextFirst
);

annotate service.Bookings with @(
    Common.Label      : 'Bookings',
    UI.TextArrangement: #TextFirst
);

annotate service.BookingItems with @(
    Common.Label      : 'Booking Items',
    UI.TextArrangement: #TextFirst
);

// EVENTS ENTITY

annotate service.Events with @(
    UI.Identification           : [ // ← ADD THIS FIRST
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TicketBookingService.completeEvent',
            Label : 'Complete Event',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'TicketBookingService.cancelEvent',
            Label : 'Cancel Event',
        }
    ],
    UI.SelectionFields          : [
        eventName,
        eventType,
        location,
        status
    ],

    UI.LineItem                 : [
        {
            $Type            : 'UI.DataField',
            Value            : eventID,
            Label            : 'Event ID',
            ![@UI.Importance]: #High
        },
        {
            $Type            : 'UI.DataField',
            Value            : eventName,
            Label            : 'Event Name',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: eventType,
            Label: 'Type',
        // Criticality: eventTypeCriticality
        },
        {
            $Type: 'UI.DataField',
            Value: eventDate,
            Label: 'Event Date'
        },
        {
            $Type: 'UI.DataField',
            Value: venue,
            Label: 'Venue'
        },
        {
            $Type: 'UI.DataField',
            Value: location,
            Label: 'Location'
        },
        {
            $Type: 'UI.DataField',
            Value: totalCapacity,
            Label: 'Total Capacity'
        },
        {
            $Type      : 'UI.DataField',
            Value      : totalAvailable,
            Label      : 'Available Seats',
            Criticality: availabilityCriticality
        },
        {
            $Type                    : 'UI.DataField',
            Value                    : status,
            Label                    : 'Status',
            Criticality              : statusCriticality,
            // CriticalityRepresentation: #WithIcon,
            ![@UI.Importance]        : #High
        }
    ],

    UI.HeaderInfo               : {
        TypeName      : 'Event',
        TypeNamePlural: 'Events',
        Title         : {Value: eventName},
        Description   : {Value: eventID},
        TypeImageUrl  : 'https://thumbs.dreamstime.com/b/events-calendar-icon-blue-square-button-events-calendar-icon-isolated-blue-square-button-abstract-illustration-99526972.jpg'
    },

    UI.HeaderFacets             : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#EventHeader',
            Label : 'Event Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#TotalCapacity',
            Label : 'Total Capacity'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#AvailableSeats',
            Label : 'Available Seats'
        }
    ],

    UI.Facets                   : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : 'EventDetails',
            Label : 'Event Details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#GeneralInfo',
                    Label : 'General Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#VenueInfo',
                    Label : 'Venue Information'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'SeatTypesFacet',
            Label : 'Seat Types & Pricing',
            Target: 'seatTypes/@UI.LineItem'
        }
    ],

    UI.FieldGroup #EventHeader  : {Data: [
        {
            Value: eventID,
            Label: 'Event ID'
        },
        {
            Value      : status,
            Label      : 'Status',
            Criticality: statusCriticality
        },
        {
            Value: eventDate,
            Label: 'Event Date'
        }
    ]},

    UI.FieldGroup #GeneralInfo  : {Data: [
        {
            Value: eventID,
            Label: 'Event ID'
        },
        {
            Value: eventName,
            Label: 'Event Name'
        },
        {
            Value: eventType,
            Label: 'Event Type'
        },
        {
            Value: eventDate,
            Label: 'Date & Time'
        },
        {
            Value: status,
            Label: 'Status'
        }
    ]},

    UI.FieldGroup #VenueInfo    : {Data: [
        {
            Value: venue,
            Label: 'Venue'
        },
        {
            Value: location,
            Label: 'Location'
        }
    ]},

    UI.DataPoint #TotalCapacity : {
        Value        : totalCapacity,
        Title        : 'Total Capacity',
        Visualization: #Number
    },

    UI.DataPoint #AvailableSeats: {
        Value        : totalAvailable,
        Title        : 'Available',
        Visualization: #Number,
        Criticality  : availabilityCriticality
    }
) {
    // eventID        @(
    //     Common.Label       : 'Event ID',
    //     Common.FieldControl: #ReadOnly
    // );

    eventName      @(
        Common.Label       : 'Event Name',
        Common.FieldControl: #Mandatory
    );

    eventType      @(
        Common.Label                   : 'Event Type',
        Common.ValueListWithFixedValues: true,
        Common.FieldControl            : #Mandatory
    );

    // eventDate      @(
    //     Common.Label       : 'Event Date & Time',
    //     Common.FieldControl: #Mandatory
    // );

    venue          @Common.Label: 'Venue';
    location       @Common.Label: 'Location';

    status         @(
        Common.Label                   : 'Status',
        Common.ValueListWithFixedValues: true,
        Common.FieldControl            : #Mandatory
    );

    totalCapacity  @(
        Common.Label       : 'Total Capacity',
        Common.FieldControl: #ReadOnly
    );

    totalAvailable @(
        Common.Label       : 'Available Seats',
        Common.FieldControl: #ReadOnly
    );

};


// SEAT TYPES

annotate service.SeatTypes with @(
    UI.LineItem                : [
        {
            $Type            : 'UI.DataField',
            Value            : seatType,
            Label            : 'Seat Type',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: event.eventName,
            Label: 'Event'
        },

        {
            $Type: 'UI.DataField',
            Value: totalSeats,
            Label: 'Total Seats'
        },
        {
            $Type            : 'UI.DataField',
            Value            : availableSeats,
            Label            : 'Available',
            Criticality      : seatAvailabilityCriticality,
            ![@UI.Importance]: #High
        },
        {
            $Type            : 'UI.DataField',
            Value            : price,
            Label            : 'Price per Seat',
            ![@UI.Importance]: #High
        }
    ],

    UI.HeaderInfo              : {
        TypeName      : 'Seat Type',
        TypeNamePlural: 'Seat Types',
        Title         : {Value: seatType}
    },

    UI.Facets                  : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Seat Type Details',
        Target: '@UI.FieldGroup#SeatTypeInfo'
    }],

    UI.FieldGroup #SeatTypeInfo: {Data: [
        {
            Value: seatType,
            Label: 'Seat Type'
        },
        {
            Value: totalSeats,
            Label: 'Total Seats'
        },
        {
            Value: availableSeats,
            Label: 'Available Seats'
        },
        {
            Value: price,
            Label: 'Price per Seat'
        }
    ]}
) {
    seatType       @(
        Common.Label                   : 'Seat Type',
        Common.ValueListWithFixedValues: true,
        Common.FieldControl            : #Mandatory
    );

    totalSeats     @(
        Common.Label       : 'Total Seats',
        Common.FieldControl: #Mandatory
    );

    availableSeats @(
        Common.Label       : 'Available Seats',
        Common.FieldControl: #Mandatory
    );

    price          @(
        Common.Label        : 'Price',
        Measures.ISOCurrency: 'INR',
        Common.FieldControl : #Mandatory
    );
};

// CUSTOMERS

annotate service.Customers with @(
    UI.SelectionFields            : [
        customerID,
        firstName,
        // lastName,
        email
    ],

    UI.LineItem                   : [
        {
            $Type            : 'UI.DataField',
            Value            : customerID,
            Label            : 'Customer ID',
            ![@UI.Importance]: #High
        },
        {
            $Type            : 'UI.DataField',
            Value            : firstName,
            Label            : 'First Name',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: lastName,
            Label: 'Last Name'
        },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: 'Email'
        },
        {
            $Type: 'UI.DataField',
            Value: phoneNumber,
            Label: 'Phone'
        }
    ],

    UI.HeaderInfo                 : {
        TypeName      : 'Customer',
        TypeNamePlural: 'Customers',
        Title         : {Value: firstName},
        Description   : {Value: customerID},
        TypeImageUrl  : 'https://www.pngitem.com/pimgs/m/74-741993_customer-icon-png-customer-icon-transparent-png.png'
    },

    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Customer Information',
            Target: '@UI.FieldGroup#CustomerDetails'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Bookings',
            Target: 'bookings/@UI.LineItem'
        }
    ],

    UI.FieldGroup #CustomerDetails: {Data: [
        {
            Value: customerID,
            Label: 'Customer ID'
        },
        {
            Value: firstName,
            Label: 'First Name'
        },
        {
            Value: lastName,
            Label: 'Last Name'
        },
        {
            Value: email,
            Label: 'Email'
        },
        {
            Value: phoneNumber,
            Label: 'Phone Number'
        }
    ]}
) {
    customerID  @(
        Common.Label       : 'Customer ID',
        Common.FieldControl: #ReadOnly
    );

    firstName   @(
        Common.Label       : 'First Name',
        Common.FieldControl: #Mandatory
    );

    // lastName    @(
    //     Common.Label       : 'Last Name',
    //     Common.FieldControl: #Mandatory
    // );

    email       @(
        Common.Label       : 'Email',
        Common.FieldControl: #Mandatory
    );

    phoneNumber @Common.Label: 'Phone Number';
};


// BOOKINGS - MAIN TRANSACTION

annotate service.Bookings with @(
    UI.SelectionFields           : [
        bookingNumber,
        customer_ID,
        status,
        bookingDate
    ],

    UI.LineItem                  : [
        {
            $Type            : 'UI.DataField',
            Value            : bookingNumber,
            Label            : 'Booking Number',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: customer.customerID,
            Label: 'Customer ID'
        },
        {
            $Type            : 'UI.DataField',
            Value            : customer.firstName,
            Label            : 'Customer Name',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: bookingDate,
            Label: 'Booking Date'
        },
        {
            $Type            : 'UI.DataField',
            Value            : totalAmount,
            Label            : 'Total Amount',
            ![@UI.Importance]: #High
        },
        {
            $Type                    : 'UI.DataField',
            Value                    : status,
            Label                    : 'Status',
            Criticality              : statusCriticality,
            CriticalityRepresentation: #WithIcon,
            ![@UI.Importance]        : #High
        }
    ],

    UI.HeaderInfo                : {
        TypeName      : 'Booking',
        TypeNamePlural: 'Bookings',
        Title         : {Value: bookingNumber},
        Description   : {Value: customer.firstName},
        TypeImageUrl  : 'https://images.seeklogo.com/logo-png/48/1/booking-logo-png_seeklogo-482782.png'
    },

    UI.HeaderFacets              : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#BookingHeader'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#TotalAmount'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#Status'
        }
    ],

    UI.Identification            : [
        {
            $Type        : 'UI.DataFieldForAction',
            Action       : 'TicketBookingService.confirmBooking',
            Label        : 'Confirm Booking',
            Criticality  : 3,
            ![@UI.Hidden]: {$edmJson: {$Or: [
                {$Eq: [
                    {$Path: 'status'},
                    'CONFIRMED'
                ]},
                {$Eq: [
                    {$Path: 'status'},
                    'CANCELLED'
                ]}
            ]}}
        },
        {
            $Type        : 'UI.DataFieldForAction',
            Action       : 'TicketBookingService.cancelBooking',
            Label        : 'Cancel Booking',
            Criticality  : 1,
            ![@UI.Hidden]: {$edmJson: {$Or: [
                {$Eq: [
                    {$Path: 'status'},
                    'DRAFT'
                ]},
                {$Eq: [
                    {$Path: 'status'},
                    'CANCELLED'
                ]}
            ]}}
        },

    ],

    UI.Facets                    : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : 'BookingDetailsFacet',
            Label : 'Booking Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#BookingDetails',
                    Label : 'Booking Details'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#CustomerInfo',
                    Label : 'Customer Information'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'BookingItemsFacet',
            Label : 'Booking Items',
            Target: 'items/@UI.LineItem'
        }
    ],

    UI.FieldGroup #BookingHeader : {Data: [
        {
            Value: bookingNumber,
            Label: 'Booking Number'
        },
        {
            Value: bookingDate,
            Label: 'Booking Date'
        }
    ]},

    UI.FieldGroup #BookingDetails: {Data: [
        {
            Value: bookingNumber,
            Label: 'Booking Number'
        },
        {
            Value: bookingDate,
            Label: 'Booking Date'
        },
        {
            Value: totalAmount,
            Label: 'Total Amount'
        },
        {
            Value: status,
            Label: 'Status'
        }
    ]},

    UI.FieldGroup #CustomerInfo  : {Data: [
        {
            Value: customer_ID,
            Label: 'Customer'
        },
        {
            Value: customer.email,
            Label: 'Email'
        },
        {
            Value: customer.phoneNumber,
            Label: 'Phone'
        }
    ]},

    UI.DataPoint #TotalAmount    : {
        Value        : totalAmount,
        Title        : 'Total Amount',
        Visualization: #Number
    },

    UI.DataPoint #Status         : {
        Value      : status,
        Title      : 'Status',
        Criticality: statusCriticality
    }
) {
    bookingNumber @(
        Common.Label       : 'Booking Number',
        Common.FieldControl: #ReadOnly
    );

    bookingDate   @(
        Common.Label       : 'Booking Date',
        Common.FieldControl: #ReadOnly
    );

    customer      @(
        Common.Label          : 'Customer ID',
        Common.Text           : customer.firstName,
        Common.TextArrangement: #TextFirst,
        Common.ValueList      : {
            Label         : 'Customers',
            CollectionPath: 'Customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: customer_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'customerID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'firstName'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'lastName'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'email'
                }
            ]
        },
        Common.FieldControl   : #Mandatory
    );

    totalAmount   @(
        Common.Label        : 'Total Amount',
        Measures.ISOCurrency: 'INR',
        Common.FieldControl : #ReadOnly
    );

    status        @(
        Common.Label                   : 'Status',
        Common.ValueListWithFixedValues: true,
        Common.FieldControl            : #ReadOnly
    );
};

// BOOKING ITEMS

annotate service.BookingItems with @(
    UI.LineItem               : [
        {
            $Type            : 'UI.DataField',
            Value            : event.eventName,
            Label            : 'Event Name',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: event.eventDate,
            Label: 'Event Date'
        },
        {
            $Type            : 'UI.DataField',
            Value            : seatType.seatType,
            Label            : 'Seat Type',
            ![@UI.Importance]: #High
        },
        {
            $Type            : 'UI.DataField',
            Value            : quantity,
            Label            : 'Quantity',
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: unitPrice,
            Label: 'Unit Price'
        },
        {
            $Type            : 'UI.DataField',
            Value            : totalPrice,
            Label            : 'Total Price',
            ![@UI.Importance]: #High
        }
    ],

    UI.HeaderInfo             : {
        TypeName      : 'Booking Item',
        TypeNamePlural: 'Booking Items',
        Title         : {Value: event.eventName},
        Description   : {Value: seatType.seatType}
    },

    UI.Facets                 : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Item Details',
        Target: '@UI.FieldGroup#ItemDetails'
    }],

    UI.FieldGroup #ItemDetails: {Data: [
        {
            Value: event_ID,
            Label: 'Event'
        },
        {
            Value: seatType_ID,
            Label: 'Seat Type'
        },
        {
            Value: quantity,
            Label: 'Quantity'
        },
        {
            Value: unitPrice,
            Label: 'Unit Price'
        },
        {
            Value: totalPrice,
            Label: 'Total Price'
        }
    ]}
);

// Field-level annotations for BookingItems
annotate service.BookingItems {
    event      @(
        Common.Label          : 'Event',
        Common.Text           : event.eventName,
        Common.TextArrangement: #TextFirst,
        Common.ValueList      : {
            Label         : 'Events',
            CollectionPath: 'Events',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: event_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'eventID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'eventName'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'eventDate'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'status'
                }
            ]
        },
        Common.FieldControl   : #Mandatory
    );

    seatType   @(
        Common.Label          : 'Seat Type',
        Common.Text           : seatType.seatType,
        Common.TextArrangement: #TextFirst,
        Common.ValueList      : {
            Label         : 'Seat Types',
            CollectionPath: 'SeatTypes',
            Parameters    : [
                // {
                //     $Type            : 'Common.ValueListParameterInOut',
                //     LocalDataProperty: seatType_ID,
                //     ValueListProperty: 'ID'
                // },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'seatType'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'eventName' // ⭐ ADD THIS: SHOW EVENT NAME
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'availableSeats'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'price'
                }
            ]
        },
        Common.FieldControl   : #Mandatory
    );

    quantity   @(
        Common.Label       : 'Quantity',
        Common.FieldControl: #Mandatory
    );

    unitPrice  @(
        Common.Label        : 'Unit Price',
        Measures.ISOCurrency: 'INR',
        Common.FieldControl : #ReadOnly
    );

    totalPrice @(
        Common.Label        : 'Total Price',
        Measures.ISOCurrency: 'INR',
        Common.FieldControl : #ReadOnly
    );
};