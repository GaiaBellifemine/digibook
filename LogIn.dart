import 'package:flutter/material.dart';
import 'package:digibook2/screens/login/localwidgets/ourLoginForm.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget> [
                Padding(padding: EdgeInsets.all(30.0), child: Image.asset("assets/logo.png"),
                ),
                SizedBox(height: 10.0,),
                ourLoginForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
