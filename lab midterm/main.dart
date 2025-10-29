import 'dart:io';
import 'new_patient_screen.dart';
import 'search_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'all_patients_screen.dart';
import 'package:intl/intl.dart';

// ✅ Global list for patients
List<Map<String, dynamic>> patients = [];

// ✅ In-memory user accounts
List<Map<String, String>> users = [
  {'username': 'admin', 'password': '12345'},
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool isLoggedIn = false;
  String? currentUser; // store current logged in username

  // NEW: track whether user pressed "Get Started"
  bool hasStarted = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  // Login with username
  void loginUser(String username) {
    setState(() {
      isLoggedIn = true;
      currentUser = username;
    });
  }

  // Logout
  void logoutUser() {
    setState(() {
      isLoggedIn = false;
      currentUser = null;
    });
  }

  // Update current username after editing account
  void updateCurrentUser(String newUsername) {
    setState(() {
      currentUser = newUsername;
    });
  }

  // NEW: called when Get Started pressed
  void startApp() {
    setState(() {
      hasStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistant-Dr',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      // SHOW GetStartedScreen first (if not started), then Login or Home.
      home: !hasStarted
          ? GetStartedScreen(onStart: startApp)
          : isLoggedIn
          ? HomeScreen(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
        onLogout: logoutUser,
        currentUsername: currentUser ?? '',
        onAccountUpdated: updateCurrentUser,
      )
          : LoginScreen(onLogin: loginUser),
    );
  }
}

// ===================== GET STARTED SCREEN (NEW) =====================
class GetStartedScreen extends StatelessWidget {
  final VoidCallback onStart;
  const GetStartedScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/logo.png', height: 100),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Assistant-Dr",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Manage patients quickly and easily.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: onStart,
                  child: const Text(
                    'Already have an account? Continue to Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== LOGIN SCREEN =====================
class LoginScreen extends StatefulWidget {
  final Function(String) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  void _handleLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    final user = users.firstWhere(
          (u) =>
      u['username']!.toLowerCase() == username.toLowerCase() &&
          u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      widget.onLogin(user['username']!); // pass normalized username from users list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/logo.png', height: 100),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // <-- CHANGED: use push so LoginScreen remains in stack and its callback can be used after signup
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SignupScreen(onSignupComplete: (username) {
                                // after signup we take the created username and login
                                widget.onLogin(username);
                              })),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== FORGOT PASSWORD =====================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool obscurePassword = true;

  void _resetPassword() {
    final username = usernameController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (username.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final userIndex = users.indexWhere(
            (u) => u['username']!.toLowerCase() == username.toLowerCase());

    if (userIndex != -1) {
      users[userIndex]['password'] = newPassword;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username not found!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter new password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== SIGNUP SCREEN =====================
class SignupScreen extends StatefulWidget {
  final Function(String) onSignupComplete;
  const SignupScreen({super.key, required this.onSignupComplete});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool registerAsPatient = false;
  String gender = 'Unknown'; // New: default gender field for patient creation

  void _handleSignup() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    final exists = users.any(
            (user) => user['username']!.toLowerCase() == username.toLowerCase());

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account already exists!')),
      );
      return;
    }

    users.add({'username': username, 'password': password});

    if (registerAsPatient) {
      patients.add({
        'fullName': username,
        'phone': '',
        'profileImage': null,
        'gender': gender,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully! Logging in...')),
    );

    // Immediately login the new user by returning the username via callback
    widget.onSignupComplete(username);

    // After calling the callback, pop back so the app root (MyApp) can rebuild to Home
    // (LoginScreen was left in stack because we used Navigator.push to open Signup).
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: registerAsPatient,
                  onChanged: (val) {
                    setState(() {
                      registerAsPatient = val ?? false;
                    });
                  },
                  title: const Text(
                    'Register as patient (create patient record)',
                    style: TextStyle(color: Colors.white),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.white,
                  checkColor: Colors.blueAccent,
                ),
                // New: gender selection for the patient record (only visible if registering as patient)
                if (registerAsPatient)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Patient Gender (for record):',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'Male',
                              groupValue: gender,
                              title: const Text('Male', style: TextStyle(color: Colors.white)),
                              onChanged: (val) {
                                setState(() {
                                  gender = val ?? 'Unknown';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'Female',
                              groupValue: gender,
                              title: const Text('Female', style: TextStyle(color: Colors.white)),
                              onChanged: (val) {
                                setState(() {
                                  gender = val ?? 'Unknown';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: 'Unknown',
                              groupValue: gender,
                              title: const Text('Unknown', style: TextStyle(color: Colors.white)),
                              onChanged: (val) {
                                setState(() {
                                  gender = val ?? 'Unknown';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 13),
                ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // <-- CHANGED: simply return to the existing login screen (pop)
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== HOME SCREEN =====================
class HomeScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  final VoidCallback onLogout;
  final String currentUsername;
  final Function(String) onAccountUpdated;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.onLogout,
    required this.currentUsername,
    required this.onAccountUpdated,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  String _getDateString() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, MMMM d, y');
    return 'Today is ${formatter.format(now)}';
  }

  // NEW: compute recent patients (by createdAt if available)
  List<Map<String, dynamic>> _getRecentPatients({int limit = 5}) {
    List<Map<String, dynamic>> copy = List.from(patients);
    // If createdAt exists, parse and sort; else fall back to original order (most recent at end)
    copy.sort((a, b) {
      try {
        final aTime = a['createdAt'] != null ? DateTime.parse(a['createdAt']) : null;
        final bTime = b['createdAt'] != null ? DateTime.parse(b['createdAt']) : null;
        if (aTime != null && bTime != null) return bTime.compareTo(aTime);
        if (aTime != null) return -1;
        if (bTime != null) return 1;
      } catch (e) {
        // ignore parse errors
      }
      // fallback: newer items likely at end -> reverse order
      return copy.indexOf(b).compareTo(copy.indexOf(a));
    });
    if (copy.length > limit) return copy.sublist(0, limit);
    return copy;
  }

  // NEW: compute male/female percentages
  Map<String, dynamic> _getGenderStats() {
    int male = 0;
    int female = 0;
    int unknown = 0;

    for (var p in patients) {
      final g = (p['gender'] ?? '').toString().toLowerCase();
      if (g == 'male') male++;
      else if (g == 'female') female++;
      else unknown++;
    }

    final total = male + female + unknown;
    double malePct = 0;
    double femalePct = 0;
    if (total > 0) {
      malePct = (male / total) * 100;
      femalePct = (female / total) * 100;
    }
    return {
      'male': male,
      'female': female,
      'unknown': unknown,
      'malePct': malePct,
      'femalePct': femalePct,
      'total': total,
    };
  }

  @override
  Widget build(BuildContext context) {
    final recent = _getRecentPatients();
    final stats = _getGenderStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant-Dr'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    toggleTheme: toggleTheme,
                    isDarkMode: isDarkMode,
                    onLogout: onLogout,
                    currentUsername: currentUsername,
                    onAccountUpdated: onAccountUpdated,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // NEW: Floating plus button to add new patient
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => NewPatientScreen()));
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Patient',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getGreeting(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(_getDateString(),
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 12),
                  Text('Logged in as: $currentUsername',
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Today's Overview",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  const Icon(Icons.people, color: Colors.green, size: 45),
                  Text('${patients.length}',
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  const Text('Total Patients',
                      style: TextStyle(fontSize: 16, color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Gender percentage card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender Distribution',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Male', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('${stats['male']}'),
                            const SizedBox(height: 6),
                            Text('${stats['malePct'].toStringAsFixed(1)}%'),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (stats['malePct'] as double) / 100,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('Female', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('${stats['female']}'),
                            const SizedBox(height: 6),
                            Text('${stats['femalePct'].toStringAsFixed(1)}%'),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (stats['femalePct'] as double) / 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Total counted: ${stats['total']}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionCard(context,
                    icon: Icons.person_add,
                    color: Colors.green[100]!,
                    label: 'New Patient',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => NewPatientScreen()))),
                _buildActionCard(context,
                    icon: Icons.search,
                    color: Colors.blue[100]!,
                    label: 'Search',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SearchScreen()))),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: _buildActionCard(context,
                  icon: Icons.people_alt,
                  color: Colors.orange[100]!,
                  label: 'All Patients',
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AllPatientsScreen()))),
            ),
            const SizedBox(height: 20),
            // Recent Patients section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Patients',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (recent.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('No recent patients')),
                    )
                  else
                    Column(
                      children: recent.map((p) {
                        final created = p['createdAt'];
                        String displayDate = '';
                        if (created != null) {
                          try {
                            final dt = DateTime.parse(created);
                            displayDate = DateFormat('MMM d, y • hh:mm a').format(dt);
                          } catch (e) {
                            displayDate = created.toString();
                          }
                        }
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: p['profileImage'] != null
                                ? (p['profileImage'] is String
                                ? (File(p['profileImage']).existsSync()
                                ? FileImage(File(p['profileImage'])) as ImageProvider
                                : const AssetImage('assets/avatar.png'))
                                : const AssetImage('assets/avatar.png'))
                                : const AssetImage('assets/avatar.png'),
                          ),
                          title: Text(p['fullName'] ?? 'Unknown'),
                          subtitle: Text(
                              '${p['phone'] ?? ''}${displayDate.isNotEmpty ? ' • $displayDate' : ''}'),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
        required Color color,
        required String label,
        required VoidCallback onTap,
        double? width}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? (MediaQuery.of(context).size.width - 64) / 2,
        padding: const EdgeInsets.all(16),
        decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon,
                    color: color == Colors.green[100]
                        ? Colors.green
                        : color == Colors.blue[100]
                        ? Colors.blue
                        : Colors.orange)),
            const SizedBox(height: 8),
            Text(label,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ===================== SETTINGS SCREEN =====================
class SettingsScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  final VoidCallback onLogout;
  final String currentUsername;
  final Function(String) onAccountUpdated;

  const SettingsScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.onLogout,
    required this.currentUsername,
    required this.onAccountUpdated,
  });

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export data feature coming soon!')),
    );
  }

  void _importFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import file feature coming soon!')),
    );
  }

  void _clearAllData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clear all data feature coming soon!')),
    );
  }

  void _openAccountEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountScreen(
          currentUsername: currentUsername,
          onAccountUpdated: onAccountUpdated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.blueAccent,
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Appearance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode, color: Colors.blueGrey),
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              value: isDarkMode,
              onChanged: toggleTheme,
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Data Management",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.blue),
              title: const Text('Export Data'),
              onTap: () => _exportData(context),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Import File'),
              onTap: () => _importFile(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Clear All Data'),
              onTap: () => _clearAllData(context),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // --- NEW: App version and Designed by entries ---
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('App Version'),
              subtitle: const Text('v1.0.0'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App version: v1.0.0')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Designed By'),
              subtitle: const Text('Rajesh Kumar'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Designed by Rajesh Kumar')),
                );
              },
            ),
            // --- END NEW ENTRIES ---
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Account'),
              subtitle: Text('Signed in as: $currentUsername'),
              onTap: () => _openAccountEditor(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                onLogout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ));
  }
}

