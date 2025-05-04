import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/dummy_data.dart';
import '../widgets/property_card.dart';
import '../../explore/screens/explore_screen.dart';
import 'category_property_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            _buildPromoCarousel(),
            const SizedBox(height: 16),
            _buildCategoryIcons(context),
            const SizedBox(height: 16),
            _buildSection("Recommended Property", context),
            const SizedBox(height: 16),
            const SizedBox(height: 16),

            Text(
              "All Properties",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyProperties.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return PropertyCard(property: dummyProperties[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Material(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Location",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 18, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    "Bandung, Indonesia",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildSearchBar()),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.blue),
                      onPressed: () {},
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () {},
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    final List<String> promos = [
      "https://img.freepik.com/free-photo/type-entertainment-complex-popular-resort-with-pools-water-parks-turkey-with-more-than-5-million-visitors-year-amara-dolce-vita-luxury-hotel-resort-tekirova-kemer_146671-18728.jpg",
      "https://img.freepik.com/free-photo/swimming-pool-beach-luxury-hotel-type-entertainment-complex-amara-dolce-vita-luxury-hotel-resort-tekirova-kemer-turkey_146671-18726.jpg",
      "https://img.freepik.com/free-photo/woman-talking-with-hotel-receptionist-lobby_23-2149304051.jpg",
    ];

    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: promos.length,
        controller: PageController(viewportFraction: 1.03),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(promos[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcons(BuildContext context) {
    final categories = [
      {'icon': Icons.villa, 'label': 'Hotel'},
      {'icon': Icons.apartment, 'label': 'Apartment'},
      {'icon': Icons.house, 'label': 'Villa'},
      {'icon': Icons.cottage, 'label': 'Resort'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          categories.map((cat) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CategoryPropertyScreen(
                          category: cat['label'] as String,
                        ),
                  ),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue[50],
                    child: Icon(cat['icon'] as IconData, color: Colors.blue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSection(String title, BuildContext context) {
    final properties = dummyProperties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExploreScreen()),
                );
              },
              child: const Text("See all"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.take(5).length,

            itemBuilder: (context, index) {
              return PropertyCard(property: properties[index]);
            },
            separatorBuilder: (context, _) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}
