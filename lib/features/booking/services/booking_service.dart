import '../../../models/booking_model.dart';

class BookingService {
  static final List<Booking> _bookings = [];

  static List<Booking> getAll() => _bookings;

  static void add(Booking booking) => _bookings.add(booking);

  static void cancel(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) _bookings[index].status = 'Cancelled';
  }

  static void markAsPaid(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) _bookings[index].status = 'Paid';
  }
}
