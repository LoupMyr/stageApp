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
        leadingWidth: 150,
        leading: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image(
                image: AssetImage('lib/assets/achicourt.png'),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(right: 20),
              tooltip: 'Retour',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
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
      Directory directoryDoc = await getApplicationDocumentsDirectory();
      try {
        final file = await File(
                '${directoryDoc.path}/qrCodes/QRCode-${_type['libelle']}-${_materiel['id']}.png')
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
