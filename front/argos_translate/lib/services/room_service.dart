import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class RoomService {
  static Future<String> generateRoom() async {
    final response = await http.get(Uri.parse('$baseUrl/room/generate'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['room_id'];
    } else {
      throw Exception('Failed to generate room');
    }
  }

  static Future<bool> checkRoomExists(String roomNumber) async {
    final url = Uri.parse('$baseUrl/room/$roomNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Room does not exist or failed to check: ${response.statusCode}');
      return false;
    }
  }
}
