import 'package:flutter/material.dart';
import 'PaymentNotificationPage.dart';

class PaymentNotification extends StatefulWidget {
  int _userId;
  PaymentNotification(int _userId){
    this._userId = _userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new PaymentNotificationState(_userId);
  }
}

class PaymentNotificationState extends State<PaymentNotification> {
  int selectedDrawerIndex = 0;
  int _userId;
  PaymentNotificationState(int _userId){
    this._userId = _userId;
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('ใบแจ้งชำระ'),
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
        body: new PaymentmultiLine(),
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
