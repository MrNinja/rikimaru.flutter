import 'package:architecture_generator/src/screen_widget_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder screenWidgetBuilder(BuilderOptions options) =>
    SharedPartBuilder([ScreenWidgetGenerator()], 'screenWidget');
