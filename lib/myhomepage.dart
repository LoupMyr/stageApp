import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle _textStyle = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/routeListe'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    child: Text(
                      'Consulter la liste compléte',
                      textAlign: TextAlign.center,
                      style: _textStyle,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/routeByType'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text('Rechercher un type',
                          textAlign: TextAlign.center, style: _textStyle)),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/routeByEtat'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text('Rechercher un état',
                          textAlign: TextAlign.center, style: _textStyle)),
                ),
                const Padding(padding: EdgeInsets.all(2)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/routeAjout'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text('Ajouter un élément',
                          textAlign: TextAlign.center, style: _textStyle)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
