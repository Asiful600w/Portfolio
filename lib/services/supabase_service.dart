import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../models/project_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch only the first profile found (as it's a portfolio)
  Future<ProfileModel?> getProfile() async {
    try {
      final response =
          await _client.from('profiles').select().limit(1).maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      // Return null or handle error as per requirement
      // For now we just return null so UI can fallback
      return null;
    }
  }

  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await _client
          .from('projects')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
