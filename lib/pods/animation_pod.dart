import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnimationPod extends ChangeNotifier {
  List _insertedElements = [];

  List get elements => _insertedElements;

  void clear() => _insertedElements.clear();
  void add(String id) => _insertedElements.add(id);
  void addAll(Iterable ids) => _insertedElements.addAll(ids);
  void remove(String id) => _insertedElements.remove(id);
  bool contains(String id) => _insertedElements.contains(id);
}

final animationPod = ChangeNotifierProvider((_) => AnimationPod());