import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Product {
  final String productId;
  final String imageUrl;
  String desc;

  Product(this.productId, this.imageUrl, this.desc);

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'imageUrl': imageUrl,
      'desc': desc,
    };
  }
}

class AdminServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadImageToFireStorage(
      {required String childName, required Uint8List file}) async {
    String downloadUrl = '';
    try {
      String pid = Uuid().v1();
      Reference _ref = _storage
          .ref()
          .child(childName)
          .child(_auth.currentUser!.email!)
          .child(pid);
      UploadTask uploadTask = _ref.putData(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (err) {
      print(err.toString());
    }
    return downloadUrl;
  }

  Future<String> uploadProduct(
      {required BuildContext context,
      required String desc,
      required Uint8List file}) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await uploadImageToFireStorage(childName: 'roadworks', file: file);
      String productId = Uuid().v1();
      final _product = Product(productId, photoUrl, desc);

      await _firestore
          .collection('roadworks')
          .doc(_product.productId)
          .set(_product.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

getImage({required ImageSource source}) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  {
    print('No image selected');
  }
}
