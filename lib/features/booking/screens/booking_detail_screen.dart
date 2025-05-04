import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/booking_model.dart';
import '../../booking/screens/booking_screen.dart';
import '../../../provider/booking_provider.dart';
import 'package:provider/provider.dart';
import 'payment_screen.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final nights = booking.checkOut.difference(booking.checkIn).inDays;
    final double subtotal = booking.price * nights;
    final double adminFee = 20000;
    final double total = subtotal + adminFee;

    // Format rupiah
    String formatCurrency(double amount) {
      return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pemesanan')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(booking.imageUrl, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              booking.propertyName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("${DateFormat('dd MMM yyyy').format(booking.checkIn)} - ${DateFormat('dd MMM yyyy').format(booking.checkOut)}"),
            Text("$nights malam"),
            const SizedBox(height: 8),
            Text("Tipe Kamar: ${booking.roomType}"),
            Text("Preferensi: ${booking.smoking ? 'Smoking' : 'Non-Smoking'}"),
            const SizedBox(height: 16),
            const Text("Data Pemesan", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Nama: ${booking.guestName}"),
            Text("Telepon: ${booking.guestPhone}"),
            Text("Email: ${booking.guestEmail}"),

            const Divider(height: 32),

            _row("Harga / malam", formatCurrency(booking.price)),
            _row("Subtotal", formatCurrency(subtotal)),
            _row("Biaya Layanan", formatCurrency(adminFee)),
            _row("Total", formatCurrency(total), bold: true),

            const SizedBox(height: 16),
            if (booking.status == "Sudah Dibayar")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("✅ Sudah Dibayar", style: TextStyle(color: Colors.green)),
                  const SizedBox(height: 8),
                  Text("Kode Booking:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    _generateBookingCode(booking.id),
                    style: const TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ],
              )
            else
            
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PaymentScreen(),
              settings: RouteSettings(arguments: booking.id),
            ),
          );
        },
        child: const Text("Lanjutkan Pembayaran"),
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: () {
          _showCancelDialog(context, booking.id);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text("Batalkan Pesanan"),
      ),
    ],
  ),
  


            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  String _generateBookingCode(String id) {
    // Contoh: "BK-12345XYZ"
    final code = id.hashCode.abs().toString().padLeft(6, '0');
    return "BK-$code";
  }
  void _showCancelDialog(BuildContext context, String bookingId) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Batalkan Pesanan?"),
      content: const Text("Apakah Anda yakin ingin membatalkan pesanan ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Tidak"),
        ),
        TextButton(
          onPressed: () {
            Provider.of<BookingProvider>(context, listen: false).cancelBooking(bookingId);
            Navigator.pop(ctx); // Tutup dialog
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
          child: const Text("Ya, Batalkan"),
        ),
      ],
    ),
  );
}

}
