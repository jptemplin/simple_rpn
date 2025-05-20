import 'package:flutter/foundation.dart';

class CalcStack {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double t = 0.0;

  CalcStack() {
    clear();
  }

  // Push: X->Y, Y->Z, Z->T, T lost, new X
  void push(double value) {
    t = z;
    z = y;
    y = x;
    x = value;
  }

  // Pop: X is popped, Y->X, Z->Y, T->Z, T stays the same
  double pop() {
    final popped = x;
    x = y;
    y = z;
    z = t;
    // T remains unchanged (rolls down)
    return popped;
  }

  // Clear all registers to zero
  void clear() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    t = 0.0;
  }

  // For debugging
  void dump() {
    if (kDebugMode) {
      print('T: $t\nZ: $z\nY: $y\nX: $x');
    }
  }
}
