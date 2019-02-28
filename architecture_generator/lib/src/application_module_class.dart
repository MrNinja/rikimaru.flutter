import 'package:architecture_component/architecture_component.dart';
import 'package:architecture_generator/architecture_generator.dart';
import 'package:flutter/material.dart';

part 'application_module_class.g.dart';

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen() => HomeScreenWidget();
}

class HomeViewModel extends ViewModel {
  /// Do nothing.
}

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => null;
}
