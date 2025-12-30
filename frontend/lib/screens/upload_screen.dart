import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  File? _selectedFile;
  String _selectedType = 'music';
  bool _isUploading = false;

  // DATA CLOUDINARY (Ganti dengan milikmu)
  final String cloudName = "dqq1z4xlo"; 
  final String uploadPreset = "questify_preset"; 

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: _selectedType == 'video' ? FileType.video : FileType.audio,
    );
    if (result != null) setState(() => _selectedFile = File(result.files.single.path!));
  }

  Future<void> _uploadContent() async {
    if (_selectedFile == null || _titleController.text.isEmpty) return;
    setState(() => _isUploading = true);

    try {
      // --- LANGKAH 1: UPLOAD KE CLOUDINARY ---
      var cloudinaryUri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');
      var cloudRequest = http.MultipartRequest('POST', cloudinaryUri);
      
      cloudRequest.fields['upload_preset'] = uploadPreset;
      cloudRequest.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      var cloudResponse = await cloudRequest.send();
      var cloudResponseBody = await http.Response.fromStream(cloudResponse);
      var cloudData = jsonDecode(cloudResponseBody.body);

      if (cloudResponse.statusCode != 200) throw Exception("Gagal upload ke Cloudinary");
      String secureUrl = cloudData['secure_url'];

      // --- LANGKAH 2: SIMPAN METADATA KE KOYEB ---
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var koyebUri = Uri.parse('https://comparative-rheta-questifyapp-08414160.koyeb.app/recommendations/upload');

      var response = await http.post(
        koyebUri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': _titleController.text,
          'artist': _artistController.text,
          'type': _selectedType,
          'audioUrl': secureUrl, // Kirim URL saja
          'lyrics': jsonEncode([]),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Publikasi!")));
          Navigator.pop(context);
        }
      } else {
        throw Exception("Gagal simpan ke database");
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Upload ke Questify", style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Judul", hintStyle: TextStyle(color: Colors.white24))),
            const SizedBox(height: 15),
            TextField(controller: _artistController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Artis", hintStyle: TextStyle(color: Colors.white24))),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _pickFile, child: Text(_selectedFile == null ? "Pilih File" : "File Siap")),
            const SizedBox(height: 50),
            _isUploading 
              ? const CircularProgressIndicator(color: Colors.purple) 
              : ElevatedButton(onPressed: _uploadContent, child: const Text("PUBLIKASIKAN")),
          ],
        ),
      ),
    );
  }
}