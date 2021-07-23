import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/form_widget.dart';
import 'package:http/http.dart';

class TaskModel {
  final String id;
  final String name;

  TaskModel({this.id, this.name});
}

class ApiTodoList extends StatefulWidget {
  
  @override
  _ApiTodoListState createState() => _ApiTodoListState();
}

class _ApiTodoListState extends State<ApiTodoList> {
  List<TaskModel> apiTodoList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadApiTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Todo List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemBuilder: (context, index) => Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text('${apiTodoList[index].name}'),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          var val = await showDialog(
                            context: context,
                            builder: (context) => FormWidget(
                              initialVal: apiTodoList[index].name,
                            ),
                          );
                          if (val != null && val.trim().isNotEmpty) {
                            editItemInApiTodoList(
                                val, apiTodoList[index].id, index);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteItemInApiTodoList(apiTodoList[index].id);
                        },
                      )
                    ],
                  ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: apiTodoList.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var val = await showDialog(
            context: context,
            builder: (context) => FormWidget(),
          );
          if (val != null && val.trim().isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              apiTodoList.add(val);
            });
            // prefs.setStringList('apiTodoList', apiTodoList);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void loadApiTodoList() async {
    /// Get method
    setState(() => isLoading = true);
    var url = Uri.parse('https://6088ee99a6f4a30017427356.mockapi.io/v1/user');
    var response = await get(url);
  
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        jsonData.forEach((item) {
          apiTodoList.add(TaskModel(
            id: item['id'],
            name: item['name'],
          ));
        });
      }
      setState(() => isLoading = false);
    }
    setState(() => isLoading = false);
  }

  void deleteItemInApiTodoList(String id) async {
    setState(() => isLoading = true);
    var url =
        Uri.parse('https://6088ee99a6f4a30017427356.mockapi.io/v1/user/$id');
    var response = await delete(url);
    if (response.statusCode == 200) {
      setState(() {
        apiTodoList.removeWhere((element) => element.id == id);
      });
      setState(() => isLoading = false);
    }
  }

  void editItemInApiTodoList(String val, String id, int index) async {
    setState(() => isLoading = true);
    var url =
        Uri.parse('https://6088ee99a6f4a30017427356.mockapi.io/v1/user/$id');
    var response = await put(url, body: {"name": val});
    if (response.statusCode == 200) {
      setState(() {
        apiTodoList.removeWhere((element) => element.id == id);
        apiTodoList.insert(
            0,
            TaskModel(
              id: id,
              name: val,
            ));
      });
      setState(() => isLoading = false);
    }
  }
}
