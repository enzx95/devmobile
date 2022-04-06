import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetclassb2b/Model/Utilisateur.dart';
import 'package:projetclassb2b/contact.dart';
import 'package:projetclassb2b/functions/FirestoreHelper.dart';

import 'chat.dart';

import 'package:projetclassb2b/contact.dart';

import 'chat.dart';
import 'chatPage.dart';
import 'find_friend_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'chatPage.dart';

class detail extends StatefulWidget {
  Utilisateur user;
  List<Chat> chats = [];
  Utilisateur logged;

  detail({required Utilisateur this.user, required Utilisateur this.logged});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return detailState();
  }
}

class detailState extends State<detail> {
  late bool isFriend = false;
  @override
  void initState() {
    // TODO: implement initState
    print(widget.user.id);
    FirestoreHelper().isFriendCheck(widget.user.id).then((value) {
      setState(() {
        isFriend = value;
      });
      print(isFriend);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.pseudo}"),
        ),
        body: Center(
          child: bodyPage(),
        ));
  }

  late String popupMsg;

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

  // void showNotFoundDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         content: const Text('Not Found'),
  //         actions: [
  //           TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'))
  //         ],
  //       );
  //     },
  //   );
  // }

  // void findUser() async {
  //   QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
  //       .instance
  //       .collection('users')
  //       .where('username', isEqualTo: widget.user.pseudo)
  //       .get();
  //   print(result.docs);
  //   if (result.docs.isEmpty) {
  //     showNotFoundDialog();
  //   } else {
  //     String friendId = result.docs.first.id;
  //     if (friendId == FirebaseAuth.instance.currentUser!.uid) {
  //       showNotFoundDialog();
  //     } else {
  //       Chat? chat =
  //           widget.chats.firstWhereOrNull((e) => e.friendId == friendId);
  //       if (chat != null) {
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (_) => ChatPage(chat!)));
  //       } else {
  //         chat = Chat(friendId,
  //             friendUsername: result.docs.first.data()['username'],
  //             messages: []);
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (_) => ChatPage(chat!)));
  //       }
  //     }
  //   }
  // }
  // Future<List<String>> getContacts() async {
  //   final Future<String> uid = FirestoreHelper().getIdentifiant();
  //   final currentUser = [];
  //   final groups = [];
  //   // Get User document
  //   await firestore
  //       .collection('UserNames')
  //       .document(uid)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //     currentUser.add(snapshot.data);
  //   });
  //   // Get groupeId from currentUser Data
  //   final groupId = currentUser[0]['groupId'];

  //   // Get groupe Document
  //   await firestore
  //       .collection('Groups')
  //       .document(groupId)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //     groups.add(snapshot.data);
  //   });

  //   return groups[0]['members'];
  // }

  Widget bodyPage() {
    // late bool isFriend;

    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (widget.user.avatar == null)
                    ? NetworkImage(
                        "https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg")
                    : NetworkImage(widget.user.avatar!),
                fit: BoxFit.fill,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.mail), Text(widget.user.mail)],
        ),
        Text("${widget.user.pseudo}"),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              if (!isFriend) {
                print("Boutton friends");
                FirestoreHelper().addFriend(widget.user.id).then((value) {
                  print("ajout réussi");
                  popupMsg = "ajout terminée";
                  PopUp();
                }).catchError((onError) {
                  print("ajout erroné");
                  popupMsg = "Erreur";
                  PopUp();
                });
              } else {
                FirestoreHelper().removeFriend(widget.user.id).then((value) {
                  print("friend removed");
                  // popupMsg = "Ami supprimé";
                  // PopUp();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text('Suppression effectuée'),
                        actions: [
                          TextButton(
                              onPressed: () => {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => contact())),
                                    setState(() {})
                                  },
                              child: const Text('OK'))
                        ],
                      );
                    },
                  );
                }).catchError((onError) {
                  print("Erreur de suppression");
                  popupMsg = "Erreur";
                  PopUp();
                });
              }
              //FirestoreHelper().Incription(mail, password, pseudo);
            },
            child: isFriend ? Text("Retirer l'ami") : Text("ajouter ami"))
      ],
    );
  }
}
