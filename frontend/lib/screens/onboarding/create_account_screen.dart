import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'choose_artist_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final DateTime dob;
  final String gender;

  const CreateAccountScreen({
    super.key,
    required this.dob,
    required this.gender,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController = TextEditingController();
  bool agree = false;
  bool isSaving = false;

  // Fungsi untuk memproses pendaftaran ke backend
  Future<void> _handleCreateAccount() async {
    setState(() => isSaving = true);

    // Menyiapkan data payload untuk dikirim ke API
    final payload = {
      "full_name": nameController.text,
      "date_of_birth": widget.dob.toIso8601String(),
      "gender": widget.gender,
      "terms_accepted": agree,
    };

    // Memanggil ApiService untuk simpan data profil
    final success = await ApiService.updateOnboardingData(payload);

    if (!mounted) return;
    setState(() => isSaving = false);

    if (success) {
      // Jika berhasil, lanjut ke pemilihan artis
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChooseArtistScreen()),
      );
    } else {
      // Jika gagal (misal koneksi mati), tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat akun. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Siapa namamu?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Masukkan nama sesuai identitas',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Preview data dari screen sebelumnya (opsional, biar keren)
            Text(
              "Info Profil: ${widget.gender}, Lahir: ${widget.dob.day}/${widget.dob.month}/${widget.dob.year}",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            const Spacer(),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: agree,
              onChanged: (v) => setState(() => agree = v!),
              title: const Text(
                'Saya setuju dengan Syarat Ketentuan & Kebijakan Privasi Questify.',
                style: TextStyle(fontSize: 13),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // Tombol aktif hanya jika nama diisi, checkbox dicentang, dan tidak sedang loading
                onPressed:
                    (nameController.text.isNotEmpty && agree && !isSaving)
                    ? _handleCreateAccount
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
