import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  late SupabaseClient _client;

  SupabaseClient get client => _client;

  /// Initialize Supabase with your credentials
  /// Get these from your Supabase project settings
  Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      print('Supabase initialized successfully');
    } catch (e) {
      print('Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  // Auth Methods
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  // Generic database methods
  Future<List<Map<String, dynamic>>> getRecords(
    String table, {
    Map<String, dynamic>? filters,
  }) async {
    var query = _client.from(table).select();

    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    return await query;
  }

  Future<Map<String, dynamic>> insertRecord(
    String table,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.from(table).insert(data).select().single();
    return response as Map<String, dynamic>;
  }

  Future<void> updateRecord(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _client.from(table).update(data).eq('id', id);
  }

  Future<void> deleteRecord(String table, String id) async {
    await _client.from(table).delete().eq('id', id);
  }
}
