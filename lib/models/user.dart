import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUser {
  final String email;
  final String uid;
  final String phoneNumber;
  final String userType;
  final String name;

  ModelUser(
      {required this.email,
      required this.uid,
      required this.phoneNumber,
      required this.name,
      this.userType = 'worker'});

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'userType': userType,
        'uid': uid
      };

  static ModelUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ModelUser(
        userType: snapshot['userType'] ?? '',
        email: snapshot['email'] ?? '',
        uid: snapshot['uid'] ?? '',
        phoneNumber: snapshot['phoneNumber'] ?? '',
        name: snapshot['name'] ?? '');
  }
}
