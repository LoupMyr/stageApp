import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/class/widgets.dart';

class SearchByLieuPage extends StatefulWidget {
  const SearchByLieuPage({super.key, required this.title});

  final String title;

  @override
  State<SearchByLieuPage> createState() => SearchByLieuPageState();
}

class SearchByLieuPageState extends State<SearchByLieuPage> {
  String _dropdownvalue = ' ';
  int _idSelec = -1;
  final Tools _tools = Tools();
  var _listM;
  var _listT;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _col = Column(children: []);
  bool _boolAdmin = false;

  void recupMateriels() async {
    _boolAdmin = await _tools.checkAdmin();
    if (!_boolAdmin && await _tools.checkMods() == false) {
      Widgets.buildNonAdmin(context);
      return;
    }
    _col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        SpinKitThreeInOut(color: Colors.teal),
      ],
    );
    setState(() {
      _col;
    });
    var responseM = await _tools.getMateriels();
    var responseT = await _tools.getTypes();
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _listM = convert.jsonDecode(responseM.body);
      _listT = convert.jsonDecode(responseT.body);
      _listM = _tools.sortListByDateAchat(_listM['hydra:member']);

      buildList();
    } else {
      setState(() {
        _col = Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

  void buildList() {
    List<Widget> tab = List.empty(growable: true);
    if (_idSelec == 0) {
      tab.add(
        const Text(
          Strings.noSelectionStr,
          style: TextStyle(fontSize: 25),
        ),
      );
    } else {
      for (var elt in _listM) {
        List<String> temp = elt['lieuInstallation'].split('/');
        int idLieu = int.parse(temp[temp.length - 1]);
        if (idLieu == _idSelec) {
          var type;
          for (var t in _listT['hydra:member']) {
            if (t['@id'] == elt['type']) {
              type = t;
            }
          }
          AssetImage img = _tools.findImg(type['libelle']);
          List<dynamic> tableau = [elt, type];
          tab.add(Widgets.createRowElt(
              elt, type, _textStyle, tableau, img, context));
          if (_boolAdmin) {
            tab.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 5,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteElt(elt['id'].toString()),
                    ),
                  ),
                  Widgets.createEditOption(context, tableau),
                ],
              ),
            );
          }
        }
      }
    }
    if (tab.isEmpty) {
      tab.add(Text(
        Strings.emptyEltByLieu + _dropdownvalue.toLowerCase(),
        style: const TextStyle(fontSize: 25),
      ));
    }
    setState(() {
      _col = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tab,
      );
    });
  }

  Future<void> deleteElt(String id) async {
    await Widgets.buildDeletePopUp(id, _listM, _scaffoldKey);
    setState(() {
      recupMateriels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Widgets.createAppBar(widget.title, context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              const Text(
                Strings.lieuTitle,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              DropdownButton(
                value: _dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Strings.itemsLieu
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idSelec = Strings.itemsLieu.indexOf(newValue!);
                  setState(() {
                    _dropdownvalue = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              _col,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                recupMateriels();
              }),
          tooltip: Strings.refresh,
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
