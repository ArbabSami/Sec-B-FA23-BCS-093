import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz 2 – Flutter CRUD (Soft Dark Gray Theme)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1C), // soft dark gray
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00BFA6), // soft teal accent
          secondary: Color(0xFF80CBC4), // lighter mint accent
          surface: Color(0xFF2A2A2A), // medium gray surface
          background: Color(0xFF1C1C1C),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A),
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00BFA6),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class User {
  int id;
  String name;
  String email;
  int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  int nextId = 1;

  void _addOrEditUser({User? existingUser}) {
    final nameController =
        TextEditingController(text: existingUser?.name ?? '');
    final emailController =
        TextEditingController(text: existingUser?.email ?? '');
    final ageController =
        TextEditingController(text: existingUser?.age.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            existingUser == null ? 'Add New User' : 'Edit User',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFA6),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF00BFA6)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF00BFA6)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake, color: Color(0xFF00BFA6)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(existingUser == null ? Icons.add : Icons.update),
              label: Text(existingUser == null ? 'Add' : 'Update'),
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final age = int.tryParse(ageController.text.trim()) ?? 0;

                if (name.isEmpty || email.isEmpty || age <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields correctly!'),
                    ),
                  );
                  return;
                }

                setState(() {
                  if (existingUser == null) {
                    users.add(
                      User(id: nextId++, name: name, email: email, age: age),
                    );
                  } else {
                    existingUser.name = name;
                    existingUser.email = email;
                    existingUser.age = age;
                  }
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int id) {
    setState(() {
      users.removeWhere((u) => u.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz 2 – CRUD (Soft Dark Gray Theme)'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E2E2E), Color(0xFF1C1C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1C), Color(0xFF2E2E2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: users.isEmpty
            ? const Center(
                child: Text(
                  'No users added yet.\nTap the + button to add a new user!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
              )
            : ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF00BFA6),
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF80CBC4),
                        ),
                      ),
                      subtitle: Text(
                        '${user.email}\nAge: ${user.age}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF00BFA6)),
                            onPressed: () => _addOrEditUser(existingUser: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFFF5252)),
                            onPressed: () => _deleteUser(user.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditUser(),
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }
}
