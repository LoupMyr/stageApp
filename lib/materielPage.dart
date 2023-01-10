import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
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
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Text(_type['libelle'], style: _textStyle),
      ),
    );
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Text(_etat['libelle'], style: _textStyle),
      ),
    );
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Text(_materiel['marque'], style: _textStyle),
      ),
    );
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Text(_materiel['modele'], style: _textStyle),
      ),
    );
    tab.add(
      SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width / 9,
        child: Text(_materiel['numSerie'], style: _textStyle),
      ),
    );
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 9,
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
          width: MediaQuery.of(context).size.width / 9,
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
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 9,
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
          width: MediaQuery.of(context).size.width / 9,
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
    try {
      tab.add(
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 9,
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
          width: MediaQuery.of(context).size.width / 9,
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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: tab);
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
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Etat', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Numéro de série', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Date \nd\'achat', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Date fin de garantie',
                        style: _textStyleHeaders, overflow: TextOverflow.fade),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text('Remarques', style: _textStyleHeaders),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              createSizedBoxs(),
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
            child: Center(
              child: Column(children: children),
            ),
          ),
        );
      },
    );
  }
}
