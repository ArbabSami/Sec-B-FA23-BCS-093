import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  bool _loading = true;
  String? _email;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = _auth.currentUser();
    setState(() {
      _email = user?.email;
      _userId = user?.id;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Logged in user info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Email: ${_email ?? "N/A"}'),
                  SizedBox(height: 8),
                  Text('User ID: ${_userId ?? "N/A"}'),
                  SizedBox(height: 20),
                  Text('Take screenshots: Registration, Login, Home, Email Confirmation, Supabase Auth table.'),
                ],
              ),
      ),
    );
  }
}
