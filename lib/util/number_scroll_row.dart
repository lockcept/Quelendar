import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:quelendar/util/calculate_focus_color.dart';

class NumberScrollRow extends StatefulWidget {
  final int defaultValue;
  final void Function(int) onChanged;
  final String trailingText;
  final int maxValue;

  const NumberScrollRow({
    Key? key,
    required this.defaultValue,
    required this.onChanged,
    required this.trailingText,
    required this.maxValue,
  }) : super(key: key);

  @override
  NumberScrollRowState createState() => NumberScrollRowState();
}

class NumberScrollRowState extends State<NumberScrollRow> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final selectWidget = Row(
      children: [
        Expanded(
          flex: 7,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: NumberPicker(
              value: widget.defaultValue,
              minValue: 1,
              maxValue: widget.maxValue,
              onChanged: (value) => widget.onChanged(value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(flex: 3, child: Text(widget.trailingText)),
      ],
    );

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isEditMode
                    ? Theme.of(context).colorScheme.secondary
                    : calculateFocusColor(Theme.of(context).colorScheme.secondary),
                textStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              onPressed: () {
                setState(() {
                  isEditMode = !isEditMode;
                });
              },
              child: Text("${widget.defaultValue.toString()}${widget.trailingText}"),
            ),
          ),
        ],
      ),
      if (isEditMode) selectWidget
    ]);
  }
}
