import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
import '../services/translation_service.dart';
import '../widgets/warning_box.dart';

class HostViewLast extends StatefulWidget {
  const HostViewLast({super.key});

  @override
  HostViewLastState createState() => HostViewLastState();
}

class HostViewLastState extends State<HostViewLast> {
  bool _isListening = false;
  bool _isRestarting = false;
  bool _isMuted = false;
  bool _roomGenerated = false;
  String _roomCode = '';
  List<dynamic> _translationLanguages = [];
  List<dynamic> _inputSpeechLanguages = [];
  String? _selectedTranslationLanguage;
  String? _selectedInputSpeechLanguage;
  String _currentRecognizedText = '';
  Timer? _recognitionResetTimer;
  List<String> _spokenTextHistory = [];
  List<String> _translatedTextHistory = [];
  WebSocketChannel? _channel;
  final ScrollController _scrollController = ScrollController();

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
    if (_selectedTranslationLanguage != null) {
      final languageCode = _selectedTranslationLanguage!.split(' - ')[1];
      try {
        final roomCode = await RoomService.generateRoom(languageCode);
        setState(() {
          _roomCode = roomCode;
          _roomGenerated = true;
          _connectToRoom(roomCode);
        });

        if (!_isMuted) {
          _startListening();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate room')),
        );
      }
    } else {
      print('No translation language selected');
    }
  }

  void _connectToRoom(String roomId) {
    if (_selectedTranslationLanguage != null) {
      _channel = WebSocketChannel.connect(
          Uri.parse('ws://wewiza.ddns.net:8089/ws/$roomId'));
    } else {
      print('No translation language selected');
    }
  }

  void _startListening() {
    if (_isMuted || _isRestarting) return;

    _speechRecognition.startListening((result) {
      if (_isMuted || _isRestarting) return;

      setState(() {
        _currentRecognizedText = result.trim();
        _isListening = _speechRecognition.isListening;
      });

      _recognitionResetTimer?.cancel();
      _recognitionResetTimer = Timer(Duration(milliseconds: 550), () {
        if (_currentRecognizedText.isNotEmpty) {
          _stopListening();
          Timer(Duration(milliseconds: 100), () {
            String tempText = _currentRecognizedText;
            _translateAndSend(tempText);
            _startListening(); // Restart listening only after translation
          });
        }
      });
    }, localeId: _selectedInputSpeechLanguage);
  }

  void _stopListening() {
    if (_isRestarting) return;

    _isRestarting = true;
    _speechRecognition.stopListening();
    setState(() {
      _isListening = false;
      _currentRecognizedText = '';
    });
    _isRestarting = false;
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _stopListening();
      } else {
        if (_roomGenerated) {
          _startListening();
        }
      }
    });
  }

  Future<void> _translateAndSend(String text) async {
    if (_selectedTranslationLanguage != null && text.isNotEmpty) {
      final languageCode = _selectedTranslationLanguage!.split(' - ')[1];
      if (!_spokenTextHistory.contains(text)) {
        final translatedText =
            await TranslationService.translateText(text, languageCode);
        if (translatedText != null && translatedText.isNotEmpty) {
          setState(() {
            _spokenTextHistory.add(text);
            _translatedTextHistory.add(translatedText);
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          });

          _channel?.sink.add(translatedText);
          print('Sent for translation: $text');
          print('Translated text: $translatedText');
        } else {
          print('Empty translation or translation failed');
        }
      } else {
        print('Phrase already sent: $text');
      }
    } else {
      print('No translation language selected or empty text');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _speechRecognition.stopListening();
    _channel?.sink.close();
    _recognitionResetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.host),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          warningBox(),
          SizedBox(height: 20.0),
          if (_roomGenerated)
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Room Code: $_roomCode',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _toggleMute,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20.0),
                        backgroundColor: _isMuted
                            ? Colors.grey
                            : (_isListening ? Colors.green : Colors.blue),
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
                      _isMuted
                          ? 'Silenciado'
                          : (_isListening
                              ? 'Escuchando...'
                              : 'Puede hablar...'),
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _spokenTextHistory.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListTile(
                              title: Text(_spokenTextHistory[index]),
                              subtitle: Text(_translatedTextHistory[index]),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
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
                          Text(AppLocalizations.of(context)!
                              .languageToTranslate),
                          const SizedBox(width: 10),
                          if (_translationLanguages.isNotEmpty)
                            DropdownButton<String>(
                              value: _selectedTranslationLanguage,
                              items: _translationLanguages
                                  .map<DropdownMenuItem<String>>(
                                      (dynamic lang) {
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
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 22.0),
                        ),
                        child: Text(
                          'Generar sala',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