// ===================== ACCOUNT EDIT SCREEN (NEW) =====================
class AccountScreen extends StatefulWidget {
  final String currentUsername;
  final Function(String) onAccountUpdated;

  const AccountScreen({
    super.key,
    required this.currentUsername,
    required this.onAccountUpdated,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final currentPasswordController = TextEditingController();
  final newUsernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool obscureCurrent = true;
  bool obscureNew = true;

  void _updateAccount() {
    final currentUsername = widget.currentUsername;
    final currentPassword = currentPasswordController.text.trim();
    final newUsername = newUsernameController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (currentPassword.isEmpty || (newUsername.isEmpty && newPassword.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide current password and new details to update.')),
      );
      return;
    }

    final userIndex = users.indexWhere(
            (u) => u['username']!.toLowerCase() == currentUsername.toLowerCase());

    if (userIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current user not found.')),
      );
      return;
    }

    // verify current password
    if (users[userIndex]['password'] != currentPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current password is incorrect.')),
      );
      return;
    }

    // If changing username, ensure uniqueness
    if (newUsername.isNotEmpty) {
      final exists = users.any((u) =>
      u['username']!.toLowerCase() == newUsername.toLowerCase() &&
          u['username']!.toLowerCase() != currentUsername.toLowerCase());
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already taken. Please choose another.')),
        );
        return;
      }
    }

    // perform updates
    if (newUsername.isNotEmpty) {
      // update users list
      users[userIndex]['username'] = newUsername;

      // update patient records created with this username
      for (var p in patients) {
        if ((p['fullName'] ?? '').toString().toLowerCase() ==
            currentUsername.toLowerCase()) {
          p['fullName'] = newUsername;
        }
      }

      // notify parent about username change
      widget.onAccountUpdated(newUsername);
    }

    if (newPassword.isNotEmpty) {
      users[userIndex]['password'] = newPassword;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account updated successfully!')),
    );

    // clear fields
    currentPasswordController.clear();
    newUsernameController.clear();
    newPasswordController.clear();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newUsernameController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text('Signed in as: ${widget.currentUsername}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              TextField(
                controller: currentPasswordController,
                obscureText: obscureCurrent,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter current password (required)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscureCurrent = !obscureCurrent;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newUsernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'New username (leave blank to keep same)',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'New password (leave blank to keep same)',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Update Account', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Notes:\n• You must enter your current password to make changes.\n• Leave fields blank to keep existing values.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
