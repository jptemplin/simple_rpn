import 'package:flutter/material.dart';
import 'package:simple_rpn/calc_button.dart';
import 'package:simple_rpn/constants.dart';

class CalcNumberPad extends StatelessWidget {
  final void Function(String) onButtonPressed;
  const CalcNumberPad({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CalcButton(
              label: label7,
              onPressed: () => onButtonPressed(label7),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label8,
              onPressed: () => onButtonPressed(label8),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label9,
              onPressed: () => onButtonPressed(label9),
              color: Colors.grey[600],
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: label4,
              onPressed: () => onButtonPressed(label4),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label5,
              onPressed: () => onButtonPressed(label5),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label6,
              onPressed: () => onButtonPressed(label6),
              color: Colors.grey[600],
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: label1,
              onPressed: () => onButtonPressed(label1),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label2,
              onPressed: () => onButtonPressed(label2),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: label3,
              onPressed: () => onButtonPressed(label3),
              color: Colors.grey[600],
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: label0,
              onPressed: () => onButtonPressed(label0),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: labelDecimalPoint,
              onPressed: () => onButtonPressed(labelDecimalPoint),
              color: Colors.grey[600],
            ),
            CalcButton(
              label: labelClearX,
              onPressed: () => onButtonPressed(labelClearX),
              fontsize: 20,
            ),
          ],
        ),
      ],
    );
  }
}
