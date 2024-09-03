import 'package:bookbuddy/auth/login.dart';
import 'package:bookbuddy/auth/services/local_storage_repository.dart';
import 'package:bookbuddy/models/error_model.dart';
import 'package:bookbuddy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../../home/home.dart';
import './database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);
final userProvider = StateProvider<UserModel?>((ref) => null);
final themeProvider = StateProvider<bool>((ref) => true);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;


  Future<ErrorModel> getUserData() async {
    
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    
    try {
      String? token = await _localStorageRepository.getToken();
      DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('User')
        .doc(token)
        .get();

      if (token != null) {
        
          _localStorageRepository.setToken(user.id);
          
          final newUser = UserModel(
          email: user['email'],
          name: user['name'] ?? '',
          imgUrl: user['imgUrl'] ?? '',
          id: user['id'],
        );
        
          return ErrorModel(error: null, data: newUser);
      
      }
    } catch (e) {
      return ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void setUser(id){
    _localStorageRepository.setToken(id);
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}

final LocalStorageRepository _localStorageRepository =
        LocalStorageRepository();

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
  
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails!.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid
      };
      _localStorageRepository.setToken(userInfoMap["id"]);
      await DatabaseMethods()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }



  
}

  Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  _localStorageRepository.setToken('');
  if (context.mounted) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
  }
}