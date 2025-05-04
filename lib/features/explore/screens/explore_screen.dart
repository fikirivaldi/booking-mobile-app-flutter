import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/dummy_data.dart';
import '../widgets/explore_property_card.dart';
import '../../../models/property_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Property> _filteredProperties = dummyProperties;
  String _selectedType = 'Semua';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProperties =
          dummyProperties.where((property) {
            final matchQuery =
                property.name.toLowerCase().contains(query) ||
                property.location.toLowerCase().contains(query) ||
                property.type.toLowerCase().contains(query);

            final matchType =
                _selectedType == 'Semua' || property.type == _selectedType;

            return matchQuery && matchType;
          }).toList();
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(16),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                "Filter Tipe Properti",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildFilterChip('Semua'),
                  _buildFilterChip('Hotel'),
                  _buildFilterChip('Villa'),
                  _buildFilterChip('Apartment'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Terapkan Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
  final isSelected = _selectedType == label;
  return ChoiceChip(
    label: Text(label),
    selected: isSelected,
    selectedColor: Colors.blue,
    backgroundColor: Colors.grey[200],
    labelStyle: TextStyle(
      color: isSelected ? Colors.white : Colors.black,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    onSelected: (selected) {
      setState(() {
        _selectedType = label; // Ini penting!
      });
    },
  );
}



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
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
                    onPressed: _openFilterSheet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPropertyList(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Temukan Hotel', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari hotel...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    if (_filteredProperties.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.search_off, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tidak ada properti ditemukan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        itemCount: _filteredProperties.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return PropertyCard(property: _filteredProperties[index]);
        },
      ),
    );
  }
}
