import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController addressC = TextEditingController();

  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submission Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v!.contains('@') ? null : 'Invalid email',
                ),
                TextFormField(
                  controller: phoneC,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (v) => v!.length < 10 ? 'Invalid number' : null,
                ),
                TextFormField(
                  controller: addressC,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 20),
                const Text("Gender"),
                DropdownButton<String>(
                  value: gender,
                  items: ['Male', 'Female', 'Other']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => gender = v!),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await SupabaseService.insertSubmission({
                        'name': nameC.text,
                        'email': emailC.text,
                        'phone': phoneC.text,
                        'address': addressC.text,
                        'gender': gender,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Submitted Successfully!')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/list'),
                  child: const Text("View Submissions →"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
