import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'dart:convert' as convert;

import 'package:stage/class/tools.dart';
import 'package:stage/class/widgets.dart';

class SearchByTypePage extends StatefulWidget {
  const SearchByTypePage({super.key, required this.title});

  final String title;

  @override
  State<SearchByTypePage> createState() => SearchByTypePageState();
}

class SearchByTypePageState extends State<SearchByTypePage> {
  String _dropdownvalue = ' ';
  int _idSelec = -1;
  final Tools _tools = Tools();
  var _listM;
  var _type;
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _col = Column(
    children: const <Widget>[
      Text(
        Strings.noSelectionStr,
        style: TextStyle(fontSize: 25),
      ),
    ],
  );
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
    var responseType = await _tools.getType(_idSelec);
    if (responseM.statusCode == 200 && responseT.statusCode == 200) {
      _listM = convert.jsonDecode(responseM.body);
      _type = convert.jsonDecode(responseType.body);
      _listM = _tools.sortListByDateAchat(_listM['hydra:member']);

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
    List<Widget> tab = List.empty(growable: true);
    if (_idSelec == 0) {
      tab.add(
        const Text(
          Strings.noSelectionStr,
          style: TextStyle(fontSize: 25),
        ),
      );
    }
    for (var elt in _listM) {
      List<String> temp = elt['type'].split('/');
      int idType = int.parse(temp[temp.length - 1]);
      if (idType == _idSelec) {
        AssetImage img = _tools.findImg(_type['libelle']);
        List<dynamic> tableau = [elt, _type];
        tab.add(Widgets.createRowElt(
            elt, _type, _textStyle, tableau, img, context));
        if (_boolAdmin) {
          tab.add(
            Row(
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
                items: Strings.itemsType
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idSelec = Strings.itemsType.indexOf(newValue!);
                  setState(() {
                    _dropdownvalue = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: _col,
                ),
              ),
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
