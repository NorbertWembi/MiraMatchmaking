import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showGeneral = true;
  String searchQuery = "";

  // Notification toggle states
  final Map<String, bool> notificationToggles = {
    "New texts from chat": true,
    "New matches": false,
    "Someone liked you": true,
    "A new person is near you": false,
    "Promotions & Offers": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tabs (General / Custom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => setState(() => showGeneral = true),
                child: Text(
                  'General:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: showGeneral ? Colors.black : Colors.grey,
                    decoration: showGeneral
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => showGeneral = false),
                child: Text(
                  'Custom:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !showGeneral ? Colors.black : Colors.grey,
                    decoration: !showGeneral
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1),

          // --- Content
          Expanded(
            child: showGeneral ? _buildGeneralTab() : _buildCustomTab(),
          ),
        ],
      ),
    );
  }

  // --- General Tab Content ---
  Widget _buildGeneralTab() {
    final messages = [
      {
        "name": "SARAH",
        "message": "Good Morning, how did you sleep :)?",
        "time": "3m ago"
      },
      {"name": "JASON", "message": "Haha, so true.", "time": "40m ago"},
    ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    msg['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    msg['time']!,
                    style: const TextStyle(color: Colors.pinkAccent),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(msg['message']!),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  // --- Custom Tab Content ---
  Widget _buildCustomTab() {
    final settings = [
      "New texts from chat",
      "New matches",
      "Someone liked you",
      "A new person is near you",
      "Promotions & Offers",
    ];

    // Filtered based on search query
    final filteredSettings = settings
        .where((item) =>
        item.toLowerCase().contains(searchQuery.toLowerCase().trim()))
        .toList();

    return Column(
      children: [
        // --- Search bar ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              hintText: 'Search Settings',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.black87,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),

        // --- List of toggle items ---
        Expanded(
          child: ListView.builder(
            itemCount: filteredSettings.length,
            itemBuilder: (context, index) {
              final item = filteredSettings[index];
              return ListTile(
                title: Text(item),
                trailing: Switch(
                  value: notificationToggles[item] ?? false,
                  activeThumbColor: Colors.red,
                  onChanged: (val) {
                    setState(() {
                      notificationToggles[item] = val;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
