import 'package:flutter/material.dart';
import 'package:stage/class/local.dart';
import 'package:stage/class/strings.dart';

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
      icon: const Icon(Icons.person_outline),
      iconSize: 35,
    ));

    if (role == 'ROLE_ADMIN') {
      _navbar.add(IconButton(
        padding: const EdgeInsets.only(right: 20),
        tooltip: 'Administration',
        onPressed: () => Navigator.pushNamed(context, '/routeListeUsers'),
        icon: const Icon(Icons.admin_panel_settings),
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
                  tooltip: Strings.logoutToolTip,
                  onPressed: logout,
                  icon: const Icon(Icons.logout_outlined),
                  iconSize: 35,
                ),
              ],
            ),
            actions: _navbar,
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text(
                        Strings.listButtonStr,
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
                            child: Text(Strings.searchTypeButtonStr,
                                textAlign: TextAlign.center,
                                style: _textStyle)),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/routeByDate'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: Text(Strings.searchYearButtonStr,
                                textAlign: TextAlign.center,
                                style: _textStyle)),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                            child: Text(Strings.searchEtatButtonStr,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: Text(Strings.addEltButtonStr,
                            textAlign: TextAlign.center, style: _textStyle)),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
