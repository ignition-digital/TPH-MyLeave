import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tph_myleave/features/dashboard/admin_dashboard.dart';
import 'package:tph_myleave/features/dashboard/employee_dashboard.dart';
import 'package:tph_myleave/features/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String role = "employee";
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 10),

            // Password
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // Role dropdown
            DropdownButton<String>(
              value: role,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "employee", child: Text("Employee")),
                DropdownMenuItem(value: "admin", child: Text("Admin")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            // Button / Loader
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: loginUser,
                    child: const Text("Login"),
                  ),

            const SizedBox(height: 10),

            // Go to register
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Register Employee"),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FIXED LOGIN FUNCTION
  void loginUser() async {
    setState(() => isLoading = true);

    try {
      // 1️⃣ Login with Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user == null) {
        throw "Invalid email or password!";
      }

      final userId = response.user!.id;

      // 2️⃣ Get user info from database
      final data = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) {
        throw "User data not found!";
      }

      // 3️⃣ Check role
      if (data['role'] != role) {
        throw "Role mismatch! Please select correct role.";
      }

      print("✅ Login success");

      // 4️⃣ Navigate based on role
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeDashboard()),
        );
      }
    } catch (e) {
      print("❌ Login error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      // ✅ Always stop loading
      setState(() => isLoading = false);
    }
  }
}