import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  final String initialVal;

  const FormWidget({Key key, this.initialVal}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  String task = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          TextFormField(
            initialValue: widget.initialVal,
            onChanged: (val) {
              task = val;
            },
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context, task);
            },
            child: Text(
              'Submit',
            ),
            color: Colors.grey,
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
