import 'package:flutter/material.dart';

Widget buildCardTable(Map<String, Widget> data) {
  List<Widget> childrenWithDividers = [];
  List<Widget> childrenWithoutDividers = data.entries.map(
    (entry) {
      return Container(
        constraints: const BoxConstraints(minHeight: 40.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(entry.key),
              ),
              const SizedBox(
                width: 8.0,
                height: 24,
              ),
              Expanded(flex: 7, child: entry.value),
            ],
          ),
        ),
      );
    },
  ).toList();

  for (int i = 0; i < childrenWithoutDividers.length; i++) {
    childrenWithDividers.add(childrenWithoutDividers[i]);
    if (i < childrenWithoutDividers.length - 1) {
      childrenWithDividers.add(const Divider());
    }
  }

  return Card(
    elevation: 2.0,
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: childrenWithDividers,
        )),
  );
}
