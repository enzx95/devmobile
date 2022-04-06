import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projetclassb2b/Model/Utilisateur.dart';

class FirestoreHelper {
  //Attributs
  final auth = FirebaseAuth.instance;
  final fireStorage = FirebaseStorage.instance;
  final fire_user = FirebaseFirestore.instance.collection("users");
  final fire_chat = FirebaseFirestore.instance.collection("ChatRoom");

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

    Map<String, dynamic> map = {
      "username": pseudo,
      "mail": mail,
      "friends": []
    };
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

  // Future addChatRoom(chatRoom, chatRoomId) {
  //   return fire_chat.doc(chatRoomId).set(chatRoom).catchError((e) {
  //     print(e);
  //   });
  // }

  // getChats(String chatRoomId) async {
  //   return fire_chat
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .orderBy('time')
  //       .snapshots();
  // }

  // Future<void> addMessage(String chatRoomId, chatMessageData) {
  //   return fire_chat
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .add(chatMessageData)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  // getUserChats(String itIsMyName) async {
  //   return await fire_chat
  //       .where('users', arrayContains: itIsMyName)
  //       .snapshots();
  // }

  addFriend(String friendUid) async {
    fire_user.doc(auth.currentUser!.uid).update({
      'friends': FieldValue.arrayUnion([friendUid])
    });
  }

  removeFriend(String friendUid) async {
    fire_user.doc(auth.currentUser!.uid).update({
      'friends': FieldValue.arrayRemove([friendUid])
    });
  }

  Future<bool> isFriendCheck(String friendUid) async {
    final result =
        await fire_user.where('friends', arrayContains: friendUid).get();
    return result.docs.isNotEmpty;
  }

  Future<String> getIdByUsername(String username) async {
    Future<String> uid;
    // Query queryUsername = fire_user.where('username', isEqualTo: username);
    // queryUsername.get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc.id);
    //     'doc.id';
    //   });
    // });
    // return uid;
    // get a new reference for a document in the medicine collection
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnap.docs.isEmpty) {
      return '';
    }
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.
    return doc.id;
  }
}
