import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../features/matches/widgets/rounded_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false;

  bool _isLoading = false;
  String _message = "";

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });

    const String apiUrl = "http://10.0.2.2:5050/api/users/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() => _message = "Login successful!");
        Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/navbar');
        });
      } else {
        setState(
          () => _message = data['message'] ?? data['error'] ?? 'Login failed',
        );
      }
    } catch (e) {
      setState(() => _message = "Error connecting to server");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buildLabeledField(
  String label,
  TextEditingController controller, {
  bool obscure = false,
  bool passwordToggle = false,
  bool visible = false,
  VoidCallback? onToggle,
  String? hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        obscureText: obscure && !visible,
        decoration: roundedField(hint ?? label).copyWith(
          suffixIcon: passwordToggle
              ? IconButton(
                  icon: Icon(
                    visible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF7C7C), Color(0xFFFFB199)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: 240,
                        height: 240,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    buildLabeledField(
                      "Email",
                      emailController,
                      hint: "Enter your email",
                    ),
                    const SizedBox(height: 14),

                    buildLabeledField(
                      "Password",
                      passwordController,
                      obscure: true,
                      passwordToggle: true,
                      visible: _passwordVisible,
                      onToggle: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      hint: "Enter your password",
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("LOGIN"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_message.isNotEmpty)
                      Center(
                        child: Text(
                          _message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
