import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
import '../services/text_to_speech_service.dart';
import '../services/translation_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _speechAvailable = false;
  String _lastWords = '';
  String _currentWords = '';
  final String _selectedLocaleId = 'es_MX';

  // #################################################################################################
  List<dynamic> _voiceLanguages = [];
  List<dynamic> _translationLanguages = [];
  String? _selectedVoiceLanguage;
  String? _selectedTranslationLanguage;
  bool _roomGenerated = false;
  String _roomCode = '';
  final SpeechRecognition _speechRecognition = SpeechRecognition();

  // #################################################################################################

  printLocales() async {
    var locales = await _speechToText.locales();
    for (var local in locales) {
      debugPrint(local.name);
      debugPrint(local.localeId);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _initSpeech();
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
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate room')),
      );
    }
  }

  void errorListener(SpeechRecognitionError error) {
    debugPrint(error.errorMsg.toString());
    if (error.permanent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition error: ${error.errorMsg}')),
      );
    } else {
      // Retry listening
      _startListening();
    }
  }

  void statusListener(String status) async {
    debugPrint("status $status");
    if (status == "done" && _speechEnabled) {
      setState(() {
        _lastWords += " $_currentWords";
        _currentWords = "";
      });
      await _startListening();
    }
  }

  void _initSpeech() async {
    _speechAvailable = await _speechToText.initialize(
        onError: errorListener, onStatus: statusListener);
    setState(() {
      if (_speechAvailable) {
        _startListening();
      }
    });
  }

  Future _startListening() async {
    debugPrint("=================================================");
    await _stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _selectedLocaleId,
      cancelOnError: false,
      partialResults: true,
      listenMode: ListenMode.dictation,
    );
    setState(() {
      _speechEnabled = true;
    });
  }

  Future _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _currentWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _lastWords.isNotEmpty
                      ? '$_lastWords $_currentWords'
                      : _speechAvailable
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
