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
}
