import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'Book.dart';
import 'BookCard.dart';
import 'main.dart';
import 'dart:math';

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

  @override
  void initState() {
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

  int generateRandom() {
    Random random = new Random();
    int id = random.nextInt(5);
    return id;
  }

  reduceCopies() {}
  Future<void> addUser(ssn, barcode, cDate, rDate) {
    //borrower
    // Call the user's CollectionReference to add a new user
    // returnDate = outDate.add(Duration(days: 50));

    return users
        .add({
          'id': generateRandom(), 'SSN': ssn, // John Doe
          // 'company': company, // Stokes and Sons
          'barcode': barcode, // 42
          'checkout date': cDate,
          'Return date': rDate,
          'returned': false
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  dynamic meditaor(ssn, barcode) {
    SSN = ssn;
    BARCODE = barcode;
  }

  extendReservation() {
    var tmp = [];

    users
        .where("id", isEqualTo: reservationDoc['id'])
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        tmp.add(element.id);
      });
    });

    users.doc(tmp[0]).update({'Return Date': extendDate});
  }

  dynamic rrSSN;
  dynamic rrBarcode;

  var listOfReservation = [];
  var reservationDoc;

  dynamic returnBook() {
    bool check = false;

    rrSSN =
        users.where("SSN", isEqualTo: SSN).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        listOfReservation.add(element.data());
      });
    });

    // print(listOfReservation[0]);

    for (var i = 0; i < listOfReservation.length; i++) {
      if (listOfReservation[i]['barcode'] == BARCODE) {
        reservationDoc = listOfReservation[i];
        check = true;
      }
    }

    return check;
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
    } else if (returnBook()) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
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
          returnBook();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildWidget(
                            context: context,
                            n: list[1],
                            fun: meditaor(
                                ssn, barcode)), // a place holder for a button
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
