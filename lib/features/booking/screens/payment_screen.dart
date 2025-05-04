import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/booking_provider.dart';
import '../../../app/main_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! String) {
      return const Scaffold(
        body: Center(child: Text("Booking ID tidak ditemukan.")),
      );
    }

    final bookingId = args;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final booking = bookingProvider.bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => throw Exception('Booking tidak ditemukan'),
    );

    final int nights = booking.checkOut.difference(booking.checkIn).inDays;
    final double subtotal = booking.price * nights;
    final double adminFee = 20000; // contoh biaya admin
    final double total = subtotal + adminFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.propertyName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "${DateFormat('dd MMM yyyy').format(booking.checkIn)} - ${DateFormat('dd MMM yyyy').format(booking.checkOut)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("$nights malam", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _priceRow(
                      "Harga per malam",
                      formatCurrency.format(booking.price),
                    ),
                    _priceRow(
                      "Subtotal ($nights malam)",
                      formatCurrency.format(subtotal),
                    ),
                    _priceRow("Biaya layanan", formatCurrency.format(adminFee)),
                    const Divider(height: 24),
                    _priceRow(
                      "Total",
                      formatCurrency.format(total),
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Detail Pemesan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _infoRow(Icons.person, "Nama", booking.guestName),
            _infoRow(Icons.phone, "No. Telp", booking.guestPhone),
            _infoRow(Icons.email, "Email", booking.guestEmail),

            const SizedBox(height: 24),
            const Text(
              "Detail Kamar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _infoRow(Icons.hotel, "Tipe Kamar", booking.roomType),
            _infoRow(
              Icons.smoking_rooms,
              "Preferensi",
              booking.smoking ? "Smoking Room" : "Non-Smoking Room",
            ),

            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "⚠️ Wajib membawa kartu identitas saat check-in.",
                    style: TextStyle(color: Colors.orange),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "💵 Deposit sebesar Rp100.000 akan dibayarkan di hotel.",
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap:
                    booking.status == "Sudah Dibayar"
                        ? null
                        : () {
                          bookingProvider.updateStatus(
                            booking.id,
                            "Sudah Dibayar",
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MainScreen(selectedIndex: 2),
                            ),
                            (route) => false,
                          );
                        },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient:
                        booking.status == "Sudah Dibayar"
                            ? LinearGradient(
                              colors: [Colors.grey, Colors.grey.shade400],
                            )
                            : const LinearGradient(
                              colors: [Colors.blue, Color(0xFF0056D2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    boxShadow:
                        booking.status == "Sudah Dibayar"
                            ? []
                            : [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                  ),
                  child: Center(
                    child: Text(
                      booking.status == "Sudah Dibayar"
                          ? "Sudah Dibayar"
                          : "Bayar Sekarang",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
