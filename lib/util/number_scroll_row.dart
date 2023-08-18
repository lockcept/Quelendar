import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberScrollRow extends StatelessWidget {
  final int defaultValue;
  final void Function(int) onChanged;
  final String leadingText;
  final int maxValue;

  const NumberScrollRow({
    Key? key,
    required this.defaultValue,
    required this.onChanged,
    required this.leadingText,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: NumberPicker(
              value: defaultValue,
              minValue: 1,
              maxValue: maxValue,
              onChanged: (value) => onChanged(value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(flex: 2, child: Text(leadingText)),
      ],
    );
  }
}
