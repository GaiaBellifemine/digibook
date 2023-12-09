import 'package:flutter/material.dart';
import 'package:digibook2/widgets/ourContainer.dart';
import 'package:digibook2/screens/signup/Signup.dart';
import 'package:provider/provider.dart';
import 'package:digibook2/states/currentUser.dart';
import 'package:digibook2/contenitore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digibook2/main.dart';

enum LoginType{
  email,
  google,
}

class ourLoginForm extends StatefulWidget {
  @override
  _ourLoginFormState createState() => _ourLoginFormState();
}

class _ourLoginFormState extends State<ourLoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser({@required LoginType type,
    String email,
    String password,
    BuildContext context,
    }) async{
    CurrentUser _currentUser=Provider.of<CurrentUser>(context, listen: false);

    try{
      String _returnString;

      switch(type) {
        case LoginType.email:
          _returnString=await _currentUser.logInUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString=await  _currentUser.logInUserWithGoogle();
          break;
        default:
      }

      if(_returnString=="success"){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>contenitore())
        );
      }
      else{
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }catch(e){
      print(e);
    }
  }

  Widget _googleButton() {
    String getEmail(){
      return _emailController.text;
    }
    return OutlineButton(
        splashColor: Colors.grey,
      onPressed: () {
        _loginUser(
            type: LoginType.google,
            context: context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"),height: 25.0,),
            Padding(
                padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Accedi con google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ourContainer(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text("Log In", style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email"),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller:  _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password"
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          RaisedButton(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
            ),
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Text(
              "Log In",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
            onPressed: (){
              _loginUser(
                  type: LoginType.email,
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
            },
          ),
          FlatButton(
            child: Text("Non ho un account"),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context)=>OurSignUp(),
                ),
              );
            },
          ),
          _googleButton(),
        ],
      ),
    );
  }
}