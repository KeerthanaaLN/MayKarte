const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  console.log(this);
  const { Events, SeatTypes, Customers, Bookings, BookingItems } = this.entities;

      //  CONFIRM BOOKING
  this.on('confirmBooking', 'Bookings', async req => {
    const id = req.params[0].ID;
    const booking = await SELECT.one.from(Bookings).where({ ID: id });

    if (!booking) return req.error(404,'Booking not found');
    if (booking.status === 'CONFIRMED') return 'Already confirmed';
    if (booking.status === 'CANCELLED') return req.error(400,'Cannot confirm cancelled booking');

    const items = await SELECT.from(BookingItems).where({ booking_ID: id });
    if (!items.length) return req.error(400,'Cannot confirm empty booking');

    const seatMap = new Map();
    for (const i of items) seatMap.set(i.seatType_ID, (seatMap.get(i.seatType_ID) || 0) + i.quantity);
    for (const [stID, qty] of seatMap) {
      const st = await SELECT.one.from(SeatTypes).where({ ID: stID });
      if (st.availableSeats < qty) return req.error(400, `Not enough ${st.seatType} seats`);
    }
    for (const [stID, qty] of seatMap) {
      const st = await SELECT.one.from(SeatTypes).where({ ID: stID });
      await UPDATE(SeatTypes).set({ availableSeats: st.availableSeats - qty }).where({ ID: stID });
    }

    await UPDATE(Bookings).set({ status: 'CONFIRMED' }).where({ ID: id });
    return `Booking ${booking.bookingNumber} confirmed!`;
  });


     //EVENTS - AFTER READ
  this.after('READ', 'Events', async events => {
    if (!events) return;
    const list = Array.isArray(events) ? events : [events];

    for (const e of list) {
      const seatTypes = await SELECT.from(SeatTypes).where({ event_ID: e.ID });
      e.totalCapacity   = seatTypes.reduce((s, st) => s + (st.totalSeats || 0), 0);
      e.totalAvailable  = seatTypes.reduce((s, st) => s + (st.availableSeats || 0), 0);
      e.statusCriticality = e.status === 'ACTIVE' ? 3 : e.status === 'CANCELLED' ? 1 : 2;
      e.availabilityCriticality = e.totalAvailable > 100 ? 3 : e.totalAvailable > 20 ? 2 : 1;
      e.eventTypeCriticality = e.eventType === 'MUSIC_SHOW' ? 3 : e.eventType === 'WORKSHOP' ? 5 : 0;
    }
  });

    //  SEAT TYPES - AFTER READ
  this.after('READ', 'SeatTypes', async list => {
    if (!list) return;
    const seatList = Array.isArray(list) ? list : [list];
    for (const st of seatList)
      st.seatAvailabilityCriticality =st.availableSeats > 50 ? 3 : st.availableSeats > 10 ? 2 : 1;
  });

    //  BOOKINGS - AFTER READ & UPDATE
  const computeCriticality = b =>
    b.status === 'DRAFT' ? 2 : b.status === 'CONFIRMED' ? 3 : b.status === 'COMPLETED' ? 3 : b.status === 'CANCELLED' ? 1 : 0;

  this.after('READ', 'Bookings', async list => {
    if (!list) return;
    const items = Array.isArray(list) ? list : [list];
    for (const b of items) b.statusCriticality = computeCriticality(b);
  });

  this.after('UPDATE', 'Bookings', async b => {
    if (!b) return;
    b.statusCriticality = computeCriticality(b);
  });

  
    //  SEAT TYPE VALIDATION
  this.before('CREATE', 'SeatTypes', async req => {
    if (req.data.availableSeats > req.data.totalSeats) return req.error(400, 'Available seats cannot exceed total seats');

    req.data.availableSeats ??= req.data.totalSeats;

    const exists = await SELECT.from(SeatTypes).where({
      event_ID: req.data.event_ID,
      seatType: req.data.seatType
    });

    if (exists.length) req.error(400, `${req.data.seatType} already exists for this event`);
  });

  this.before('UPDATE', 'SeatTypes', async req => {
    const old = await SELECT.one.from(SeatTypes).where({ ID: req.data.ID });
    if (!old) return;

    const total = req.data.totalSeats ?? old.totalSeats;
    const avail = req.data.availableSeats ?? old.availableSeats;

    if (avail > total) return req.error(400, 'Available seats cannot exceed total seats');

    const booked = old.totalSeats - old.availableSeats;
    if (total < booked) req.error(400, `Cannot reduce total seats below ${booked} (already booked)`);
  });

    //  EVENT - AUTO ID / VALIDATION
  this.before('CREATE', 'Events', async req => {
    const last = await SELECT.one.from(Events).columns('eventID').orderBy('eventID desc');
    const next = String((parseInt(last?.eventID?.replace('EV','')) || 0) + 1).padStart(3,'0');
    req.data.eventID = 'EV' + next;
    req.data.status ??= 'ACTIVE';
  });

  this.before('UPDATE', 'Events', async req => {
    if (!req.data.status) return;

    const event = await SELECT.one.from(Events).where({ ID: req.data.ID });
    if (!event) return;

    if (new Date(event.eventDate) < new Date() && req.data.status === 'ACTIVE') return req.error(400, 'Cannot reactivate past event');

    // prevent cancelling when confirmed bookings exist
    if (['CANCELLED','COMPLETED'].includes(req.data.status)) {
      const items = await SELECT.from(BookingItems).where({ event_ID: event.ID });
      const bookIDs = [...new Set(items.map(i => i.booking_ID))];
      const confirmed = await SELECT.from(Bookings).where({ status: 'CONFIRMED', ID: { in: bookIDs } });

      if (confirmed.length && req.data.status === 'CANCELLED') req.error(400,'Cannot cancel event with confirmed bookings. Cancel bookings first.');
    }
  });

    //  CUSTOMER - AUTO ID
  this.before('CREATE', 'Customers', async req => {
    const last = await SELECT.one.from(Customers).columns('customerID').orderBy('customerID desc');
    const next = String((parseInt(last?.customerID?.replace('CUST','')) || 0) + 1).padStart(4,'0');
    req.data.customerID = 'CUST' + next;
  });

    //  BOOKING DRAFT INIT & SAVE
  this.before('NEW', 'Bookings.drafts', req => {
    req.data = { bookingNumber: 'DRAFT-' + Date.now(), bookingDate: new Date().toISOString(), status: 'DRAFT', totalAmount: 0};
  });

  this.on('SAVE', 'Bookings', async (req, next) => {
    const b = req.data;
    if (!b.bookingNumber || b.bookingNumber.startsWith('DRAFT-')) {
      const last = await SELECT.one.from(Bookings).columns('bookingNumber').where({ bookingNumber: { like: 'BK%' } }).orderBy('bookingNumber desc');
      const nextNo = String((parseInt(last?.bookingNumber?.replace('BK','')) || 0) + 1).padStart(4,'0');
      b.bookingNumber = 'BK' + nextNo;
    }
    b.bookingDate ??= new Date().toISOString();
    return next();
  });

    //  BOOKING ITEM VALIDATION
  const validateItem = async (req, drafts = false) => {
    const table = drafts ? `${BookingItems.name}.drafts` : BookingItems;
    const existing = req.data.ID ? await SELECT.one.from(table).where({ ID: req.data.ID }) : null;

    const qty = req.data.quantity ?? existing?.quantity;
    if (qty !== undefined && qty <= 0) return req.error(400, 'Quantity must be > 0');

    const seatTypeID = req.data.seatType_ID ?? existing?.seatType_ID;
    if (!seatTypeID) return;

    const st = await SELECT.one.from(SeatTypes).where({ ID: seatTypeID });
    if (!st) return req.error(400, 'Seat type not found');

    if (qty !== undefined && st.availableSeats < qty) return req.error(400, `Not enough ${st.seatType} seats. Requested ${qty}, Available ${st.availableSeats}`);

    if (qty !== undefined) {
      req.data.unitPrice = st.price;
      req.data.totalPrice = st.price * qty;
    }
  };

  this.before(['CREATE','UPDATE'], 'BookingItems', req => validateItem(req));
  this.before(['CREATE','UPDATE'], 'BookingItems.drafts', req => validateItem(req, true));

    //  UPDATE TOTAL AMOUNT IN DRAFT
  this.after(['CREATE','UPDATE','DELETE'], 'BookingItems.drafts', async (_, req) => {
    const bookingID = req.data?.booking_ID || _.booking_ID;
    if (!bookingID) return;

    const items = await SELECT.from(`${BookingItems.name}.drafts`).where({ booking_ID: bookingID });
    const total = items.reduce((s,i) => s + Number(i.totalPrice || 0),0);

    await UPDATE(`${Bookings.name}.drafts`).set({ totalAmount: total }).where({ ID: bookingID });
  });

    //  CANCEL BOOKING
  this.on('cancelBooking', 'Bookings', async req => {
    const id = req.params[0].ID;
    const booking = await SELECT.one.from(Bookings).where({ ID: id });
    if (!booking) return req.error(404,'Not found');
    if (booking.status === 'CANCELLED') return 'Already cancelled';
    if (booking.status === 'DRAFT') return req.error(400,'Cannot cancel draft booking');
    const items = await SELECT.from(BookingItems).where({ booking_ID: id });
    if (booking.status === 'CONFIRMED') {
      const seatMap = new Map();
      for (const i of items) seatMap.set(i.seatType_ID, (seatMap.get(i.seatType_ID) || 0) + i.quantity);
      for (const [stID, qty] of seatMap) {
        const st = await SELECT.one.from(SeatTypes).where({ ID: stID });
        await UPDATE(SeatTypes).set({ availableSeats: st.availableSeats + qty }).where({ ID: stID });
      }
    }
    await UPDATE(Bookings).set({ status: 'CANCELLED' }).where({ ID: id });
    return `Booking ${booking.bookingNumber} cancelled.`;
  });

    //  COMPLETE EVENT
  this.on('completeEvent', 'Events', async req => {
    const id = req.params[0].ID;
    const event = await SELECT.one.from(Events).where({ ID: id });
    if (!event) return req.error(404,'Not found');
    if (event.status === 'COMPLETED') return 'Already completed';
    if (event.status === 'CANCELLED') return req.error(400,'Cannot complete cancelled event');
    if (new Date(event.eventDate) > new Date()) return req.error(400,'Cannot complete before event date');
    await UPDATE(Events).set({ status: 'COMPLETED' }).where({ ID: id });
    return `Event ${event.eventName} marked as completed.`;
  });

    //  CANCEL EVENT (AUTO CANCEL BOOKINGS)
  this.on('cancelEvent', 'Events', async req => {
    const id = req.params[0].ID;
    const event = await SELECT.one.from(Events).where({ ID: id });
    if (!event) return req.error(404,'Not found');
    if (event.status === 'CANCELLED') return 'Already cancelled';
    if (event.status === 'COMPLETED') return req.error(400,'Cannot cancel completed event');
    const items = await SELECT.from(BookingItems).where({ event_ID: id });
    const bookingIDs = [...new Set(items.map(i => i.booking_ID))];
    const confirmed = await SELECT.from(Bookings).where({ status: 'CONFIRMED', ID: { in: bookingIDs } });
    for (const b of confirmed) {
      const its = await SELECT.from(BookingItems).where({ booking_ID: b.ID });
      const seatMap = new Map();
      for (const i of its)
        seatMap.set(i.seatType_ID, (seatMap.get(i.seatType_ID) || 0) + i.quantity);
      for (const [stID, qty] of seatMap) {
        const st = await SELECT.one.from(SeatTypes).where({ ID: stID });
        await UPDATE(SeatTypes).set({ availableSeats: st.availableSeats + qty }).where({ ID: stID });
      }
      await UPDATE(Bookings).set({ status: 'CANCELLED' }).where({ ID: b.ID });
    }
    await UPDATE(Events).set({ status: 'CANCELLED' }).where({ ID: id });
    return `Event "${event.eventName}" cancelled. ${confirmed.length} confirmed booking(s) auto-cancelled.`;
  });


    //  BLOCK EDITING CONFIRMED/CANCELLED BOOKINGS
  this.before(['UPDATE','DELETE'], 'Bookings', async req => {
    const id = req.data?.ID ?? req.query?.SELECT?.from?.ref?.[0]?.where?.[2]?.val;
    if (!id) return;
    const booking = await SELECT.one.from(Bookings).where({ ID: id });
    if (booking?.status === 'CONFIRMED')req.error(400,'Cannot modify confirmed booking');
    if (booking?.status === 'CANCELLED')req.error(400,'Cannot modify cancelled booking');
  });

  this.before(['UPDATE','DELETE'], 'BookingItems', async req => {
    const id = req.event === 'DELETE'? (await SELECT.one.from(BookingItems).where({ ID: req.data.ID }))?.booking_ID: req.data.booking_ID;
    if (!id) return;
    const booking = await SELECT.one.from(Bookings).where({ ID: id });
    if (booking?.status === 'CONFIRMED') req.error(400,'Cannot modify confirmed booking');
    if (booking?.status === 'CANCELLED') req.error(400,'Cannot modify cancelled booking');
  });
});