// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'package:ics324_project/BookCardv2.dart';

import 'package:uuid/uuid.dart';
import 'Book.dart';
import 'BookCard.dart';
import 'main.dart';
import 'BookCard.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({Key? key}) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool isFirstTime = false;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];
  var outDate = DateTime.now();
  var returnDate = DateTime.now().add(Duration(days: 90));
  var extendDate =
      DateTime.now().add(Duration(days: 90)).add(Duration(days: 30));

  dynamic SSN;
  dynamic BARCODE;

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

  dynamic rrSSN;
  dynamic rrBarcode;
  bool check = false;

  var listOfReservation = [];
  dynamic docOfReservation;
  var reservedBookToDecrement = '';
//---------------------------------------------------------------------------

  dynamic userBorrows() async {
    rrSSN = await users
        .where("SSN", isEqualTo: SSN)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        listOfReservation.add(element.data());
      });
    });
  }

  dynamic checkBook() async {
    await getData();
    await userBorrows();
    for (var i = 0; i < listOfReservation.length; i++) {
      if (listOfReservation[i]['barcode'] == BARCODE &&
          listOfReservation[i]['returned'] == false) {
        docOfReservation = listOfReservation[i];
        print(docOfReservation);
        setState(() {
          check = true;
          print('I am printed');
        });
      }
    }
  }

  @override
  void initState() {
    checkBook();
    super.initState();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Borrows');
  //CollectionReference borrowsCollection = FirebaseFirestore.instance.collection(collectionPath)
  CollectionReference Reserver =
      FirebaseFirestore.instance.collection('Reserves');

  Future<void> addReserve(ssn, barcode) {
    return Reserver.add({
      'SSN': ssn, // John Doe
      // 'company': company, // Stokes and Sons
      'barcode': barcode // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addUser(ssn, barcode, cDate, rDate) async {
    var reservationDocs = await users.where('SSN', isEqualTo: ssn).get();
    var numberOfReservation = reservationDocs.docs.length;

    if (numberOfReservation < 5) {
      setState(() {
        check = true;
      });

      // FirebaseFirestore.instance
      //     .collection('Book')
      //     .doc(BARCODE)
      //     .update({'copies': datas[index]['copies'] - 1});
      //      // need to get currentCopies  - 1

      String id = Uuid().v1();
      return users
          .doc(id)
          .set({
            'id': id, 'SSN': ssn, // John Doe
            // 'company': company, // Stokes and Sons
            'barcode': barcode, // 42
            'CheckoutDate': cDate,
            'ReturnDate': rDate,
            'returned': false
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error")); // uuid;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('You have checked out 5 books'),
                content: const Text('You can not borrow more'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }

  dynamic meditaor(ssn, isbn) {
    SSN = ssn;
    BARCODE = isbn;
  }

  extendReservation() {
    users
        .doc(docOfReservation['id'].toString())
        .update({'ReturnDate': extendDate});
  }

  returnReservation() {
    var actualReturnDate = DateTime.now();
    users
        .doc(docOfReservation['id'].toString())
        .update({'returned': actualReturnDate});

    var data1 = actualReturnDate;
    var data2 = docOfReservation['ReturnDate'];

    DateTime dateTime1 = actualReturnDate;
    DateTime dateTime2 = DateTime.parse(data2.toDate().toString());
    int timeDifference = dateTime1
        .difference(dateTime2)
        .inDays; // or in whatever format you want.
    if (timeDifference > 0) {
      users
          .doc(docOfReservation['id'].toString())
          .update({'penality': timeDifference});
    }
    setState(() {
      check = false;
    });
  }

//
  Widget buildWidget({BuildContext? context, int? n, Future? fun}) {
    if (n == 0) {
      return ElevatedButton(
        onPressed: () {
          addReserve(SSN, BARCODE);
        },
        child: Text('Reserve'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          //side: BorderSide(color: Colors.red)
        ))),
      );
    } else if (check == true) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              returnReservation();
            },
            child: Text('Return'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              //side: BorderSide(color: Colors.red)
            ))),
          ),
          ElevatedButton(
            onPressed: () {
              extendReservation();
              setState(() {
                check = false;
              });
            },
            child: Text('Extend'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              //side: BorderSide(color: Colors.red)
            ))),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          addUser(SSN, BARCODE, outDate, returnDate); //call
          setState(() {
            check == true;
          });
        },
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
    dynamic isbn = list[0];
    dynamic ssn = list[2];
    dynamic barcode = list[3];
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
          padding: const EdgeInsets.only(top: 75),
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
                    // BookDetail(
                    //     title: datas[index]['title'],
                    //     author: datas[index]['author'],
                    //     imageURL: datas[index]['imageURL']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildWidget(
                            context: context,
                            n: list[1],
                            fun: meditaor(
                                ssn, isbn)), // a place holder for a button
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
