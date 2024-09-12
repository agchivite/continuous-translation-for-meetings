import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/constants.dart';
import '../services/room_service.dart';
import '../services/speech_to_text_service.dart';
import '../utils/languages_input_speech.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/warning_box.dart';

class HostView extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final Locale currentLocale;

  const HostView(
      {super.key, required this.onLocaleChange, required this.currentLocale});

  @override
  HostViewState createState() => HostViewState();
}

class HostViewState extends State<HostView> {
  bool _isListening = false;
  bool _isRestarting = false;
  bool _isMuted = false;
  bool _roomGenerated = false;
  String _roomCode = '';
  List<String> _inputSpeechLanguages = [];
  String? _selectedInputSpeechLanguage;
  String _currentRecognizedText = '';
  Timer? _recognitionResetTimer;
  List<String> _spokenTextHistory = [];
  WebSocketChannel? _channel;
  final ScrollController _scrollController = ScrollController();
  final SpeechRecognition _speechRecognition = SpeechRecognition();

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  void _loadLanguages() {
    setState(() {
      _inputSpeechLanguages = LanguagesInputSpeechList.getLanguageCodes();
      _selectedInputSpeechLanguage =
          _inputSpeechLanguages.isNotEmpty ? _inputSpeechLanguages[0] : null;
    });
  }

  Future<void> _generateRoom() async {
    try {
      final roomCode = await RoomService.generateRoomVanilla();
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
        SnackBar(
            content: Text(AppLocalizations.of(context)!.failedRoomGeneration)),
      );
    }
  }

  void _connectToRoom(String roomId) {
    _channel = WebSocketChannel.connect(Uri.parse('$websocketUrl/ws/$roomId'));
    _channel!.stream.listen(
      (message) {
        print('Received: $message');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  Future<void> _startListening() async {
    if (_isMuted || _isRestarting) return;

    await _speechRecognition.startListening(
      (result) {
        if (_isMuted || _isRestarting) return;

        setState(() {
          _currentRecognizedText = result.trim();
        });

        _recognitionResetTimer?.cancel();
        _recognitionResetTimer = Timer(const Duration(milliseconds: 550), () {
          if (_currentRecognizedText.isNotEmpty) {
            String tempText = _currentRecognizedText;
            _sendText(tempText);
          }
        });
      },
      localeId: _selectedInputSpeechLanguage,
      onListeningStateChanged: (isListening) {
        setState(() {
          _isListening = isListening;
        });
      },
    );
  }

  void _stopListening() {
    if (_isRestarting) return;

    _isRestarting = true;
    _speechRecognition.stopListening();
    setState(() {
      _isListening = false;
      _currentRecognizedText = ''; // Clear the recognized text
    });
    _recognitionResetTimer?.cancel(); // Cancel any pending timers
    _isRestarting = false;
  }

  void _sendText(String text) {
    if (text.isNotEmpty && !_spokenTextHistory.contains(text)) {
      setState(() {
        _spokenTextHistory.add(text);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

      _channel?.sink.add(text);
      print('Sent text: $text');

      _speechRecognition.stopAndRestartListening();
    } else {
      print('Empty text or already sent');
    }
  }

  /*void _sendText(String text) {
    if (text.isNotEmpty && !_spokenTextHistory.contains(text)) {
      setState(() {
        _spokenTextHistory.add(text);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

      _channel?.sink.add(text);
      print('Sent text: $text');
    } else {
      print('Empty text or already sent');
    }
  }*/

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _speechRecognition.setMuted(_isMuted);

      if (_isMuted) {
        _stopListening();
      } else {
        if (_roomGenerated) {
          _startListening();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _speechRecognition.stopListening();
    _channel?.sink.close();
    _recognitionResetTimer?.cancel();
    super.dispose();
  }

  void _closeRoom() {
    _channel?.sink.close();
    setState(() {
      _roomGenerated = false;
      _roomCode = '';
      _spokenTextHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.host),
        actions: [
          LanguageDropdown(
            selectedLocale: widget.currentLocale,
            onLocaleChange: (Locale locale) {
              widget.onLocaleChange(locale);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          warningBox(context),
          const SizedBox(height: 20.0),
          if (_roomGenerated)
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Text(
                      '${AppLocalizations.of(context)!.roomCode} $_roomCode',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _toggleMute,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                        backgroundColor: _isMuted ? Colors.grey : Colors.green,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isMuted
                          ? AppLocalizations.of(context)!.mute
                          : AppLocalizations.of(context)!.listening,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _closeRoom,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                        backgroundColor: Colors.red,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.closeRoom,
                        style: const TextStyle(color: Colors.white),
                      ),
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
                          Text(AppLocalizations.of(context)!
                              .inputSpeechLanguage),
                          const SizedBox(width: 10),
                          if (_inputSpeechLanguages.isNotEmpty)
                            DropdownButton<String>(
                              value: _selectedInputSpeechLanguage,
                              items: _inputSpeechLanguages
                                  .map<DropdownMenuItem<String>>((code) {
                                return DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(
                                    LanguagesInputSpeechList.getLanguageName(
                                        code),
                                  ),
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
                      ElevatedButton(
                        onPressed: _generateRoom,
                        child: Text(AppLocalizations.of(context)!.generateRoom),
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
