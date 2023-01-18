import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'dart:convert' as convert;

import 'package:stage/class/tools.dart';
import 'package:stage/class/widgets.dart';

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
        Strings.noSelectionStr,
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
    var responseType = await _tools.getType(_idSelec);
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
              '${Strings.criticalErrorStr} - ${responseM.statusCode.toString()}',
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
          Strings.noSelectionStr,
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
        Strings.emptyEltByType1 +
            _dropdownvalue.toLowerCase() +
            Strings.emptyEltByType2,
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
            title: const Text(Strings.deleteEltTitle),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(Strings.deleteStr),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(Strings.yesButtonStr),
                onPressed: () {
                  deleteElt(id);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(Strings.cancelButtonStr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void deleteElt(String id) async {
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
        content: Text(Strings.deleteEltSuccessful),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.errorHappened),
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
              tooltip: Strings.backToolTip,
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
                Strings.typeTitle,
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
                    child: Text(Strings.typeHeader, style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(Strings.marqueHeader, style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(Strings.modeleHeader, style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(Strings.optionHeader, style: _textStyleHeaders),
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
