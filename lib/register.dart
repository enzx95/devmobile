import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetclassb2b/dashboard.dart';
import 'package:projetclassb2b/functions/FirestoreHelper.dart';

class register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return registerState();
  }
}

class registerState extends State<register> {
  String mail = "";
  late String popupMsg;
  late String password;
  //late String nom;
  late String pseudo;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Inscription"),
          centerTitle: true,
        ),
        body: Container(
          child: bodyPage(),
          padding: EdgeInsets.all(20),
        ));
  }

  PopUp() {
    showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(popupMsg),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          } else {
            return AlertDialog(
              title: Text(popupMsg),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          }
        });
  }

  Widget bodyPage() {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              mail = value;
            });
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Entrer votre adresse mail",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Entrer votre mot de passe",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              pseudo = value;
            });
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Entrer votre pseudo",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // TextField(
        //   onChanged: (value) {
        //     setState(() {
        //       nom = value;
        //     });
        //   },
        //   decoration: InputDecoration(
        //       filled: true,
        //       fillColor: Colors.white,
        //       hintText: "Entrer votre nom",
        //       border:
        //           OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        // ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              print("Boutton register");
              FirestoreHelper()
                  .Incription(mail, password, pseudo)
                  .then((value) {
                print("Inscription réussi");
                popupMsg = "Inscription terminée";
                PopUp();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return dashboard();
                }));
              }).catchError((onError) {
                print("Inscription erroné");
                popupMsg = "Email/Username déja utilisé";
                PopUp();
              });

              //FirestoreHelper().Incription(mail, password, pseudo);
            },
            child: Text("Inscription")),
      ],
    );
  }
}
