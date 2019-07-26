import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: new MyHomePage(title: 'Table behavior demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {

    final cols1 = [
      new DataColumn(
        label: const Text('Column title 1'),
      ),
    ];

    final cols2 = [
      new DataColumn(
        label: const Text('Column title 1'),
      ),
      new DataColumn(
        label: const Text('Long column title'),
      ),
      new DataColumn(
        label: const Text('Title'),
      ),
    ];

    final rows1 = new List.generate(3, (_) =>
    new DataRow(
        cells: [
          new DataCell(new Text('loooooonnnnnng')),
        ]));

    final rows2 = new List.generate(3, (_) =>
    new DataRow(
        cells: [
          new DataCell(new Text('loooooonnnnnng gets wrapped')),
          new DataCell(new Text('short')),
          new DataCell(new Text('vs')),
        ]));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Column(
        children: [
          new Material(
            child: new DataTable(columns: cols1, rows: rows1),
          ),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          new Material(
            child: new DataTable(columns: cols2, rows: rows2),
          ),
        ],
      ),
    );
  }
}