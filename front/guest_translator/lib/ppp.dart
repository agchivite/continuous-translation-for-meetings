import 'dart:convert'; // Import for JSON decoding

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/text_to_speech_service.dart';

class TranslationRoomGuest extends StatefulWidget {
  const TranslationRoomGuest({super.key});

  @override
  TranslationRoomGuestState createState() => TranslationRoomGuestState();
}

class TranslationRoomGuestState extends State<TranslationRoomGuest> {
  final TextEditingController _roomController = TextEditingController();
  WebSocketChannel? _channel;
  List<String> _messages = [];

  List<dynamic> _voiceLanguages = [];
  String? _selectedVoiceLanguage;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    List<dynamic> voiceLanguages = await TextToSpeech.getLanguages();
    setState(() {
      _voiceLanguages = voiceLanguages;
      _selectedVoiceLanguage =
          voiceLanguages.isNotEmpty ? voiceLanguages[0] : null;
    });
  }

  Future<bool> _checkRoomExists(String roomId) async {
    final response = await http
        .get(Uri.parse('http://wewiza.ddns.net:8089/check_room/$roomId'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['exists'] as bool;
    } else {
      return false;
    }
  }

  void _connectToRoom(String roomId) async {
    if (await _checkRoomExists(roomId)) {
      if (_channel != null) {
        _channel!.sink.close();
      }

      _channel = WebSocketChannel.connect(
          Uri.parse('ws://wewiza.ddns.net:8089/ws/$roomId'));

      _channel?.stream.listen((message) async {
        setState(() {
          _messages.add(message);
        });
        if (_selectedVoiceLanguage != null) {
          await TextToSpeech.speak(message, _selectedVoiceLanguage!);
        } else {
          print('No voice language selected');
        }
      }, onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('WebSocket error: $error')),
        );
        setState(() {
          _isConnected = false;
        });
      }, onDone: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('WebSocket connection closed')),
        );
        setState(() {
          _isConnected = false;
        });
      });

      setState(() {
        _isConnected = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room does not exist')),
      );
    }
  }

  void _disconnectFromRoom() {
    _channel?.sink.close();
    setState(() {
      _isConnected = false;
      _messages.clear();
      _roomController.clear();
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation Room - Guest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isConnected) ...[
              TextField(
                controller: _roomController,
                decoration: InputDecoration(
                  labelText: 'Enter Room ID',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final roomId = _roomController.text;
                  if (roomId.isNotEmpty) {
                    _connectToRoom(roomId);
                  }
                },
                child: Text('Join Room'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Voice Language:'),
                  const SizedBox(width: 10),
                  if (_voiceLanguages.isNotEmpty)
                    DropdownButton<String>(
                      value: _selectedVoiceLanguage,
                      items: _voiceLanguages
                          .map<DropdownMenuItem<String>>((dynamic lang) {
                        return DropdownMenuItem<String>(
                          value: lang as String,
                          child: Text(lang as String),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedVoiceLanguage = newValue;
                        });
                      },
                    ),
                ],
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _disconnectFromRoom,
                child: Text('Leave Room'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_messages[index]),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
