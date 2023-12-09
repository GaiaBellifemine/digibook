import 'package:digibook2/contenitore.dart';
import 'package:digibook2/states/currentUser.dart';
import 'package:digibook2/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:provider/provider.dart';
import 'package:digibook2/screens/login/LogIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
  //rest of the code
  runApp(MyApp());
}

Future<String> getPrefs() async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  return pref.getString('email') ?? '';
}

void setStr(String str) async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  pref.setString('email', str);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentUser(),
      child: MaterialApp(
        //Per l'utilizzo del material design
        debugShowCheckedModeBanner: false,
        theme: ourTheme().buildTheme(),
        home: FutureBuilder(//Uso FutureBuilder per ritornare un Widget alla base di un dato Future (getPrefs)
          future: getPrefs(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data!='') return contenitore();
              else {
                setStr('inserito');
                return LogIn();
              }
            }
            else{
              return LogIn();
            }
          },
        ),
      ),
    );
  }
}
