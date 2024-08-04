import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AudioReceiver extends StatefulWidget {
  final WebSocketChannel channel;

  const AudioReceiver({Key? key, required this.channel}) : super(key: key);

  @override
  _AudioReceiverState createState() => _AudioReceiverState();
}

class _AudioReceiverState extends State<AudioReceiver> {
  String _audioData = '';

  @override
  void initState() {
    super.initState();
    _listenToAudio();
  }

  void _listenToAudio() {
    widget.channel.stream.listen((data) {
      // Asumiendo que los datos de audio se envían como base64 codificado
      // Si los datos están en otro formato, ajusta esta parte según sea necesario
      setState(() {
        _audioData = utf8.decode(data);
      });
    }).onError((error) {
      print('Error en la conexión del WebSocket: $error');
    });
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Receiver'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Datos de Audio Recibidos:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20),
              Text(
                _audioData.isNotEmpty
                    ? _audioData
                    : 'Esperando datos de audio...',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
