import 'package:flutter/material.dart';
import 'notification_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController = TextEditingController();
  DateTime? dob;
  String? gender;
  bool agree = false;

  bool get valid =>
      nameController.text.isNotEmpty &&
      dob != null &&
      gender != null &&
      agree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            ListTile(
              title: Text(
                dob == null
                    ? 'Date of birth'
                    : dob!.toLocal().toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => dob = picked);
                }
              },
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: ['Male', 'Female', 'Other']
                  .map((g) => ChoiceChip(
                        label: Text(g),
                        selected: gender == g,
                        onSelected: (_) => setState(() => gender = g),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            CheckboxListTile(
              value: agree,
              onChanged: (v) => setState(() => agree = v!),
              title: const Text(
                'I agree to Terms of Use & Privacy Policy',
                style: TextStyle(fontSize: 13),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: valid
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
