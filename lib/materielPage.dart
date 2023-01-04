import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaterielPage extends StatefulWidget {
  const MaterielPage({super.key, required this.title});

  final String title;

  @override
  State<MaterielPage> createState() => MaterielPageState();
}

class MaterielPageState extends State<MaterielPage> {
  List<dynamic> _tab = [];
  final TextStyle _textStyle = TextStyle(fontSize: 20);
  final TextStyle _textStyleHeaders = const TextStyle(fontSize: 30);

  @override
  Widget build(BuildContext context) {
    _tab = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    var materiel = _tab[0];
    var type = _tab[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Type', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Marque', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Modele', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Date \nd\'achat', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child:
                        Text('Date fin de garantie', style: _textStyleHeaders),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text('Remarques', style: _textStyleHeaders),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(type['libelle'], style: _textStyle),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(materiel['marque'], style: _textStyle),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(materiel['modele'], style: _textStyle),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(materiel['dateAchat']))
                            .toString(),
                        style: _textStyle),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(materiel['dateFinGaranti']))
                            .toString(),
                        style: _textStyle),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width / 7,
                    child: SingleChildScrollView(
                      child: Text(materiel['remarques'],
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
