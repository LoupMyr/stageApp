import 'package:flutter/material.dart';
import 'package:stage/local.dart';
import 'package:stage/tools.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextStyle _textStyle = const TextStyle(fontSize: 20);
  List<Widget> _navbar = [];
  Future<String> checkUser() async {
    var role = await Local.storage.read(key: 'role');
    if (role == 'ROLE_ADMIN') {
      _navbar = [
        IconButton(
          padding: EdgeInsets.only(right: 20),
          tooltip: 'Administration',
          onPressed: () => Navigator.pushNamed(context, '/routeListeUsers'),
          icon: const Icon(Icons.person_outline),
          iconSize: 35,
        )
      ];
    }
    return '';
  }

  void logout() async {
    Local.storage.deleteAll();
    Navigator.pushReplacementNamed(context, '/routeConnexion');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          _navbar = [];
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: 'Deconnexion',
              icon: const Icon(Icons.logout_sharp),
              onPressed: logout,
            ),
            centerTitle: true,
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 30),
            ),
            actions: _navbar,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/routeListe'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  SizedBox.fromSize(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.05)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/routeByType'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: Text('Rechercher un type',
                                textAlign: TextAlign.center,
                                style: _textStyle)),
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/routeByEtat'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: Text('Rechercher un état',
                                textAlign: TextAlign.center,
                                style: _textStyle)),
                      ),
                    ],
                  ),
                  SizedBox.fromSize(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.05)),
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
        );
      },
    );
  }
}
