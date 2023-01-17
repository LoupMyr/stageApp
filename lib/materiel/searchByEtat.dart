import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/class/widgets.dart';

class SearchByEtat extends StatefulWidget {
  const SearchByEtat({super.key, required this.title});

  final String title;

  @override
  State<SearchByEtat> createState() => SearchByEtatState();
}

class SearchByEtatState extends State<SearchByEtat> {
  String _dropdownvalue = ' ';
  int _idSelec = -1;
  final List<String> _itemsEtat = [
    ' ',
    'Neuf',
    'Très bon état',
    'Bon état',
    'Autres'
  ];
  final Tools _tools = Tools();
  var _listM;
  var _listT;
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
      Widgets.buildEmptyPopUp(context);
      return;
    }
    _col = Column(
      children: const <Widget>[
        SpinKitThreeInOut(color: Colors.teal),
      ],
    );
    var responseM = await _tools.getMateriels();
    var responseT = await _tools.getTypes();
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _listM = convert.jsonDecode(responseM.body);
      _listT = convert.jsonDecode(responseT.body);
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

  void buildList() {
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
      List<String> temp = elt['etat'].split('/');
      int idEtat = int.parse(temp[temp.length - 1]);
      if (idEtat == _idSelec) {
        var type;
        for (var t in _listT['hydra:member']) {
          if (t['@id'] == elt['type']) {
            type = t;
          }
        }
        AssetImage img = _tools.findImg(type['libelle']);
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
                    child: Text(type['libelle'], style: _textStyle),
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
        'Aucun matériel du stock est ${_dropdownvalue.toLowerCase()}',
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
        barrierDismissible: false,
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

  Future<void> deleteElt(String id) async {
    for (var elt in _listM['hydra:member']) {
      if (elt['id'].toString() == id) {
        if (elt['photos'].isNotEmpty) {
          List<int> tabIdPhoto = [];
          for (int i = 0; i < elt['photos'].length; i++) {
            List<String> temp = elt['photos'][i].split('/');
            int id = int.parse(temp[temp.length - 1]);
            tabIdPhoto.add(id);
          }
          for (int i = 0; i < tabIdPhoto.length; i++) {
            await _tools.deletePhoto(tabIdPhoto[i].toString());
          }
        }
      }
    }
    var response = await _tools.deleteMateriel(id);
    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Matériel supprimé'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Une erreur est survenue'),
      ));
    }
    setState(() {
      recupMateriels();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                'Recherchez un état parmis ceux présenté ici pour retrouver \ntous les matériels correspondant à celui-ci.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              DropdownButton(
                value: _dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _itemsEtat.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idSelec = _itemsEtat.indexOf(newValue!);
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
