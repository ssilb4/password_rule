import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'detail.dart';

void main() {
  runApp(MyApp(
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Password Rule Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var entryItems = List<String>.generate(1, (i) => "Item $i");
  var items = List<String>();

  TextEditingController seachController = new TextEditingController();

  void networkInit() async {
    try{
      var url = "http://27.35.61.53:3000/password-rules"; //You should change this url for what you want.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
        entryItems.clear();
        jsonResponse.forEach((data){
          entryItems.add(data['name']);
          print(data['name']);
        });
        setState(() {
          items.clear();
          items.addAll(entryItems);
        });
      } else {
        print("Request failed with status: ${response.statusCode}.");
      }
    } catch(exception){
      print(exception);
    }
  }

  @override
  void initState() {
    networkInit();
    //items.addAll(entryItems);
    super.initState();
  }

  void _seachList(String searchValue) {
    var searchedList = List<String>();
    if(searchValue.isEmpty){
      searchedList.clear();
      searchedList.addAll(entryItems);
    } else{
      var searchList = List<String>();
      searchList.addAll(entryItems);
      searchList.forEach((item){
        if(item.contains(searchValue)){
          searchedList.add(item);
        }
      });
    }
    setState(() {
      items.clear();
      items.addAll(searchedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextField(
            controller: seachController,
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            onChanged: (text){
              _seachList(text);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text('${items[index]}'),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Detail(index: index)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Detail()),
            );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
