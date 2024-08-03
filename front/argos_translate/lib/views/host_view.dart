import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
import '../services/text_to_speech_service.dart';
import '../services/translation_service.dart';

class HostView extends StatefulWidget {
  const HostView({super.key});

  @override
  HostViewState createState() => HostViewState();
}

class HostViewState extends State<HostView> {
  bool _isListening = false;
  bool _roomGenerated = false;
  String _roomCode = '';
  List<dynamic> _voiceLanguages = [];
  List<dynamic> _translationLanguages = [];
  String? _selectedVoiceLanguage;
  String? _selectedTranslationLanguage;
  String _spokenText = '';
  String _translatedText = '';

  WebSocketChannel? _channel;

  final SpeechRecognition _speechRecognition = SpeechRecognition();

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    List<dynamic> voiceLanguages = await TextToSpeech.getLanguages();
    List<dynamic> translationLanguages =
        await TranslationService.getTranslationLanguages();
    setState(() {
      _voiceLanguages = voiceLanguages;
      _translationLanguages = translationLanguages;
      _selectedVoiceLanguage =
          voiceLanguages.isNotEmpty ? voiceLanguages[0] : null;
      _selectedTranslationLanguage =
          translationLanguages.isNotEmpty ? translationLanguages[0] : null;
    });
  }

  Future<void> _generateRoom() async {
    try {
      final roomCode = await RoomService.generateRoom();
      setState(() {
        _roomCode = roomCode;
        _roomGenerated = true;
        _connectToRoom(
            roomCode);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate room')),
      );
    }
  }

  void _connectToRoom(String roomId) {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://wewiza.ddns.net:8089/ws/$roomId'));
  }

  void _startListening() {
    _speechRecognition.startListening((result) {
      setState(() {
        _spokenText = result;
        _isListening = _speechRecognition.isListening;
      });

      if (_spokenText.isNotEmpty) {
        _translateAndSend(_spokenText);
      }
    });
  }

  void _stopListening() {
    _speechRecognition.stopListening();
    setState(() {
      _isListening = _speechRecognition.isListening;
    });
  }

  Future<void> _translateAndSend(String text) async {
    if (_selectedTranslationLanguage != null) {
      final translatedText = await TranslationService.translateText(
          text, _selectedTranslationLanguage!);
      if (translatedText != null) {
        if (translatedText.isNotEmpty) {
          setState(() {
            _translatedText = translatedText;
          });
          if (_selectedVoiceLanguage != null) {
            await TextToSpeech.speak(translatedText, _selectedVoiceLanguage!);
          } else {
            print('No voice language selected');
          }
          _channel?.sink.add(
              translatedText);
        } else {
          print('Empty translation');
        }
      } else {
        print('Translation failed');
      }
    } else {
      print('No translation language selected');
    }
  }

  @override
  void dispose() {
    _speechRecognition.stopListening();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.host),
      ),
      body: Center(
        child: _roomGenerated
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Room Code: $_roomCode',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.languageOfVoice),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!.languageToTranslate),
                      const SizedBox(width: 10),
                      if (_translationLanguages.isNotEmpty)
                        DropdownButton<String>(
                          value: _selectedTranslationLanguage,
                          items: _translationLanguages
                              .map<DropdownMenuItem<String>>((dynamic lang) {
                            return DropdownMenuItem<String>(
                              value: lang as String,
                              child: Text(lang as String),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTranslationLanguage = newValue;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isListening = !_isListening;
                      });
                      if (_isListening) {
                        _startListening();
                      } else {
                        _stopListening();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20.0),
                      backgroundColor: _isListening ? Colors.red : Colors.blue,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _isListening
                        ? 'Escuchando...'
                        : 'Presiona el botón para escuchar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _spokenText,
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _translatedText,
                    style:
                        TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _generateRoom,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                ),
                child: Text(
                  'Generar sala',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
      ),
    );
  }
}
