import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:stage/class/strings.dart';
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
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);
  var _materiels;
  var _types;
  Column _col = Column(children: const <Widget>[]);
  final List<dynamic> _listMateriels = List.empty(growable: true);
  final List<Widget> _tab = List.empty(growable: true);
  List<List<dynamic>> _tabSorted = List.empty(growable: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  selectYear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.selectYearTitle),
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
      Widgets.buildNonAdmin(context);
      return;
    }
    _col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
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

  void createList() {
    _listMateriels.clear();
    _tab.clear();
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
          _listMateriels.add(elt);
          AssetImage img = _tools.findImg(type['libelle']);
          List<dynamic> tableau = [elt, type];
          _tab.add(Widgets.createRow(
              elt, type, _textStyleHeaders, tableau, img, context));
          _tab.add(
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width / 5,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteElt(elt['id'].toString()),
              ),
            ),
          );
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
        Text(Strings.emptyEltByYearStr + _annee.toString()),
      ]);
    }
    setState(() {
      _col;
    });
  }

  Future<void> deleteElt(String id) async {
    await Widgets.buildDeletePopUp(id, _materiels, _scaffoldKey);
    setState(() {
      recupMateriels();
    });
  }

  Future<void> donwloadPdf() async {
    final pdf = createPdf();
    Directory pathDoc = await getApplicationDocumentsDirectory();
    final file = File('${pathDoc.path}/recap-stock-${_annee.toString()}.pdf');
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(Strings.pdfDownloadSuccessful),
    ));
  }

  pw.Document createPdf() {
    _tabSorted = _tools.sortByType(_types, _listMateriels);
    final pdf = pw.Document();
    for (int i = 0; i < _tabSorted.length; i++) {
      if (_tabSorted[i].isNotEmpty) {
        List<pw.Widget> body = createBody(i);
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
              child: pw.Column(
                children: body,
              ),
            ),
          ),
        );
      }
    }
    return pdf;
  }

  List<pw.Widget> createBody(int i) {
    List<dynamic> tab = _tabSorted[i];
    String nomType = _types['hydra:member'][i]['libelle'];
    List<pw.Widget> body = List.empty(growable: true);
    body.add(pw.Text(nomType,
        style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)));
    body.add(pw.Padding(padding: const pw.EdgeInsets.only(bottom: 30)));
    for (var elt in tab) {
      body.add(pw.Divider(thickness: 3));
      body.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.SizedBox(
              child: pw.Text(elt['modele']),
            ),
          ],
        ),
      );
      body.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.SizedBox(
              child: pw.Text(elt['marque']),
            ),
          ],
        ),
      );
      body.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.SizedBox(
            child: pw.Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(elt['dateAchat']))
                  .toString(),
            ),
          ),
        ],
      ));
    }
    return body;
  }

  dynamic downloadButton() {
    if (_isSelected) {
      return FloatingActionButton(
        onPressed: donwloadPdf,
        child: const Icon(Icons.download),
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Widgets.createAppBar(widget.title, context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Text(
                Strings.selectYearTitle,
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
                      Strings.yearSelectedStr + _annee.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text(Strings.yearEmptyStr),
              const Padding(padding: EdgeInsets.all(10)),
              const Divider(thickness: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: Widgets.createHeaders(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _col,
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isSelected
          ? FloatingActionButton(
              onPressed: donwloadPdf, child: const Icon(Icons.download))
          : null,
    );
  }
}
