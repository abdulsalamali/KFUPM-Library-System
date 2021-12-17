import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'Book.dart';
import 'BookCard.dart';
import 'main.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({Key? key}) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool isFirstTime = false;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];

  getData() async {
    if (!isFirstTime) {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection("Book").get();
      isFirstTime = true;
      setState(() {
        datas.addAll(snap.docs);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildWidget({BuildContext? context, String n = ''}) {
    var myint = int.parse(n);
    if (myint == 0) {
      return ElevatedButton(
        onPressed: () {},
        child: Text('Reserve'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          //side: BorderSide(color: Colors.red)
        ))),
      );
    } else {
      return ElevatedButton(
        onPressed: () {},
        child: Text('Borrow'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          //side: BorderSide(color: Colors.red)
        ))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ModalRoute.of(context)!.settings.arguments
        as List<dynamic>; // the value passed by main.dart.
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.amberAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        /*
        Later:
        if copies>0
        enter
        else show reserve
        */
        floatingActionButton: FloatingActionButton(
          /* Fetches the books from the DB */
          onPressed: getData,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Book details'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index) {
              if (list[0] == datas[index]['ISBN']) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BookCard(
                        // extra: add hero.
                        title: datas[index]['title'],
                        author: datas[index]['author'],
                        copies: datas[index]['copies'],
                        imageURL: datas[index]['imageURL']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildWidget(
                            context: context,
                            n: list[1]), // a place holder for a button
                      ],
                    )
                  ],
                );
              } else {
                return Center(child: Text(''));
              }
            },
          ),
        ),
      ),
    );
  }
}
