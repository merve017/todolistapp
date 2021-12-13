import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  int? _priority = 5;

  bool _status = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Todo"),
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                size: 35,
              ),
              color: Colors.greenAccent,
              onPressed: () => submit(context),
            ),
            IconButton(
              icon: const Icon(
                Icons.cancel,
                size: 35,
              ),
              color: Colors.redAccent,
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 10),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 25,
                      child: Text('Title:'),
                    ),
                  ),
                  TextFormField(
                    controller: _title,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        prefixIcon: const Icon(Icons.description),
                        hintText: "Title",
                        hintStyle: kHintStyle,
                        fillColor: Colors.grey[200],
                        filled: true,
                        enabledBorder: kOutlineBorder,
                        focusedBorder: kOutlineBorder,
                        errorBorder: kOutLineErrorBorder,
                        focusedErrorBorder: kOutLineErrorBorder),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter title';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 25,
                      child: Text('description'),
                    ),
                  ),
                  TextFormField(
                    controller: _description,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        prefixIcon: const Icon(Icons.description),
                        hintText: "Description",
                        hintStyle: kHintStyle,
                        fillColor: Colors.grey[200],
                        filled: true,
                        enabledBorder: kOutlineBorder,
                        focusedBorder: kOutlineBorder,
                        errorBorder: kOutLineErrorBorder,
                        focusedErrorBorder: kOutLineErrorBorder),
                  ),
                  Checkbox(
                      value: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 25,
                      child: Text('priority'),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SfSlider(
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blueGrey,
                            value: _priority as double,
                            stepSize: 1,
                            max: 5,
                            min: 1,
                            interval: 1,
                            showLabels: true,
                            labelFormatterCallback:
                                (dynamic actualValue, String formattedText) {
                              switch (actualValue as int) {
                                case 1:
                                  return 'low';
                                case 2:
                                  return 'medium/low';
                                case 3:
                                  return 'medium';
                                case 4:
                                  return 'high/medium';
                                default:
                                  return 'high';
                              }
                            },
                            onChanged: (dynamic value) {
                              setState(() {
                                _priority = (value as int?);
                              });
                            },
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Todo todo = Todo(title: _title.text);
      todo.description = _description.text;
      TodoService().add(todo.toJson(todo));
      Navigator.pop(context);
    }
  }
}
