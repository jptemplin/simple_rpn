import 'package:flutter/foundation.dart';

class CalcStack {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  double _t = 0.0;

  CalcStack() {
    clear();
  }

  // Aliases for registers
  double get x => _x;
  double get y => _y;
  double get z => _z;
  double get t => _t;

  set x(double value) => _x = value;
  set y(double value) => _y = value;
  set z(double value) => _z = value;
  set t(double value) => _t = value;

  // Push: X->Y, Y->Z, Z->T, T lost, new X
  void push(double value) {
    _t = _z;
    _z = _y;
    _y = _x;
    _x = value;
  }

  // Pop: X is popped, Y->X, Z->Y, T->Z, T stays the same
  double pop() {
    final popped = _x;
    _x = _y;
    _y = _z;
    _z = _t;
    // T remains unchanged (rolls down)
    return popped;
  }

  // Clear all registers to zero
  void clear() {
    _x = 0.0;
    _y = 0.0;
    _z = 0.0;
    _t = 0.0;
  }

  // For debugging
  void dump() {
    if (kDebugMode) {
      print('T: $_t\nZ: $_z\nY: $_y\nX: $_x');
    }
  }
}
