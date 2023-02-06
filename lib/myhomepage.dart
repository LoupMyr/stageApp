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
  final TextStyle _textStyle =
      const TextStyle(fontSize: 20, color: Colors.black);
  List<Widget> _navbar = List.empty(growable: true);

  Future<String> checkUser() async {
    _navbar.clear();
    var role = await Local.storage.read(key: 'role');
    _navbar.add(IconButton(
      padding: const EdgeInsets.only(right: 20),
      tooltip: Strings.tooltipProfil,
      onPressed: () => Navigator.pushNamed(context, '/routeProfil'),
      icon: const Icon(Icons.person_outline),
      iconSize: 35,
    ));

    if (role == 'ROLE_ADMIN') {
      _navbar.add(IconButton(
        padding: const EdgeInsets.only(right: 20),
        tooltip: Strings.tooltipAdmin,
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
          _navbar = List.empty(growable: true);
        }
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 150,
            leading: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image(
                    image: AssetImage('assets/achicourt.png'),
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
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 30),
            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/buttons/checklist.png'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.listButtonStr,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeListe');
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/buttons/filter.png'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.filterLabelbtn,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeByFiltres');
                        },
                      ),
                    ],
                  ),
                  SizedBox.fromSize(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.05)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/buttons/multiImg.png'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.searchTypeButtonStr,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeByType');
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/buttons/brokenPc.jpg'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.searchEtatButtonStr,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeByEtat');
                        },
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/buttons/mairie.jpg'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.searchPlaceButtonStr,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeByLieu');
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      MaterialButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.black,
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/buttons/calendar.jpg'),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(Strings.searchYearButtonStr,
                                  textAlign: TextAlign.center,
                                  style: _textStyle),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeByDate');
                        },
                      ),
                    ],
                  ),
                  SizedBox.fromSize(
                      size: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.05)),
                  MaterialButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.black,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/buttons/multiImg.png'),
                            fit: BoxFit.cover,
                            opacity: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(Strings.addEltButtonStr,
                              textAlign: TextAlign.center, style: _textStyle),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/routeAjout',
                          arguments: []);
                    },
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
