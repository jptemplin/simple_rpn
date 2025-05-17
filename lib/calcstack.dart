// Dart doesn't have a built-in stack data structure,
// but we can implement one using a list.

class CalcStack<T> {
  final List<T> _list = [];

  CalcStack(List<T> list) {
    _list.addAll(list);
  }

  void push(T value) => _list.add(value);
  T pop() => _list.removeLast();
  T get top => _list.last;
  bool get isEmpty => _list.isEmpty;
  int get length => _list.length;

  void replaceTop(T value) {
    if (_list.isEmpty) {
      throw StateError('Cannot replace top of an empty stack');
    }
    _list[_list.length - 1] = value;
  }
}
