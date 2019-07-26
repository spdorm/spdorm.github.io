import 'package:flutter/material.dart';
import 'InformStatusPage.dart';

void main(){
  runApp(MaterialApp(
    home: InformStatusDormPage(),
  ));
}

class InformStatusDormPage extends StatefulWidget {
  int _dormId, _userId;
  InformStatusTable(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new InformStatusDormPageState();
  }
}

class InformStatusDormPageState extends State<InformStatusDormPage> {
  int selectedDrawerIndex = 0;
  int _dormId,_userId;
  InformDormPageState(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'การแจ้งซ่อม',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('การแจ้งซ่อม'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
                print('Search button');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.tune,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                print('Filter button');
              },
            ),
          ],
        ),
        //body: new InformStatusTable(_dormId,_userId),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.mail),
              title: new Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: new Text('Profile'),
            )
          ],
        ),
      ),
    );
  }
}
