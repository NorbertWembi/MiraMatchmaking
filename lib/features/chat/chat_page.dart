
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:matchmaking/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatarUrl,
  });

  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatarUrl;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  bool _loading = true;
  String? _error;

  // Added: emojis available in the picker.
  final List<String> _emojis = [
    '😀', '😂', '🥰', '😍', '😊', '😉', '😭', '🤣',
    '😎', '😘', '❤️', '💕', '💖', '💔', '👍', '👎',
    '👏', '🙏', '🙌', '💪', '🔥', '🎉', '🥳', '🤗',
    '🤔', '😢', '😡', '💯', '✨', '🌹', '😘', '❤️‍🔥',
  ];

  // Added: display the emoji picker and insert the selected emoji.
  void _showEmojiPicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose an emoji',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _emojis.map((emoji) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            final text = _controller.text;
                            final selection = _controller.selection;

                            final hasValidSelection =
                                selection.isValid &&
                                    selection.end <= text.length;

                            final start = hasValidSelection
                                ? selection.start
                                : text.length;
                            final end = hasValidSelection
                                ? selection.end
                                : text.length;

                            final updatedText = text.replaceRange(
                              start,
                              end,
                              emoji,
                            );

                            _controller.value = TextEditingValue(
                              text: updatedText,
                              selection: TextSelection.collapsed(
                                offset: start + emoji.length,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _chatService.connectSocket(widget.currentUserId);
    _chatService.onNewMessage(_onIncomingMessage);
    _loadHistory();
  }

  @override
  void dispose() {
    _chatService.offNewMessage();
    _controller.dispose();
    super.dispose();
  }

  void _onIncomingMessage(Map<String, dynamic> data) {
    final incoming = ChatMessage.fromJson(data);
    if (incoming.senderId != widget.otherUserId) return;
    if (incoming.receiverId.isNotEmpty &&
        incoming.receiverId != widget.currentUserId) {
      return;
    }

    if (!mounted) return;
    setState(() {
      _messages.add(incoming);
      // _loadHistory(); // Refresh history to ensure correct order and any missed messages
    },);
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _chatService.loadChatHistory(
        widget.currentUserId,
        widget.otherUserId,
      );
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _chatService.sendMessageViaSocket(
      senderId: widget.currentUserId,
      receiverId: widget.otherUserId,
      text: text,
    );
    setState(() {
      _messages.add(
        ChatMessage(
          id: '',
          senderId: widget.currentUserId,
          receiverId: widget.otherUserId,
          text: text,
          createdAt: DateTime.now(),
        ),
      );
    });
    _controller.clear();
    // _loadHistory(); // Refresh history to ensure correct order and any missed messages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 196, 196),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 14),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE8E0FF),
                    foregroundImage:
                    widget.otherUserAvatarUrl != null &&
                        widget.otherUserAvatarUrl!.isNotEmpty
                        ? NetworkImage(widget.otherUserAvatarUrl!)
                        : null,
                    child:
                    widget.otherUserAvatarUrl == null ||
                        widget.otherUserAvatarUrl!.isEmpty
                        ? Text(
                      widget.otherUserName.isNotEmpty
                          ? widget.otherUserName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F1147),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.otherUserName),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(201, 188, 5, 5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('Online'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loadHistory,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    final isMe = msg.senderId == widget.currentUserId;
                    final formattedTime = DateFormat(
                      'hh:mm a',
                    ).format(msg.createdAt);

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
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color.fromARGB(
                                252,
                                245,
                                243,
                                243,
                              )
                                  : const Color.fromARGB(55, 233, 64, 87),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(msg.text),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
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
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Your message',
                        fillColor: const Color.fromARGB(2, 190, 45, 45),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 240, 239, 239),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 240, 239, 239),
                            width: 1,
                          ),
                        ),
                        // Added: emoji button inside the message field.
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Color.fromARGB(255, 255, 0, 0),
                          ),
                          onPressed: _showEmojiPicker,
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset('assets/Vector_(Stroke).png'),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(236, 255, 254, 254),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
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
