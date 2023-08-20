import 'package:flutter/material.dart';

final dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

class DaysSelector extends StatelessWidget {
  final List<int> selectedIndices;
  final Function(List<int>) onSelectionChanged;

  const DaysSelector({
    super.key,
    required this.selectedIndices,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0,
      runSpacing: 4.0,
      children: List.generate(dayLabels.length, (index) {
        return ElevatedButton(
          onPressed: () {
            List<int> updatedSelection = List.from(selectedIndices);
            if (updatedSelection.contains(index)) {
              updatedSelection.remove(index);
            } else {
              updatedSelection.add(index);
            }
            onSelectionChanged(updatedSelection);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndices.contains(index) ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          child: Text(dayLabels[index]),
        );
      }),
    );
  }
}
