import 'package:flutter/material.dart';
import 'config.dart';

void main() => runApp(AppHome());

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card with ExpansionTile'),
        ),
        body: AppHomePage(),
      ),
    );
  }
}

class AppHomePage extends StatefulWidget {
  AppHomePage({Key key}) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Container(
  alignment: Alignment.centerLeft,
  margin: new EdgeInsets.all(8.0),
  padding: new EdgeInsets.all(8.0),
  height: 150.0,
  decoration: new BoxDecoration(
    color: Colors.lightBlue,
    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
    boxShadow: [new BoxShadow(color: Colors.black54, offset: new Offset(2.0, 2.0),
    blurRadius: 5.0)],
  ),
  child: new Row(children: <Widget>[
    new CircleAvatar(
      backgroundColor: Colors.white70,radius: 50.0,
      backgroundImage: NetworkImage('${config.url_upload}/upload/image/dorm/17072019100823.jpg'),
  ),
    new Expanded(child: new Padding(padding: new EdgeInsets.only(left: 8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('Hot Pot', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          new Row(children: <Widget>[
            new Icon(Icons.star, color: Colors.white,),
            new Icon(Icons.star, color: Colors.white,),
            new Icon(Icons.star, color: Colors.white,),
            new Icon(Icons.star_half, color: Colors.white,),
            new Icon(Icons.star_border, color: Colors.white,),
          ],),
          new Wrap(spacing: 2.0,children: <Widget>[
            new Chip(label: new Text('Hot')),
            new Chip(label: new Text('Hot')),
            new Chip(label: new Text('Hot')),
          ],)
        ],),))
  ],),
);
}
}
