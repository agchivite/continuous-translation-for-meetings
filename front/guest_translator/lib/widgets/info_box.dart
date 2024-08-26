import 'package:flutter/material.dart';

Widget infoBox() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.blue[100], // Fondo azul claro
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: Colors.blue[700]!, // Borde azul más oscuro
        width: 2.0,
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.info, // Cambiado a ícono de información
          color: Colors.blue[700], // Color azul más oscuro para el ícono
          size: 40.0,
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Text(
            'El anfitrión debe indicar el código de la habitación.',
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
