import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../app_url.dart'; 

class UpdateProfileScreen extends StatefulWidget {
  final UserModel user; 

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController emailCtrl;
  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController mobileCtrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    emailCtrl = TextEditingController(text: widget.user.email);
    firstNameCtrl = TextEditingController(text: widget.user.firstName);
    lastNameCtrl = TextEditingController(text: widget.user.lastName);
    mobileCtrl = TextEditingController(text: widget.user.mobile);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    mobileCtrl.dispose();
    super.dispose();
  }

  Widget _input(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => loading = true);

    final Map<String, dynamic> body = {
      'id': widget.user.id,
      'email': emailCtrl.text,
      'firstName': firstNameCtrl.text,
      'lastName': lastNameCtrl.text,
      'mobile': mobileCtrl.text,
    };

    try {
      final response = await http.post(
        Uri.parse(AppUrl.profileUpdate),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true); // return true to reload user data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _button() => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF27AE60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: loading ? null : _updateProfile,
      child: loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Update Profile'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF27AE60),
        title: const Text('Update Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _input('Email', emailCtrl),
              const SizedBox(height: 16),
              _input('First Name', firstNameCtrl),
              const SizedBox(height: 16),
              _input('Last Name', lastNameCtrl),
              const SizedBox(height: 16),
              _input('Mobile', mobileCtrl),
              const SizedBox(height: 30),
              _button(),
            ],
          ),
        ),
      ),
    );
  }
}
