import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:quelendar/util/calculate_focus_color.dart';

class ClockScrollRow extends StatefulWidget {
  final int defaultHour;
  final int defaultMinute;
  final void Function(int) onHourChanged;
  final void Function(int) onMinuteChanged;

  const ClockScrollRow({
    Key? key,
    required this.defaultHour,
    required this.defaultMinute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  }) : super(key: key);

  @override
  ClockScrollRowState createState() => ClockScrollRowState();
}

class ClockScrollRowState extends State<ClockScrollRow> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final selectWidget = Row(
      children: [
        Expanded(
          flex: 4,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: NumberPicker(
              value: widget.defaultHour,
              minValue: 0,
              maxValue: 23,
              onChanged: (value) => widget.onHourChanged(value),
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
        const Expanded(flex: 1, child: Text("시")),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          flex: 4,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: NumberPicker(
              value: widget.defaultMinute,
              minValue: 0,
              maxValue: 59,
              onChanged: (value) => widget.onMinuteChanged(value),
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
        const Expanded(flex: 1, child: Text("분")),
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
                    ? Theme.of(context).colorScheme.primary
                    : calculateFocusColor(Theme.of(context).colorScheme.primary),
                textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () {
                setState(() {
                  isEditMode = !isEditMode;
                });
              },
              child: Text("${widget.defaultHour.toString()}시 ${widget.defaultMinute.toString()}분"),
            ),
          ),
        ],
      ),
      if (isEditMode) selectWidget
    ]);
  }
}
