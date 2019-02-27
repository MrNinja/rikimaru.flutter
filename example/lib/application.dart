import 'package:architecture_component/architecture_component.dart';
import 'package:architecture_generator/architecture_generator.dart';
import 'package:example/config.dart';
import 'package:example/src/screen/home_screen.dart';
import 'package:example/src/viewmodel/view_model.dart';
import 'package:flutter/material.dart';

part 'application.g.dart';

@ApplicationModule
class Application extends StatelessWidget {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen() => HomeScreenWidget();

  @override
  Widget build(BuildContext context) {
    final buildConfig = Configuration.of(context);

    return MaterialApp(
      title: buildConfig.appName,
      theme: ThemeData(
        // Define the default
        brightness: Brightness.light,
        primaryColor: Colors.grey[900],
        primaryColorDark: Colors.grey[800],
        primaryColorLight: Colors.grey[600],
        accentColor: Colors.grey[400],
        backgroundColor: Colors.grey[200],

        // Define the default Font Family
        fontFamily: 'Roboto',

        // Define the default TextTheme
        textTheme: TextTheme(
          display4: TextStyle(
              color: Colors.grey[900],
              fontSize: 96.0,
              fontWeight: FontWeight.w300,
              letterSpacing: -1.5),
          display3: TextStyle(
              color: Colors.grey[800],
              fontSize: 60.0,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.5),
          display2: TextStyle(
              color: Colors.grey[900],
              fontSize: 48.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0),
          display1: TextStyle(
              color: Colors.grey[800],
              fontSize: 34.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25),
          headline: TextStyle(
              color: Colors.grey[900],
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0),
          subhead: TextStyle(
              color: Colors.grey[800],
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15),
          title: TextStyle(
              color: Colors.grey[900],
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15),
          subtitle: TextStyle(
              color: Colors.grey[800],
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1),
          body1: TextStyle(
              color: Colors.grey[900],
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5),
          body2: TextStyle(
              color: Colors.grey[800],
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25),
          button: TextStyle(
              color: Colors.grey[100],
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25),
          caption: TextStyle(
              color: Colors.grey[100],
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4),
          overline: TextStyle(
              color: Colors.grey[100],
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: buildConfig.debug,
    );
  }
}
