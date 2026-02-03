import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void pushTo(BuildContext context, String path) {
  context.push(path); // ✅ مهم جدًا
}

void replaceTo(BuildContext context, String path) {
  context.go(path);
}

void pop(BuildContext context) {
  context.pop();
}
