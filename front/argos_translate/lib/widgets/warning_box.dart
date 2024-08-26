import 'package:flutter/material.dart';

Widget warningBox() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.yellow[100],
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: Colors.yellow[700]!,
        width: 2.0,
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.warning,
          color: Colors.yellow[700],
          size: 40.0,
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Text(
            'Desactive las notificaciones para evitar el sonido de reactivación del micrófono.',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
