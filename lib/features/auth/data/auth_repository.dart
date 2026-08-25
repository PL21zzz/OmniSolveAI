import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}

class AuthRepository {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Sign Up with Email & Password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Không thể tạo tài khoản');

      await user.updateDisplayName(displayName);

      final userModel = UserModel(
        uid: user.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      // Save user to Cloud Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } catch (e) {
      debugPrint('Firebase SignUp Error: $e');
      throw Exception(_parseAuthError(e.toString()));
    }
  }

  // Sign In with Email & Password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Đăng nhập thất bại');

      // Fetch user profile from Cloud Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }

      return UserModel(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName ?? 'Người dùng',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Firebase SignIn Error: $e');
      throw Exception(_parseAuthError(e.toString()));
    }
  }

  // Google Sign In
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Đã hủy đăng nhập Google');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Không thể liên kết Google Auth');

      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Google User',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      // Save or update user in Cloud Firestore
      await _firestore.collection('users').doc(user.uid).set(
            userModel.toMap(),
            SetOptions(merge: true),
          );

      return userModel;
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      throw Exception(_parseAuthError(e.toString()));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  String _parseAuthError(String errorMsg) {
    if (errorMsg.contains('email-already-in-use')) {
      return 'Email này đã được sử dụng cho tài khoản khác.';
    } else if (errorMsg.contains('wrong-password') || errorMsg.contains('user-not-found') || errorMsg.contains('invalid-credential')) {
      return 'Email hoặc mật khẩu không chính xác.';
    } else if (errorMsg.contains('weak-password')) {
      return 'Mật khẩu quá yếu, vui lòng chọn ít nhất 6 ký tự.';
    } else if (errorMsg.contains('invalid-email')) {
      return 'Định dạng Email không hợp lệ.';
    }
    return 'Lỗi xác thực: $errorMsg';
  }
}
