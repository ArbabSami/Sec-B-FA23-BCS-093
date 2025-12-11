import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  final AuthService _auth = AuthService();

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _showSnack(String text, [Color? color]) {
    final snack = SnackBar(content: Text(text), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmCtrl.text) {
      _showSnack('Password and Confirm Password do not match', Colors.red);
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await _auth.signUp(_emailCtrl.text.trim(), _passCtrl.text);
      if (res.error != null) {
        _showSnack('Error: ${res.error?.message}', Colors.red);
      } else {
        _showSnack('Registered successfully. Check your email to confirm (if enabled).', Colors.green);
        await Future.delayed(Duration(milliseconds: 700));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } catch (e) {
      _showSnack('Registration failed: $e', Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Register'),
                  ),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Text('Already have an account? Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
