import 'package:analyzer/dart/element/element.dart';

/// [GeneratorUtils]'s utility class which contain list of utilities method
/// supported generate source.
class ClassGeneratorUtils {
  // Utility technique.
  ClassGeneratorUtils._();

  /// Get optional declaration format. It also add default value and this
  /// keyword if needed.
  static String getOptionalDeclare(ParameterElement param, [hasThis = false]) {
    final StringBuffer declareGenerator = StringBuffer();
    if (param.type.toString() != 'dynamic') {
      declareGenerator.write('${param.type} ');
    }
    if (hasThis) {
      declareGenerator.write('this.');
    }
    declareGenerator.write(param.name);
    if (param.defaultValueCode != null) {
      declareGenerator.write(' = ${param.defaultValueCode}');
    }
    return declareGenerator.toString();
  }

  /// Replace null [String] by empty [String] or place prefix and suffix beside
  /// this [String] value.
  static String getNonNullValue(String value, {pre = '', suf = ''}) {
    return value == null ? '' : '$pre$value$suf';
  }
}

/// [ParameterGenerator]'s is generate processor support class for generate
/// class Fields and method Parameters based on inputted [ParameterElement].
class ParameterGenerator {
  final List<ParameterElement> parameters;
  final List<ParameterElement> normalParameters = List();
  final List<ParameterElement> optionalParameters = List();
  final List<ParameterElement> optionalNamedParameters = List();

  ParameterGenerator(this.parameters) {
    /// Divide parameter into three group.
    /// Normal parameters:
    /// => Default syntax parameters.
    /// Optional positional parameters []:
    /// => Square brackets can be used to specify optional positional parameters.
    /// Optional named parameters {}:
    /// => Curly braces can be used to specify optional named parameters.
    for (ParameterElement parameterElement in parameters) {
      if (parameterElement.isOptional) {
        if (parameterElement.isPositional) {
          optionalParameters.add(parameterElement);
        } else {
          optionalNamedParameters.add(parameterElement);
        }
      } else {
        normalParameters.add(parameterElement);
      }
    }
  }

  /// Generate class fields.
  String generateClassFields() {
    final StringBuffer fieldGenerator = StringBuffer();
    for (ParameterElement parameterElement in parameters) {
      final String type = parameterElement.type.toString();
      final String name = parameterElement.name;
      fieldGenerator.writeln('  final $type $name;');
    }

    if (fieldGenerator.length > 0) fieldGenerator.write('\n\n');
    return fieldGenerator.toString();
  }

  /// Generate method declare params with [hasThis] option.
  String generateDeclareParams([hasThis = false]) {
    final StringBuffer paramGenerator = StringBuffer();

    /// Normal parameters.
    if (normalParameters.length > 0) {
      paramGenerator.write(
          ClassGeneratorUtils.getOptionalDeclare(normalParameters[0], hasThis));
      if (normalParameters.length > 1) {
        normalParameters.sublist(1).forEach((parameter) => paramGenerator.write(
            ', ${ClassGeneratorUtils.getOptionalDeclare(parameter, hasThis)}'));
      }
    }

    /// Optional positional parameters.
    if (optionalParameters.length > 0) {
      if (paramGenerator.length > 0) {
        paramGenerator.write(', ');
      }

      paramGenerator.write(
          '[${ClassGeneratorUtils.getOptionalDeclare(optionalParameters[0], hasThis)}');
      if (optionalParameters.length > 1) {
        optionalParameters.sublist(1).forEach((parameter) => paramGenerator.write(
            ', ${ClassGeneratorUtils.getOptionalDeclare(parameter, hasThis)}'));
      }
      paramGenerator.write(']');
    }

    /// Optional named parameters.
    if (optionalNamedParameters.length > 0) {
      if (paramGenerator.length > 0) {
        paramGenerator.write(', ');
      }

      paramGenerator.write(
          '{${ClassGeneratorUtils.getOptionalDeclare(optionalNamedParameters[0], hasThis)}');
      if (optionalNamedParameters.length > 1) {
        optionalNamedParameters.sublist(1).forEach((parameter) =>
            paramGenerator.write(
                ', ${ClassGeneratorUtils.getOptionalDeclare(parameter, hasThis)}'));
      }
      paramGenerator.write('}');
    }

    return paramGenerator.toString();
  }

  /// Generate method input param.
  String generateInputParams() {
    final StringBuffer paramGenerator = StringBuffer();

    /// Normal parameters and Optional positional parameters.
    final List<ParameterElement> nonNamed = List();
    nonNamed.addAll(normalParameters);
    nonNamed.addAll(optionalParameters);
    if (nonNamed.length > 0) {
      paramGenerator.write(nonNamed[0].name);
      if (nonNamed.length > 1) {
        nonNamed.sublist(1).forEach(
            (parameter) => paramGenerator.write(', ${parameter.name}'));
      }
    }

    /// Optional named parameters.
    if (optionalNamedParameters.length > 0) {
      if (paramGenerator.length > 0) {
        paramGenerator.write(', ');
      }

      paramGenerator.write(
          '${optionalNamedParameters[0].name}: ${optionalNamedParameters[0].name}');
      if (optionalNamedParameters.length > 1) {
        optionalNamedParameters.sublist(1).forEach((parameter) =>
            paramGenerator.write(', ${parameter.name}: ${parameter.name}'));
      }
    }

    return paramGenerator.toString();
  }
}
