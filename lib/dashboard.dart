import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetclassb2b/Model/Utilisateur.dart';
import 'package:projetclassb2b/chatPage.dart';
import 'package:projetclassb2b/detail.dart';
import 'package:projetclassb2b/functions/FirestoreHelper.dart';

class dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashboardState();
  }
}

class dashboardState extends State<dashboard> {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    friends = logged.friends;
    print(friends.length);
    return Scaffold(
      //drawer: myDrawer(),
      appBar: AppBar(
        title: Text("Mes contacts"),
      ),
      body: bodyPage(),
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
                  if (!friends.contains(user.id)) {
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
                        leading: (user.avatar == null)
                            ? Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"),
                                        fit: BoxFit.fill)),
                              )
                            : Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(user.avatar!),
                                        fit: BoxFit.fill)),
                              ),
                        title: Text("${user.pseudo}"),
                        trailing: IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
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
