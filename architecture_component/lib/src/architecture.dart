import 'dart:async';

import 'package:flutter/material.dart';

/// Utility class provide the instance of data [ViewModel] each screen.
abstract class ViewModel {
  /// List [ViewModel] instances and corresponding [ViewModel] class type lead to
  /// the Dependency Injection design pattern. This static variable hold the static
  /// list [ViewModel] and inject it into [ScreenWidget] automatically via the
  /// [ViewModel.provide] static method. The [ViewModel] instances alive as long
  /// as Application alive.
  static final Map<Type, ViewModel> _viewModelMap = Map<Type, ViewModel>();

  @protected
  int _version = 0;

  ViewModel({version = 0}) : _version = version;

  /// Update [ViewModel] version.
  updateVersion() => _version++;

  /// Provide the [ViewModel] from [_viewModelMap]. Create a new instance by the
  /// inputted provider unless could not found [ViewModel] instance.
  static E provide<E extends ViewModel>(ViewModelProvider<E> provider) {
    E viewModel = _viewModelMap[E];
    if (viewModel == null) {
      viewModel = provider();
      _viewModelMap[E] = viewModel;
    }

    return viewModel;
  }
}

/// LiveData is an observable data holder class.
class LiveData<E> {
  E _data;
  StreamController<E> _controller;

  /// Always re-initial stream state and notify the value to view.
  set value(E value) {
    initialState();
    _data = value;
    add(_data);
  }

  /// Always re-initial stream state and notify the value to view without update.
  set notify(E value) {
    initialState();
    add(value);
  }

  /// Response the current data.
  E get value => _data;

  /// Directly get the notify data changed to stream method.
  Function(E) get add => _controller.add;

  /// Directly get the send error to stream method.
  Function(E) get addError => _controller.addError;

  /// Directly get stream instance.
  Stream<E> get stream => _controller.stream;

  /// Check this stream close or not.
  bool get isClosed => _controller.isClosed;

  /// Make sure calling this method to avoid memory leak.
  Future<void> dispose() async {
    if (!_controller.hasListener) {
      await _controller?.close();
    }
  }

  /// Initial a new LiveData. Remember to call dispose when stop using this
  /// instance to avoid memory leak.
  LiveData.init({@required initialData}) : assert(initialData != null) {
    value = initialData;
  }

  /// Initial the state of stream controller.
  initialState() {
    _controller ??= StreamController<E>.broadcast();
  }

  /// Build the new [LiveData]'s subscriber widget.
  StatefulWidget subscribe(AsyncWidgetBuilder<E> builder) {
    return StreamBuilder<E>(
      initialData: _data,
      stream: stream,
      builder: builder,
    );
  }
}

/// Provides [ViewModel] to its [child] [Widget] tree via [InheritedWidget].
/// When the [version] changes, all descendants of this screen who request
/// (via [BuildContext.inheritFromWidgetOfExactType]) to be rebuilt when
/// the model changes will do so.
class _InheritedViewModel<E extends ViewModel> extends InheritedWidget {
  /// The [ViewModel] to provide to its descendants.
  final E viewModel;
  final int version;

  _InheritedViewModel({E viewModel, Key key, Widget child})
      : this.viewModel = viewModel,
        this.version = viewModel._version,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedViewModel<E> oldWidget) =>
      (oldWidget.version != version);
}

/// Provides a [ViewModel] to all descendants of this Widget.
/// This widget represented a screen of the Application.
///
/// ### Example
///
/// ```
/// class MyScreenWidget extends ScreenWidget<MyViewModel> {
///   MyScreenWidget({@required child}) : super(child: child);
///
///   @override
///   MyViewModel provideViewModel() {
///     return MyViewModel();
///   }
/// }
/// ```
///
/// The Descendant Widgets can access the [ViewModel] directly
/// via the [ScreenWidget.of] static method.
///
/// ### Example
///
/// ```
/// final myViewModel = ScreenWidget.of<MyViewModel>(context);
/// ```
abstract class ScreenWidget<E extends ViewModel> extends StatelessWidget {
  /// The [Widget] the [viewModel] will be available to.
  final Widget child;

  @mustCallSuper
  ScreenWidget({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    E viewModel = ViewModel.provide<E>(provideViewModel);
    return _InheritedViewModel<E>(viewModel: viewModel, child: child);
  }

  /// Prepare a method for build_runner library.
  E provideViewModel();

  /// Response a corresponded [ViewModel] or throw new [InheritedScreenWidgetError].
  static E of<E extends ViewModel>(BuildContext context) {
    final Type type = _type<_InheritedViewModel<E>>();
    Widget inheritedWidget = context.inheritFromWidgetOfExactType(type);
    if (inheritedWidget == null) {
      throw InheritedScreenWidgetError();
    } else {
      return (inheritedWidget as _InheritedViewModel<E>).viewModel;
    }
  }

  /// The trick to get the type with a Generic Type.
  static Type _type<E>() => E;
}

/// The error that will be thrown when the ScreenWidget' descendants
/// cannot be found in the Widget tree.
class InheritedScreenWidgetError extends Error {
  InheritedScreenWidgetError();

  String toString() {
    return '''Error: Could not find the correct ScreenWidget.
To fix, please make sure that:
          
  * Provide types to new class `MyScreen extends ScreenWidget<MyViewModel>`
  * Provide types to ScreenWidget.of<MyViewModel>() 
  * Always use package imports. Ex: `import 'package:my_app/my_model.dart';

If none of these solutions work, please file a bug at:

  * https://github.com/MrNinja/flutter_architecture_component/issues/new

Thanks!''';
  }
}

/// Provide the corresponded [ViewModel].
typedef E ViewModelProvider<E extends ViewModel>();
