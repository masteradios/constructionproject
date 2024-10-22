import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  ModelUser _user = ModelUser(
      email: 'email', uid: 'uid', phoneNumber: 'phoneNumber', name: 'name');
  ModelUser get getUser => _user;

  Future<void> refreshUser({required ModelUser user}) async {
    _user = user;
    notifyListeners();
  }
}
