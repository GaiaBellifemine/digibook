import 'package:flutter/material.dart';
import 'package:digibook2/widgets/ourContainer.dart';
import 'package:digibook2/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:digibook2/screens/login/LogIn.dart';
import 'package:provider/provider.dart';

class OurSignUpForm extends StatefulWidget {
  @override
  _OurSignUpFormState createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _fullNameController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _confirmPasswordController=TextEditingController();

  void _signUpUser(String email, String password, BuildContext context, String fullName) async{
    CurrentUser _currentUser=Provider.of<CurrentUser>(context, listen: false);
    //Navigator.pop(context);
    String _returnString=await _currentUser.signUpUser(email, password, fullName);
    try{
      if(_returnString=="success") {
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return ourContainer(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text("Registrati", style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: "Nome utente"),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email"),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: "Conferma password"
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
              "Registrati",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
            onPressed: (){
            //Navigator.pop(context);
              if(_passwordController.text==_confirmPasswordController.text){
                _signUpUser(_emailController.text, _passwordController.text, context, _fullNameController.text);
              }
              else{
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Le password non corrispondono'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}