import 'package:flutter/material.dart';

Widget getDevidedRow(String name, Widget settingWidget) {
  return Card(
      elevation: 2.0,
      child: Container(
        constraints: const BoxConstraints(minHeight: 70.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(name),
              ),
              const SizedBox(
                width: 8.0,
                height: 24,
              ),
              Expanded(flex: 7, child: settingWidget),
            ],
          ),
        ),
      ));
}
