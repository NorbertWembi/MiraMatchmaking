import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingStep2 extends StatefulWidget {
  const OnboardingStep2({
    super.key,
    required this.appTitle,
    required this.username,
    required this.age,
    required this.gender,
  });

  final String appTitle;
  final String username;
  final int age;
  final String gender;

  @override
  State<OnboardingStep2> createState() => _OnboardingStep2State();
}

class _OnboardingStep2State extends State<OnboardingStep2> {
  final _country = TextEditingController();
  final _city = TextEditingController();
  final _university = TextEditingController();
  final _hobbyInput = TextEditingController();
  final _bio = TextEditingController();
  final int _bioLimit = 150;

  DateTime? _birthday;
  final List<String> _hobbies = [];
  double _distanceKm = 5;

  bool get _valid {
    // Based on your UI: birthday, country, city required. University optional.
    final okBirthday = _birthday != null;
    final okCountry = _country.text.trim().isNotEmpty;
    final okCity = _city.text.trim().isNotEmpty;
    return okBirthday && okCountry && okCity;
  }

  AppBar _appBar() => AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: kBrandRed),
        const SizedBox(width: 6),
        Text(
          widget.appTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initial = _birthday ?? DateTime(now.year - 19, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 16, now.month, now.day),
      helpText: 'Select your birthday',
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  void _addHobbyFromInput() {
    final t = _hobbyInput.text.trim();
    if (t.isEmpty) return;
    if (_hobbies.contains(t)) return;
    setState(() {
      _hobbies.add(t);
      _hobbyInput.clear();
    });
  }

  Widget _chip(String text) => InputChip(
    label: Text(text),
    onPressed: () {},
    onDeleted: () => setState(() => _hobbies.remove(text)),
    deleteIconColor: Colors.black54,
    backgroundColor: Colors.white,
    side: const BorderSide(color: kBorder),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  );

  String _kmLabel(double v) => '${v.round()} km';

  @override
  void initState() {
    super.initState();
    _bio.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bioCount = _bio.text.characters.length;

    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
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
                                value: 0.99,
                                minHeight: 6,
                                color: kBrandRed,
                                backgroundColor: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Step 2/2',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'Complete your profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Share more about yourself',
                        style: TextStyle(color: kMuted, fontSize: 16),
                      ),
                      const SizedBox(height: 22),

                      const Text(
                        'Birthday',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _pickBirthday,
                        child: AbsorbPointer(
                          child: TextField(
                            decoration: fieldDeco(
                              _birthday == null
                                  ? 'YYYY - MM - DD'
                                  : '${_birthday!.year.toString().padLeft(4, '0')} - '
                                  '${_birthday!.month.toString().padLeft(2, '0')} - '
                                  '${_birthday!.day.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'Country',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _country,
                        decoration: fieldDeco('Enter your country'),
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'City',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _city,
                        decoration: fieldDeco('Enter your city'),
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'University',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _university,
                        decoration: fieldDeco(
                          'Enter your university (optional)',
                        ),
                      ),
                      const SizedBox(height: 18),

                      const Text(
                        'Hobbies / Interests',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _hobbyInput,
                              decoration: fieldDeco('Type and press Enter'),
                              onSubmitted: (_) => _addHobbyFromInput(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: kBrandRed,
                            ),
                            onPressed: _addHobbyFromInput,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ..._hobbies.map(_chip),
                          for (final quick in const [
                            'Travel',
                            'Music',
                            'Movies',
                            'Sports',
                            'Reading',
                            'Cooking',
                          ])
                            if (!_hobbies.contains(quick)) _chip('+ $quick'),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Biography',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$bioCount/$_bioLimit',
                            style: const TextStyle(color: kMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _bio,
                        maxLines: 4,
                        maxLength: _bioLimit,
                        decoration: fieldDeco(
                          'Tell others about yourself...',
                        ).copyWith(counterText: ''),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Preferred Distance',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Text(
                              _kmLabel(_distanceKm),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _distanceKm,
                        min: 5,
                        max: 100,
                        divisions: 95,
                        label: _kmLabel(_distanceKm),
                        onChanged: (v) => setState(() => _distanceKm = v),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('5 km', style: TextStyle(color: kMuted)),
                            Text('100 km', style: TextStyle(color: kMuted)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Back'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _valid
                              ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile saved (demo).'),
                              ),
                            );
                          }
                              : null,
                          child: const Text('Finish setting up ur profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
