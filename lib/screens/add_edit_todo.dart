import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/validation.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddEditTodo extends StatefulWidget {
  final Todo? todo;

  const AddEditTodo({Key? key, this.todo}) : super(key: key);

  @override
  _AddEditTodoState createState() => _AddEditTodoState();
}

class _AddEditTodoState extends State<AddEditTodo> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  int _priority = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _status = false;
  bool _routine = false;
  DateTime? _dueDate; //= DateTime.now();
  List<bool> _weekdays = List<bool>.filled(7, false);
  final DateSymbols de = dateTimeSymbolMap()['de'];

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      _title.text = widget.todo!.title;
      _description.text = widget.todo!.description as String;
      _priority = widget.todo!.priority as int;
      _status = widget.todo!.status as bool;
      _dueDate =
          widget.todo!.dueDate == null ? null : widget.todo!.dueDate!.toLocal();
      _routine = widget.todo!.routine as bool;
      _weekdays = widget.todo!.weekdays;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_DE', null);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.todo != null ? "Edit todo" : "Add Todo"),
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.check,
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
                    textLabel("Titel:"),
                    TextFormField(
                        controller: _title,
                        textAlign: TextAlign.start,
                        decoration: textFormFieldDecoration("Titel"),
                        validator: (value) => validateTitle(value)),
                    placeHolder,
                    textLabel("Notizen:"),
                    TextFormField(
                      controller: _description,
                      textAlign: TextAlign.start,
                      decoration: textFormFieldDecoration("Notizen"),
                      validator: (value) => validateDescription(value),
                    ),
                    placeHolder,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        textLabel("Routineaufgabe: "),
                        Checkbox(
                            value: _routine,
                            onChanged: (value) {
                              setState(() {
                                _routine = value as bool;
                              });
                            })
                      ],
                    ),
                    placeHolder,
                    textLabel("Prioriät:"),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: prioritySlider())),
                    placeHolder,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        textLabel("Status: "),
                        Checkbox(
                            value: _status,
                            onChanged: (value) {
                              setState(() {
                                _status = value as bool;
                              });
                            })
                      ],
                    ),
                    if (_routine == true) placeHolder,
                    if (_routine == true)
                      WeekdaySelector(
                        weekdays: de.STANDALONEWEEKDAYS,
                        shortWeekdays: de.STANDALONENARROWWEEKDAYS,
                        firstDayOfWeek: de.FIRSTDAYOFWEEK + 1,
                        values: _weekdays,
                        onChanged: (int day) {
                          setState(() {
                            final index = day % 7;
                            _weekdays[index] = !_weekdays[index];
                          });
                        },
                      ),
                    placeHolder,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        textLabel(_routine == true
                            ? "Serie endet am: "
                            : "Endfällig: "),
                        ElevatedButton(
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today_outlined),
                                Text(_dueDate == null
                                    ? "Select Date"
                                    : DateFormat('dd.MM.yyyy', 'de_AT')
                                        .format(_dueDate!))
                              ]),
                          onPressed: () async {
                            final newDate = await showDatePicker(
                              context: context,
                              initialDate: _dueDate ?? DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 5),
                              lastDate: DateTime(DateTime.now().year + 5),
                            );

                            if (newDate != null) {
                              setState(() => _dueDate = newDate);
                            }
                          },
                        ),
                        if (_dueDate != null)
                          ElevatedButton(
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Icon(Icons.timer),
                                  Text(DateFormat('HH:mm', 'de_AT')
                                      .format(_dueDate!))
                                ]),
                            onPressed: () async {
                              final newTime = await showTimePicker(
                                  context: context,
                                  builder: (context, childWidget) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: childWidget as Widget);
                                  },
                                  initialTime: TimeOfDay(
                                      hour: _dueDate!.hour,
                                      minute: _dueDate!.minute));
                              if (newTime != null) {
                                setState(() {
                                  _dueDate = DateTime(
                                      _dueDate!.year,
                                      _dueDate!.month,
                                      _dueDate!.day,
                                      newTime.hour,
                                      newTime.minute);
                                });
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Todo todo = Todo(
          title: _title.text,
          description: _description.text,
          priority: _priority,
          status: _status,
          dueDate: _dueDate,
          routine: _routine,
          weekdays: _weekdays);
      if (widget.todo == null) {
        TodoService().add(todo.toJson(todo));
      } else {
        TodoService().updateByID(todo.toJson(todo), widget.todo!.uid as String);
      }
      Navigator.pop(context);
    }
  }

  Widget prioritySlider() {
    return SfSlider(
        activeColor: Colors.blue,
        inactiveColor: Colors.blueGrey,
        value: _priority,
        stepSize: 1,
        max: 5,
        min: 1,
        interval: 1,
        showLabels: true,
        labelFormatterCallback: (dynamic actualValue, String formattedText) {
          switch (actualValue) {
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
            _priority = (value! as int);
          });
        });
  }
}
