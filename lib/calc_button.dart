import 'package:flutter/material.dart';
import 'package:calc_buttons/constants.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontsize;

  const CalcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontsize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        height: kCalcButtonHeight,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            padding: const EdgeInsets.all(8),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: fontsize ?? 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
