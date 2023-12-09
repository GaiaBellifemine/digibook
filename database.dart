import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digibook2/models/user.dart';
class OurDatabase{

  Future<String> createUser(OurUser user) async{
    String retVal="error";

    try{
      await FirebaseFirestore.instance.collection('users').document(user.uid).set(
          {
            'fullName': user.fullName,
            'email': user.email,
            'accountCreated': Timestamp.now(),
          });
      retVal="success";
    }catch(e){
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async{
    OurUser retVal=OurUser();

    try{
      DocumentSnapshot _docSnapshot=await FirebaseFirestore.instance.collection('users').document(uid).get();
      final data=_docSnapshot.data();
      retVal.uid=uid;
      retVal.fullName=data["fullName"];
      retVal.email=data["email"];
      retVal.accountCreated=data["accountCreated"];
    }catch(e){
      print(e);
    }

    return retVal;
  }
}