import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:projetclassb2b/detail.dart';
import 'package:projetclassb2b/functions/FirestoreHelper.dart';

import 'chat.dart';
import 'chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class FindFriendPage extends StatefulWidget {
  //final List<Chat> chats;

  //const FindFriendPage(this.chats, {Key? key}) : super(key: key);

  @override
  State<FindFriendPage> createState() => _FindFriendPageState();
}

class _FindFriendPageState extends State<FindFriendPage> {
  String pseudo = '';
  String uidFriend = '';
  bool isfriend = false;
  bool isSearching = false;

  void showNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Not Found'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  void PopUp(String popupMsg) {
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

  // void findUser() async {
  //   setState(() => isSearching = true);
  //   QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
  //       .instance
  //       .collection('users')
  //       .where('username', isEqualTo: pseudo)
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
  //   setState(() => isSearching = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un ami')),
      body: isSearching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pseudo de l'ami"),
                    onChanged: (val) => setState(() => pseudo = val),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // friendId = FirestoreHelper().getIdByUsername(pseudo);
                    print(pseudo);

                    FirestoreHelper().getIdByUsername(pseudo).then((value) => {
                          //print(value),
                          uidFriend = value,
                          FirestoreHelper()
                              .isFriendCheck(value)
                              .then((value) => {print(value), isfriend = value})
                        });
                    late String popupMsg;

                    print(uidFriend);
                    if (uidFriend == FirebaseAuth.instance.currentUser!.uid) {
                      PopUp("Vous ne pouvez pas vous ajouter vous même...");
                    } else if (uidFriend == '') {
                      PopUp("Utilisateur non trouvé");
                    } else if (isfriend == true) {
                      PopUp("Vous êtes déja amis");
                    } else {
                      FirestoreHelper().addFriend(uidFriend).then((value) {
                        print("ajout réussi");
                        popupMsg = "ajout terminée";
                        PopUp(popupMsg);
                      }).catchError((onError) {
                        print("ajout erroné");
                        popupMsg = "Erreur";
                        PopUp(popupMsg);
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Ajouter'),
                  ),
                ),
              ],
            ),
    );
  }
}


// if (!isFriend) {
//                 print("Boutton friends");
//                 FirestoreHelper().addFriend(widget.user.id).then((value) {
//                   print("ajout réussi");
//                   popupMsg = "ajout terminée";
//                   PopUp();
//                 }).catchError((onError) {
//                   print("ajout erroné");
//                   popupMsg = "Erreur";
//                   PopUp();
//                 });
//               } else {
//                 FirestoreHelper().removeFriend(widget.user.id).then((value) {
//                   print("friend removed");
//                   popupMsg = "Ami supprimé";
//                   PopUp();
//                 }).catchError((onError) {
//                   print("Erreur de suppression");
//                   popupMsg = "Erreur";
//                   PopUp();
//                 });
//               }



//               late bool isFriend = false;
//   @override
//   void initState() {
    // TODO: implement initState
  //   print(widget.user.id);
  //   FirestoreHelper().isFriendCheck(widget.user.id).then((value) {
  //     setState(() {
  //       isFriend = value;
  //     });
  //     print(isFriend);
  //   });
  //   super.initState();
  // }