import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_url.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(AppUrl.registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "mobile": mobileController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showMsg("Registration successful ");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        _showMsg(data["message"] ?? "Registration failed ");
      }
    } catch (e) {
      _showMsg("Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Join With Us",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                _input(
                  controller: emailController,
                  hint: "Email",
                  validator: (v) {
                    if (v!.isEmpty) return "Email required";
                    if (!v.contains("@")) return "Invalid email";
                    return null;
                  },
                ),
                _input(
                  controller: firstNameController,
                  hint: "First Name",
                  validator: (v) => v!.isEmpty ? "First name required" : null,
                ),
                _input(
                  controller: lastNameController,
                  hint: "Last Name",
                  validator: (v) => v!.isEmpty ? "Last name required" : null,
                ),
                _input(
                  controller: mobileController,
                  hint: "Mobile",
                  validator: (v) =>
                      v!.length < 10 ? "Invalid mobile number" : null,
                ),
                _input(
                  controller: passwordController,
                  hint: "Password",
                  isPassword: true,
                  validator: (v) =>
                      v!.length < 6 ? "Minimum 6 characters" : null,
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signUp,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
