import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/property_model.dart'; // Pastikan ini sesuai dengan path model Property

class BookingProvider with ChangeNotifier {
  final List<Booking> _bookings = [];
  final List<Property> _favorites = []; // Daftar properti favorit

  List<Booking> get bookings => _bookings;
  List<Property> get favorites => _favorites;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateStatus(String id, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = newStatus;
      notifyListeners();
    }
  }

  void updateBooking(Booking updatedBooking) {
    final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    if (index != -1) {
      _bookings[index] = updatedBooking;
      notifyListeners();
    }
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1 && _bookings[index].status == 'Belum Dibayar') {
      _bookings[index].status = 'Dibatalkan';
      notifyListeners();
    }
  }

  // Menambahkan fungsi toggleFavorite untuk menambah/menghapus properti dari favorit
  void toggleFavorite(Property property) {
    if (_favorites.contains(property)) {
      _favorites.remove(property); // Menghapus dari favorit
    } else {
      _favorites.add(property); // Menambahkan ke favorit
    }
    notifyListeners(); // Memberitahukan ada perubahan
  }
}
