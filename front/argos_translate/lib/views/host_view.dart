import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
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
  List<dynamic> _translationLanguages = [];
  List<dynamic> _inputSpeechLanguages = [];
  String? _selectedTranslationLanguage;
  String? _selectedInputSpeechLanguage;
  String _spokenTextBuffer = '';
  List<String> _spokenTextHistory = [];
  List<String> _translatedTextHistory = [];

  WebSocketChannel? _channel;
  Timer? _sendTimer;

  final SpeechRecognition _speechRecognition = SpeechRecognition();

  Map<String, String> _languagesDictionary = {};

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    List<dynamic> inputSpeechLanguages = await _speechRecognition.getLocales();

    setState(() {
      _languagesDictionary = RoomService.getLanguagesDictionary();
      _translationLanguages = _languagesDictionary.entries
          .map((entry) => '${entry.key} - ${entry.value}')
          .toList();
      _inputSpeechLanguages = inputSpeechLanguages;
      _selectedTranslationLanguage =
          _translationLanguages.isNotEmpty ? _translationLanguages[0] : null;
      _selectedInputSpeechLanguage = inputSpeechLanguages.isNotEmpty
          ? inputSpeechLanguages[0].localeId
          : null;
    });
  }

  Future<void> _generateRoom() async {
    try {
      final roomCode = await RoomService.generateRoom();
      setState(() {
        _roomCode = roomCode;
        _roomGenerated = true;
        _connectToRoom(roomCode);
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
        _spokenTextBuffer = ' $result'; // Update buffer directly
        _isListening = _speechRecognition.isListening;
      });
    }, localeId: _selectedInputSpeechLanguage);

    _startSendTimer();
  }

  void _stopListening() {
    _speechRecognition.stopListening();
    setState(() {
      _isListening = _speechRecognition.isListening;
    });

    _stopSendTimer();
  }

  void _startSendTimer() {
    _sendTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_spokenTextBuffer.isNotEmpty) {
        _translateAndSend(_spokenTextBuffer.trim());
        _spokenTextBuffer = ''; // Reset buffer after sending
      }
    });
  }

  void _stopSendTimer() {
    _sendTimer?.cancel();
  }

  Future<void> _translateAndSend(String text) async {
    if (_selectedTranslationLanguage != null) {
      final languageCode = _selectedTranslationLanguage!.split(' - ').first;
      final translatedText =
          await TranslationService.translateText(text, languageCode);
      if (translatedText != null && translatedText.isNotEmpty) {
        setState(() {
          _spokenTextHistory.add(text);
          _translatedTextHistory.add(translatedText);
        });
        _channel?.sink.add(translatedText);
      } else {
        print('Empty translation or translation failed');
      }
    } else {
      print('No translation language selected');
    }
  }

  @override
  void dispose() {
    _speechRecognition.stopListening();
    _channel?.sink.close();
    _stopSendTimer();
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: _spokenTextHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_spokenTextHistory[index]),
                          subtitle: Text(_translatedTextHistory[index]),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Input speech language:'),
                        const SizedBox(width: 10),
                        if (_inputSpeechLanguages.isNotEmpty)
                          DropdownButton<String>(
                            value: _selectedInputSpeechLanguage,
                            items: _inputSpeechLanguages
                                .map<DropdownMenuItem<String>>((lang) {
                              return DropdownMenuItem<String>(
                                value: lang.localeId,
                                child: Text(lang.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedInputSpeechLanguage = newValue;
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
                      onPressed: _generateRoom,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20.0),
                      ),
                      child: Text(
                        'Generar sala',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ]),
      ),
    );
  }
}
