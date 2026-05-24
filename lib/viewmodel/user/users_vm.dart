import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/user/users.dart';
import '../../repository/user/users_repo.dart';


class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  String email = '';
  String password = '';
  String name = '';
  bool isLoading = false;
  UserModel? currentUser;
  StreamSubscription? _userSub;

  bool _isUserLoaded = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setEmail(String value) => email = value;
  void setPassword(String value) => password = value;
  void setName(String value) => name = value;



  void clearUserInput(){
    email='';
    password='';
  }


  bool isGenderSelected = false;



  Future<void> login(BuildContext context) async {
    _setLoading(true);
    try {
      currentUser = await _repo.login(email, password);
      _success(context, "Login Success");
    } catch (e) {
      _error(context, e.toString());
    }
    _setLoading(false);
  }

  Future<void> signup(BuildContext context) async {
    _setLoading(true);
    try {
      currentUser = await _repo.signup(name, email, password);
      _success(context, "Signup Success");
    } catch (e) {
      _error(context, e.toString());
    }
    _setLoading(false);
  }

  Future<void> googleSignIn(BuildContext context) async {
    _setLoading(true);
    try {
      currentUser = await _repo.signInWithGoogle();
      _success(context, "Google Login Success");
    } catch (e) {
      _error(context, e.toString());
    }
    _setLoading(false);
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    try {
      await _repo.logout();
      _success(context, "Logout Success");
    } catch (e) {
      _error(context, e.toString());
    }
    _setLoading(false);
  }

  /**
      Future<void> loadUser() async {

      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return;

      if (currentUser != null) return;

      isLoading = true;
      notifyListeners();

      currentUser = await _repo.getUser(firebaseUser.uid);

      isLoading = false;
      notifyListeners();
      }
   **/

  void loadUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _userSub?.cancel(); // prevent duplicate listeners

    _userSub = _repo.getUser(uid).listen((user) {
      print(" USER UPDATE: ${user?.name}");
      currentUser = user;
      notifyListeners(); //  auto UI update
    });
  }

  //  FORCE REFRESH (if needed)
  /*
  Future<void> refreshUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    currentUser = await _repo.getUser(firebaseUser.uid);
    notifyListeners();
  }
   */

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _success(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }


  Future<void> checkUserSetup(String userId) async {
    isGenderSelected = await _repo.checkUserSetup(userId);
    notifyListeners();
  }

  Future<void> saveGender(String userId, String gender) async {
    await _repo.saveGender(userId, gender);
    isGenderSelected = true;
    notifyListeners();
  }


  //  CLEANUP
  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}
