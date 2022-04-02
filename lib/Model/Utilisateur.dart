import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  //Attributs
  String id = "";
  String? avatar;
  //String nom = "";
  String pseudo = "";
  String mail = "";
  String? telephone;
  bool isConnected = false;
  DateTime birthDay = DateTime.now();

  //Contructeur
  Utilisateur(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    //nom = map["NOM"];
    pseudo = map["username"];
    mail = map["mail"];
    telephone = map["TELEPHONE"];
    avatar = map["AVATAR"];
  }

  Utilisateur.vide();

  //Méthodes

}
