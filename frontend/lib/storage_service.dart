import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'jwt_token';
  static const String _onboardingKey = 'onboarding_done';

  /// Menyimpan JWT Token setelah login berhasil
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Mengambil JWT Token untuk keperluan Authorization Header di API
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Menghapus Token (digunakan saat logout)
  /// Note: Menggunakan remove() lebih aman daripada clear() agar status onboarding tidak hilang
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Menandai bahwa user sudah menyelesaikan alur onboarding
  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  /// Mengecek apakah user perlu masuk ke layar onboarding atau langsung ke Home
  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  /// Menghapus semua data (digunakan jika ingin reset total aplikasi)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
