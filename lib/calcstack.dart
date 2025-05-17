// Dart doesn't have a built-in stack data structure,
// but we can implement one using a list.

class CalcStack<T> {
  final _list = <T>[];

  void push(T value) => _list.add(value);
  T pop() => _list.removeLast();
  T peek() => _list.last;
  bool get isEmpty => _list.isEmpty;
  int get length => _list.length;
}
