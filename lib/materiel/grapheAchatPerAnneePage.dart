import 'package:stage/class/achatPerYear.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class GrapheAchatPerAnneePage extends StatefulWidget {
  const GrapheAchatPerAnneePage({super.key, required this.title});
  final String title;

  @override
  State<GrapheAchatPerAnneePage> createState() =>
      GrapheAchatPerAnneePageState();
}

class GrapheAchatPerAnneePageState extends State<GrapheAchatPerAnneePage> {
  Tools _tools = Tools();
  var _materiels;
  List<AchatPerYear> _listTotal = List.empty(growable: true);
  DateTime _selectedDateDebut = DateTime.now();
  int _anneeDebut = -1;
  bool _isSelectedDebut = false;
  DateTime _selectedDateFin = DateTime(DateTime.now().year + 5, 1);
  int _anneeFin = -1;
  int _difference = 0;
  bool _isSelectedFin = false;
  Column _column = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Text('Aucune selection ou selection invalide'),
    ],
  );

  selectYearDebut() {
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
              selectedDate: _selectedDateDebut,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _anneeDebut = dateTime.year;
                  _isSelectedDebut = true;
                  testSelect();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  selectYearFin() {
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
              selectedDate: _selectedDateFin,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _anneeFin = dateTime.year;
                  _isSelectedFin = true;
                  testSelect();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Future<String> recupMateriels() async {
    var response = await _tools.getMateriels();
    if (response.statusCode == 200) {
      _materiels = convert.jsonDecode(response.body);
      _materiels = _tools.sortListByDateAchat(_materiels['hydra:member']);
      findMateriels();
      createGraphe();
    }
    return '';
  }

  void testSelect() async {
    if (_isSelectedDebut && _isSelectedFin && _anneeFin - _anneeDebut > 0) {
      _column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SpinKitThreeInOut(color: Colors.teal),
        ],
      );
      await recupMateriels();
    } else {
      _column = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('Aucune selection ou selection invalide'),
        ],
      );
      setState(() {
        _column;
      });
    }
  }

  void findMateriels() {
    _listTotal.clear();
    _difference = _anneeFin - _anneeDebut;
    for (int i = _anneeDebut; i <= _anneeFin; i++) {
      double total = 0;
      for (var elt in _materiels) {
        int annee = int.parse(
            DateFormat('yyyy').format(DateTime.parse(elt['dateAchat'])));
        if (annee == i) {
          total++;
        }
      }
      _listTotal.add(new AchatPerYear(i.toString(), total));
    }
  }

  void createGraphe() {
    _column = Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            child: SfCartesianChart(
              title: ChartTitle(
                  text: 'Matériels acheté entre $_anneeDebut et $_anneeFin',
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              primaryXAxis: CategoryAxis(
                  interval: 1,
                  labelRotation: (_difference) * 5,
                  labelAlignment: LabelAlignment.end),
              primaryYAxis: NumericAxis(minimum: 0, interval: 1),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<AchatPerYear, String>>[
                ColumnSeries<AchatPerYear, String>(
                    onPointTap: (pointInteractionDetails) => null,
                    width: 0.5,
                    dataSource: _listTotal,
                    xValueMapper: (AchatPerYear data, index) => data.getAnnee(),
                    yValueMapper: (AchatPerYear data, index) => data.getTotal(),
                    name: 'Total:',
                    color: const Color.fromRGBO(8, 142, 255, 1))
              ],
            ),
          ),
        ),
      ],
    );
    setState(() {
      _column;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.createAppBar(widget.title, context),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Selectionner un interval:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  tooltip: 'Année de début',
                  hoverColor: Colors.transparent,
                  onPressed: selectYearDebut,
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 25,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                IconButton(
                  tooltip: 'Année de fin',
                  hoverColor: Colors.transparent,
                  onPressed: selectYearFin,
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 25,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isSelectedDebut
                    ? Text(_anneeDebut.toString())
                    : const Text(''),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
                _isSelectedFin ? Text(_anneeFin.toString()) : const Text(''),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 25)),
            const Divider(thickness: 2),
            _column,
          ],
        ),
      ),
    );
  }
}
