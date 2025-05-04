import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/dummy_data.dart';
import '../../../models/property_model.dart';
import '../widgets/property_card.dart';

class CategoryPropertyScreen extends StatelessWidget {
  final String category;

  const CategoryPropertyScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Filter property berdasarkan kategori
    List<Property> filteredProperties = dummyProperties.where((property) {
      return property.type.toLowerCase() == category.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: filteredProperties.isEmpty
          ? Center(
              child: Text('No properties found for $category',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
            )
          : GridView.builder(
              itemCount: filteredProperties.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return PropertyCard(property: filteredProperties[index]);
              },
            ),
      ),
    );
  }
}
