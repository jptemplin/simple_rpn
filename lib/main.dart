import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:simple_rpn/calc_stack.dart';
import 'package:simple_rpn/constants.dart';
import 'package:simple_rpn/calc_off_button_row.dart';
import 'package:simple_rpn/calc_display_box.dart';
import 'package:simple_rpn/calc_number_pad.dart';
import 'package:simple_rpn/calc_operator_pad.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Skeleton',
      home: const CalculatorWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  bool numberEntryMode = true;
  bool integerEntryMode = true;
  bool isNegative = false;
  bool stackLiftEnabled = false;
  String integerPart = '';
  String decimalPart = '';
  String lastKeyPressed = '';
  var stack = CalcStack();
  String display = '0';
  final integerFormatter = NumberFormat("#,##0");
  final numberFormat = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    stack.clear();
    endNumberEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CalcOffButtonRow(),
            CalcDisplayBox(display: display),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CalcNumberPad(onButtonPressed: onButtonPressed),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: CalcOperatorPad(onButtonPressed: onButtonPressed),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onButtonPressed(String label) {
    lastKeyPressed = label;

    switch (label) {
      case label0:
      case label1:
      case label2:
      case label3:
      case label4:
      case label5:
      case label6:
      case label7:
      case label8:
      case label9:
        if (!numberEntryMode) {
          // If stack lift is enabled, push current X to the stack
          if (stackLiftEnabled) {
            stack.push(stack.x);
          }
          beginNumberEntry();
          stackLiftEnabled = false; // Reset after lifting (or not)
        }
        if (integerEntryMode) {
          integerPart += label;
        } else {
          decimalPart += label;
        }
        String display = formatDisplay();
        double value = parseNumber(display);
        stack.x = value;
        break;

      case labelDecimalPoint:
        if (!numberEntryMode) {
          beginNumberEntry();
        }
        if (integerEntryMode) {
          integerEntryMode = false;
          decimalPart = '';
        }
        break;

      case labelPlusMinus:
        if (stack.x != 0) {
          isNegative = !isNegative;
          stack.x = -stack.x;
        }
        break;

      case labelPlus:
        performBinaryOperation((a, b) => a + b);
        break;

      case labelMinus:
        performBinaryOperation((a, b) => a - b);
        break;

      case labelMultiply:
        performBinaryOperation((a, b) => a * b);
        break;

      case labelDivide:
        performBinaryOperation((a, b) => a / b);
        break;

      case labelPercent:
        double operand1 = stack.pop();
        double operand2 = stack.x;
        double result = operand2 * (operand1 / 100.0);
        stack.push(result);
        endNumberEntry();
        stackLiftEnabled = true; // LIFT stack on next entry
        break;

      case labelClearX:
        stack.x = 0.0;
        endNumberEntry();
        break;

      case labelSwapXY:
        double temp = stack.x;
        stack.x = stack.y;
        stack.y = temp;
        endNumberEntry();
        stackLiftEnabled = true; // LIFT stack on next entry
        break;

      case labelEnter:
        if (numberEntryMode) {
          double value = parseNumber(formatDisplay());
          stack.push(value);
          stack.x = value;
        } else {
          stack.push(stack.x);
        }
        endNumberEntry();
        stackLiftEnabled = false; // Do NOT lift stack on next entry
        break;

      default:
        break;
    }
    setState(() {
      display =
          (lastKeyPressed == labelEnter)
              ? formatNumber(stack.x)
              : (numberEntryMode ? formatDisplay() : formatNumber(stack.x));
    });

    if (kDebugMode) {
      print('Display: $display');
      stack.dump();
    }
  }

  void beginNumberEntry() {
    numberEntryMode = true;
    integerEntryMode = true;
    isNegative = false;
    integerPart = '';
    decimalPart = '';
  }

  void endNumberEntry() {
    numberEntryMode = false;
    integerEntryMode = false;
    isNegative = false;
    integerPart = '';
    decimalPart = '';
  }

  void performBinaryOperation(double Function(double, double) operation) {
    double operand1 = stack.pop();
    double operand2 = stack.pop();
    double result = operation(operand2, operand1);
    stack.push(result);
    endNumberEntry();
    stackLiftEnabled = true; // LIFT stack on next entry
  }

  // Formats an [int] or [double] to a locale-aware string with commas.
  String formatNumber(num value) {
    // Handle negative numbers
    final isNeg = value < 0;
    value = value.abs();

    // Round to 6 decimal places
    value = double.parse(value.toStringAsFixed(6));

    // Split into integer and decimal parts
    String asString = value.toStringAsFixed(6);
    List<String> parts = asString.split('.');

    // Format integer part with commas
    String intPart = integerFormatter.format(int.parse(parts[0]));

    // Remove trailing zeros from decimal part
    String decPart = parts[1].replaceFirst(RegExp(r'0+$'), '');

    String result = isNeg ? '-' : '';
    result += intPart;
    if (decPart.isNotEmpty) {
      result += '.$decPart';
    }
    return result;
  }

  // Parses a string with commas into a [double].
  // Assumes the string is formatted in your locale's decimal pattern.
  double parseNumber(String input) {
    return numberFormat.parse(input).toDouble();
  }

  String formatDisplay() {
    String formatted = '';
    if (isNegative && (integerPart.isNotEmpty || decimalPart.isNotEmpty)) {
      formatted += '-';
    }
    if (integerPart.isEmpty) {
      formatted += '0';
    } else {
      // Add commas to the integer part
      int intPart = int.parse(integerPart);
      String integerPartWithCommas = integerFormatter.format(intPart);
      formatted += integerPartWithCommas;
    }
    if (!integerEntryMode) {
      formatted += '.';
      if (decimalPart.isNotEmpty) {
        formatted += decimalPart;
      }
    }
    return formatted;
  }
}
