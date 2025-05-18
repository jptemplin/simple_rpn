import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String integerPart = '';
  String decimalPart = '';
  var stack = CalcStack<double>(const [0.0, 0.0, 0.0, 0.0]);
  String display = '0';
  final integerFormatter = NumberFormat("#,##0");
  final numberFormat = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    endNumberEntry();
  }

  // Formats an [int] or [double] to a locale-aware string with commas.
  String formatNumber(num value) {
    return numberFormat.format(value);
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
    stack.push(result);
    endNumberEntry();
  }

  void onButtonPressed(String label) {
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
          beginNumberEntry();
        }
        if (integerEntryMode) {
          integerPart += label;
        } else {
          decimalPart += label;
        }
        String display = formatDisplay();
        double value = parseNumber(display);
        stack.replaceTop(value);
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

      case '+/-':
        if (stack.top != 0) {
          isNegative = !isNegative;
          stack.replaceTop(-stack.top);
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
        double operand2 = stack.top;
        double result = operand2 * (operand1 / 100.0);
        stack.push(result);
        endNumberEntry();
        break;

      case 'CLX':
        stack.replaceTop(0.0);
        endNumberEntry();
        break;

      case 'ENTER':
        double value = parseNumber(formatDisplay());
        stack.push(value);
        stack.replaceTop(value);
        endNumberEntry();
        break;

      default:
        break;
    }
    setState(() {
      if (numberEntryMode) {
        display = formatDisplay();
      } else {
        display = formatNumber(stack.top);
      }
    });

    // print('Display: $display');
    // stack.dump();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // OFF button row
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 24, right: 18),
                  child: ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
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
            ),
            // Display box
            Container(
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
                  // Fade effect
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
            ),
            // Keypad
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: 4x3 number pad
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CalcButton(
                              label: '7',
                              onPressed: () => onButtonPressed('7'),
                            ),
                            CalcButton(
                              label: '8',
                              onPressed: () => onButtonPressed('8'),
                            ),
                            CalcButton(
                              label: '9',
                              onPressed: () => onButtonPressed('9'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CalcButton(
                              label: '4',
                              onPressed: () => onButtonPressed('4'),
                            ),
                            CalcButton(
                              label: '5',
                              onPressed: () => onButtonPressed('5'),
                            ),
                            CalcButton(
                              label: '6',
                              onPressed: () => onButtonPressed('6'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CalcButton(
                              label: '1',
                              onPressed: () => onButtonPressed('1'),
                            ),
                            CalcButton(
                              label: '2',
                              onPressed: () => onButtonPressed('2'),
                            ),
                            CalcButton(
                              label: '3',
                              onPressed: () => onButtonPressed('3'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CalcButton(
                              label: '0',
                              onPressed: () => onButtonPressed('0'),
                            ),
                            CalcButton(
                              label: '.',
                              onPressed: () => onButtonPressed('.'),
                            ),
                            CalcButton(
                              label: 'CLX',
                              onPressed: () => onButtonPressed('CLX'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right side: 2x4 operator pad
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CalcButton(
                              label: '+/-',
                              onPressed: () => onButtonPressed('+/-'),
                            ),
                            CalcButton(
                              label: '÷',
                              onPressed: () => onButtonPressed('÷'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CalcButton(
                              label: '%',
                              onPressed: () => onButtonPressed('%'),
                            ),
                            CalcButton(
                              label: '×',
                              onPressed: () => onButtonPressed('×'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CalcEnterButton(
                                label: 'ENTER',
                                onPressed: () => onButtonPressed('ENTER'),
                              ),
                            ),
                            SizedBox(
                              height: kCalcButtonHeight * 2 + 8,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CalcButton(
                                    label: '-',
                                    onPressed: () => onButtonPressed('-'),
                                  ),
                                  CalcButton(
                                    label: '+',
                                    onPressed: () => onButtonPressed('+'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
