import 'dart:io';
import 'dart:ui';
import 'package:download_assets/download_assets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key, required this.title});

  final String title;

  @override
  State<QrCodePage> createState() => QrCodePageState();
}

class QrCodePageState extends State<QrCodePage> {
  DownloadAssetsController downloadAssetsController =
      DownloadAssetsController();
  String message = "Press the download button to start the download";
  bool downloaded = false;
  String _dataStr = 'Erreur';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await downloadAssetsController.init();
    downloaded = await downloadAssetsController.assetsDirAlreadyExists();
  }

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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _refresh,
            tooltip: 'Télécharger',
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  Future _refresh() async {
    await _downloadFile(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKw5RDspUDcObjGF6t2fY8WKSJnNhVfzFRoMHL3GsT&s',
        'QrCode');
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('C:/Users/pc-Utilisateur/Documents/$fileName.png');
    return file.writeAsBytes(req.bodyBytes, flush: true);
  }
}
