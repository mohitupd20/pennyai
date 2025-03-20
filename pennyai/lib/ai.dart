import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pennyai/system.dart';


class ChatAI extends StatefulWidget {
  const ChatAI({super.key});

  @override
  _ChatAIState createState() => _ChatAIState();
}

class _ChatAIState extends State<ChatAI> {
  final TextEditingController _textController = TextEditingController();
  bool showPlayer = false;
  String? audioPath;
  final String _response = '';
  late final AudioRecorder record;
  final audioPlayer = AudioPlayer();
  List<Map<String, String>> messages = [];

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
    record = AudioRecorder();
    showPlayer = false;
    super.initState();
  }

  Future<void> _getAIResponse(String userInput) async {
    setState(() {
      if (messages.isEmpty) {
        messages.add({
          'role': 'system',
          'content': annapurnaBotSystemPrompt
        });
      }
      messages.add({'role': 'user', 'content': userInput});
    });

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
          'messages': messages,
          'response_format': { 'type': 'text' }
        }),
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var responseData = json.decode(decodedBody);
        print(responseData);

        var aiResponse = responseData['choices'][0]['message']['content'];
        setState(() {
          messages.add({'role': 'assistant', 'content': aiResponse});
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(aiResponse)),
          );
        }
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting AI response: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Failed to get AI response')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT'),
        backgroundColor: Color(0xFFEA580C),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              dropdownColor: Color(0xFFEA580C),
              value: selectedLanguage,
              style: TextStyle(color: Colors.white),
              icon: Icon(Icons.language, color: Colors.white),
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
      body: Container(
        color: Color(0xFFFFF7ED),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['role'] == 'user';

                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFFEA580C) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: isUser ? Colors.white : Color(0xFFEA580C),
                          radius: 16,
                          child: Icon(
                            isUser ? Icons.person : Icons.assistant,
                            color: isUser ? Color(0xFFEA580C) : Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: isUser ?
                          Text(
                            message['content'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ) :
                          MarkdownBody(
                            data: message['content'] ?? '',
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(color: Colors.black87, fontSize: 16),
                              h1: TextStyle(color: Colors.black87),
                              h2: TextStyle(color: Colors.black87),
                              h3: TextStyle(color: Colors.black87),
                              h4: TextStyle(color: Colors.black87),
                              h5: TextStyle(color: Colors.black87),
                              h6: TextStyle(color: Colors.black87),
                              em: TextStyle(color: Colors.black87),
                              strong: TextStyle(color: Colors.black87),
                              code: TextStyle(color: Colors.black87, backgroundColor: Color(0xFFFED7AA)),
                              blockquote: TextStyle(color: Colors.black54),
                              listBullet: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  showPlayer
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await audioPlayer.play(DeviceFileSource(audioPath!));
                          },
                          icon: Icon(Icons.play_arrow),
                          label: Text('Play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEA580C),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => showPlayer = false);
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (await record.hasPermission()) {
                              final directory = await getApplicationDocumentsDirectory();
                              final path = '${directory.path}/recording.wav';
                              await record.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
                            }
                          },
                          icon: Icon(Icons.mic),
                          label: Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEA580C),
                          ),
                        ),
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
                          icon: Icon(Icons.stop),
                          label: Text('Stop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Message ChatGPT...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFFEA580C)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFFEA580C)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Color(0xFFEA580C)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFF7ED),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: () {
                            if (_textController.text.isNotEmpty) {
                              _getAIResponse(_textController.text);
                              _textController.clear();
                            }
                          },
                          backgroundColor: Color(0xFFEA580C),
                          mini: true,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        print(translatedText);
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