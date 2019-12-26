import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final String keyValue;
  Detail({@required this.keyValue}) ;

  @override
  DetailState createState() => DetailState();

}

class DetailState extends State<Detail> {

  var name = "";
  bool number = false;
  bool lower = false;
  bool upper = false;
  bool special = false;
  var min = -1;
  var max = -1;
  var count = -1;
  var etc = "";

  void networkGetValue(keyValue) async {
    try{
      var url = "http://27.35.61.53:3000/password-rules/" + keyValue; //You should change this url for what you want.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
        setState((){
          name = result[0]["name"];
          number = result[0]["number"];
          lower = result[0]["lower"];
          upper = result[0]["upper"];
          min = result[0]["min"];
          max = result[0]["max"];
          count = result[0]["count"];
          special = result[0]["special"];
          etc = result[0]["etc"];
        });
      } else {
        print("Request failed with status: ${response.statusCode}.");
      }
    } catch(exception){
      print(exception);
    }
  }

  Object boolToString(boolValue){
    if(boolValue == true){
      return "허용";
    } else{
      return "불가";
    }
  }

  String makeSentence(keyValue){
    var returnValue = '';
    if(keyValue == null){
      return '아직 등록되지 않았습니다.';
    } else{
      if(number == true){
        returnValue += '숫자, ';
      }
      if(lower == true){
        returnValue += '영문(소), ';
      }
      if(upper == true){
        returnValue += '영문(대), ';
      }
      if(special == true){
        returnValue += '특수문자, ';
      }
      if(count != null && count > 0){
        returnValue = returnValue.substring(0,returnValue.length-2);
        returnValue += '중에서 ' + count.toString() + '개를 포함하여야 합니다.';
      }
      if(min != null && min > 0){
        returnValue += '길이는 ' + min.toString() + '이상 ' ;
      }
      if(max != null && max > 0){
        returnValue += max.toString() + '이하입니다.' ;
      }
    }
    return returnValue;
  }
  
  Widget build(BuildContext context) {
    if(widget.keyValue != null){
      networkGetValue(widget.keyValue);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '이름 :' + name
            ),
            Text(
              makeSentence(widget.keyValue)
            ),
            Row(
              children: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate back to first route when tapped.
                },
                child: Text('Cancel'),
              ),
              RaisedButton(
                onPressed: () {
                  // Navigate back to first route when tapped.
                },
                child: Text('Save'),
              ),],
            ),
          ],
        ),
      ),
    );
  }
}