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

  @override
  Widget build(BuildContext context) {
    final isbn = ModalRoute.of(context)!.settings.arguments
        as String; // the value passed by main.dart.
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
        body: ListView.builder(
          itemCount: datas.length,
          itemBuilder: (context, index) {
            if (isbn == datas[index]['ISBN']) {
              return Column(
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
                      Text('llllll',
                          style: TextStyle(
                              color:
                                  Colors.red)), // a place holder for a button
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
    );
  }
}
