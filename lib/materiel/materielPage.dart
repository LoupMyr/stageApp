import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:stage/class/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class MaterielPage extends StatefulWidget {
  const MaterielPage({super.key, required this.title});

  final String title;

  @override
  State<MaterielPage> createState() => MaterielPageState();
}

class MaterielPageState extends State<MaterielPage> {
  List<dynamic> _tab = List.empty(growable: true);
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final pw.TextStyle _tsPdf = pw.TextStyle(
      fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  final Border _border =
      const Border(left: BorderSide(color: Colors.black, width: 3));
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  var _materiel;
  var _type;
  var _etat;
  var _lieu;
  var _photos;
  String _lieuStr = '';
  String _dateAchat = '';
  String _dateFinGarantie = '';
  String _remarques = '';

  Future<String> recupEtat() async {
    if (await _tools.checkAdmin() == false &&
        await _tools.checkMods() == false) {
      Widgets.buildNonAdmin(context);
      return '';
    }

    List<String> temp = _tab[0]['etat'].split('/');
    int idEtat = int.parse(temp[temp.length - 1]);
    temp = _tab[0]['lieuInstallation'].split('/');
    int idLieu = int.parse(temp[temp.length - 1]);

    var responseEtat = await _tools.getEtatById(idEtat);
    var responseP = await _tools.getPhotos();
    var responseLieu = await _tools.getLieuById(idLieu);
    if (responseEtat.statusCode == 200 &&
        responseP.statusCode == 200 &&
        responseLieu.statusCode == 200) {
      _etat = convert.jsonDecode(responseEtat.body);
      _photos = convert.jsonDecode(responseP.body);
      _lieu = convert.jsonDecode(responseLieu.body);
      _recupDataBool = true;
    }
    return '';
  }

  Widget createArray() {
    List<Widget> tab = List.empty(growable: true);
    findFields();
    tab.add(createText('Type:', _etat['libelle']));

    tab.add(addGap());
    tab.add(createText('Etat:', _type['libelle']));

    tab.add(addGap());
    tab.add(createText('Marque:', _materiel['marque']));

    tab.add(addGap());
    tab.add(createText('Modele:', _materiel['modele']));

    tab.add(addGap());
    tab.add(createText('Lieu d\'installation', _lieuStr));

    tab.add(addGap());
    tab.add(createText('Numéro de série:', _materiel['numSerie']));

    tab.add(addGap());
    tab.add(createText('Numéro d\'inventaire', _materiel['numInventaire']));

    tab.add(addGap());
    tab.add(createText('Date d\'achat', _dateAchat));

    tab.add(addGap());
    tab.add(createText('Date fin de garantie', _dateFinGarantie));

    tab.add(addGap());
    tab.add(createText('Remarques:', _remarques));

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: tab),
    );
  }

  RichText createText(String title, String content) {
    return RichText(
      text: TextSpan(
          text: title,
          style: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text: ' $content',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            )
          ]),
    );
  }

  void findFields() {
    if (_lieu['libelle'].toString() == 'Autres') {
      try {
        _lieuStr = _materiel['detailTypeAutres'];
      } catch (e) {
        _lieuStr = 'Autres \n Pas de spécification';
      }
    }
    try {
      _dateAchat = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateAchat']))
          .toString();
    } catch (e) {
      _dateAchat = ' / ';
    }
    try {
      _dateFinGarantie = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateFinGaranti']))
          .toString();
    } catch (e) {
      _dateFinGarantie = ' / ';
    }
    try {
      _remarques = _materiel['remarques'];
    } catch (e) {
      _remarques = ' / ';
    }
  }

  String createDataStr() {
    String dataStr =
        '${_materiel['marque']} ${_materiel['modele']}\nN° serie: ${_materiel['numSerie']}\nN° inventaire: ${_materiel['numInventaire']}\n$_lieuStr\nDate facture: $_dateAchat';
    return dataStr;
  }

  Widget addGap() {
    return const Padding(padding: EdgeInsets.all(10));
  }

  List<Widget> createAssets() {
    List<Widget> tabWidget = List.empty(growable: true);
    String dataStr = createDataStr();
    tabWidget.add(
      const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
    );
    List<dynamic> list = [dataStr, _materiel, _type];
    if (_materiel['photos'].isNotEmpty) {
      for (var elt in _photos['hydra:member']) {
        if (elt['materiel'] == _materiel['@id']) {
          String imgUrl = elt['url'];
          tabWidget.add(
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/routeImage",
                  arguments: imgUrl),
              child: Image(
                image: NetworkImage(imgUrl),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
            ),
          );
        }
      }
    }
    tabWidget.add(
      const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
    );
    tabWidget.add(
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.13,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, "/routeQrcode", arguments: list),
              child: QrImage(
                data: dataStr,
              ),
            ),
          ),
        ),
      ),
    );
    return tabWidget;
  }

  Future<void> donwloadPdf() async {
    final pdf = createPdf();
    Directory pathDoc = await getApplicationDocumentsDirectory();
    await _tools.checkArboresence(pathDoc.path);
    try {
      final file = File(
          '${pathDoc.path}/gestionStock/pdfFiches/fiche-technique-${_type['libelle'].toLowerCase()}.pdf');
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      var temp = await getTemporaryDirectory();
      final file = File(
          '${temp.path}/fiche-technique-${_type['libelle'].toLowerCase()}.pdf');
      await file.writeAsBytes(await pdf.save());
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(Strings.pdfDownloadSuccessful),
    ));
  }

  pw.Document createPdf() {
    final pdf = pw.Document();
    String lieuStr = _lieu['libelle'].toString();
    pw.Widget padding =
        pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 10));
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text('Fiche technique',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 35,
                      decoration: pw.TextDecoration.underline)),
              pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 30)),
              pw.Divider(thickness: 2),
              pw.Text(
                'Type:',
                style: _tsPdf,
              ),
              pw.Text(_type['libelle']),
              padding,
              pw.Text(
                'Etat: \n',
                style: _tsPdf,
              ),
              pw.Text(_etat['libelle']),
              padding,
              pw.Text(
                'Marque: \n',
                style: _tsPdf,
              ),
              pw.Text(_materiel['marque']),
              padding,
              pw.Text(
                'Modele: \n',
                style: _tsPdf,
              ),
              pw.Text(_materiel['modele']),
              padding,
              pw.Text(
                'Numéro de série: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(_materiel['numSerie']),
              padding,
              pw.Text(
                'Numéro d\'inventaire: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(_materiel['numInventaire']),
              padding,
              pw.Text(
                'Lieu d\'installation: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(lieuStr),
              padding,
              pw.Text(
                'Date d\'achat: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(_dateAchat),
              padding,
              pw.Text(
                'Date de fin de garantie: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(_dateFinGarantie),
              padding,
              pw.Text(
                'Remarques: \n',
                style: _tsPdf,
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(_remarques),
              pw.Divider(thickness: 2),
            ],
          ),
        ),
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    _tab = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _materiel = _tab[0];
    _type = _tab[1];
    return FutureBuilder(
      future: recupEtat(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;
        List<Widget> childrenAssets;
        FloatingActionButton fab = const FloatingActionButton(
          onPressed: null,
          heroTag: 'null',
        );
        if (snapshot.hasData) {
          if (_recupDataBool) {
            children = [
              createArray(),
            ];
            childrenAssets = createAssets();
            fab = FloatingActionButton(
              onPressed: donwloadPdf,
              heroTag: 'downloadFichePdf',
              tooltip: 'Télécharger en PDF',
              child: const Icon(Icons.download),
            );
          } else {
            recupEtat();
            children = [
              const SpinKitThreeInOut(
                color: Colors.orange,
                size: 100,
              ),
            ];
            childrenAssets = [];
          }
        } else if (snapshot.hasError) {
          children = [
            const Icon(
              Icons.error_outline,
              color: Colors.teal,
              size: 125,
            ),
            const Text(
              Strings.criticalErrorStr,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ];
          childrenAssets = [];
        } else {
          children = [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SpinKitThreeInOut(
                  color: Colors.teal,
                  size: 100,
                ),
              ],
            ),
          ];
          childrenAssets = [];
        }
        return Scaffold(
          appBar: Widgets.createAppBar(widget.title, context),
          body: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: children,
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 50)),
                Column(
                  children: childrenAssets,
                ),
              ],
            ),
          ),
          floatingActionButton: fab,
        );
      },
    );
  }
}
