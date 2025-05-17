import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key}); // Constructor with super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Skeleton',
      home: const CalculatorSkeleton(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorSkeleton extends StatelessWidget {
  const CalculatorSkeleton({super.key}); // Constructor with super.key

  static const double buttonHeight = 80;

  Widget buildButton(String label, {Color? color}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () {},
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
        child: Padding(
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
                        buildButton('00'),
                        buildButton('.'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right side
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(children: [buildButton('±'), buildButton('÷')]),
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
      ),
    );
  }
}
