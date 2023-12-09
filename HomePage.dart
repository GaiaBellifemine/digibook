import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digibook2/screens/login/LogIn.dart';
import 'infoLibri.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon cusIcon=Icon(Icons.search);
  Widget cusSearchBar=Text("Homepage");

  final FirebaseAuth auth=FirebaseAuth.instance;

  String getCurrentUserId(){
    return auth.currentUser.uid;
  }

  TextEditingController _controller=TextEditingController();

  bool isSearching=false;

  Future<bool> esiste(String titolo) async{
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users').doc(getCurrentUserId()).collection('WishList')
        .where('titolo', isEqualTo: titolo)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Widget cerca(BuildContext context) {
    if(!isSearching) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('LIBRO').snapshots(),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.favorite_border),
                        iconSize: 20.0,
                        onPressed: () async{
                          try{

                            final FirebaseAuth auth=FirebaseAuth.instance;
                            final User user=auth.currentUser;
                            final uid=user.uid;


                            await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(document.id).set({
                              'titolo': document['titolo'],
                              'copertina': document['copertina'],
                              'autore': document['autore'],
                            });
                          }catch(e){
                            print(e);
                          }
                        },
                      ),

                      IconButton(icon: Icon(Icons.remove_circle_outline),
                        iconSize: 20.0,
                        onPressed: () async{
                          try{

                            final FirebaseAuth auth=FirebaseAuth.instance;
                            final User user=auth.currentUser;
                            final uid=user.uid;


                            await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(document.id).delete();
                          }catch(e){
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
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
          stream: FirebaseFirestore.instance.collection('LIBRO')
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.favorite_border),
                        iconSize: 20.0,
                        onPressed: () async{

                          try{

                            final FirebaseAuth auth=FirebaseAuth.instance;
                            final User user=auth.currentUser;
                            final uid=user.uid;


                            await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(document.id).set({
                              'titolo': document['titolo'],
                              'copertina': document['copertina'],
                              'autore': document['autore'],
                            });
                          }catch(e){
                            print(e);
                          }
                        },
                      ),

                      IconButton(icon: Icon(Icons.remove_circle_outline),
                        iconSize: 20.0,
                        onPressed: () async{
                          try{

                            final FirebaseAuth auth=FirebaseAuth.instance;
                            final User user=auth.currentUser;
                            final uid=user.uid;


                            await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(document.id).delete();
                          }catch(e){
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
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

  Widget getEmail(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(getCurrentUserId()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Caricamento");
          }
          var userDocument = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: Image.asset("assets/Header.png"),),
              Text(userDocument["fullName"], textAlign: TextAlign.center,style: TextStyle(fontSize: 17, color: Colors.white54),),
            ],
          );
          //);
        }
    );
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      backgroundColor: Colors.white,
      drawer: SafeArea(
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  color: Color.fromARGB(255, 77, 49, 71),
                  height: 120,
                  child: DrawerHeader(
                    /*decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Header.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),*/
                    child: getEmail(context),
                  )
                ),
                ListTile(
                  title: Text("Logout",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: Icon(Icons.logout),
                  onTap: () async{
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>LogIn()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
                  this.cusSearchBar=Text("Homepage");
                  isSearching=false;
                  _controller.text="";
                }
              });
            },
            icon: cusIcon,
          ),
        ],
        title: cusSearchBar,
      ),

      body: cerca(context),
    );
  }
}
