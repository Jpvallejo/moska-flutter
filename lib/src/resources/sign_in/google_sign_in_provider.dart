import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  assert(currentUser.email != null);
  assert(currentUser.displayName != null);
  assert(currentUser.photoUrl != null);
  name = currentUser.displayName;
  email = currentUser.email;
  imageUrl = currentUser.photoUrl;

  final storage = new FlutterSecureStorage();
  storage.write(key: 'isLoggedIn', value: 'true');
  storage.write(key: 'name', value: name);
  storage.write(key: 'email', value: email);
  storage.write(key: 'imageUrl', value: imageUrl);
  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  final storage = new FlutterSecureStorage();
  storage.deleteAll();

  print("User Sign Out");
}
