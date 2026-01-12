using { TicketBookingService as service } from '../../srv/service';
using from './annotations';


annotate service.Bookings with actions {

    // CONFIRM BOOKING (enabled only when status = 'DRAFT')
    confirmBooking @(
        Core.OperationAvailable : {
            $edmJson : {
                $Eq : [
                    { $Path : 'status' },
                    'DRAFT'
                ]
            }
        },

        Common.SideEffects : {
            TargetProperties : ['status', 'totalAmount'],
            TargetEntities   : ['items']  // Refresh line items also
        }
    );

    // CANCEL BOOKING (enabled only when status = 'CONFIRMED')
    cancelBooking @(
        Core.OperationAvailable : {
            $edmJson : {
                $Eq : [
                    { $Path : 'status' },
                    'CONFIRMED'
                ]
            }
        },

        Common.SideEffects : {
            TargetProperties : ['status', 'totalAmount'],
            TargetEntities   : ['items']
        }
    );
};

annotate service.Bookings with @(
    UI.SelectionPresentationVariant #tableView : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Bookings',
    },
    UI.SelectionFields : [
        bookingNumber,
        customer_ID,
        bookingDate,
        status,
    ],
);

annotate service.Events with @(
    UI.LineItem #tableView : [
    ],
    UI.SelectionPresentationVariant #tableView : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Table View Events',
    },
    UI.LineItem #tableView1 : [
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.eventID,
            Label : 'eventID',
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.eventName,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.eventType,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.venue,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.location,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.status,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.totalCapacity,
        },
        {
            $Type : 'UI.DataField',
            Value : seatTypes.event.totalAvailable,
        },
    ],
    UI.SelectionPresentationVariant #tableView1 : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView1',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Events 1',
    },
    UI.LineItem #tableView2 : [
        {
            $Type : 'UI.DataField',
            Value : eventName,
        },
        {
            $Type : 'UI.DataField',
            Value : eventDate,
            Label : 'eventDate',
        },
        {
            $Type : 'UI.DataField',
            Value : location,
        },
        {
            $Type : 'UI.DataField',
            Value : status,
        },
        {
            $Type : 'UI.DataField',
            Value : totalAvailable,
        },
    ],
    UI.SelectionPresentationVariant #tableView2 : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView2',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Events',
    },
);

annotate service.Bookings with {
    customer @(
        Common.Text : customer.customerID,
        Common.Text.@UI.TextArrangement : #TextSeparate,
    )
};

annotate service.Customers with @(
    UI.LineItem #tableView : [
    ],
    UI.SelectionPresentationVariant #tableView : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Customers',
    },
    UI.LineItem #tableView1 : [
    ],
    UI.SelectionPresentationVariant #tableView1 : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView1',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Table View Customers 1',
    },
    UI.LineItem #tableView2 : [
        {
            $Type : 'UI.DataField',
            Value : firstName,
        },
        {
            $Type : 'UI.DataField',
            Value : lastName,
            Label : 'lastName',
        },
        {
            $Type : 'UI.DataField',
            Value : email,
        },
        {
            $Type : 'UI.DataField',
            Value : phoneNumber,
        },
    ],
    UI.SelectionPresentationVariant #tableView2 : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView2',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
            ],
        },
        Text : 'Customers',
    },
);

annotate service.Bookings with {
    status @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Status',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : status,
                ValueListProperty : 'code',
            },
        ],
        Label : 'Status',
    }
};

annotate service.Status with {
    code @(
        Common.Text : name,
        Common.Text.@UI.TextArrangement : #TextOnly,
)};

