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

  // ================= AUTH =================
  static Future<bool> loginWithGoogle() async {
    try {
      final user = await googleSignIn.signIn();
      if (user == null) return false;

      final auth = await user.authentication;
      final res = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': auth.idToken}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await StorageService.saveToken(data['token']);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    await googleSignIn.signOut();
    await StorageService.deleteToken();
  }

  // ================= HOME DATA =================
  static Future<List<MusicItem>> fetchHome(String filter) async {
    final token = await StorageService.getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/recommendations?filter=$filter'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) return [];

    final List data = jsonDecode(res.body);
    return data.map((e) => MusicItem.fromJson(e)).toList();
  }

  // ================= PROFILE =================
  static Future<Map<String, dynamic>> fetchProfile() async {
    final token = await StorageService.getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }
}
