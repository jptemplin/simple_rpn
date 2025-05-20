import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calc_buttons/constants.dart';
import 'package:calc_buttons/calc_stack.dart';
import 'package:calc_buttons/calc_button.dart';
import 'package:calc_buttons/calc_enter_button.dart';

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
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
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

      case '.':
        if (!numberEntryMode) {
          beginNumberEntry();
        }
        if (integerEntryMode) {
          integerEntryMode = false;
          decimalPart = '';
        }
        break;

      case '±':
        if (stack.x != 0) {
          isNegative = !isNegative;
          stack.x = -stack.x;
        }
        break;

      case '+':
        performBinaryOperation((a, b) => a + b);
        break;

      case '-':
        performBinaryOperation((a, b) => a - b);
        break;

      case '×':
        performBinaryOperation((a, b) => a * b);
        break;

      case '÷':
        performBinaryOperation((a, b) => a / b);
        break;

      case '%':
        double operand1 = stack.pop();
        double operand2 = stack.x;
        double result = operand2 * (operand1 / 100.0);
        stack.push(result);
        endNumberEntry();
        stackLiftEnabled = true; // LIFT stack on next entry
        break;

      case 'CL𝑋':
        stack.x = 0.0;
        endNumberEntry();
        break;

      case 'ENTER':
        double value = parseNumber(formatDisplay());
        stack.push(value);
        stack.x = value;
        endNumberEntry();
        stackLiftEnabled = false; // Do NOT lift stack on next entry
        break;

      default:
        break;
    }
    setState(() {
      display =
          (lastKeyPressed == 'ENTER')
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
            CalcButton(label: '7', onPressed: () => onButtonPressed('7')),
            CalcButton(label: '8', onPressed: () => onButtonPressed('8')),
            CalcButton(label: '9', onPressed: () => onButtonPressed('9')),
          ],
        ),
        Row(
          children: [
            CalcButton(label: '4', onPressed: () => onButtonPressed('4')),
            CalcButton(label: '5', onPressed: () => onButtonPressed('5')),
            CalcButton(label: '6', onPressed: () => onButtonPressed('6')),
          ],
        ),
        Row(
          children: [
            CalcButton(label: '1', onPressed: () => onButtonPressed('1')),
            CalcButton(label: '2', onPressed: () => onButtonPressed('2')),
            CalcButton(label: '3', onPressed: () => onButtonPressed('3')),
          ],
        ),
        Row(
          children: [
            CalcButton(label: '0', onPressed: () => onButtonPressed('0')),
            CalcButton(label: '.', onPressed: () => onButtonPressed('.')),
            CalcButton(
              label: 'CL𝑋',
              onPressed: () => onButtonPressed('CL𝑋'),
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
            CalcButton(label: '±', onPressed: () => onButtonPressed('±')),
            CalcButton(label: '÷', onPressed: () => onButtonPressed('÷')),
          ],
        ),
        Row(
          children: [
            CalcButton(label: '%', onPressed: () => onButtonPressed('%')),
            CalcButton(label: '×', onPressed: () => onButtonPressed('×')),
          ],
        ),
        Row(
          children: [
            // ENTER button takes half the row width and full height
            Expanded(
              child: CalcEnterButton(
                label: 'ENTER',
                onPressed: () => onButtonPressed('ENTER'),
              ),
            ),
            // + and - buttons stacked vertically, sharing the other half of the row
            Expanded(
              child: SizedBox(
                height: kCalcButtonHeight * 2 + 8, // Match ENTER button height
                child: Column(
                  children: [
                    Expanded(
                      child: CalcButton(
                        label: '-',
                        onPressed: () => onButtonPressed('-'),
                      ),
                    ),
                    Expanded(
                      child: CalcButton(
                        label: '+',
                        onPressed: () => onButtonPressed('+'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
