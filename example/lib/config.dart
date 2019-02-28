import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ConfigWidget extends InheritedWidget {
  final Configuration configuration;

  ConfigWidget({@required this.configuration, @required Widget child})
      : super(child: child);

  @override
  // Config won’t ever change after we’ve created it.
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class Configuration {
  static Configuration of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ConfigWidget) as ConfigWidget)
        .configuration;
  }

  final String appName;
  final String flavorName;
  final bool debug;

  const Configuration({
    this.appName = "Rikimaru Flutter Application",
    this.flavorName = "",
    this.debug = true,
  });
}
