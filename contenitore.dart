import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digibook2/Cart.dart';
import 'package:digibook2/HomePage.dart';
import 'package:digibook2/Map.dart';

//stateful = crea widget con classe contenente elementi dinamici (cioè variabili nel tempo) 
// stateless = crea widget con classe contenente elementi statici (cioè non variabili nel tempo)

// quando contenitore viene chiamata, si crea uno stato iniziale che viene modificato attraverso la classe contenitoreState

class contenitore extends StatefulWidget {
  @override
  _contenitoreState createState() => _contenitoreState();
}

class _contenitoreState extends State<contenitore> {
  int currentIndex=0;
  PageController _c;
  @override
  void initState(){
    _c =  new PageController(
      initialPage: currentIndex,
    );
    super.initState();
  }

  final List<Widget> _children=
  [
    HomePage(),
    Cart(),
    Map(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*_children[currentIndex]*/new PageView(
        controller: _c,
        onPageChanged: (newPage){
          setState((){
            currentIndex=newPage;
          });
        },
        children: [
          HomePage(),
          Cart(),
          Map(),
        ],
      ),//_children[currentIndex], //Seleziono la pagina in base alla NavyBar
      bottomNavigationBar: BottomNavyBar( //Inizio la costruzione della NavyBar
        selectedIndex: currentIndex, //L'indice selezionato dalla navybar
        onItemSelected: (index){
          /*setState(() {
            currentIndex=index; //Seleziono l'indice
          });*/
          this._c.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
        },
        items: <BottomNavyBarItem>[ //Gli elementi che compongono la navybar
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Catalogo'),
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded),
            title: Text('Whishlist'),
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add_location_alt_outlined),
            title: Text('Mappa'),
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
