import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:todolist_app/models/routine_model.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/service/routine_service.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';
import 'package:todolist_app/shared/loading.dart';
import 'package:todolist_app/shared/validation.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddEditTodo extends StatefulWidget {
  final Todo? todo;
  final RoutineTask? routineTask;
  final String? rid;

  const AddEditTodo({Key? key, this.todo, this.routineTask, this.rid})
      : super(key: key);

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
  Repetition _repetition = Repetition.none;

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
    } else if (widget.routineTask != null) {
      _title.text = widget.routineTask!.title;
      _description.text = widget.routineTask!.description as String;
      _priority = widget.routineTask!.priority as int;
      _status = widget.routineTask!.status as bool;
      _dueDate =
          widget.todo!.dueDate == null ? null : widget.todo!.dueDate!.toLocal();
      _weekdays = widget.routineTask!.weekdays;
      _repetition = Repetition.values[widget.routineTask!.repetition as int];
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_DE', null);
    return widget.rid != null
        ? StreamBuilder<QuerySnapshot>(
            stream: RoutineService().getRoutineTasks(widget.rid!),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return loadingScreens(snapshot, "Erledigte To-Do's");
            })
        : mainWidget();
  }

  Widget mainWidget() {
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
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    leading: const Text(''),
                    title: TextFormField(
                      controller: _title,
                      validator: (value) => validateTitle(value),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Titel hinzufügen',
                      ),
                    )),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Icon(
                    Icons.subject,
                    color: Colors.black87,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: _description,
                            validator: (value) => validateDescription(value),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Beschreibung hinzufügen',
                            )),
                      ),
                      Checkbox(
                          value: _status,
                          onChanged: (value) {
                            setState(() {
                              _status = value as bool;
                            });
                          }),
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                ),
                ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Icon(
                      Icons.priority_high_rounded,
                      color: Colors.black87,
                    ),
                    title: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: prioritySlider()))),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                ),
                ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Icon(
                      Icons.repeat_on_rounded,
                      color: Colors.black87,
                    ),
                    title: Row(
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
                    )),
                if (_routine == true) placeHolder,
                if (_routine == true)
                  ListTile(
                      contentPadding: const EdgeInsets.all(5),
                      leading: const Text(''),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            textLabel("Wiederholung: "),
                            DropdownButton<String>(
                              value: _repetition.name,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  switch (newValue) {
                                    case 'Wöchentlich':
                                      _repetition = Repetition.weekly;
                                      break;
                                    case 'Monatlich':
                                      _repetition = Repetition.monthly;
                                      break;
                                    case 'Jährlich':
                                      _repetition = Repetition.yearly;
                                      break;
                                    default:
                                      _repetition = Repetition.none;
                                  }
                                });
                              },
                              items: <String>[
                                Repetition.none.name,
                                Repetition.weekly.name,
                                Repetition.monthly.name,
                                Repetition.yearly.name,
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ])),
                if (_routine == true) placeHolder,
                if (_routine == true)
                  ListTile(
                      contentPadding: const EdgeInsets.all(5),
                      title: WeekdaySelector(
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
                      )),
                const Divider(
                  height: 1.0,
                  thickness: 1,
                ),
                placeHolder,
                ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black87,
                  ),
                  title: Row(
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
                )
              ],
            )),
      ),
    ));
  }

  submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      late RoutineTask routineTask;
      late Todo todo;
      if (_routine) {
        routineTask = RoutineTask(
            rid: RoutineService().getID(),
            title: _title.text,
            description: _description.text,
            priority: _priority,
            dueDate: _dueDate,
            doneDate: _status == true ? DateTime.now() : null,
            weekdays: _weekdays,
            repetition: _repetition.index);
      } else {
        todo = Todo(
            title: _title.text,
            description: _description.text,
            priority: _priority,
            status: _status,
            dueDate: _dueDate,
            doneDate: _status == true ? DateTime.now() : null);
      }
      int m;
      bool n;
      if (widget.todo == null && widget.routineTask == null) {
        if (_routine == true) {
          RoutineService().add(routineTask.toJson(routineTask));

          for (var i = DateTime.now();
              i.isBefore(_dueDate!.add(const Duration(days: 1)));
              i = i.add(const Duration(days: 1))) {
            m = i.weekday % 7;
            n = _weekdays[(i.weekday % 7)];
            print(m);
            print(n);
            if (_weekdays[(i.weekday % 7)]) {
              todo = Todo(
                  title: _title.text,
                  description: _description.text,
                  priority: _priority,
                  dueDate: i,
                  status: false,
                  rid: routineTask.rid,
                  doneDate: _status == true ? DateTime.now() : null);
              TodoService().add(todo.toJson(todo));
            }
          }
          if (_repetition == Repetition.weekly) {}
        } else {
          TodoService().add(todo.toJson(todo));
        }
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
        max: 4,
        min: 1,
        interval: 1,
        showLabels: true,
        labelFormatterCallback: (dynamic actualValue, String formattedText) {
          switch (actualValue) {
            case 4:
              return 'Hoch';
            case 3:
              return 'Mittel';
            case 2:
              return 'Niedrig';
            default:
              return 'Nicht priorisiert';
          }
        },
        onChanged: (dynamic value) {
          setState(() {
            if (value is String) {
              _priority = int.parse(value);
            } else {
              _priority = value.toInt();
            }
          });
        });
  }

  Widget loadingScreens(AsyncSnapshot<QuerySnapshot> snapshot, String title) {
    const Loading();
    if (snapshot.hasError) {
      return const Text("Etwas ging schief - bitte aktualisiere die Seite");
      // Fluttertoast.showToast(msg: 'Something went wrong');
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Text(
          "Laden...",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      // if (snapshot.hasData && snapshot.data!.size > 0) {
      RoutineTask routineTask = RoutineTask.fromJson(
          snapshot.data!.docs[0].data() as Map<String, dynamic>);
      _title.text = routineTask.title;
      _description.text = routineTask.description as String;
      _priority = routineTask.priority as int;
      _status = routineTask.status as bool;
      _routine = true;
      _dueDate =
          routineTask.dueDate == null ? null : routineTask.dueDate!.toLocal();
      _weekdays = routineTask.weekdays;
      _repetition = Repetition.values[routineTask.repetition as int];
      return mainWidget();
    }
  }
}
