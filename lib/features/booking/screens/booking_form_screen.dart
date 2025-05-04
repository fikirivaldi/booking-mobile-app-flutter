import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/booking_model.dart';
import '../../../provider/booking_provider.dart';
import 'payment_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final Booking booking;

  const BookingFormScreen({super.key, required this.booking});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime? checkIn;
  DateTime? checkOut;
  String roomType = 'Twin';
  String smoking = 'Non-Smoking';
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> _selectDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
          // reset checkout jika lebih awal dari checkin
          if (checkOut != null && checkOut!.isBefore(checkIn!)) {
            checkOut = null;
          }
        } else {
          checkOut = picked;
        }
      });
    }
  }

  void _submitBooking() {
  if (checkIn == null || checkOut == null || nameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Harap lengkapi semua data.')),
    );
    return;
  }

  final booking = widget.booking.copyWith(
    id: DateTime.now().toIso8601String(), // generate ID saat submit
    checkIn: checkIn!,
    checkOut: checkOut!,
    roomType: roomType,
    smoking: smoking == "Smoking",
    guestName: nameController.text,
    guestPhone: phoneController.text,
    guestEmail: emailController.text,
  );

  Provider.of<BookingProvider>(context, listen: false).addBooking(booking);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentScreen(),
      settings: RouteSettings(arguments: booking.id),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Pemesanan"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Tanggal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("Check-In"),
                    subtitle: Text(
                      checkIn == null
                          ? 'Pilih Tanggal'
                          : DateFormat('dd MMM yyyy').format(checkIn!),
                    ),
                    onTap: () => _selectDate(true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListTile(
                    title: const Text("Check-Out"),
                    subtitle: Text(
                      checkOut == null
                          ? 'Pilih Tanggal'
                          : DateFormat('dd MMM yyyy').format(checkOut!),
                    ),
                    onTap: () => _selectDate(false),
                  ),
                ),
              ],
            ),
            const Divider(),

            const Text(
              "Tipe Kamar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children:
                  ["Twin", "Double"].map((type) {
                    return Expanded(
                      child: RadioListTile(
                        title: Text(type),
                        value: type,
                        groupValue: roomType,
                        onChanged: (value) {
                          setState(() => roomType = value!);
                        },
                      ),
                    );
                  }).toList(),
            ),

            const Text(
              "Preferensi Merokok",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children:
                  ["Smoking", "Non-Smoking"].map((val) {
                    return Expanded(
                      child: RadioListTile(
                        title: Text(val),
                        value: val,
                        groupValue: smoking,
                        onChanged: (value) {
                          setState(() => smoking = value!);
                        },
                      ),
                    );
                  }).toList(),
            ),

            const Divider(),

            const Text(
              "Data Pemesan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Nomor Telepon"),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 16),
            const Text(
              "⚠️ Wajib membawa kartu identitas saat check-in.\n💵 Deposit sebesar Rp100.000 akan dibayarkan di hotel.",
              style: TextStyle(color: Colors.orange),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna latar belakang
                  foregroundColor: Colors.white, // Warna teks
                ),
                child: const Text("Lanjut ke Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
