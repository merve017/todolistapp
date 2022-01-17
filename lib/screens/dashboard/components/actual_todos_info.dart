import 'package:flutter/material.dart';
import 'package:todolist_app/screens/lists/components/liststreambuilder.dart';
import 'package:todolist_app/service/todo_service.dart';
import 'package:todolist_app/shared/constants.dart';

class ActualTodosInfo extends StatelessWidget {
  const ActualTodosInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "offene To-Do's von heute",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          placeHolder,
          ListStreamBuilder(
              query: TodoService()
                  .getTodoListOfCurrentUserofOpenTodosOfTodayLimit5())
        ]));
  }
}
