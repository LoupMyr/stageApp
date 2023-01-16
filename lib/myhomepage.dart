import 'package:flutter/material.dart';
import 'package:stage/class/local.dart';

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
    _navbar.clear();
    var role = await Local.storage.read(key: 'role');
    _navbar.add(IconButton(
      padding: const EdgeInsets.only(right: 20),
      tooltip: 'Profil',
      onPressed: () => Navigator.pushNamed(context, '/routeProfil'),
      icon: const Icon(Icons.person_outline, color: Colors.black),
      iconSize: 35,
    ));
    if (role == 'ROLE_ADMIN') {
      _navbar.add(IconButton(
        padding: const EdgeInsets.only(right: 20),
        tooltip: 'Administration',
        onPressed: () => Navigator.pushNamed(context, '/routeListeUsers'),
        icon: const Icon(
          Icons.admin_panel_settings,
          color: Colors.black,
        ),
        iconSize: 35,
      ));
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
          body: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 300.0,
              leading: IconButton(
                tooltip: 'Deconnexion',
                icon: const Icon(Icons.logout_sharp, color: Colors.black),
                onPressed: logout,
              ),
              actions: _navbar,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      decoration: TextDecoration.underline),
                ),
                background: Column(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Image(
                      image: const AssetImage(
                        'lib/assets/achicourt.png',
                      ),
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.32,
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/routeListe'),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/routeByType'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                child: Text('Rechercher un type',
                                    textAlign: TextAlign.center,
                                    style: _textStyle)),
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/routeByEtat'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: Colors.black),
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
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/routeAjout'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: Text('Ajouter un élément',
                                textAlign: TextAlign.center,
                                style: _textStyle)),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05)),
                    ],
                  ),
                );
              }, childCount: 1),
            ),
          ]),
        );
      },
    );
  }
}
