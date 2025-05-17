import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calc_buttons/calcstack.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Skeleton',
      home: const CalculatorSkeleton(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorSkeleton extends StatefulWidget {
  const CalculatorSkeleton({super.key});

  @override
  State<CalculatorSkeleton> createState() => _CalculatorSkeletonState();
}

class _CalculatorSkeletonState extends State<CalculatorSkeleton> {
  double Xreg = 0;
  bool numberEntryMode = true;
  bool integerEntryMode = true;
  bool isNegative = false;
  String integerPart = '';
  String decimalPart = '';
  var stack = CalcStack<double>();
  final formatter = NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();
    Xreg = 0;
    integerEntryMode = true;
    numberEntryMode = true;
    isNegative = false;
    integerPart = '';
    decimalPart = '';
    // Initialize any state or variables here
  }

  String formatInputBuffer() {
    String formatted = '';

    if (isNegative && (integerPart.isNotEmpty || decimalPart.isNotEmpty)) {
      formatted += '-';
    }

    if (integerPart.isEmpty) {
      formatted += '0';
    } else {
      // Add commas to the integer part
      int intPart = int.parse(integerPart);
      String integerPartWithCommas = formatter.format(intPart);
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
        if (integerEntryMode) {
          integerPart += label;
        } else {
          decimalPart += label;
        }
        Xreg = double.parse(
          (isNegative ? '-' : '') +
              integerPart +
              (decimalPart.isNotEmpty ? '.' + decimalPart : ''),
        );
        break;

      case '.':
        if (numberEntryMode) {
          if (integerEntryMode) {
            integerEntryMode = false;
            decimalPart = '';
          }
        }
        break;

      case '+/-':
        Xreg = -Xreg;
        if (Xreg < 0) isNegative = true;
        break;

      case '+':
        double operand1 = stack.pop();
        double operand2 = Xreg;
        double result = operand1 + operand2;
        stack.push(result);
        Xreg = result;
        break;

      case '-':
      case '×':
      case '÷':
        //handleOperator(key);
        break;

      case 'CLX':
        Xreg = 0;
        numberEntryMode = true;
        integerEntryMode = true;
        isNegative = false;
        integerPart = '';
        decimalPart = '';
        break;

      case 'ENTER':
        print('ENTER pressed');
        stack.push(Xreg);
        integerEntryMode = true;
        numberEntryMode = true;
        isNegative = false;
        integerPart = '';
        decimalPart = '';
        Xreg = 0;
        break;

      default:
        print('Unknown key: $label');
    }
    String buffer = formatInputBuffer();
    print('Buffer: $buffer');
    print('X: $Xreg');
  }

  static const double buttonHeight = 80;

  Widget buildButton(String label, {Color? color}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () => onButtonPressed(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            padding: const EdgeInsets.all(8),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildVerticalEnterButton(String label, {Color? color}) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: buttonHeight * 2 + 8, // +8 for row spacing
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onButtonPressed(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              label
                  .split('')
                  .map(
                    (char) => Text(
                      char,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  // Left side: 4x3 number pad
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            buildButton('7'),
                            buildButton('8'),
                            buildButton('9'),
                          ],
                        ),
                        Row(
                          children: [
                            buildButton('4'),
                            buildButton('5'),
                            buildButton('6'),
                          ],
                        ),
                        Row(
                          children: [
                            buildButton('1'),
                            buildButton('2'),
                            buildButton('3'),
                          ],
                        ),
                        Row(
                          children: [
                            buildButton('0'),
                            buildButton('.'),
                            buildButton('CLX'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  //
                  // Right side: 2x4 operator pad
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(children: [buildButton('+/-'), buildButton('÷')]),
                        Row(children: [buildButton('%'), buildButton('×')]),
                        Row(
                          children: [
                            Expanded(child: buildVerticalEnterButton('ENTER')),
                            SizedBox(
                              height: buttonHeight * 2 + 8,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [buildButton('-'), buildButton('+')],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
