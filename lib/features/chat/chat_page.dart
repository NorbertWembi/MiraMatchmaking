import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'message': message,
        'isRealUser': true,
        'time': DateTime.now(),
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _messages.add({
            'message': "Bot reply to \"$message\"",
            'isRealUser': false,
            'time': DateTime.now(),
          });
        });
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(245, 255, 254, 254),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 14),
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/3d_avatar_15.png'),
                  ),
                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('First name'),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(201, 188, 5, 5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text('Online'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    final bool isMe = msg['isRealUser'];
                    final String formattedTime = DateFormat(
                      'hh:mm a',
                    ).format(msg['time']);

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Color.fromARGB(252, 245, 243, 243)
                                  : Color.fromARGB(55, 233, 64, 87),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(msg['message']),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Text(formattedTime),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Expanded(child: Center(child: Text("Display Messages in this space"),)
              // ),

              // Center(
              //   child: Text("Hello"),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                      decoration: InputDecoration(
                        hintText: 'Your message',
                        fillColor: Color.fromARGB(2, 190, 45, 45),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 240, 239, 239),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 240, 239, 239),
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset('assets/Vector_(Stroke).png'),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(236, 255, 254, 254),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.mic,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
