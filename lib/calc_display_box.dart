import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalcDisplayBox extends StatelessWidget {
  final String display;
  const CalcDisplayBox({super.key, required this.display});

  @override
  Widget build(BuildContext context) {
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
}
