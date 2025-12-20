import 'package:flutter/material.dart';
import '../api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Questify',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: emailC,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _handleLogin,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 12),

                // GOOGLE LOGIN
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => loading = true);
                    final ok = await ApiService.loginWithGoogle();
                    setState(() => loading = false);

                    if (ok && mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      _snack('Google login failed');
                    }
                  },
                  icon: Image.asset('assets/icons/google.png', height: 20),
                  label: const Text('Continue with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGIN HANDLER =================
  Future<void> _handleLogin() async {
    setState(() => loading = true);
    try {
      await ApiService.login(emailC.text.trim(), passC.text.trim());

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      final msg = e.toString().replaceAll('Exception:', '').trim();

      // 👉 AUTO ARAHKAN KE OTP JIKA BELUM VERIFIED
      if (msg.contains('not verified')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(email: emailC.text.trim()),
          ),
        );
      } else {
        _snack(msg);
      }
    } finally {
      setState(() => loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
