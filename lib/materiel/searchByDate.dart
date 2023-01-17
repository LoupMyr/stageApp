import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:pdf/widgets.dart' as pw;
import 'package:stage/class/widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SearchByDate extends StatefulWidget {
  const SearchByDate({super.key, required this.title});

  final String title;

  @override
  State<SearchByDate> createState() => SearchByDateState();
}

class SearchByDateState extends State<SearchByDate> {
  final DateTime _selectedDate = DateTime.now();
  int _annee = -1;
  bool _isSelected = false;
  final Tools _tools = Tools();
  final TextStyle _ts = const TextStyle(fontSize: 20);
  var _materiels;
  var _types;
  Column _col = Column(
    children: const <Widget>[Text('Aucune année selectionné.')],
  );
  List<Widget> _tab = [];
  var _tabPdf = [];

  selectYear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selectionner  une année"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _annee = dateTime.year;
                  _isSelected = true;
                  recupMateriels();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> recupMateriels() async {
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
      _materiels = convert.jsonDecode(responseM.body);
      _types = convert.jsonDecode(responseT.body);
      createList();
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

  void createList() {
    for (var elt in _materiels['hydra:member']) {
      if (elt['dateAchat'].isNotEmpty && elt['dateAchat'] != null) {
        List<String> temp = elt['dateAchat'].split('-');
        int anneeElt = int.parse(temp[0]);
        if (anneeElt == _annee) {
          var type;
          for (var t in _types['hydra:member']) {
            if (t['@id'] == elt['type']) {
              type = t;
            }
          }
          AssetImage img = _tools.findImg(type['libelle']);
          List<dynamic> tableau = [elt, type];
          _tab.add(
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
                      child: Text(type['libelle'], style: _ts),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: Text(elt['marque'], style: _ts),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: Text(elt['modele'], style: _ts),
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
          _tabPdf = [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: <pw.Widget>[
                pw.SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: pw.Center(
                    child: pw.Text(type['libelle'],
                        style: pw.TextStyle(fontSize: 20)),
                  ),
                ),
                pw.SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: pw.Center(
                    child: pw.Text(elt['marque'],
                        style: pw.TextStyle(fontSize: 20)),
                  ),
                ),
                pw.SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 5,
                  child: pw.Center(
                    child: pw.Text(elt['modele'],
                        style: pw.TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ];
        }
      }
    }
    if (_tab.isNotEmpty) {
      _col = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tab,
      );
    } else {
      _col = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Aucun matériel n\'a été acquis en ${_annee.toString()}'),
      ]);
    }
    setState(() {
      _col;
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
    for (var elt in _materiels['hydra:member']) {
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

  Future<void> donwloadPdf() async {
    final pdf = createPdf();
    Directory pathDoc = await getApplicationDocumentsDirectory();
    final file = File('${pathDoc.path}/recap-stock-${_annee.toString()}.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  dynamic createPdf() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            children: _tabPdf,
          ),
        ),
      ),
    );

    return pdf;
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
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Text(
                'Selectionner une date:',
                style: _ts,
              ),
              IconButton(
                hoverColor: Colors.transparent,
                onPressed: selectYear,
                icon: const Icon(
                  Icons.calendar_today,
                  size: 25,
                ),
              ),
              _isSelected
                  ? Text(
                      'Date selectionné: ${_annee.toString()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text(''),
              const Padding(padding: EdgeInsets.all(10)),
              const Divider(thickness: 2),
              _col,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: donwloadPdf,
        child: const Icon(Icons.download),
      ),
    );
  }
}
