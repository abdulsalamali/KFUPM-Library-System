import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'BookDetails.dart';
import 'main.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    dynamic ssn = list[0];
    dynamic hul = list[1];
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.amberAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book details'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index) {
              if (datas[index]['title'] == hul ||
                  datas[index]['author'] == hul ||
                  datas[index]['subject'] == hul ||
                  datas[index]['pub_date'] == hul) {
                return GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookDetails(),
                            settings: RouteSettings(
                                // passes an argument to change the route dynamically.
                                arguments: [
                                  datas[index]['ISBN'],
                                  datas[index]['copies'],
                                  ssn,
                                  datas[index]
                                      ['barcode'] // dart dataclass generator
                                ])));
                  },
                  child: BookCard(
                      title: datas[index]['title'],
                      author: datas[index]['author'],
                      //  copies: datas[index]['copies'],
                      imageURL: datas[index]['imageURL']),
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
