class Equipment {
  final String id;
  final String name;
  final String description;
  final String category;
  final double dailyRentalPrice;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final DateTime dateAdded;
  final bool isAvailable;
  final String imageUrl;
  final int quantity;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dailyRentalPrice,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.dateAdded,
    required this.isAvailable,
    required this.imageUrl,
    required this.quantity,
  });

  factory Equipment.empty() {
    return Equipment(
      id: '',
      name: '',
      description: '',
      category: 'Tractor',
      dailyRentalPrice: 0,
      ownerId: '',
      ownerName: '',
      ownerPhone: '',
      dateAdded: DateTime.now(),
      isAvailable: true,
      imageUrl: '',
      quantity: 1,
    );
  }

  Equipment copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? dailyRentalPrice,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    DateTime? dateAdded,
    bool? isAvailable,
    String? imageUrl,
    int? quantity,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      dailyRentalPrice: dailyRentalPrice ?? this.dailyRentalPrice,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      dateAdded: dateAdded ?? this.dateAdded,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
