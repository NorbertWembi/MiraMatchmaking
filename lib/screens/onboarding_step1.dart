import 'package:flutter/material.dart';
import '../theme.dart';
import 'onboarding_step2.dart';

class OnboardingStep1 extends StatefulWidget {
  const OnboardingStep1({super.key, this.appTitle = 'Miira'});
  final String appTitle;

  @override
  State<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends State<OnboardingStep1> {
  final _username = TextEditingController();
  final _age = TextEditingController();
  String? _gender;

  bool get _valid {
    final u = _username.text.trim().isNotEmpty;
    final a = int.tryParse(_age.text) != null && int.parse(_age.text) > 0;
    final g = _gender != null;
    return u && a && g;
  }

  @override
  void initState() {
    super.initState();
    _username.addListener(() => setState(() {}));
    _age.addListener(() => setState(() {}));
  }

  AppBar _appBar() => AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: kBrandRed),
        const SizedBox(width: 6),
        Text(widget.appTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // progress + step label
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: 0.33,
                        minHeight: 6,
                        color: kBrandRed,
                        backgroundColor: const Color(0xFF1F2937), // dark gray bar
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Step 1/2', style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 18),

              const Text("Let's get started",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Tell us about yourself',
                  style: TextStyle(color: kMuted, fontSize: 16)),
              const SizedBox(height: 22),

              const Text('Username', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              TextField(controller: _username, decoration: fieldDeco('Enter your username')),
              const SizedBox(height: 18),

              const Text('Age', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),
              TextField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: fieldDeco('Enter your age'),
              ),
              const SizedBox(height: 18),

              const Text('Gender', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 6),

              ...['Male', 'Female', 'Other'].map(
                    (g) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorder),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: RadioListTile<String>(
                      value: g,
                      groupValue: _gender,
                      onChanged: (v) => setState(() => _gender = v),
                      title: Text(g, style: const TextStyle(fontSize: 18)),
                      activeColor: kBrandRed,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),
                ),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _valid
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OnboardingStep2(
              appTitle: widget.appTitle,
              username: _username.text.trim(),
              age: int.parse(_age.text),
              gender: _gender!,
            ),
          ),
        );
      }
    : null,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
