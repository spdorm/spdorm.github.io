import 'package:flutter/material.dart';

class TabBarDemo extends StatelessWidget {
  @override  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Calls", icon: Icon(Icons.call_made)),
                Tab(text: "Missed",icon: Icon(Icons.call_missed)),
                Tab(text: "Received", icon: Icon(Icons.call_received)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              DialledCallsPage(),
              MissedCallsPage(),
              ReceivedCallsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

List<Contact> missedCallContacts = [
  Contact(fullName: 'Pratap Kumar', email: 'pratap@example.com'),
  Contact(fullName: 'Jagadeesh', email: 'Jagadeesh@example.com'),
  Contact(fullName: 'Srinivas', email: 'Srinivas@example.com'),
  Contact(fullName: 'Narendra', email: 'Narendra@example.com'),
  Contact(fullName: 'Sravan ', email: 'Sravan@example.com'),
  Contact(fullName: 'Ranganadh', email: 'Ranganadh@example.com'),
  Contact(fullName: 'Karthik', email: 'Karthik@example.com'),
  Contact(fullName: 'Saranya', email: 'Saranya@example.com'),
  Contact(fullName: 'Mahesh', email: 'Mahesh@example.com'),
];

List<Contact> receivedCallContacts = [
  Contact(fullName: 'Pratap Kumar', email: 'pratap@example.com'),
  Contact(fullName: 'Jagadeesh', email: 'Jagadeesh@example.com'),
  Contact(fullName: 'Srinivas', email: 'Srinivas@example.com'),
];

List<Contact> dialledCallContacts = [
  Contact(fullName: 'Ranganadh', email: 'Ranganadh@example.com'),
  Contact(fullName: 'Karthik', email: 'Karthik@example.com'),
  Contact(fullName: 'Saranya', email: 'Saranya@example.com'),
  Contact(fullName: 'Mahesh', email: 'Mahesh@example.com'),
];

class MissedCallsPage extends StatefulWidget {
  @override  State<StatefulWidget> createState() {
    // TODO: implement createState    return new _MissedCallsPage();
  }
}

class _MissedCallsPage extends State<MissedCallsPage> {
  @override  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                itemCount: missedCallContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${missedCallContacts[index].fullName}',
                    ),
                    subtitle: Text('${missedCallContacts[index].email}'),
                    leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('${missedCallContacts[index].fullName.substring(
                            0, 1)}')),
                    onTap: () => _onTapItem(context, missedCallContacts[index]),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _onTapItem(BuildContext context, Contact post) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
  }
}

class ReceivedCallsPage extends StatefulWidget {
  @override  State<StatefulWidget> createState() {
    // TODO: implement createState    return new _ReceivedCallsPage();
  }
}

class _ReceivedCallsPage extends State<ReceivedCallsPage> {
  @override  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                itemCount: receivedCallContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${receivedCallContacts[index].fullName}',
                    ),
                    subtitle: Text('${receivedCallContacts[index].email}'),
                    leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child:
                        Text('${receivedCallContacts[index].fullName.substring(
                            0, 1)}')),
                    onTap: () => _onTapItem(context, receivedCallContacts[index]),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _onTapItem(BuildContext context, Contact post) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
  }
}

class DialledCallsPage extends StatefulWidget {
  @override  State<StatefulWidget> createState() {
    // TODO: implement createState    return new _DialledCallsPage();
  }
}

class _DialledCallsPage extends State<DialledCallsPage> {
  @override  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                itemCount: dialledCallContacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${dialledCallContacts[index].fullName}',
                    ),
                    subtitle: Text('${dialledCallContacts[index].email}'),
                    leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child:
                        Text('${dialledCallContacts[index].fullName.substring(
                            0, 1)}')),
                    onTap: () => _onTapItem(context, dialledCallContacts[index]),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _onTapItem(BuildContext context, Contact post) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Tap on " + ' - ' + post.fullName)));
  }
}

class Contact {
  final String fullName;
  final String email;

  const Contact({this.fullName, this.email});
}