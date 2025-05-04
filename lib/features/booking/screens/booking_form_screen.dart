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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Pilih Tanggal"),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    _buildDateTile(
                      "Check-In",
                      checkIn,
                      () => _selectDate(true),
                    ),
                    const SizedBox(width: 8),
                    _buildDateTile(
                      "Check-Out",
                      checkOut,
                      () => _selectDate(false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _sectionTitle("Tipe Kamar"),
            _buildRadioGroup(["Twin", "Double"], roomType, (val) {
              setState(() => roomType = val);
            }),

            const SizedBox(height: 20),

            _sectionTitle("Preferensi Merokok"),
            _buildRadioGroup(["Smoking", "Non-Smoking"], smoking, (val) {
              setState(() => smoking = val);
            }),

            const SizedBox(height: 20),
            _sectionTitle("Data Pemesan"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: nameController,
              label: "Nama Lengkap",
              icon: Icons.person,
            ),
            _buildTextField(
              controller: phoneController,
              label: "Nomor Telepon",
              icon: Icons.phone,
              inputType: TextInputType.phone,
            ),
            _buildTextField(
              controller: emailController,
              label: "Email",
              icon: Icons.email,
              inputType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "⚠️ Wajib membawa kartu identitas saat check-in.\n💵 Deposit sebesar Rp100.000 akan dibayarkan di hotel.",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitBooking,
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  "Lanjut ke Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildDateTile(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date == null
                        ? 'Pilih Tanggal'
                        : DateFormat('dd MMM yyyy').format(date),
                    style: TextStyle(
                      color: date == null ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioGroup(
    List<String> options,
    String groupValue,
    void Function(String) onChanged,
  ) {
    return Row(
      children:
          options.map((option) {
            return Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RadioListTile<String>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(option),
                  value: option,
                  groupValue: groupValue,
                  onChanged: (val) => onChanged(val!),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
