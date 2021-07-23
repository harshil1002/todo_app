import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'form_widget.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> todoList = [];

  @override
  void initState() {
    super.initState();
    loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${todoList[index]}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: () async {
                      var val = await showDialog(
                        context: context,
                        builder: (context) => FormWidget(
                          initialVal: todoList[index],
                        ),
                      );
                      if (val != null && val.trim().isNotEmpty) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        deleteItemInTodoList(todoList[index]);
                        setState(() {
                          todoList.add(val);
                        });
                        prefs.setStringList('todoList', todoList);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      deleteItemInTodoList(todoList[index]);
                    },
                  )
                ],
              ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: todoList.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var val = await showDialog(
            context: context,
            builder: (context) => FormWidget(),
          );
          if (val != null && val.trim().isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              todoList.add(val);
            });
            prefs.setStringList('todoList', todoList);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = prefs.getStringList('todoList') ?? [];
    });
  }

  void deleteItemInTodoList(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isAvailable = todoList.where((item) {
      return item == val;
    });
    if (isAvailable != null) {
      setState(() {
        todoList.remove(val);
        prefs.setStringList('todoList', todoList);
      });
    }
  }

  void editItemInTodoList(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isAvailable = todoList.where((item) {
      return item == val;
    });
    if (isAvailable != null) {
      setState(() {
        todoList.remove(val);
        prefs.setStringList('todoList', todoList);
      });
    }
  }
}
