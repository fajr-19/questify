import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'storage_service.dart';
import 'screens/models/music_item.dart';

class ApiService {
  static const baseUrl = 'https://comparative-rheta-questifyapp-08414160.koyeb.app';

  static final googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '699171401038-tfit4h97i9sfs4vismq2rnrcabpla6l2.apps.googleusercontent.com',
  );

  // --- 1. AUTHENTICATION & ONBOARDING ---

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
        return data;
      }
      return null;
    } catch (e) {
      debugPrint("Login Error: $e");
      return null;
    }
  }

  static Future<bool> updateOnboardingData(Map<String, dynamic> payload) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return false;

      final res = await http.post(
        Uri.parse('$baseUrl/user/onboarding'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      debugPrint("Update Onboarding Error: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      await googleSignIn.signOut();
    } catch (_) {}
    await StorageService.deleteToken();
  }

  // --- 2. MUSIC & RECOMMENDATIONS ---

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
      debugPrint("ML Fetch Error: $e");
      return [];
    }
  }

  static Future<List<MusicItem>> fetchPopularArtists() async {
    try {
      final token = await StorageService.getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/recommendations/popular'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => MusicItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Popular Artists Fetch Error: $e");
      return [];
    }
  }

  static Future<void> cacheYoutubeId(String musicId, String ytId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return;

      final res = await http.post(
        Uri.parse('$baseUrl/recommendations/cache-youtube'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'musicId': musicId, 'youtubeId': ytId}),
      );
      if (res.statusCode == 200) {
        debugPrint("✅ YouTube ID Cached: $ytId");
      }
    } catch (e) {
      debugPrint("❌ Cache YouTube Error: $e");
    }
  }

  // --- 3. USER DATA & GAMIFICATION ---

  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return {};
      final res = await http.get(
        Uri.parse('$baseUrl/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res.statusCode == 200 ? jsonDecode(res.body) : {};
    } catch (e) {
      debugPrint("Fetch Profile Error: $e");
      return {};
    }
  }

  static Future<void> addXP(int amount) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return;

      await http.post(
        Uri.parse('$baseUrl/user/add-xp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'xpAmount': amount}),
      );
    } catch (e) {
      debugPrint("XP Error: $e");
    }
  }
}
