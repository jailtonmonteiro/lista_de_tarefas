import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoControler = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoControler.text;
      _toDoControler.text = "";
      newToDo["done"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  //returns used file
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  //save file
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  //Reading file
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blue,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _toDoControler,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blue)),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Adicionar"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_toDoList[index]["title"]),
                      value: _toDoList[index]["done"],
                      secondary: CircleAvatar(
                        child: Icon(_toDoList[index]["done"]
                            ? Icons.check
                            : Icons.error),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _toDoList[index]["done"] = value;
                          _saveData();
                        });
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
