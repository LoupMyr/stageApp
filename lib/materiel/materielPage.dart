import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:stage/class/widgets.dart';

class MaterielPage extends StatefulWidget {
  const MaterielPage({super.key, required this.title});

  final String title;

  @override
  State<MaterielPage> createState() => MaterielPageState();
}

class MaterielPageState extends State<MaterielPage> {
  List<dynamic> _tab = List.empty(growable: true);
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
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
  String _dateAchat = '';

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

  Widget createFirstArray() {
    List<Widget> tab = List.empty(growable: true);
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(
          _type['libelle'],
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
    tab.add(addGap());
    tab.add(
      Container(
        decoration: BoxDecoration(border: _border),
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(
          _etat['libelle'],
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
    tab.add(addGap());
    tab.add(
      Container(
        decoration: BoxDecoration(border: _border),
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(
          _materiel['marque'],
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
    tab.add(addGap());
    tab.add(
      Container(
        decoration: BoxDecoration(border: _border),
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(
          _materiel['modele'],
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
    tab.add(addGap());
    String lieuStr = _lieu['libelle'].toString();
    if (_lieu['libelle'].toString() == 'Autres') {
      try {
        lieuStr = _materiel['detailTypeAutres'];
      } catch (e) {
        lieuStr = 'Autres \n Pas de spécification';
      }
    }
    tab.add(
      Container(
        decoration: BoxDecoration(border: _border),
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(
          lieuStr,
          style: _textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: tab);
  }

  Widget createSecondArray() {
    List<Widget> tab = List.empty(growable: true);
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: SingleChildScrollView(
          child: Text(_materiel['numSerie'],
              style: _textStyle, textAlign: TextAlign.center),
        ),
      ),
    );
    tab.add(addGap());
    tab.add(
      Container(
        decoration: BoxDecoration(border: _border),
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: SingleChildScrollView(
          child: Text(_materiel['numInventaire'],
              style: _textStyle, textAlign: TextAlign.center),
        ),
      ),
    );
    tab.add(addGap());
    try {
      tab.add(
        Container(
          decoration: BoxDecoration(border: _border),
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_materiel['dateAchat']))
                  .toString(),
              style: _textStyle,
              textAlign: TextAlign.center),
        ),
      );
      _dateAchat = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateAchat']))
          .toString();
    } catch (e) {
      tab.add(
        Container(
          decoration: BoxDecoration(border: _border),
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Icon(Icons.question_mark, size: 40),
                  ],
                ),
              ]),
        ),
      );
    }
    tab.add(addGap());
    try {
      tab.add(
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: Colors.black, width: 3),
                  right: BorderSide(color: Colors.black, width: 3))),
          height: 100,
          width: MediaQuery.of(context).size.width / 6,
          child: Text(
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(_materiel['dateFinGaranti']))
                .toString(),
            style: _textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (e) {
      tab.add(
        Container(
          decoration: BoxDecoration(border: _border),
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.question_mark, size: 40),
                  ],
                ),
              ]),
        ),
      );
    }
    tab.add(addGap());
    String dataStr = createDataStr();
    List<dynamic> list = [dataStr, _materiel, _type];
    tab.add(
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.09,
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            width: MediaQuery.of(context).size.width * 0.1,
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, "/routeQrcode", arguments: list),
              child: QrImage(
                data: dataStr,
                size: 100,
              ),
            ),
          ),
        ),
      ),
    );
    try {
      tab.add(
        Container(
          decoration: BoxDecoration(border: _border),
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                _materiel['remarques'],
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      tab.add(
        Container(
          decoration: BoxDecoration(border: _border),
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.question_mark, size: 40),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: tab);
  }

  String createDataStr() {
    String dataStr =
        '${_materiel['marque']} ${_materiel['modele']}\nN° serie: ${_materiel['numSerie']}\nN° inventaire: ${_materiel['numInventaire']}\n${_materiel['lieuInstallation']}\nDate facture: $_dateAchat';
    return dataStr;
  }

  Widget addGap() {
    return const Padding(padding: EdgeInsets.all(10));
  }

  Widget createImg() {
    List<Widget> tabImg = List.empty(growable: true);
    if (_materiel['photos'].isNotEmpty) {
      for (var elt in _photos['hydra:member']) {
        if (elt['materiel'] == _materiel['@id']) {
          String imgUrl = elt['url'];
          tabImg.add(
            Image(
              image: NetworkImage(imgUrl),
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          );
        }
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tabImg,
    );
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
        if (snapshot.hasData) {
          if (_recupDataBool) {
            children = [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.typeHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.etatHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.marqueHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.modeleHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(
                      Strings.lieuInstallationHeader,
                      style: _textStyleHeaders,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              createFirstArray(),
              addGap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.numSerieHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.numInventaireHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.dateAchatHeader,
                        style: _textStyleHeaders,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.dateGarantieHeader,
                        style: _textStyleHeaders,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.qrCodeHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(Strings.remarquesHeader,
                        style: _textStyleHeaders, textAlign: TextAlign.center),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              createSecondArray(),
              addGap(),
              addGap(),
              createImg(),
            ];
          } else {
            recupEtat();
            children = [
              const SpinKitThreeInOut(
                color: Colors.teal,
                size: 100,
              )
            ];
          }
        } else if (snapshot.hasError) {
          children = [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 125,
            ),
            const Text(
              Strings.criticalErrorStr,
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ];
        } else {
          children = [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 2.2)),
                const SpinKitThreeInOut(
                  color: Colors.teal,
                  size: 100,
                ),
              ],
            ),
          ];
        }
        return Scaffold(
          appBar: Widgets.createAppBar(widget.title, context),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children),
            ),
          ),
        );
      },
    );
  }
}
