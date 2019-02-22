import 'package:example/application.dart';
import 'package:example/config.dart';
import 'package:example/main_debug.dart' as debug;
import 'package:example/main_release.dart' as release;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const configurations = {
  debug.buildType: Configuration(
    flavorName: debug.buildType,
    debug: true,
  ),
  release.buildType: Configuration(
    flavorName: release.buildType,
    debug: false,
  ),
};

main() => launch(debug.buildType);

void launch(buildType) {
  var configuredApp = ConfigWidget(
    configuration: configurations[buildType],
    child: Application(),
  );

  // Don't allow landscape mode
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(configuredApp));
}
