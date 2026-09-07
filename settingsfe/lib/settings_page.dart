import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _settingsItems = [
    'Edit Profile',
    'Change Password',
    'Blocked Users',
    'Privacy Policy',
    'Report / Block Someone',
    'Delete Account',
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter items based on search
    final visibleItems = _settingsItems
        .where((item) =>
            item.toLowerCase().contains(_searchQuery.toLowerCase().trim()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'User Settings',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search  Settings',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Colors.black),

          // List of settings + Logout
          Expanded(
            child: ListView.separated(
              itemCount: visibleItems.length + 1, // +1 for Logout row
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.black),
              itemBuilder: (context, index) {
                // Last row = Logout
                if (index == visibleItems.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: const [
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.logout, size: 18, color: Colors.red),
                      ],
                    ),
                  );
                }

                final item = visibleItems[index];

                return ListTile(
                  title: Text(
                    item,
                    style: const TextStyle(fontSize: 15),
                  ),
                  onTap: () {
                    if (item == 'Report / Block Someone') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportBlockPage(),
                        ),
                      );
                    }
                    // you can add more navigation for other items later
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// Report / Block Screen
// =====================

class ReportBlockPage extends StatelessWidget {
  const ReportBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report / Block',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Manage interactions with users you find inappropriate.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: Colors.black),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: _RedBigButton(
              label: 'Block User',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Block User pressed')),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: _RedBigButton(
              label: 'Report User',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportUserPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RedBigButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _RedBigButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// =================
// Report User Screen
// =================

class ReportUserPage extends StatefulWidget {
  const ReportUserPage({super.key});

  @override
  State<ReportUserPage> createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {
  String? selectedReason;
  final TextEditingController _controller = TextEditingController();

  final reasons = [
    'Spam or misleading',
    'Harassment or bullying',
    'Inappropriate content',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report / Block',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Manage interactions with users you find inappropriate.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: Colors.black),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ...reasons.map(
                  (reason) => RadioListTile<String>(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (val) {
                      setState(() {
                        selectedReason = val;
                      });
                    },
                    title: Text(reason),
                    activeColor: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    height: 120,
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: 'Briefly Explain What happened..',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: _RedBigButton(
              label: 'Submit Report',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted (mock).')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
