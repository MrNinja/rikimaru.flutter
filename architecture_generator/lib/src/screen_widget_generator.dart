import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:architecture_generator/src/annotation/module.dart';
import 'package:architecture_generator/src/common/class_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

// Provider method name should start with.
const String PROVIDE_METHOD_NAME_START = 'provide';

// Type checker of ScreenProvider annotation.
const screenProviderChecker = const TypeChecker.fromRuntime(ScreenProvider);

// [ApplicationModule] annotation validated exception.
final _onlyClassException =
    Exception("ApplicationModule annotation can only be defined on a class.");

// [ScreenProvider] annotation validated exception.
_methodStartWithException(String name) => Exception(
    "Method name `$name` have to start with $PROVIDE_METHOD_NAME_START");

/// [ScreenWidgetGenerator]'s generator for dependency injection architecture.
/// This class prepare source for screen module inside application class.
class ScreenWidgetGenerator extends GeneratorForAnnotation<$ApplicationModule> {
  // Allow creating via `const` as well as enforces immutability here.
  const ScreenWidgetGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) throw _onlyClassException;
    ClassElement classElement = element as ClassElement;

    var values = Set<String>();
    List<MethodElement> listMethod = classElement.methods;
    for (MethodElement methodElement in listMethod) {
      final screenProviderAnnotation =
          screenProviderChecker.firstAnnotationOfExact(methodElement);

      if (screenProviderAnnotation != null) {
        final String provideMethodName = methodElement.name;
        if (!provideMethodName.startsWith(PROVIDE_METHOD_NAME_START))
          throw _methodStartWithException(provideMethodName);

        // Get ViewModel class name.
        final viewModel =
            screenProviderAnnotation.getField('viewModel').toTypeValue();
        final viewModelClassName = viewModel.toString();

        final sourceGenerator = new StringBuffer();
        buildWidgetClass(sourceGenerator, viewModelClassName, provideMethodName,
            methodElement.parameters);

        if (sourceGenerator.isNotEmpty) {
          values.add(sourceGenerator.toString());
        }
      }
    }

    return values.join('\n\n');
  }
}

/// Build screen widget class and it's support class.
void buildWidgetClass(StringBuffer sourceGenerator, String viewModelClass,
    String provideMethod, List<ParameterElement> parameters) {
  // Prepare parameter generate processor.
  ParameterGenerator parameterGenerator = ParameterGenerator(parameters);
  parameterGenerator.generateInputParams();

  // Prepare class value.
  final screenClass = provideMethod.substring(PROVIDE_METHOD_NAME_START.length);
  final declareParam = parameterGenerator.generateDeclareParams();
  final inputParam = parameterGenerator.generateInputParams();

  /// Write source format.
  sourceGenerator.writeln('''
class $screenClass extends ScreenWidget<$viewModelClass> {
  $screenClass._($declareParam) : super(child: Application.$provideMethod($inputParam));

  factory $screenClass($declareParam) => $screenClass._($inputParam);

  @override
  $viewModelClass provideViewModel() {
    return $viewModelClass();
  }
}
''');
}
