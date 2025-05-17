import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  double Xregister = 0;
  bool decimalMode = false;
  int decimalPlaces = 0;
  final formatter = NumberFormat("#,##0.00");

  @override
  void initState() {
    super.initState();
    Xregister = 0;
    decimalMode = false;
    decimalPlaces = 0;
    // Initialize any state or variables here
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
        double digit = double.parse(label);
        if (decimalMode) {
          decimalPlaces++;
          double decimal = digit * pow(10, -decimalPlaces).toDouble();
          Xregister += decimal;
        } else {
          Xregister = Xregister * 10 + digit;
        }
        break;

      case '.':
        decimalMode = true;
        decimalPlaces = 0;
        break;

      case '+/-':
        Xregister = -Xregister;
        break;

      case '+':
      case '-':
      case '×':
      case '÷':
        //handleOperator(key);
        break;

      case 'CLX':
        Xregister = 0;
        decimalMode = false;
        break;

      default:
        print('Unknown key: $label');
    }
    String formatted = formatter.format(Xregister);
    print('X: $formatted');
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
        onPressed: () {},
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


// final formatter = NumberFormat("#,##0.00");

// double value = 1234567.89;
// String formatted = formatter.format(value);

// print(formatted); // Outputs: 1,234,567.89