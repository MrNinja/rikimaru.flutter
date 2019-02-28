import 'dart:isolate';

import 'package:architecture_generator/plugin_starter.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
