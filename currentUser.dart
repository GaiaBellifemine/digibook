import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:digibook2/models/user.dart';
import 'package:digibook2/services/database.dart';

class CurrentUser extends ChangeNotifier{ //verifica provider
  OurUser _currentUser=OurUser();

  OurUser get getCurrentUser=>_currentUser;


  Future<String> signUpUser(String email, String password, String fullName) async{
    String retVal="error";
    OurUser _user=OurUser();
    try{
      //AuthResult _authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final _authResult=(await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
      _user.uid=_authResult.uid;
      _user.email=_authResult.email;
      _user.fullName=fullName;
      String returnString= await OurDatabase().createUser(_user);
      if(returnString=="success") {
        retVal = "success";
      }
    }catch(e) {
      retVal=e.message;
    }

    return retVal;
  }


  Future<String> logInUserWithEmail(String email, String password) async{
    String retVal="error";

    try{
      final _authResult=(await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;

        _currentUser=await OurDatabase().getUserInfo(_authResult.uid);
        if(_currentUser!=null){
          retVal="success";
        }
    }catch(e) {
      retVal=e.message;
    }

    return retVal;

  }

  Future<String> logInUserWithGoogle() async{
    String retVal="error";

    OurUser _user=OurUser();

    try{
      final GoogleSignInAccount _googleUser=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication _googleAuth=await _googleUser.authentication;

      final GoogleAuthCredential credential=GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      final _authResult=(await FirebaseAuth.instance.signInWithCredential(credential));
      if(_authResult.additionalUserInfo.isNewUser){
        _user.uid=_authResult.user.uid;
        _user.email=_authResult.user.email;
        _user.fullName=_authResult.user.displayName;
        OurDatabase().createUser(_user);
      }
      _currentUser=await OurDatabase().getUserInfo(_authResult.user.uid);
      if(_currentUser!=null){
        retVal="success";
      }

    }catch(e) {
      retVal=e.message;
    }

    return retVal;

  }
}