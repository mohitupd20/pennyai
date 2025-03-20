import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:flutter_markdown/flutter_markdown.dart';
// Import your system prompt file
import 'package:pennyai/system.dart';

class PennyAssistantScreen extends StatefulWidget {
  const PennyAssistantScreen({super.key});

  @override
  State<PennyAssistantScreen> createState() => _PennyAssistantScreenState();
}

class _PennyAssistantScreenState extends State<PennyAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      content: "Hi! I'm Penny, your AI financial assistant. How can I help you today?",
      isUser: false,
      time: '9:30 AM',
    ),
    ChatMessage(
      content: "Based on your spending, you could save \$75 this month by reducing coffee purchases. Would you like a detailed breakdown?",
      isUser: false,
      time: '9:32 AM',
    ),
    ChatMessage(
      content: "Yes, please show me where I can save money.",
      isUser: true,
      time: '9:33 AM',
    ),
    ChatMessage(
      content: "Here's your spending breakdown:\n\nCoffee: \$64 (15 purchases)\n\nSuggestion: Try making coffee at home 3 days a week to save \$28.",
      isUser: false,
      time: '9:34 AM',
    ),
  ];

  // AI functionality variables from ChatAI
  bool showPlayer = false;
  String? audioPath;
  late final AudioRecorder record;
  final audioPlayer = AudioPlayer();
  List<Map<String, String>> aiMessages = [];

  // Use the same language options as in ChatAI
  String selectedLanguage = 'hi-IN';

  final Map<String, String> languageOptions = {
    'hi-IN': 'Hindi',
    'bn-IN': 'Bengali',
    'kn-IN': 'Kannada',
    'ml-IN': 'Malayalam',
    'mr-IN': 'Marathi',
    'od-IN': 'Odia',
    'pa-IN': 'Punjabi',
    'ta-IN': 'Tamil',
    'te-IN': 'Telugu',
    'gu-IN': 'Gujarati',
    'en-IN': 'English'
  };

  @override
  void initState() {
    super.initState();
    record = AudioRecorder();
    showPlayer = false;

    // Initialize AI messages with system prompt
    // Uncomment when you have the system prompt file
    // aiMessages.add({
    //   'role': 'system',
    //   'content': annapurnaBotSystemPrompt
    // });

    // For now, let's use a placeholder system prompt
    aiMessages.add({
      'role': 'system',
      'content': 'You are Penny, an AI financial assistant. Help users manage their finances, provide spending insights, and offer savings tips.'
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    record.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Penny AI Assistant'),
        backgroundColor: const Color(0xFF5E72E4),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF5E72E4),
              value: selectedLanguage,
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.language, color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                }
              },
              items: languageOptions.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatContainer(),
          ),
          _buildVoiceControls(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _messages.length,
        reverse: false,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return _buildMessageBubble(message);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF5E72E4) : const Color(0xFFE9ECEF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.isUser
                ? Text(
              message.content,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            )
                : MarkdownBody(
              data: message.content,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                h1: const TextStyle(color: Colors.black87),
                h2: const TextStyle(color: Colors.black87),
                h3: const TextStyle(color: Colors.black87),
                h4: const TextStyle(color: Colors.black87),
                h5: const TextStyle(color: Colors.black87),
                h6: const TextStyle(color: Colors.black87),
                em: const TextStyle(color: Colors.black87),
                strong: const TextStyle(color: Colors.black87),
                code: const TextStyle(color: Colors.black87, backgroundColor: Color(0xFFE2E8F0)),
                blockquote: const TextStyle(color: Colors.black54),
                listBullet: const TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message.time,
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceControls() {
    if (!showPlayer) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                if (await record.hasPermission()) {
                  final directory = await getApplicationDocumentsDirectory();
                  final path = '${directory.path}/recording.wav';
                  await record.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recording started')),
                  );
                }
              },
              icon: const Icon(Icons.mic, size: 16),
              label: const Text('Start Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E72E4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () async {
                String? path = await record.stop();
                if (path != null) {
                  setState(() {
                    audioPath = path;
                    showPlayer = true;
                  });
                  _processSpeech(File(path));
                }
              },
              icon: const Icon(Icons.stop, size: 16),
              label: const Text('Stop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await audioPlayer.play(DeviceFileSource(audioPath!));
              },
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Play'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E72E4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => showPlayer = false);
              },
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Ask Penny anything...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF5E72E4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  // AI Integration Methods
  Future<void> _getAIResponse(String userInput) async {
    // Add user message to UI message list
    final now = DateTime.now();
    final formattedTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _messages.add(
        ChatMessage(
          content: userInput,
          isUser: true,
          time: formattedTime,
        ),
      );
    });

    // Add user message to AI messages list
    aiMessages.add({'role': 'user', 'content': userInput});

    try {
      var response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer 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',
        },
        body: jsonEncode({
          'model': 'google/gemini-2.0-flash-001',
          'messages': aiMessages,
          'response_format': { 'type': 'text' }
        }),
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var responseData = json.decode(decodedBody);
        print(responseData);

        var aiResponse = responseData['choices'][0]['message']['content'];

        // Add AI response to messages list for UI
        setState(() {
          _messages.add(
            ChatMessage(
              content: aiResponse,
              isUser: false,
              time: formattedTime,
            ),
          );

          // Also add to AI messages for context
          aiMessages.add({'role': 'assistant', 'content': aiResponse});
        });
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting AI response: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Failed to get AI response')),
        );

        // Add error message to chat
        setState(() {
          _messages.add(
            ChatMessage(
              content: "I'm sorry, I couldn't process your request at this moment. Please try again later.",
              isUser: false,
              time: formattedTime,
            ),
          );
        });
      }
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final userInput = _messageController.text;
      _messageController.clear();
      _getAIResponse(userInput);
    }
  }

  Future<void> _processSpeech(File audioFile) async {
    try {
      var file = await http.MultipartFile.fromPath(
        'file',
        audioFile.path,
        contentType: http_parser.MediaType.parse('audio/wav'),
      );

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.sarvam.ai/speech-to-text')
      )
        ..headers.addAll({
          'api-subscription-key': '6292fbe0-abec-4776-91a6-1e759c02583c',
          'Accept': 'application/json; charset=utf-8'
        })
        ..files.add(file)
        ..fields['model'] = 'saarika:v1'
        ..fields['language_code'] = selectedLanguage
        ..fields['with_timestamps'] = 'true';

      var response = await request.send();
      var responseBytes = await response.stream.toBytes();
      var decodedString = utf8.decode(responseBytes);
      var jsonResponse = jsonDecode(decodedString);

      if (response.statusCode == 200) {
        var translatedText = jsonResponse['transcript'];
        print("Transcribed text: $translatedText");

        // Show the transcribed text in a snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transcribed: $translatedText')),
          );
        }

        // Process the transcribed text as a user message
        await _getAIResponse(translatedText);
      } else {
        throw Exception('Failed to process speech: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing speech: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Failed to process speech')),
        );
      }
    }
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.time,
  });
}