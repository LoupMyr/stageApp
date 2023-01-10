import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/local.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key, required this.title});

  final String title;

  @override
  State<QrCodePage> createState() => QrCodePageState();
}

class QrCodePageState extends State<QrCodePage> {
  String _dataStr = 'Erreur';

  @override
  Widget build(BuildContext context) {
    _dataStr = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            QrImage(
              data: _dataStr,
              size: 500,
            ),
            const Text(
              "Scannez-moi !",
              style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
