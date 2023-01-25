import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;

import 'package:stage/class/widgets.dart';

class SearchWithFiltersPage extends StatefulWidget {
  const SearchWithFiltersPage({super.key, required this.title});

  final String title;

  @override
  State<SearchWithFiltersPage> createState() => SearchWithFiltersPageState();
}

class SearchWithFiltersPageState extends State<SearchWithFiltersPage> {
  String _dropdownvalueLieu = ' ';
  String _dropdownvalueType = ' ';
  String _dropdownvalueEtat = ' ';
  String _dropdownvalueAnnee = ' ';
  int _idLieuSelec = -1;
  int _idTypeSelec = -1;
  int _idEtatSelec = -1;
  int _idAnneeSelec = -1;
  final Tools _tools = Tools();
  var _listM;
  var _listT;
  List<dynamic> _listElt = List.empty(growable: true);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _col = Column(
    children: const <Widget>[
      Text(
        Strings.noSelectionStr,
        style: TextStyle(fontSize: 25),
      ),
    ],
  );

  void recupMateriels() async {
     if (await _tools.checkAdmin() == false &&
        await _tools.checkMods() == false) {
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
    if(_idEtatSelec < 0){
      print("etat");
      search('etat', _idEtatSelec);
    }
    if(_idLieuSelec < 0){
      searchDate();
    }
    if(_idAnneeSelec < 0){
      search('dateAchat', _idAnneeSelec);
    }
    if(_idTypeSelec < 0){
      search('type', _idTypeSelec);
    }
    List<Widget> tab = List.empty(growable: true);
    if(_idTypeSelec > 0 || _idEtatSelec > 0 || _idLieuSelec > 0 || _idAnneeSelec > 0){
    var type;
    for(var elt in _listElt){
          for (var t in _listT['hydra:member']) {
            if (t['@id'] == elt['type']) {
              type = t;
            }
          }
          AssetImage img = _tools.findImg(type['libelle']);
          List<dynamic> tableau = [elt, type];
          tab.add(Widgets.createRowElt(
              elt, type, _textStyleHeaders, tableau, img, context));
          tab.add(
            Row(
              children: [
                SizedBox(
                  height: 100,
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
    }else{
      tab.add(const Text('Aucune selection'));
    }
  }

  void searchDate(){
    
  }

  void search(String recherche, int idSelec){
    for(var elt in _listM['hydra:member']){
      List<String> temp = elt[recherche].split('/');
      print(temp);
      int idSearch = int.parse(temp[temp.length - 1]);
      if(idSearch == idSelec){
        _listElt.add(elt);
      }
    }
    for(var elt in _listElt){
      List<String> temp = elt[recherche].split('/');
      int idSearch = int.parse(temp[temp.length - 1]);
      if(idSearch != idSelec){
        _listElt.remove(elt);
      }
    }
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
                'Choisissez vos filtres:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
              const Text('Etat: '),
              DropdownButton(
                value: _dropdownvalueEtat,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Strings.itemsEtat
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idEtatSelec = Strings.itemsEtat.indexOf(newValue!);
                  setState(() {
                    _dropdownvalueEtat = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Text('Type:'),
              DropdownButton(
                value: _dropdownvalueType,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Strings.itemsType
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idTypeSelec = Strings.itemsType.indexOf(newValue!);
                  setState(() {
                    _dropdownvalueType = newValue;
                    recupMateriels();
                  });
                },
              ),
              const Text('Lieu:'),
              DropdownButton(
                value: _dropdownvalueLieu,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Strings.itemsLieu
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _idLieuSelec = Strings.itemsLieu.indexOf(newValue!);
                  setState(() {
                    _dropdownvalueLieu = newValue;
                    recupMateriels();
                  });
                },
              ),
              ],),
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
          tooltip: 'Actualiser',
          child: const Icon(Icons.refresh_outlined)),
    );
  }
}
