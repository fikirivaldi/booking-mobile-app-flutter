class Booking {
  final String id;
  final String propertyId;
  final String propertyName;
  final String imageUrl;
  final double price;
  final DateTime checkIn;
  final DateTime checkOut;
  String status; // "Belum Dibayar", "Sudah Dibayar"

  // Tambahan:
  final String roomType; // "Twin" atau "Double"
  final bool smoking;    // true = smoking, false = non-smoking
  final String guestName;
  final String guestPhone;
  final String guestEmail;

  Booking({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.imageUrl,
    required this.price,
    required this.checkIn,
    required this.checkOut,
    this.status = "Belum Dibayar",
    this.roomType = "Double",      // default value
    this.smoking = false,
    this.guestName = "",
    this.guestPhone = "",
    this.guestEmail = "",
  });

  Booking copyWith({
    String? id,
    String? propertyId,
    String? propertyName,
    String? imageUrl,
    double? price,
    DateTime? checkIn,
    DateTime? checkOut,
    String? status,
    String? roomType,
    bool? smoking,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
  }) {
    return Booking(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      roomType: roomType ?? this.roomType,
      smoking: smoking ?? this.smoking,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: guestEmail ?? this.guestEmail,
    );
  }
}
