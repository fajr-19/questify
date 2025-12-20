import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiService {
  static const String baseUrl = 'https://questify-backend.up.railway.app';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // ================= GOOGLE LOGIN ONLY =================
  static Future<bool> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) return false;

      final res = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await StorageService.saveToken(data['token']);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
