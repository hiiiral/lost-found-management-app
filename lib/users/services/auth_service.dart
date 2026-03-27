import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication service for user authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Create user with email & password and create Firestore profile
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _createOrUpdateUserDoc(cred.user!, name: name);
    return cred;
  }

  // Sign in with email & password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _createOrUpdateUserDoc(cred.user!);
    return cred;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Google Sign-In (web and mobile)
  Future<UserCredential?> signInWithGoogle() async {
    // On web, GoogleSignIn() works differently; this implementation works on mobile and web
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user cancelled

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    await _createOrUpdateUserDoc(userCred.user!, name: googleUser.displayName);
    return userCred;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  // Helper: create or update Firestore user document
  Future<void> _createOrUpdateUserDoc(User user, {String? name}) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    final Map<String, Object?> data = {
      'email': user.email,
      'name': name ?? user.displayName ?? '',
      'lastSeen': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      data['role'] = 'user';
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await docRef.set(data, SetOptions(merge: true));
  }

  // Promote a user to admin by UID
  Future<void> promoteToAdminByUid(String uid) async {
    final docRef = _firestore.collection('users').doc(uid);
    await docRef.set({'role': 'admin'}, SetOptions(merge: true));
  }

  // Promote a user to admin by email (finds user doc by email)
  Future<void> promoteToAdminByEmail(String email) async {
    final query = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) throw Exception('User with email not found in Firestore');
    final uid = query.docs.first.id;
    await promoteToAdminByUid(uid);
  }

  // Fetch user role
  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return 'user';
    return doc.data()?['role'] ?? 'user';
  }

  // Stream of auth changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
}
