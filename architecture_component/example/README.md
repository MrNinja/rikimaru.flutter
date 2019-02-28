# Architecture Source Generator example

[![pub package](https://img.shields.io/badge/pub-0.0.1-orange.svg)](https://pub.dartlang.org/packages/architecture_generator)
[![pub package](https://img.shields.io/badge/donate-Paypal-brightgreen.svg)](https://www.paypal.me/tranductam)

The example for Architecture Source Generator package.

## Prepare dependencies
To use this package, add `architecture_generator` and `build_runner` as a [dev_dependencies in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```
...
dev_dependencies:
  flutter_test:
    sdk: flutter

  architecture_generator: '>=0.0.1 <1.0.0'
  build_runner: ^1.0.0
...
```

## Usage
#### 1. Create a new `*.dart` file and class with named `Application`.
```
_$: main.dart

class Application {
}
```

#### 2. Include `ApplicationModule` annotation for this class.
```
_$: main.dart

@ApplicationModule
class Application {
}
```

#### 3. Prepare provider method inside `Application` class.
Provider method name leading by `provide` keyword. The suffix after `provide` keyword will be converted to Screen class name. Also remember to include `ScreenProvider` annotation for this method. The `ScreenProvider` annotation required `viewModel` input parameter which instance of `ViewModel` class.
```
_$: main.dart

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen() => HomeScreenWidget();
}
```

#### 4. Include part source for generated code.

```
_$: main.dart

part 'main.g.dart';

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen() => HomeScreenWidget();
}
```

#### 5. Run build source command
```
_$: flutter packages pub run build_runner build
```

## Example
Then use the `Architecture Source Generator` Dart class in your code. To see how this is done, check out the [Architecture Component example app](https://github.com/MrNinja/rikimaru.flutter/blob/master/example/README.md).
```
_$: application_module_class.dart

import 'package:architecture_component/architecture_component.dart';
import 'package:architecture_generator/architecture_generator.dart';
import 'package:flutter/material.dart';

part 'application_module_class.g.dart';  // part '<current file name>.g.dart';

@ApplicationModule  // ApplicationModule annotation.
class Application {  // ApplicationModule provider class
  @ScreenProvider(viewModel: HomeViewModel)  // ScreenProvider annotation with example ViewModel class instance (HomeViewModel).
  static Widget provideHomeScreen() => HomeScreenWidget();  // The provider method provide `HomeScreen` class.
}

// ViewModel sub class.
class HomeViewModel extends ViewModel {
  /// Do nothing for example.
}

// Screen child widget example.
class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => null;  // Return `null` for example.
}
```

You also declare parameter to provider method for support parameter injection.
```
@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen(param) => HomeScreenWidget();
}

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen([positionalParam]) => HomeScreenWidget();
}

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen({namedParam}) => HomeScreenWidget();
}

@ApplicationModule
class Application {
  @ScreenProvider(viewModel: HomeViewModel)
  static Widget provideHomeScreen(param, {namedParam, defaultValueParam = true}) => HomeScreenWidget();
}
```
