import 'package:flutter/material.dart';
import 'package:stage/class/local.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key, required this.title});

  final String title;

  @override
  State<ConnexionPage> createState() => ConnexionPageState();
}

class ConnexionPageState extends State<ConnexionPage> {
  final Tools _tools = Tools();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _mdp = '';
  bool _isChecked = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  void connect() async {
    var response = await _tools.authenticationUser(_email, _mdp);
    if (response.statusCode == 200) {
      var token = convert.jsonDecode(response.body);
      await Local.storage.write(key: 'token', value: token['token']);
      await Local.storage.write(key: 'email', value: _email);
      await Local.storage.write(key: 'password', value: _mdp);
      await Local.storage.write(key: 'role', value: token['data']['roles'][0]);
      await Local.storage
          .write(key: 'id', value: token['data']['id'].toString());
      Navigator.pushReplacementNamed(context, '/routeHome');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.welcomeStr),
      ));
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.invalidCredentialsStr),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${Strings.errorStr} ${response.statusCode.toString()}'),
      ));
    }
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleRemeberme(bool value) {
    _isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image(
                image: AssetImage('lib/assets/achicourt.png'),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
              tooltip: Strings.registerToolTip,
              padding: const EdgeInsets.only(right: 30),
              iconSize: 30,
              icon: const Icon(Icons.person_add),
              onPressed: () =>
                  Navigator.pushNamed(context, '/routeInscription')),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(100.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: Strings.emailLabel),
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return Strings.emptyInputStr;
                          } else {
                            setState(() {
                              _email = valeur;
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: Strings.passwordLabel),
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return Strings.emptyInputStr;
                          } else {
                            setState(() {
                              _mdp = valeur;
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
                    SizedBox(
                      height: 24.0,
                      width: 50.0,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.blue,
                        ),
                        child: Checkbox(
                          activeColor: Colors.blue,
                          value: _isChecked,
                          onChanged: (bool? value) {
                            _handleRemeberme(value!);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      Strings.rememberMeStr,
                      style: TextStyle(
                        color: Color(0xff646464),
                        fontSize: 12,
                        fontFamily: 'Rubic',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(40)),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          connect();
                        }
                      },
                      child: const Text(Strings.connectButtonStr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
