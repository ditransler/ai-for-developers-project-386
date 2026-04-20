import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.OpenAPI;

/** Calendar booking API: a single implicit owner uses admin routes; guests use public routes. No authentication—separation is by URL only. */
@service(#{ title: "Calendar Booking API" })
@doc("""
There is one predefined owner profile (not modeled as a resource). Guests have no accounts.

**Booking window:** available slots are computed for **14 calendar days** starting from the server’s current local date (inclusive). Guests may only book within that window.

**Occupancy:** at most one booking may cover any instant in time. Overlaps are forbidden even across different event types.
""")
namespace CalendarBooking;

// ——— Shared models ———

@doc("Bookable meeting template: identity, copy, and slot length.")
model EventType {
  @format("uuid")
  id: string;

  name: string;
  description: string;

  /** Duration of one slot, in minutes. */
  @TypeSpec.minValue(1)
  durationMinutes: int32;
}

@doc("Create an event type.")
model EventTypeCreate {
  @format("uuid")
  id: string;

  name: string;
  description: string;

  @TypeSpec.minValue(1)
  durationMinutes: int32;
}

@doc("Partial update for an event type.")
model EventTypeUpdate {
  name?: string;
  description?: string;

  @TypeSpec.minValue(1)
  durationMinutes?: int32;
}

@doc("A free interval the guest may book.")
model TimeSlot {
  startAt: utcDateTime;
  endAt: utcDateTime;
}

@doc("Guest books a slot. `startAt` must match a returned free slot start for that event type.")
model CreateBookingRequest {
  @format("uuid")
  eventTypeId: string;

  startAt: utcDateTime;

  /** Optional label in the owner’s meeting list. */
  guestDisplayName?: string;
}

@doc("Confirmed booking on [startAt, endAt).")
model Booking {
  @format("uuid")
  id: string;

  @format("uuid")
  eventTypeId: string;

  eventTypeName: string;
  startAt: utcDateTime;
  endAt: utcDateTime;

  guestDisplayName?: string;
}

@error
model BadRequest {
  @statusCode _: 400;
  error: "VALIDATION_ERROR" | "SLOT_OUTSIDE_WINDOW" | "SLOT_MISMATCH";
  message: string;
}

@error
model NotFound {
  @statusCode _: 404;
  message: string;
}

@error
model Conflict {
  @statusCode _: 409;
  error: "SLOT_OCCUPIED";
  message: string;
}

@error
model DeleteEventTypeConflict {
  @statusCode _: 409;
  error: "FUTURE_BOOKINGS_EXIST";
  message: string;
}

@error
model InternalError {
  @statusCode _: 500;
  message: string;
}

// ——— Guest (public) ———

@tag("Guest")
interface GuestRoutes {
  @get
  @route("/public/event-types")
  @doc("List event types (name, description, duration) for the booking options page.")
  listEventTypes(): OkResponse & Body<EventType[]> | InternalError;

  @get
  @route("/public/event-types/{eventTypeId}/available-slots")
  @doc("""
Free slots for the given type within the default **14-day** booking window from the server’s current date (inclusive).

Slots honor `durationMinutes`, exclude time covered by **any** booking (all types), and align with `CreateBookingRequest.startAt`.
""")
  listAvailableSlots(
    @path @format("uuid") eventTypeId: string,
  ): OkResponse & Body<TimeSlot[]> | NotFound | InternalError;

  @post
  @route("/public/bookings")
  @doc("Create a booking. Fails if the interval overlaps any existing booking.")
  createBooking(@body body: CreateBookingRequest): CreatedResponse & Body<Booking> | BadRequest | NotFound | Conflict | InternalError;
}

// ——— Owner (admin) ———

@tag("Owner admin")
interface AdminRoutes {
  @get
  @route("/admin/event-types")
  @doc("List event types for management.")
  listEventTypesAdmin(): OkResponse & Body<EventType[]> | InternalError;

  @post
  @route("/admin/event-types")
  @doc("Create an event type.")
  createEventType(@body body: EventTypeCreate): CreatedResponse & Body<EventType> | BadRequest | InternalError;

  @patch
  @route("/admin/event-types/{eventTypeId}")
  @doc("Update an event type.")
  updateEventType(
    @path @format("uuid") eventTypeId: string,
    @body body: EventTypeUpdate,
  ): OkResponse & Body<EventType> | BadRequest | NotFound | InternalError;

  @delete
  @route("/admin/event-types/{eventTypeId}")
  @doc("Delete an event type. Implementations may reject if future bookings exist.")
  deleteEventType(
    @path @format("uuid") eventTypeId: string,
  ): NoContentResponse | NotFound | DeleteEventTypeConflict | InternalError;

  @get
  @route("/admin/bookings")
  @doc("Upcoming bookings for all event types, one list ordered by `startAt` ascending.")
  listUpcomingBookings(): OkResponse & Body<Booking[]> | InternalError;
}
