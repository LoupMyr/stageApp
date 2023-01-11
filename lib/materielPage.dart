import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/widgetNonAdmin.dart';

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

  Widget createSizedBoxs() {
    List<Widget> tab = [];
    String dateAchat = ' / ';
    String dateFinGarantie = ' / ';
    String remarques = ' / ';
    String numSerie = ' / ';
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: Text(_type['libelle'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: Text(_etat['libelle'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: Text(_materiel['marque'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: Text(_materiel['modele'], style: _textStyle),
      ),
    );
    tab.add(addGap());
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
          child: SingleChildScrollView(
            child: Text(_materiel['numSerie'], style: _textStyle),
          ),
        ),
      );
      numSerie = _materiel['numSerie'];
    } catch (e) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
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
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
          child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_materiel['dateAchat']))
                  .toString(),
              style: _textStyle),
        ),
      );
      dateAchat = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateAchat']))
          .toString();
    } catch (e) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
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
          width: MediaQuery.of(context).size.width / 11,
          child: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(_materiel['dateFinGaranti']))
                  .toString(),
              style: _textStyle),
        ),
      );
      dateFinGarantie = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_materiel['dateFinGaranti']))
          .toString();
    } catch (e) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
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
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
          child: SingleChildScrollView(
            child: Text(_materiel['remarques'],
                style: const TextStyle(fontSize: 15)),
          ),
        ),
      );
      remarques = _materiel['remarques'];
    } catch (e) {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 11,
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
    String dataStr =
        "Type: ${_type['libelle']}\nEtat: ${_etat['libelle']}\nModele: ${_materiel['modele']}\nMarque: ${_materiel['marque']}\nNuméro de série: $numSerie\nDate d'achat: $dateAchat\nDate de fin de garantie: $dateFinGarantie";
    List<dynamic> list = [dataStr, _materiel, _type];
    tab.add(
      SizedBox(
        width: MediaQuery.of(context).size.width / 11,
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

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tab);
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
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Etat', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Numéro de série', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Date \nd\'achat', style: _textStyleHeaders),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Date fin de garantie',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Remarques',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  addGap(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('QR Code', style: _textStyleHeaders),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              createSizedBoxs(),
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
            const SpinKitRipple(
              color: Colors.teal,
              size: 100,
            )
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
              child: Center(
                child: Column(children: children),
              ),
            ),
          ),
        );
      },
    );
  }
}
