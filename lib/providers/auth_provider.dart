import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/user_model.dart';
import 'package:weather/otp_screen.dart';
import 'package:weather/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  // ignore: unused_field
  bool _isLoading = false;
  bool get isLoading => true;
  String? _uid;
  String? get uid => _uid;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;
  //
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //
  AuthProvider() {
    checkSignIn();
  }
  //
  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool('is_signedin') ?? false;
    notifyListeners();
  }

  //
  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool('is_signedin', true);
    _isSignedIn = true;
    notifyListeners();
  }

  //
  void singInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential cred) async {
            await _auth.signInWithCredential(cred);
          },
          verificationFailed: (FirebaseAuthException e) {
            showSnackBar(context, e.message.toString());
          },
          codeSent: ((verificationId, forceResendingToken) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  verificationId: verificationId,
                ),
              ),
            );
          }),
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    }
  }

  //
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        _uid = uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //
  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _storage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await storeFileToStorage('profilePic/$_uid', profilePic).then((value) {
        userModel.profilePic = value;
        userModel.phoneNumber = _auth.currentUser!.phoneNumber!;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.uid = _auth.currentUser!.uid;
      });
      _userModel = userModel;
      //
      await _firestore
          .collection('users')
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        e.message.toString(),
      );
    }
  }

  //
  Future getDataFromFirestore() async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).get().then(
      (DocumentSnapshot snapshot) {
        _userModel = UserModel(
          name: snapshot[''],
          email: snapshot[''],
          bio: snapshot[''],
          createdAt: snapshot[''],
          phoneNumber: snapshot[''],
          uid: snapshot[''],
          profilePic: snapshot[''],
        );
        _uid = userModel!.uid;
      },
    );
  }

  //
  Future saveDataToSP() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('user_model', jsonEncode(userModel!.toMap()));
  }

  //
  Future getDataToSP() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString('user_model') ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  //
  Future signOut() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await _auth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
