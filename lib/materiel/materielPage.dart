import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/class/widgetNonAdmin.dart';

class MaterielPage extends StatefulWidget {
  const MaterielPage({super.key, required this.title});

  final String title;

  @override
  State<MaterielPage> createState() => MaterielPageState();
}

class MaterielPageState extends State<MaterielPage> {
  List<dynamic> __tab = [];
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  final Tools _tools = Tools();
  bool _recupDataBool = false;
  var _materiel;
  var _type;
  var _etat;
  String _dateAchat = '';
  String _numSerie = '';

  Future<String> recupEtat() async {
    if (await _tools.checkAdmin() == false) {
      WidgetNonAdmin.buildEmptyPopUp(context);
      return '';
    }
    List<String> temp = __tab[0]['etat'].split('/');
    int id = int.parse(temp[temp.length - 1]);
    var response = await _tools.getEtatById(id);
    if (response.statusCode == 200) {
      _etat = convert.jsonDecode(response.body);
      _recupDataBool = true;
    }
    return '';
  }

  Widget createFirstArray() {
    List<Widget> tab = [];
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(_type['libelle'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(_etat['libelle'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(_materiel['marque'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(_materiel['modele'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: SingleChildScrollView(
            child: Text(_materiel['remarques'],
                style: const TextStyle(fontSize: 15)),
          ),
        ),
      );
    } catch (e) {
      tab.add(
        SizedBox(
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
    tab.add(addGap());
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: Text(_materiel['lieuInstallation'], style: _textStyle),
      ),
    );

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tab);
  }

  Widget createSecondArray() {
    List<Widget> tab = [];
    String dateAchat = ' / ';
    String dateFinGarantie = ' / ';
    String remarques = ' / ';
    String numSerie = ' / ';
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: SingleChildScrollView(
            child: Text(_materiel['numSerie'], style: _textStyle),
          ),
        ),
      );
      _numSerie = _materiel['numSerie'];
    } catch (e) {
      tab.add(
        SizedBox(
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
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: SingleChildScrollView(
          child: Text(_materiel['numInventaire'], style: _textStyle),
        ),
      ),
    );
    tab.add(addGap());

    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_materiel['dateAchat']))
                  .toString(),
              style: _textStyle),
        ),
      );
      _dateAchat = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateAchat']))
          .toString();
    } catch (e) {
      tab.add(
        SizedBox(
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
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_materiel['dateFinGaranti']))
                  .toString(),
              style: _textStyle),
        ),
      );
    } catch (e) {
      tab.add(
        SizedBox(
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
        width: MediaQuery.of(context).size.width / 7,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, "/routeQrcode", arguments: list),
          child: QrImage(
            data: dataStr,
            size: 100,
          ),
        ),
      ),
    );
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 7,
        child: null,
      ),
    );

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tab);
  }

  String createDataStr() {
    String dataStr =
        '${_materiel['marque']} ${_materiel['modele']}\nN° serie: $_numSerie\nN° inventaire: ${_materiel['numInventaire']}\n${_materiel['lieuInstallation']}\nDate facture: $_dateAchat';
    return dataStr;
  }

  Widget addGap() {
    return const Padding(padding: EdgeInsets.all(10));
  }

  Widget createImg() {
    AssetImage img = _tools.findImg(_type['libelle']);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: img,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    __tab = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _materiel = __tab[0];
    _type = __tab[1];
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
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Etat', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Remarques', style: _textStyleHeaders),
                  ),
                  addGap(),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child:
                        Text('Lieu d\'installation', style: _textStyleHeaders),
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
                    child: Text('Numéro de série', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child:
                        Text('Numéro d\'inventaire', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Date d\'achat',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Date fin de garantie',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('QR Code', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 7,
                      child: null),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              createSecondArray(),
              addGap(),
              addGap(),
              createImg(),
            ];
          } else {
            recupEtat();
            children = [
              const SpinKitRipple(
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
              'Erreur critique.',
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
                const SpinKitRing(
                  color: Colors.blueGrey,
                  size: 100,
                ),
              ],
            ),
          ];
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
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
