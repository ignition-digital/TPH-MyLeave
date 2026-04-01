import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  List<Map<String, dynamic>> companyList = [];
  String? selectedCompany;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  // 1️⃣ Fetch company list from DB (Supabase Flutter latest)
  Future<void> fetchCompanies() async {
  setState(() => isLoading = true);

  try {
    final data = await supabase.from('company').select('company_id, companyName');

    // convert data to List<Map<String, dynamic>>
    companyList = List<Map<String, dynamic>>.from(data as List);

    setState(() => isLoading = false);
  } catch (e) {
    print("Error fetching companies: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to load companies: $e")),
    );
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Employee")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedCompany,
                      hint: const Text("Select Company"),
                      isExpanded: true,
                      items: companyList.map((c) {
                        return DropdownMenuItem<String>(
                          value: c["company_id"].toString(),
                          child: Text(c["companyName"]),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCompany = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerEmployee,
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // 2️⃣ Register function
  Future<void> registerEmployee() async {
    if (selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a company")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Sign up via Supabase Auth
      final response = await supabase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user == null) {
        throw "Register failed!";
      }

      final userId = response.user!.id;

      // Insert extra data to 'users' table
      final insertResponse = await supabase.from('users').insert({
        'id': userId,
        'name': nameController.text,
        'email': emailController.text,
        'role': 'employee',
        'staff_type': 'permanent',
        'company_id': int.parse(selectedCompany!),
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register successful!")),
      );

      // Navigate back to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print("Register error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}