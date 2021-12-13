import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';

class EditTodo extends StatefulWidget {
  final Todo todo;

  const EditTodo({Key? key, required this.todo}) : super(key: key);

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late String _title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _description;
  late int? _priority;
  //final bool _status;

  @override
  void initState() {
    super.initState();
    _title = widget.todo.title;
    _description = widget.todo.description as String;
    _priority = widget.todo.priority as int;
    // _status = widget.todo.status as bool;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit todo"),
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
                padding: const EdgeInsets.all(8.0),
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
                      initialValue: _title,
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
                      validator: (title) {
                        if (title!.trim().isEmpty) {
                          return "Please enter title";
                        } else if (_title != title) {
                          _title = title;
                        }
                        return null;
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
                      initialValue: _description,
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
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
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
                              value: _priority,
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
              )),
        ),
      ),
    );
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Todo todo = Todo(title: _title);
      todo.description = _description;
      TodoService().updateByID(todo.toJson(todo), widget.todo.uid as String);
      Navigator.pop(context);
    }
  }
}
