import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/room_service.dart';

class GuestView extends StatefulWidget {
  const GuestView({super.key});

  @override
  _GuestViewState createState() => _GuestViewState();
}

class _GuestViewState extends State<GuestView> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool? _roomExists;

  Future<void> _checkRoom() async {
    setState(() {
      _isLoading = true;
      _roomExists = null;
    });

    final roomNumber = _controller.text.trim();
    if (roomNumber.isEmpty) {
      setState(() {
        _isLoading = false;
        _roomExists = false;
      });
      return;
    }

    try {
      final exists = await RoomService.checkRoomExists(roomNumber);
      setState(() {
        _roomExists = exists;
      });
    } catch (e) {
      print('Error checking room: $e');
      setState(() {
        _roomExists = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.guest),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.roomCode,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkRoom,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(AppLocalizations.of(context)!.checkRoom),
            ),
            const SizedBox(height: 20),
            if (_roomExists != null)
              Text(
                _roomExists!
                    ? AppLocalizations.of(context)!.roomExists
                    : AppLocalizations.of(context)!.roomDoesNotExist,
                style: TextStyle(
                  color: _roomExists! ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
