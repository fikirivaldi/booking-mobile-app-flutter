import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/booking_provider.dart';
import '../../../models/booking_model.dart';
import '../../../app/main_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 24,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.propertyName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${DateFormat('dd MMM yyyy').format(booking.checkIn)} - ${DateFormat('dd MMM yyyy').format(booking.checkOut)}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text("$nights malam", style: const TextStyle(fontSize: 16)),

            const Divider(height: 32),
            _priceRow(
              "Harga per malam",
              "Rp${booking.price.toStringAsFixed(0)}",
            ),
            _priceRow(
              "Subtotal ($nights malam)",
              "Rp${subtotal.toStringAsFixed(0)}",
            ),
            _priceRow("Biaya layanan", "Rp${adminFee.toStringAsFixed(0)}"),
            const Divider(height: 32),
            _priceRow("Total", "Rp${total.toStringAsFixed(0)}", bold: true),

            const SizedBox(height: 8),

            const Text(
              "Detail Pemesan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Nama: ${booking.guestName}"),
            Text("No. Telp: ${booking.guestPhone}"),
            Text("Email: ${booking.guestEmail}"),

            const SizedBox(height: 16),
            const Text(
              "Detail Kamar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Tipe Kamar: ${booking.roomType}"),
            Text(
              "Preferensi: ${booking.smoking ? 'Smoking Room' : 'Non-Smoking Room'}",
            ),

            const SizedBox(height: 12),
            const Text(
              "⚠️ Wajib membawa kartu identitas saat check-in.\n💵 Deposit sebesar Rp100.000 akan dibayarkan di hotel.",
              style: TextStyle(color: Colors.orange),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
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
                                  (context) => MainScreen(
                                    selectedIndex: 2,
                                  ), // 2 = Booking
                            ),
                            (route) => false,
                          );
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      booking.status == "Sudah Dibayar"
                          ? Colors.grey
                          : Colors.blue, // Ubah warna latar belakang di sini
                  foregroundColor: Colors.white, // Warna teks
                ),
                child: const Text("Bayar Sekarang", style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
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
