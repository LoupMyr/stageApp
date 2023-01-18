import 'package:flutter/material.dart';
import 'package:stage/class/strings.dart';
import 'package:stage/class/tools.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key, required this.title});

  final String title;

  @override
  State<InscriptionPage> createState() => InscriptionPageState();
}

class InscriptionPageState extends State<InscriptionPage> {
  final Tools _tools = Tools();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _mdp = '';

  void signUp() async {
    var response = await _tools.postUser(_email, _mdp);
    if (response.statusCode == 201) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.registerSuccessfullStr),
      ));
    } else if (response.statusCode == 402) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(Strings.emailInUsedStr),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${Strings.errorStr}${response.statusCode.toString()}'),
      ));
    }
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
              tooltip: Strings.backToolTip,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(100.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0), width: 3)),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
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
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: Strings.confirmPasswordLabel),
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return Strings.emptyInputStr;
                          } else if (valeur != _mdp) {
                            return Strings.differentPasswords;
                          }
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(40)),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: const Text(Strings.registerButtonStr),
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
