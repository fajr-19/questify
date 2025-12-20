import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiService {
  // Emulator: 10.0.2.2 | Real device: IP laptop
  static const String baseUrl = 'https://questify-backend.up.railway.app';

  // ================= LOGIN =================
  static Future<void> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await StorageService.saveToken(data['token']);
    } else {
      throw Exception(res.body);
    }
  }

  // ================= REGISTER =================
  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      await StorageService.saveToken(data['token']);
    } else {
      throw Exception(res.body);
    }
  }

  static Future<void> verifyOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    if (res.statusCode != 200) throw Exception(res.body);
  }

  // ================= GOOGLE LOGIN =================
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  static Future<bool> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      print('ACCESS TOKEN: ${googleAuth.accessToken}');
      print('ID TOKEN: ${googleAuth.idToken}');

      final idToken = googleAuth.idToken;

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
