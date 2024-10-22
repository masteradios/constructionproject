import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hiten/providers/userProvider.dart';
import 'package:hiten/showSnackBar.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String> createUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      ModelUser user = ModelUser(
          email: email, uid: cred.user!.uid, phoneNumber: '', name: email);
      uploadUserDetails(user: user);

      res = 'User Created Successfully';
    } on FirebaseAuthException catch (err) {
      print(err.toString());
    }
    return res;
  }

  Future<ModelUser> getUserDetails({required BuildContext context}) async {
    ModelUser user = ModelUser(email: '', uid: '', phoneNumber: '', name: '');
    try {
      DocumentSnapshot snap = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      print('in getting userdetails ' +
          firebaseAuth.currentUser!.email.toString());
      user = ModelUser.fromSnap(snap);
      Provider.of<UserProvider>(context, listen: false).refreshUser(user: user);
    } catch (err) {
      print(err.toString());
    }
    return user;
  }

  Future<void> uploadUserDetails({required ModelUser user}) async {
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(user.toJson());
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> signInUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(firebaseAuth.currentUser!.email);
    } catch (err) {
      displaySnackBar(context: context, content: err.toString());
    }
  }
}
