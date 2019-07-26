import 'package:flutter/material.dart';

class CharFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CharState();
  }
}

class CharState extends State<CharFragment> {
  characterNew() async {
    await showDialog<bool>(
        context: context,
        child: new AlertDialog(
          title: new Text('Create new Character?'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true)
            ),
            new FlatButton(
                child: new Text('No'),
                onPressed: () => Navigator.of(context).pop(false)
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            new RaisedButton.icon(
                onPressed: characterNew,
                icon: new Icon(Icons.add, size: 80.0,),
                label: new Text('')
            )
          ],
        )
    );
  }
}