import 'package:flutter/material.dart';
import 'mainPersonalInformation.dart';
import 'mainPaymentNotification.dart';
import 'InformPage.dart';


class InformDormPage extends StatefulWidget {
  int _dormId, _userId;
  InformDormPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new InformDormPageState(_dormId, _userId);
  }
}

class InformDormPageState extends State<InformDormPage> {
  int _dormId, _userId;
  InformDormPageState(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
    print(_dormId);
    print(_userId);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('แจ้งซ่อม'),
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
        body: new InformMultiLine(_dormId,_userId),
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
      );
  }
}
