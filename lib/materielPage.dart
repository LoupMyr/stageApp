import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stage/tools.dart';
import 'dart:convert' as convert;

class MaterielPage extends StatefulWidget {
  const MaterielPage({super.key, required this.title});

  final String title;

  @override
  State<MaterielPage> createState() => MaterielPageState();
}

class MaterielPageState extends State<MaterielPage> {
  List<dynamic> _tab = [];
  final TextStyle _textStyle = TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  Tools _tools = Tools();
  bool _recupDataBool = false;
  var _materiel;
  var _type;
  var _etat;

  Future<String> recupEtat() async {
    List<String> temp = _tab[0]['etat'].split('/');
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
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: Text(_materiel['numSerie'], style: _textStyle),
      ),
    );
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
    String dataStr =
        'Modele: ${_materiel['modele']}\nMarque: ${_materiel['marque']}';
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 11,
        child: QrImage(
          data: dataStr,
          size: 100,
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
        Image(
          image: img,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
          color: Colors.black,
        ),
      ],
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
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Etat', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Numéro de série', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Date \nd\'achat', style: _textStyleHeaders),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Date fin de garantie',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 11,
                    child: Text('Remarques',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
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
