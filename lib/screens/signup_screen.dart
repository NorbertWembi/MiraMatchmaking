import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../features/matches/widgets/location_search_field.dart';
import '../features/matches/widgets/rounded_field.dart';

Future<String?> getAddressFromCoords(double lat, double lng) async {
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']; // replace later with .env

  final url =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data["results"].isNotEmpty) {
      return data["results"][0]["formatted_address"];
    }
  }
  return null;
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  double? selectedLat;
  double? selectedLng;
  String? selectedAddress;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  bool _isLoading = false;
  String _message = '';

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    const String apiUrl = "http://10.0.2.2:5050/api/users/register";

    try {
      String? address;

      if (selectedLat != null && selectedLng != null) {
        address = await getAddressFromCoords(selectedLat!, selectedLng!);
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
          'location': {
            'lat': selectedLat,
            'lng': selectedLng,
            'address': address, // New field
          },
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setState(() => _message = "${data['message']}");
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/onboarding1');
        });
      } else {
        setState(
          () => _message =
              "${data['message'] ?? data['error'] ?? 'Signup failed'}",
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
                        'assets/logo.png',
                        width: 240,
                        height: 240,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        "Create your Miira account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    buildLabeledField(
                      "Full Name",
                      nameController,
                      hint: "Enter your full name",
                    ),
                    const SizedBox(height: 14),

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
                    const SizedBox(height: 14),

                    buildLabeledField(
                      "Confirm Password",
                      confirmPasswordController,
                      obscure: true,
                      passwordToggle: true,
                      visible: _confirmPasswordVisible,
                      onToggle: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      hint: "Re-enter your password",
                    ),
                    const SizedBox(height: 24),
                    SizedBox(height: 20),

                    Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),

                    LocationSearchField(
                      onLocationSelected: (lat, lng, address) {
                        setState(() {
                          selectedLat = lat;
                          selectedLng = lng;
                          selectedAddress = address;
                        });
                      },
                    ),

                    SizedBox(height: 12),

                    if (selectedAddress != null)
                      Text(
                        "Selected: $selectedAddress",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),

                    const SizedBox(height: 24),

                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : registerUser,
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
                            : const Text("SIGN UP"),
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
