import 'package:flutter/material.dart';
import '../../../models/property_model.dart';
import 'package:provider/provider.dart';
import '../../../models/booking_model.dart';
import '../../booking/screens/booking_form_screen.dart';
import '../../saved/screens/saved_provider.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)!.settings.arguments as Property;

    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        _buildHeader(context, property),
                        _buildPropertyInfo(property),
                        const TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: "About"),
                            Tab(text: "Gallery"),
                            Tab(text: "Review"),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: TabBarView(
                            children: [
                              _buildAboutTab(property),
                              _buildGalleryTab(property),
                              _buildReviewTab(property),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: _buildBottomBar(context, property),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Property property) {
    final imageCount =
        property.gallery.length > 4 ? 4 : property.gallery.length;

    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: imageCount,
                itemBuilder: (context, index) {
                  return Image.network(
                    property.gallery[index],
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                  );
                },
              ),
              // Dot Indicator di dalam gambar, nempel di bawah
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: imageCount,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Tombol kembali dan favorit
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleIcon(Icons.arrow_back, () => Navigator.pop(context)),
                Row(
                  children: [
                    _circleIcon(Icons.share, () {}),
                    const SizedBox(width: 8),
                    Consumer<SavedProvider>(
                      builder: (context, savedProvider, _) {
                        final isFavorited = savedProvider.isSaved(property);
                        return _circleIcon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          () => savedProvider.toggleSaved(property),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildPropertyInfo(Property property) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(property.type, style: const TextStyle(color: Colors.blue)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                "${property.rating} (${property.reviewsCount} reviews)",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            property.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(property.location, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAboutTab(Property property) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertyFeatures(property),
          const SizedBox(height: 28),
          Text(
            "Description",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            property.description,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildAgentInfo(),
        ],
      ),
    );
  }

  Widget _buildGalleryTab(Property property) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: property.gallery.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // child: Image.network(property.gallery[index], fit: BoxFit.cover), // tempat gambar GALLERY
          );
        },
      ),
    );
  }

  Widget _buildReviewTab(Property property) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children:
            property.reviews.map((review) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['user'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review['comment'] ?? '',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPropertyFeatures(Property property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _FeatureItem(icon: Icons.bed, label: "${property.bedrooms} Beds"),
        _FeatureItem(icon: Icons.bathtub, label: "${property.bathrooms} Bath"),
        _FeatureItem(icon: Icons.square_foot, label: "${property.area} sqft"),
      ],
    );
  }

  Widget _buildAgentInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png",
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Listing Agent", style: TextStyle(color: Colors.grey)),
            Text("Fiki Rivaldi", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, Property property) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(property.price);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Total Price", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '$formattedPrice/ Night',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BookingFormScreen(
                        booking: Booking(
                          id: '', // kosong dulu
                          propertyId: property.id,
                          propertyName: property.name,
                          imageUrl: property.image,
                          price: property.price,
                          checkIn: DateTime.now(), // default sementara
                          checkOut: DateTime.now().add(const Duration(days: 1)),
                        ),
                      ),
                ),
              );
            },
            child: const Text(
              "Book Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
