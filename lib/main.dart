import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_rpn/calc_stack.dart';
import 'package:simple_rpn/calc_button.dart';
import 'package:simple_rpn/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOffButtonRow(),
            _buildDisplayBox(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildNumberPad()),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _buildOperatorPad()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffButtonRow() {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 24, right: 18),
          child: ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'OFF',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      margin: const EdgeInsets.fromLTRB(12, 24, 12, 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: false,
            child: Row(
              children: [
                Text(
                  display,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.inter(
                    color: Colors.greenAccent,
                    fontSize: 36,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 30,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
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

  Widget _buildOperatorPad() {
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
