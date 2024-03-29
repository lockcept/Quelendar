import 'package:flutter/material.dart';

class CardTable extends StatefulWidget {
  final Map<String, Widget> data;

  const CardTable({super.key, required this.data});

  @override
  CardTableState createState() => CardTableState();
}

class CardTableState extends State<CardTable> {
  List<Widget> buildChildrenWithDividers() {
    List<Widget> childrenWithDividers = [];
    List<Widget> childrenWithoutDividers = widget.data.entries.map(
      (entry) {
        return Container(
          constraints: const BoxConstraints(minHeight: 30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(entry.key),
                ),
                const SizedBox(
                  width: 6.0,
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

    return childrenWithDividers;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: buildChildrenWithDividers(),
          ),
        ),
      ),
    );
  }
}
