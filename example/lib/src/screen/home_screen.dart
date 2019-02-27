import 'dart:async';

import 'package:architecture_component/architecture_component.dart';
import 'package:example/application.dart';
import 'package:example/config.dart';
import 'package:example/src/design/process_widget.dart';
import 'package:example/src/viewmodel/view_model.dart';
import 'package:flutter/material.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  State<HomeScreenWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreenWidget>
    with SingleTickerProviderStateMixin {
  final _animDuration = Duration(milliseconds: 500);

  AnimationController _animController;

  Future<void> _playAnimation() async {
    try {
      await _animController.forward(from: 0.0).orCancel;
    } on TickerCanceled {
      // The animation got canceled, probably because we were disposed
    }
  }

  @override
  void initState() {
    super.initState();
    _animController?.dispose();
    _animController = AnimationController(duration: _animDuration, vsync: this);
    _playAnimation();
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildConfig = Configuration.of(context);
    final theme = Theme.of(context);
    final homeViewModel = ScreenWidget.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(buildConfig.appName), centerTitle: true),
      body: Center(
        child: PercentRoundButton(
          child: RaisedButton(
              color: theme.primaryColor,
              splashColor: theme.accentColor,
              shape: CircleBorder(),
              child: homeViewModel.counter.subscribe((context, snapshot) =>
                  Text('${snapshot.data}', style: theme.textTheme.button)),
              onPressed: homeViewModel.increase),
          animation: Tween<double>(begin: 0, end: 1).animate(_animController),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
