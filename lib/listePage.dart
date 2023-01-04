import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;

class ListePage extends StatefulWidget {
  const ListePage({super.key, required this.title});

  final String title;

  @override
  State<ListePage> createState() => ListePageState();
}

class ListePageState extends State<ListePage> {
  var _materiels;
  var _types;
  Tools _tool = Tools();
  bool _recupDataBool = false;
  final TextStyle _textStyle = TextStyle(fontSize: 20);

  Future<String> recupMateriels() async {
    var responseM = await _tool.getMateriels();
    var responseT = await _tool.getTypes();
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _materiels = convert.jsonDecode(responseM.body);
      _types = convert.jsonDecode(responseT.body);
      _recupDataBool = true;
    }
    return '';
  }

  Widget buildTab() {
    List<Widget> tab = [];
    for (var elt in _materiels['hydra:member']) {
      var type;
      for (var i in _types['hydra:member']) {
        if (elt['type'] == i['@id']) {
          type = i;
        }
      }
      List<dynamic> tableau = [elt, type];
      tab.add(
        InkWell(
          onTap: () => Navigator.pushNamed(context, "/routeMateriel",
              arguments: tableau),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 5,
                child: Text(type['libelle'], style: _textStyle),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 5,
                child: Text(elt['marque'], style: _textStyle),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width / 5,
                child: Text(elt['modele'], style: _textStyle),
              ),
              SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => buildDeletePopUp(elt['id'].toString()),
                  )),
            ],
          ),
        ),
      );
    }
    return Column(
      children: tab,
    );
  }

  Future<void> buildDeletePopUp(String id) async {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Champ vide'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Etes vous sûr de vouloir supprimer cet élément'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Oui'),
                onPressed: () {
                  deleteElt(id);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void deleteElt(id) async {
    var response = await _tool.deleteMateriel(id);
    setState(() {
      buildTab();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recupMateriels(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (_recupDataBool) {
              children = <Widget>[
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Row(
                  children: <Widget>[
                    buildTab(),
                  ],
                ),
              ];
            } else {
              recupMateriels();
              children = <Widget>[
                const SpinKitWave(
                  color: Colors.teal,
                  size: 100,
                )
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const SpinKitWave(
                color: Colors.red,
              )
            ];
          } else {
            children = <Widget>[
              const SpinKitWave(
                color: Colors.teal,
                size: 100,
              )
            ];
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.title),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(children: children),
              ),
            ),
          );
        });
  }
}
