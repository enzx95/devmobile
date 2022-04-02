import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projetclassb2b/Model/Utilisateur.dart';

class FirestoreHelper {
  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_user = FirebaseFirestore.instance.collection("users");
  final fireStorage = FirebaseStorage.instance;

  //Constructeur

  //méthode

//Pour l'inscription
  Future Incription(String mail, String password, String pseudo) async {
    final valid = await usernameCheck(pseudo);
    if (!valid) {
      // username exists
      throw Exception('username exists');
    }
    UserCredential resultat = await auth.createUserWithEmailAndPassword(
        email: mail, password: password);

    User? user = resultat.user;
    String uid = user!.uid;

    Map<String, dynamic> map = {"username": pseudo, "mail": mail};
    addUser(uid, map);
  }

//Pour la connexion

  Future Connexion(String mail, String password) async {
    UserCredential resultat =
        await auth.signInWithEmailAndPassword(email: mail, password: password);
  }

//Ajouter des utilisateurs
  addUser(String uid, Map<String, dynamic> map) {
    fire_user.doc(uid).set(map);
  }

//Modifier les informations d'un utilisateur
  updatedUser(String uid, Map<String, dynamic> map) {
    fire_user.doc(uid).update(map);
  }

  Future<String> getIdentifiant() async {
    String uid = auth.currentUser!.uid;
    return uid;
  }

  Future<Utilisateur> getUtilisateur(String uid) async {
    DocumentSnapshot snapshot = await fire_user.doc(uid).get();
    return Utilisateur(snapshot);
  }

  Future<String> stockageImage(String nameFile, Uint8List datas) async {
    TaskSnapshot snapshot =
        await fireStorage.ref("image/$nameFile").putData(datas);
    String urlChemin = await snapshot.ref.getDownloadURL();
    return urlChemin;
  }

  Future<bool> usernameCheck(String username) async {
    final result = await fire_user.where('username', isEqualTo: username).get();
    return result.docs.isEmpty;
  }
}
