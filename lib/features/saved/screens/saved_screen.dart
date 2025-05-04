import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../saved/screens/saved_provider.dart';
import '../../../models/property_model.dart';
import '../../../provider/booking_provider.dart';
import 'package:intl/intl.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = Provider.of<SavedProvider>(context).saved;

    return Scaffold(
      appBar: AppBar(title: const Text("Tersimpan")),
      body: saved.isEmpty
    ? const Center(child: Text("Belum ada properti yang disimpan."))
    : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: saved.length,
        itemBuilder: (context, index) {
          final property = saved[index];
          return _buildGridCard(context, property);
        },
      ),

    );
  }

  Widget _buildGridCard(BuildContext context, Property property) {
  final formattedPrice = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(property.price);

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: property,
      );
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
  children: [
    ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        property.image,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
    Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () {
          Provider.of<BookingProvider>(context, listen: false)
              .toggleFavorite(property);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Icons.favorite,
            color: Colors.red,
            size: 20,
          ),
        ),
      ),
    ),
  ],
),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  property.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "$formattedPrice/ Night",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
