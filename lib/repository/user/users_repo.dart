import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/user/users.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isGenderSelected = false;

  // Save user to Firestore
  Future<void> _saveUser(UserModel user) async {
    final doc = _firestore.collection('user').doc(user.id);

    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set(user.toJson());
    }
  }

  // Get user from firestore
  Stream<UserModel?> getUser(String uid) {
    return _firestore
        .collection('user')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }


  Future<bool> checkUserSetup(String userId) async {
    final doc = await _firestore
        .collection('user')
        .doc(userId)
        .get();

    final isGenderSelected = doc.data()?['isGenderSelected'] != false
        && doc.data()?['isGenderSelected'] != null;
    return isGenderSelected;
  }

  Future<bool> saveGender(String userId, String gender) async {
    await _firestore
        .collection('user')
        .doc(userId)
        .update({
      "isGenderSelected": true,
      "isSelectgender": gender,
    });
    return isGenderSelected;
  }


  // Email Login
  Future<UserModel?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) return null;

    final userModel = UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );

    await _saveUser(userModel);

    return userModel;
  }

  // Signup
  Future<UserModel?> signup(String name, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) return null;

    await user.updateDisplayName(name);

    final userModel = UserModel(
      id: user.uid,
      name: name,
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isGenderSelected: false,
      isSelectgender: '',
      points: 0, // welcome bonus 💰
    );

    await _saveUser(userModel);

    return userModel;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) return null;

    final userModel = UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      isGenderSelected: false,
      isSelectgender: '',
      points: 0,
    );

    await _saveUser(userModel);

    return userModel;
  }

}
  Future<void> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
  }