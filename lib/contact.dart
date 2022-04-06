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
import 'detail.dart';
import 'find_friend_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'chatPage.dart';

class contact extends StatefulWidget {
  List<Chat> chats = [];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return contactState();
  }
}

class contactState extends State<contact> {
  late Utilisateur logged;
  List friends = [];

  @override
  void initState() {
    // TODO: implement initState
    FirestoreHelper().getIdentifiant().then((value) {
      setState(() {
        String id = value;
        FirestoreHelper().getUtilisateur(id).then((value) {
          print('done');
          setState(() {
            logged = value;
          });
        });
      });
    });

    //friends = logged.friends;

    super.initState();
  }

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

  void findUser(String username) async {
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    //print(UserId);
    print(result.docs);
    if (result.docs.isEmpty) {
      showNotFoundDialog();
    } else {
      String friendId = result.docs.first.id;
      if (friendId == FirebaseAuth.instance.currentUser!.uid) {
        showNotFoundDialog();
      } else {
        Chat? chat =
            widget.chats.firstWhereOrNull((e) => e.friendId == friendId);
        if (chat != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ChatPage(chat!)));
        } else {
          chat = Chat(friendId,
              friendUsername: result.docs.first.data()['username'],
              messages: []);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ChatPage(chat!)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    friends = logged.friends;
    print(friends.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes contacts"),
      ),
      body: bodyPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => FindFriendPage())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bodyPage() {
    //List friends = logged.friends;

    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Utilisateur user = Utilisateur(documents[index]);
                  //for (var i = 0; i < friends.length; i++) {
                  if (friends.contains(user.id)) {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return detail(
                              user: user,
                              logged: logged,
                            );
                          }));
                        },
                        title: Text("${user.pseudo}"),
                        trailing: IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            findUser(user.pseudo);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return chat(
                            //     user: user,
                            //     logged: logged,
                            //   );
                            // }));
                            // print("modification");
                          },
                        ),
                      ),
                    );
                  } else {
                    //return Card();
                    //}
                  }

                  return SizedBox.shrink();
                });
          }
        });
  }
}
