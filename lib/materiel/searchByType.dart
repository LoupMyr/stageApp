import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;

import 'package:stage/tools.dart';
import 'package:stage/widgetNonAdmin.dart';

class SearchByType extends StatefulWidget {
  const SearchByType({super.key, required this.title});

  final String title;

  @override
  State<SearchByType> createState() => SearchByTypeState();
}

class SearchByTypeState extends State<SearchByType> {
  String _dropdownvalue = ' ';
  int _idSelec = -1;
  final List<String> _itemsType = [
    ' ',
    'Unité centrale',
    'Ecran',
    'Clavier',
    'Souris',
    'Imprimante',
    'Copieur',
    'NAS',
    'Serveur',
    'Switch',
    'Point accès wifi',
    'ENI',
    'TBI',
    'Autres'
  ];
  final Tools _tools = Tools();
  var _listM;
  var _type;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  Widget _col = Column(
    children: const <Widget>[
      Text(
        'Aucune selection',
        style: TextStyle(fontSize: 25),
      ),
    ],
  );

  void recupMateriels() async {
    if (await _tools.checkAdmin() == false) {
      WidgetNonAdmin.buildEmptyPopUp(context);
      return;
    }
    _col = Column(
      children: const <Widget>[
        SpinKitDualRing(color: Colors.blueGrey),
      ],
    );
    var responseM = await _tools.getMateriels();
    var responseT = await _tools.getTypes();
    var responseType = await _tools.getType(_idSelec);
    await Future.delayed(const Duration(milliseconds: 500));
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _listM = convert.jsonDecode(responseM.body);
      _type = convert.jsonDecode(responseType.body);
      buildList();
    } else {
      setState(() {
        _col = Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 125,
            ),
            Text(
              'Erreur critique.\nCode d\'erreur: ${responseM.statusCode.toString()}',
              style: const TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            )
          ],
        );
      });
    }
  }

  void buildList() async {
    List<Widget> tab = [];
    if (_idSelec == 0) {
      tab.add(
        const Text(
          'Aucune selection',
          style: TextStyle(fontSize: 25),
        ),
      );
    }
    for (var elt in _listM['hydra:member']) {
      List<String> temp = elt['type'].split('/');
      int idType = int.parse(temp[temp.length - 1]);
      if (idType == _idSelec) {
        AssetImage img = _tools.findImg(_type['libelle']);
        List<dynamic> tableau = [elt, _type];
        tab.add(
          InkWell(
            onTap: () => Navigator.pushNamed(context, "/routeMateriel",
                arguments: tableau),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 7,
                  child: Center(
                      child: Image(
                    image: img,
                    color: Colors.black,
                  )),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text(_type['libelle'], style: _textStyle),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text(elt['marque'], style: _textStyle),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text(elt['modele'], style: _textStyle),
                  ),
                ),
                SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => buildDeletePopUp(elt['id'].toString()),
                    )),
              ],
            ),
          ),
        );
      }
    }
    if (tab.isEmpty) {
      tab.add(Text(
        'Il n\'y a pas de ${_dropdownvalue.toLowerCase()} dans le stock',
        style: const TextStyle(fontSize: 25),
      ));
    }
    setState(() {
      _col = Column(
        children: tab,
      );
    });
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
    var response = await _tools.deleteMateriel(id);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Matériel supprimé'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Une erreur est survenue'),
      ));
    }
    setState(() {
      buildList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const Text(
                'Recherchez un type parmis ceux présenté ici pour retrouver \ntous les matériels correspondant à celui-ci.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              DropdownButton(
                value: _dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _itemsType.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idSelec = _itemsType.indexOf(newValue!);
                  setState(() {
                    _dropdownvalue = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: null,
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Options', style: _textStyleHeaders),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _col,
              ),
            ],
          ),
        ),
      ),
    );
  }
}