import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TranslationRoomGuest extends StatefulWidget {
  @override
  _TranslationRoomGuestState createState() => _TranslationRoomGuestState();
}

class _TranslationRoomGuestState extends State<TranslationRoomGuest> {
  final TextEditingController _roomController = TextEditingController();
  WebSocketChannel? _channel;
  List<String> _messages = [];

  void _connectToRoom(String roomId) {
    setState(() {
      _channel = WebSocketChannel.connect(
          Uri.parse('ws://wewiza.ddns.net:8089/ws/$roomId'));
    });

    _channel?.stream.listen((message) {
      setState(() {
        _messages.add(message);
      });
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
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(_messages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
