import '../../models/report_model.dart';
import '../supabase_service.dart';

class ReportRepository {
  final SupabaseService _supabaseService = SupabaseService();

  static const String _calamityTableName = 'calamity_reports';
  static const String _productionTableName = 'production_reports';

  // ============ Calamity Reports ============

  /// Get all calamity reports for a user
  Future<List<CalamityReport>> getAllCalamityReports(String userId) async {
    try {
      final response = await _supabaseService.client
          .from(_calamityTableName)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);

      return (response as List)
          .map((r) => CalamityReport.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch calamity reports: $e');
    }
  }

  /// Add a calamity report
  Future<CalamityReport> addCalamityReport(
      CalamityReport report, String userId) async {
    try {
      final data = {
        'id': report.id,
        'user_id': userId,
        'type': report.type,
        'severity': report.severity,
        'date': report.date.toIso8601String(),
        'area_affected': report.areaAffected,
        'affected_crops': report.affectedCrops,
        'description': report.description,
        'damage_estimate': report.damageEstimate,
      };

      final response = await _supabaseService.client
          .from(_calamityTableName)
          .insert(data)
          .select()
          .single();

      return CalamityReport.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add calamity report: $e');
    }
  }

  /// Update a calamity report
  Future<void> updateCalamityReport(
      CalamityReport report, String userId) async {
    try {
      final data = {
        'type': report.type,
        'severity': report.severity,
        'date': report.date.toIso8601String(),
        'area_affected': report.areaAffected,
        'affected_crops': report.affectedCrops,
        'description': report.description,
        'damage_estimate': report.damageEstimate,
      };

      await _supabaseService.client
          .from(_calamityTableName)
          .update(data)
          .eq('id', report.id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update calamity report: $e');
    }
  }

  /// Delete a calamity report
  Future<void> deleteCalamityReport(String reportId, String userId) async {
    try {
      await _supabaseService.client
          .from(_calamityTableName)
          .delete()
          .eq('id', reportId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete calamity report: $e');
    }
  }

  /// Get calamity reports by type
  Future<List<CalamityReport>> getCalamityReportsByType(
      String userId, String type) async {
    try {
      final response = await _supabaseService.client
          .from(_calamityTableName)
          .select()
          .eq('user_id', userId)
          .eq('type', type)
          .order('date', ascending: false);

      return (response as List)
          .map((r) => CalamityReport.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch calamity reports: $e');
    }
  }

  // ============ Production Reports ============

  /// Get all production reports for a user
  Future<List<ProductionReport>> getAllProductionReports(String userId) async {
    try {
      final response = await _supabaseService.client
          .from(_productionTableName)
          .select()
          .eq('user_id', userId)
          .order('harvest_date', ascending: false);

      return (response as List)
          .map((r) => ProductionReport.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch production reports: $e');
    }
  }

  /// Add a production report
  Future<ProductionReport> addProductionReport(
      ProductionReport report, String userId) async {
    try {
      final data = {
        'id': report.id,
        'user_id': userId,
        'crop_type': report.cropType,
        'area': report.area,
        'planting_date': report.plantingDate.toIso8601String(),
        'harvest_date': report.harvestDate.toIso8601String(),
        'yield': report.yield,
        'yield_unit': report.yieldUnit,
        'quality_rating': report.qualityRating,
        'notes': report.notes,
      };

      final response = await _supabaseService.client
          .from(_productionTableName)
          .insert(data)
          .select()
          .single();

      return ProductionReport.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add production report: $e');
    }
  }

  /// Update a production report
  Future<void> updateProductionReport(
      ProductionReport report, String userId) async {
    try {
      final data = {
        'crop_type': report.cropType,
        'area': report.area,
        'planting_date': report.plantingDate.toIso8601String(),
        'harvest_date': report.harvestDate.toIso8601String(),
        'yield': report.yield,
        'yield_unit': report.yieldUnit,
        'quality_rating': report.qualityRating,
        'notes': report.notes,
      };

      await _supabaseService.client
          .from(_productionTableName)
          .update(data)
          .eq('id', report.id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update production report: $e');
    }
  }

  /// Delete a production report
  Future<void> deleteProductionReport(String reportId, String userId) async {
    try {
      await _supabaseService.client
          .from(_productionTableName)
          .delete()
          .eq('id', reportId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete production report: $e');
    }
  }

  /// Get production reports by crop type
  Future<List<ProductionReport>> getProductionReportsByCropType(
      String userId, String cropType) async {
    try {
      final response = await _supabaseService.client
          .from(_productionTableName)
          .select()
          .eq('user_id', userId)
          .eq('crop_type', cropType)
          .order('harvest_date', ascending: false);

      return (response as List)
          .map((r) => ProductionReport.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch production reports: $e');
    }
  }
}
