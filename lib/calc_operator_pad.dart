import 'package:flutter/material.dart';
import 'package:simple_rpn/calc_button.dart';
import 'package:simple_rpn/constants.dart';

class CalcOperatorPad extends StatelessWidget {
  final void Function(String) onButtonPressed;
  const CalcOperatorPad({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CalcButton(
              label: labelPlusMinus,
              onPressed: () => onButtonPressed(labelPlusMinus),
            ),
            CalcButton(
              label: labelDivide,
              onPressed: () => onButtonPressed(labelDivide),
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: labelPercent,
              onPressed: () => onButtonPressed(labelPercent),
            ),
            CalcButton(
              label: labelMultiply,
              onPressed: () => onButtonPressed(labelMultiply),
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: labelSwapXY,
              onPressed: () => onButtonPressed(labelSwapXY),
              fontsize: 20,
            ),
            CalcButton(
              label: labelMinus,
              onPressed: () => onButtonPressed(labelMinus),
            ),
          ],
        ),
        Row(
          children: [
            CalcButton(
              label: labelEnter,
              onPressed: () => onButtonPressed(labelEnter),
              fontsize: 20,
              color: Colors.orange,
            ),
            CalcButton(
              label: labelPlus,
              onPressed: () => onButtonPressed(labelPlus),
            ),
          ],
        ),
      ],
    );
  }
}
