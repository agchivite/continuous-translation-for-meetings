import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget warningBox(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
    padding: const EdgeInsets.all(16.0),
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
        const SizedBox(width: 16.0),
        Expanded(
          child: SelectableText(
            AppLocalizations.of(context)!.v1recommendWebComputer,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            cursorColor: Colors.yellow[700],
            showCursor: true,
            toolbarOptions: const ToolbarOptions(
              copy: true,
              selectAll: true,
            ),
          ),
        ),
      ],
    ),
  );
}
