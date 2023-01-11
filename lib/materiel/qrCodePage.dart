import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key, required this.title});

  final String title;

  @override
  State<QrCodePage> createState() => QrCodePageState();
}

class QrCodePageState extends State<QrCodePage> {
  GlobalKey globalKey = GlobalKey();
  String _dataStr = 'Erreur';
  List<dynamic> _tab = [];
  var _materiel;
  var _type;

  @override
  Widget build(BuildContext context) {
    _tab = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _dataStr = _tab[0];
    _materiel = _tab[1];
    _type = _tab[2];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text('Attention !',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
              const Text(
                'Pour télécharger le QR, si vous n\'avez pas de répertoire "qrCodes" dans "Documents", les QR Codes s\'enregistreront dans le répertoire temporaire de l\'ordinateur !',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataStr,
                  size: 500,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _captureAndSharePng,
            tooltip: 'Télécharger',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      var path = 'C:/Users/pc-Utilisateur/Documents/qrCodes';
      try {
        final file = await File(
                '$path/QRCode-${_type['libelle']}-${_materiel['id']}.png')
            .create();
        await file.writeAsBytes(pngBytes);
      } catch (e) {
        var temp = await getTemporaryDirectory();
        final file = await File(
                '${temp.path}/QRCode-${_type['libelle']}-${_materiel['id']}.png')
            .create();
        await file.writeAsBytes(pngBytes);
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('QR Code enregistré avec succès'),
      ));
    } catch (e) {
      log(' ERROR : $e');
    }
  }
}
