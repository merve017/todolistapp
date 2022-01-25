import 'package:todolist_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/service/auth_service.dart';

import 'package:todolist_app/shared/constants.dart';

import 'components/quotes.dart';
import 'components/actual_todos_info.dart';
import 'components/statistics_info.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Hello ${AuthService.user?.displayName ?? ""}!',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left),
            ),
            placeHolder,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Zitat des Tages:",
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                      placeHolder,
                      Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Quotes(),
                      ),
                      placeHolder,
                      const ActualTodosInfo(),
                      if (Responsive.isMobile(context)) placeHolder,
                      if (Responsive.isMobile(context)) const StatisticsInfos(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StatisticsInfos(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*
@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Hello ${AuthService.userFromFirebase(AuthService.user as User).firstName ?? AuthService.user!.displayName}',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.left),
            ),
            placeHolder,
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white10),
              ),
              child: const Quotes(),
            ),
            placeHolder,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const TodoInfos(),
                      placeHolder,
                      const ActualTodosInfo(),
                      if (Responsive.isMobile(context)) placeHolder,
                      if (Responsive.isMobile(context)) const StatisticsInfos(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StatisticsInfos(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }*/
