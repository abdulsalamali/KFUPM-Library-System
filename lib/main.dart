import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'package:ics324_project/BookDetails.dart';
import 'Book.dart';
import 'BookDetails.dart';
import 'homepage.dart';

void main() async {
  var myObject = HomePageState();
  // print('$myObject.searchQueryi');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (false) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.amberAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/Book': (BuildContext context) => Book(),
        '/details': (BuildContext context) => BookDetails(),
        '/Allbooks': (BuildContext context) => const HomePage(),
        '/': (BuildContext context) => home(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isFirstTime = false;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];
  static var searchQueryController = TextEditingController();
  bool _isSearching = false;
  dynamic secure;
  String searchQuery = "Search query";

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

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.black87, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  void connect() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Book(),
            settings: RouteSettings(
                // passes an argument to change the route dynamically.
                arguments: [
                  secure,
                  HomePageState
                      .searchQueryController.text // dart dataclass generator
                ])));
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search_rounded,
            color: Colors.black87,
          ),
          onPressed: () {
            connect();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final ssn = ModalRoute.of(context)!.settings.arguments as String;
    secure = ssn;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[350],
          leading: _isSearching
              ? const BackButton(
                  color: Colors.black87,
                )
              : Container(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",

              /* Fetches the books from the DB */
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'logout',
              child: Icon(Icons.logout),
            ),
          ],
        ),
        body: !isFirstTime
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: datas.length,
                itemBuilder: (context, index) {
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
                                    secure,
                                    datas[index]['barcode'],
                                    datas[index]
                                        ['imageURL'] // dart dataclass generator
                                  ])));
                    },
                    child: BookCard(
                        title: datas[index]['title'],
                        author: datas[index]['author'],
                        //  copies: datas[index]['copies'],
                        imageURL: datas[index]['imageURL']),
                  );
                },
              ));
  }
}

_buildTitle(BuildContext context) {}
