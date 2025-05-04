class Property {
  final String id;
  final String name;
  final String type;
  final String location;
  final double price;
  final double rating;
  final String image;
  final int bedrooms;
  final int bathrooms;
  final int area; // dalam m2
  final int reviewsCount; // jumlah review
  final String description;
  final List<String> gallery;
  final List<Map<String, String>> reviews; // list isi review

  Property({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.price,
    required this.rating,
    required this.image,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.reviewsCount,
    required this.description,
    required this.gallery,
    required this.reviews,
  });
}
