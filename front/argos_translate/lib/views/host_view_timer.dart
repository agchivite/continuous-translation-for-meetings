import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
import '../services/translation_service.dart';
import '../widgets/warning_box.dart';

class HostViewTimer extends StatefulWidget {
  const HostViewTimer({super.key});

  @override
  HostViewTimerState createState() => HostViewTimerState();
}

class HostViewTimerState extends State<HostViewTimer> {
  bool _isListening = false;
  bool _roomGenerated = false;
  String _roomCode = '';
  List<dynamic> _translationLanguages = [];
  List<dynamic> _inputSpeechLanguages = [];
  String? _selectedTranslationLanguage;
  String? _selectedInputSpeechLanguage;
  String _currentRecognizedText = '';
  Timer? _recognitionResetTimer;
  Timer? _sendTimer;
  List<String> _spokenTextHistory = [];
  List<String> _translatedTextHistory = [];
  WebSocketChannel? _channel;

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
    _speechRecognition.startListening((result) {
      setState(() {
        _currentRecognizedText = result.trim();
        _isListening = _speechRecognition.isListening;
      });

      // Reinicia el temporizador cada vez que se recibe nuevo texto
      _recognitionResetTimer?.cancel();
    }, localeId: _selectedInputSpeechLanguage);

    // Configura un temporizador que envía el texto y reinicia el reconocimiento cada 3 segundos
    _sendTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentRecognizedText.isNotEmpty) {
        _translateAndSend(_currentRecognizedText);
        _restartListening(); // Reinicia el reconocimiento de voz
      }
    });
  }

  void _restartListening() {
    _speechRecognition.stopListening();
    _currentRecognizedText = '';
    Future.delayed(Duration(milliseconds: 100), () {
      if (_isListening) {
        _startListening();
      }
    });
  }

  void _stopListening() {
    _speechRecognition.stopListening();
    _recognitionResetTimer?.cancel();
    _sendTimer?.cancel();
    setState(() {
      _isListening = false;
      _currentRecognizedText = '';
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
    _speechRecognition.stopListening();
    _channel?.sink.close();
    _recognitionResetTimer?.cancel();
    _sendTimer?.cancel();
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
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: _roomGenerated
                    ? Column(
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
                              backgroundColor:
                                  _isListening ? Colors.red : Colors.blue,
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
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
                          )
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
