import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stage/tools.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AjoutPage extends StatefulWidget {
  const AjoutPage({super.key, required this.title});

  final String title;

  @override
  State<AjoutPage> createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  final Tools _tool = Tools();
  final _formKey = GlobalKey<FormState>();
  String _marque = '';
  String _modele = '';
  String _remarques = '';
  String _dateAchat = '';
  String _dateGaranti = '';
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Marque'),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Saisie vide';
                      } else {
                        _marque = valeur.toString();
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Modèle'),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return 'Saisie vide';
                      } else {
                        _modele = valeur.toString();
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text('Date d\'achat: '),
                    ),
                    IconButton(
                        hoverColor: Colors.transparent,
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _dateAchat = formattedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today)),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text('Date de fin de garanti: '),
                    ),
                    IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateGaranti = formattedDate;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(hintText: 'Remarques'),
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        _remarques = '';
                      } else {
                        _remarques = valeur.toString();
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Text('Photo: '),
                    ),
                    IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : const Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
