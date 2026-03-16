import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passToggle = true;
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                  child: Image.asset('assets/images/tph.png'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter Valid Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    // Simple email regex
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => _email = text),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: TextFormField(
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => _password = text),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 18.0),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                width: 350.0,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Email and password used here
                      print('Email: $_email');
                      print('Password: $_password');
                      print('Form submitted');
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Example navigation to RegisterPage
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'New User? Create Account',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}