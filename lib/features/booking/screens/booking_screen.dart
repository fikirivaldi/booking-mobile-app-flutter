import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../provider/booking_provider.dart';
import 'booking_detail_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> filters = [
    'Semua',
    'Sudah Dibayar',
    'Belum Dibayar',
    'Dibatalkan',
  ];

  @override
  void initState() {
    _tabController = TabController(length: filters.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List _filterBookings(String filter, List all) {
    if (filter == 'Semua') return all;
    return all.where((b) => b.status == filter).toList();
  }

  String _generateBookingCode(String id) {
    final code = id.hashCode.abs().toString().padLeft(6, '0');
    return "BK-$code";
  }

  @override
  Widget build(BuildContext context) {
    final allBookings =
        Provider.of<BookingProvider>(context).bookings.reversed.toList();

    return DefaultTabController(
      length: filters.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pesanan Saya"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: filters.map((f) => Tab(text: f)).toList(),
            isScrollable: true,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
              filters.map((filter) {
                final bookings = _filterBookings(filter, allBookings);
                if (bookings.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  padding: const EdgeInsets.all(1),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final nights =
                        booking.checkOut.difference(booking.checkIn).inDays;
                    final subtotal = booking.price * nights;
                    final total = subtotal + 20000;

                    Color statusColor;
                    switch (booking.status) {
                      case 'Sudah Dibayar':
                        statusColor = Colors.green;
                        break;
                      case 'Belum Dibayar':
                        statusColor = Colors.orange;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BookingDetailScreen(booking: booking),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  booking.imageUrl,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                booking.propertyName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        booking.status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Check-In: ${DateFormat('dd MMM yyyy').format(booking.checkIn)}",
                                    ),
                                    Text(
                                      "Total: Rp${NumberFormat('#,###').format(total)}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (booking.status == "Sudah Dibayar")
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  bottom: 12,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.qr_code,
                                      color: Colors.blueAccent,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Kode Booking: ${_generateBookingCode(booking.id)}",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (booking.status == "Belum Dibayar")
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/payment',
                                        arguments: booking.id,
                                      );
                                    },
                                    icon: const Icon(Icons.payment),
                                    label: const Text("Lanjutkan Pembayaran"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Tidak ada pesanan untuk status ini.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
