import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LandingScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LandingScreen();
  }
}

class _LandingScreen extends State{
  List<Widget> lstData = List();
  void initState(){

    super.initState();
    http.get("http://www.mocky.io/v2/5c23595a2f00004300049541")
        .then((reponse){
      Map ret = jsonDecode(reponse.body) as Map;
      List jsonData = ret["data"];
      for(int i = 0; i < jsonData.length; i++){
        Map dataMap = jsonData[i];
        Card card = Card(
          child: Column(
            children: <Widget>[
              Text(dataMap["name"]),
              Text("${dataMap['price']}")
            ],
          ),
        );
        lstData.add(card);
      }
      setState(() {
      });
    });
  }
  Widget getItem(BuildContext context, int index){
    return lstData[index];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: ListView.builder(itemBuilder: getItem,itemCount: lstData.length,)
    );
  }
}