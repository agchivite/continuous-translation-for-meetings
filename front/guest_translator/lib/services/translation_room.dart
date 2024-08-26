import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guest_translator/utils/language.dart';
import 'package:guest_translator/utils/languages_support.dart';
import 'package:guest_translator/widgets/info_box.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../services/text_to_speech_service.dart';

class TranslationRoomGuest extends StatefulWidget {
  const TranslationRoomGuest({super.key});

  @override
  TranslationRoomGuestState createState() => TranslationRoomGuestState();
}

class TranslationRoomGuestState extends State<TranslationRoomGuest> {
  final TextEditingController _roomController = TextEditingController();
  WebSocketChannel? _channel;
  List<String> _messages = [];
  String _roomCode = '';
  final translator = GoogleTranslator();

  List<dynamic> _voiceLanguages = [];
  String? _selectedVoiceLanguage;
  List<Language> _translationLanguages = [];
  Language? _selectedTranslationLanguage;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _loadTranslationLanguages();
  }

  Future<void> _loadLanguages() async {
    List<dynamic> voiceLanguages = await TextToSpeech.getLanguages();

    setState(() {
      _voiceLanguages = voiceLanguages;
      _selectedVoiceLanguage =
          voiceLanguages.isNotEmpty ? voiceLanguages[0] : null;
    });
  }

  Future<void> _loadTranslationLanguages() async {
    var languageList = LanguageList();
    var languages = languageList.getAll();
    setState(() {
      _translationLanguages = languages;
      _selectedTranslationLanguage =
          _translationLanguages.isNotEmpty ? _translationLanguages[0] : null;
    });
  }

  Future<bool> _checkRoomExists(String roomId) async {
    final response =
        await http.get(Uri.parse('http://wewiza.ddns.net:8089/room/$roomId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['exists'] as bool;
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
        var translation = await translator.translate(message,
            to: _selectedTranslationLanguage!.code);
        String translatedText = translation.text;

        print('Translated message: $translatedText');
        setState(() {
          _messages.add(translatedText);
        });
        if (_selectedVoiceLanguage != null) {
          await TextToSpeech.speak(translatedText, _selectedVoiceLanguage!);
        } else {
          print('No voice language selected');
        }
      }, onError: (error) {
        print('WebSocket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WebSocket error: $error'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isConnected = false;
        });
      }, onDone: () {
        print('WebSocket connection closed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('WebSocket connection closed'),
              backgroundColor: Colors.red),
        );
        setState(() {
          _isConnected = false;
        });
      });

      setState(() {
        _isConnected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection established with room ' + _roomCode),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Room does not exist'), backgroundColor: Colors.red),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoBox(),
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: _isConnected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Room: $_roomCode',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _disconnectFromRoom,
                          child: Text('Leave Room'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                          ),
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
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _roomController,
                          decoration: InputDecoration(
                            labelText: 'Enter Room ID',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _roomCode = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final roomId = _roomController.text;
                            if (roomId.isNotEmpty) {
                              _connectToRoom(roomId);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                          ),
                          child: Text('Join Room'),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Voice Language:'),
                            const SizedBox(width: 10),
                            if (_voiceLanguages.isNotEmpty)
                              Expanded(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedVoiceLanguage,
                                  items: _voiceLanguages
                                      .map<DropdownMenuItem<String>>(
                                          (dynamic lang) {
                                    return DropdownMenuItem<String>(
                                      value: lang as String,
                                      child: Text(
                                        lang as String,
                                        overflow: TextOverflow
                                            .ellipsis, // Maneja el texto largo
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedVoiceLanguage = newValue;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Language to translate:'),
                            const SizedBox(width: 10),
                            if (_translationLanguages.isNotEmpty)
                              Expanded(
                                child: DropdownButton<Language>(
                                  isExpanded: true,
                                  value: _selectedTranslationLanguage,
                                  items: _translationLanguages
                                      .map<DropdownMenuItem<Language>>(
                                          (Language lang) {
                                    return DropdownMenuItem<Language>(
                                      value: lang,
                                      child: Text(
                                        '${lang.code} - ${lang.name}',
                                        overflow: TextOverflow
                                            .ellipsis, // Maneja el texto largo
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Language? newValue) {
                                    setState(() {
                                      _selectedTranslationLanguage = newValue;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
