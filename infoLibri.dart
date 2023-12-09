import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class infoLibro extends StatefulWidget {
  final docId;
  final uid;
  infoLibro(this.docId, this.uid, {Key key}) : super(key: key);
  @override
  _infoLibroState createState() => _infoLibroState(docId, uid);
}

class _infoLibroState extends State<infoLibro> {


  final docId,uid;
  _infoLibroState(this.docId, this.uid);

  @override
  Widget build(BuildContext context) {

   Stream<DocumentSnapshot> getData(){
     return FirebaseFirestore.instance.collection('LIBRO').doc(docId).snapshots();
   }

   Widget immagine=StreamBuilder<DocumentSnapshot>(
       stream: getData(),
       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
         if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data();

           return Column(
             children: [
               Container(
                 width: MediaQuery.of(context).size.width,
                 height: 300,
                 decoration: new BoxDecoration(
                   image: new DecorationImage(
                     image: new NetworkImage(documentFields['copertina']),
                     fit:BoxFit.cover,
                   )
                 ),
               )
             ],
           );
         }
         else
           return null;
       }
   );

   Widget trama=StreamBuilder<DocumentSnapshot>(
       stream: getData(),
       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
         if (snapshot.hasData) {
           Map<String, dynamic> documentFields = snapshot.data.data();

           return Container(
             padding: const EdgeInsets.all(32),
             child: Text(documentFields['trama'],
               softWrap: true,
               style: TextStyle(
                 fontSize: 17.0,
              ),
             ),
           );
         }
         else
           return null;
       }
   );

   Widget titolo=StreamBuilder<DocumentSnapshot>(
       stream: getData(),
       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
         if (snapshot.hasData) {

           Map<String, dynamic> documentFields = snapshot.data.data();

           return Container(
             padding: const EdgeInsets.all(32),
             child: Row(
               children: [
                 Expanded(
                   /*1*/
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       /*2*/
                       Container(
                         padding: const EdgeInsets.only(bottom: 8),
                         child: Text(
                           documentFields['titolo'],
                           style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 20.0,
                           ),
                         ),
                       ),
                       Text(
                         documentFields['autore'],
                         style: TextStyle(
                           color: Colors.grey[500],
                           fontSize: 15.0,
                         ),
                       ),
                     ],
                   ),
                 ),

                 IconButton(icon: Icon(Icons.favorite_border),
                   iconSize: 20.0,
                   onPressed: () async{
                     try{

                       final FirebaseAuth auth=FirebaseAuth.instance;
                       final User user=auth.currentUser;
                       final uid=user.uid;


                       await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(docId).set({
                         'titolo': documentFields['titolo'],
                         'copertina': documentFields['copertina'],
                         'autore': documentFields['autore'],
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


                       await FirebaseFirestore.instance.collection('users').doc(uid).collection("WishList").doc(docId).delete();
                     }catch(e){
                       print(e);
                     }
                   },
                 ),

               ],
             ),
           );
         }
         else return Text("Nessun dato trovato");
       }
   );

    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("Anteprima"),
          backgroundColor: Color.fromRGBO(77, 49, 71, 10),
        ),
        body: ListView(
          children: [
            immagine,
            titolo,
            trama,
          ],

        )
        );
  }
}
