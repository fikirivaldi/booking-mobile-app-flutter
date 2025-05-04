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
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16, top: 4),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  booking.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(booking.propertyName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Status: ${booking.status}",
                                    style: TextStyle(
                                      color:
                                          booking.status == "Sudah Dibayar"
                                              ? Colors.green
                                              : booking.status ==
                                                  "Belum Dibayar"
                                              ? Colors.orange
                                              : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Check-In: ${DateFormat('dd MMM yyyy').format(booking.checkIn)}",
                                  ),
                                  Text("Total: Rp${NumberFormat('#,###').format(total)}"),

                                ],
                              ),
                            ),
                            if (booking.status == "Sudah Dibayar")
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  bottom: 8,
                                ),
                                child: Text(
                                  "Kode Booking: ${_generateBookingCode(booking.id)}",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (booking.status == "Belum Dibayar")
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/payment',
                                      arguments: booking.id,
                                    );
                                  },
                                  child: const Text("Lanjutkan Pembayaran"),
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
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          "Tidak ada pesanan untuk status ini.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
