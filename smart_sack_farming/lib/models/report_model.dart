class CalamityReport {
  final String id;
  final String type;
  final String description;
  final String severity; // 'low', 'medium', 'high'
  final DateTime dateOccurred;
  final DateTime dateReported;
  final String farmerId;
  final String farmerName;
  final double affectedArea; // in acres
  final List<String> affectedCrops;
  final String status; // 'reported', 'verified', 'resolved'
  final String imageUrl;

  CalamityReport({
    required this.id,
    required this.type,
    required this.description,
    required this.severity,
    required this.dateOccurred,
    required this.dateReported,
    required this.farmerId,
    required this.farmerName,
    required this.affectedArea,
    required this.affectedCrops,
    required this.status,
    required this.imageUrl,
  });

  factory CalamityReport.empty() {
    return CalamityReport(
      id: '',
      type: 'Flood',
      description: '',
      severity: 'medium',
      dateOccurred: DateTime.now(),
      dateReported: DateTime.now(),
      farmerId: '',
      farmerName: '',
      affectedArea: 0,
      affectedCrops: [],
      status: 'reported',
      imageUrl: '',
    );
  }

  CalamityReport copyWith({
    String? id,
    String? type,
    String? description,
    String? severity,
    DateTime? dateOccurred,
    DateTime? dateReported,
    String? farmerId,
    String? farmerName,
    double? affectedArea,
    List<String>? affectedCrops,
    String? status,
    String? imageUrl,
  }) {
    return CalamityReport(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      dateOccurred: dateOccurred ?? this.dateOccurred,
      dateReported: dateReported ?? this.dateReported,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      affectedArea: affectedArea ?? this.affectedArea,
      affectedCrops: affectedCrops ?? this.affectedCrops,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CalamityReport.fromJson(Map<String, dynamic> json) {
    return CalamityReport(
      id: json['id'] ?? '',
      type: json['type'] ?? 'Other',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'medium',
      dateOccurred: json['date'] is String
          ? DateTime.parse(json['date'])
          : json['dateOccurred'] ?? DateTime.now(),
      dateReported: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : json['dateReported'] ?? DateTime.now(),
      farmerId: json['user_id'] ?? '',
      farmerName: json['farmer_name'] ?? '',
      affectedArea: (json['area_affected'] is int)
          ? (json['area_affected'] as int).toDouble()
          : json['area_affected'] ?? 0.0,
      affectedCrops: json['affected_crops'] is String
          ? (json['affected_crops'] as String).split(',')
          : json['affected_crops'] ?? [],
      status: json['status'] ?? 'reported',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'severity': severity,
      'date': dateOccurred.toIso8601String(),
      'area_affected': affectedArea,
      'affected_crops': affectedCrops.join(','),
      'damage_estimate': 0,
      'status': status,
    };
  }
}

class ProductionReport {
  final String id;
  final String cropType;
  final double area; // in acres
  final DateTime plantingDate;
  final DateTime harvestDate;
  final double yieldPerAcre; // in kg or quintals
  final double totalYield;
  final double qualityRating; // 1-5 stars
  final String notes;
  final DateTime reportDate;

  ProductionReport({
    required this.id,
    required this.cropType,
    required this.area,
    required this.plantingDate,
    required this.harvestDate,
    required this.yieldPerAcre,
    required this.totalYield,
    required this.qualityRating,
    required this.notes,
    required this.reportDate,
  });

  factory ProductionReport.empty() {
    return ProductionReport(
      id: '',
      cropType: '',
      area: 0,
      plantingDate: DateTime.now(),
      harvestDate: DateTime.now(),
      yieldPerAcre: 0,
      totalYield: 0,
      qualityRating: 0,
      notes: '',
      reportDate: DateTime.now(),
    );
  }

  ProductionReport copyWith({
    String? id,
    String? cropType,
    double? area,
    DateTime? plantingDate,
    DateTime? harvestDate,
    double? yieldPerAcre,
    double? totalYield,
    double? qualityRating,
    String? notes,
    DateTime? reportDate,
  }) {
    return ProductionReport(
      id: id ?? this.id,
      cropType: cropType ?? this.cropType,
      area: area ?? this.area,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      yieldPerAcre: yieldPerAcre ?? this.yieldPerAcre,
      totalYield: totalYield ?? this.totalYield,
      qualityRating: qualityRating ?? this.qualityRating,
      notes: notes ?? this.notes,
      reportDate: reportDate ?? this.reportDate,
    );
  }

  factory ProductionReport.fromJson(Map<String, dynamic> json) {
    return ProductionReport(
      id: json['id'] ?? '',
      cropType: json['crop_type'] ?? '',
      area: (json['area'] is int)
          ? (json['area'] as int).toDouble()
          : json['area'] ?? 0.0,
      plantingDate: json['planting_date'] is String
          ? DateTime.parse(json['planting_date'])
          : json['plantingDate'] ?? DateTime.now(),
      harvestDate: json['harvest_date'] is String
          ? DateTime.parse(json['harvest_date'])
          : json['harvestDate'] ?? DateTime.now(),
      yieldPerAcre: (json['yield'] is int)
          ? (json['yield'] as int).toDouble()
          : json['yield'] ?? 0.0,
      totalYield: (json['yield'] is int)
          ? (json['yield'] as int).toDouble()
          : json['yield'] ?? 0.0,
      qualityRating: (json['quality_rating'] is int)
          ? (json['quality_rating'] as int).toDouble()
          : json['quality_rating'] ?? 0.0,
      notes: json['notes'] ?? '',
      reportDate: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : json['reportDate'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_type': cropType,
      'area': area,
      'planting_date': plantingDate.toIso8601String(),
      'harvest_date': harvestDate.toIso8601String(),
      'yield': totalYield,
      'yield_unit': 'kg',
      'quality_rating': qualityRating.toInt(),
      'notes': notes,
    };
  }
}
