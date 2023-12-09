import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'infoLibri.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Icon cusIcon=Icon(Icons.search);
  Widget cusSearchBar=Text("Carrello");

  final FirebaseAuth auth=FirebaseAuth.instance;

  String getCurrentUserId(){
    return auth.currentUser.uid;
  }

  TextEditingController _controller=TextEditingController();

  Widget cerca(BuildContext context) {
    if(!isSearching) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection("WishList").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((document) {
              return new ListTile(
                leading: Image.network(document['copertina']),
                title: Text(document['titolo']),
                subtitle: Text("Autore: " + document['autore']),
                onTap: (){
                  var docId=document.id;
                  final FirebaseAuth auth=FirebaseAuth.instance;
                  final User user=auth.currentUser;
                  final uid=user.uid;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>infoLibro(docId, uid))
                  );
                },
              );
            }).toList(),
          );
        }
    );}
    else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).collection("WishList")
                  .orderBy('titolo')
                  .where('titolo', isGreaterThanOrEqualTo: _controller.text)
                  .where('titolo', isLessThan: _controller.text+'z')
                  .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data.docs.map((document) {
                return new ListTile(
                  leading: Image.network(document['copertina']),
                  title: Text(document['titolo']),
                  subtitle: Text("Autore: " + document['autore']),
                  onTap: (){
                    var docId=document.id;
                    final FirebaseAuth auth=FirebaseAuth.instance;
                    final User user=auth.currentUser;
                    final uid=user.uid;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>infoLibro(docId, uid))
                    );
                  },
                );
              }).toList(),
            );
          }
      );
    }
  }


  bool isSearching=false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(77, 49, 71, 10),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                setState(() {
                  if(this.cusIcon.icon==Icons.search){
                    this.cusIcon=Icon(Icons.cancel);
                    this.cusSearchBar=new TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cerca...",
                        hintStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        )
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      onChanged: (value){
                        setState(() {
                          isSearching=true;
                        });
                      },
                    );
                  }
                  else{
                    this.cusIcon=Icon(Icons.search);
                    this.cusSearchBar=Text("Carrello");
                    isSearching=false;
                    _controller.text="";
                  }
                });
              },
              icon: cusIcon,
            )
          ],
          title: cusSearchBar,
        ),

        body: cerca(context),
    );
  }
}
