import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'screens/models/music_item.dart';

class ApiService {
  static const baseUrl = 'https://questify-backend.up.railway.app';

  static final googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '699171401038-tfit4h97i9sfs4vismq2rnrcabpla6l2.apps.googleusercontent.com',
  );

  // AUTH: Login dengan pengecekan User Baru
  static Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      final user = await googleSignIn.signIn();
      if (user == null) return null;

      final auth = await user.authentication;
      final res = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': auth.idToken}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await StorageService.saveToken(data['token']);
        // Mengembalikan data lengkap (token & isNewUser)
        return data;
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // ONBOARDING: Simpan data pilihan user (PENTING UNTUK ML)
  static Future<bool> updateOnboardingData(Map<String, dynamic> payload) async {
    try {
      final token = await StorageService.getToken();
      final res = await http.put(
        // Gunakan PUT atau POST sesuai backend
        Uri.parse('$baseUrl/user/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // REKOMENDASI ML
  static Future<List<MusicItem>> fetchMLRecommendations() async {
    try {
      final token = await StorageService.getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/recommendations/ml'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => MusicItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<MusicItem>> fetchPopularArtists() async {
    try {
      final token = await StorageService.getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/artists'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => MusicItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final token = await StorageService.getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res.statusCode == 200 ? jsonDecode(res.body) : {'name': 'User'};
    } catch (_) {
      return {'name': 'Guest'};
    }
  }

  static Future<void> logout() async {
    await googleSignIn.signOut();
    await StorageService.deleteToken();
  }
}
