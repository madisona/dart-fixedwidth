import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import '../annotations.dart';

/// Generator to find all FixedWidthField or Record instance variables
/// in a class annotated with @fixedWidth and generate an ordered fields mixin.
class FixedWidthGenerator extends GeneratorForAnnotation<FixedWidthRecord> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@fixedWidth can only be applied to classes.',
        element: element,
      );
    }

    final className = element.name;
    final fieldsInfo = <String>[];

    for (final field in element.fields) {
      // Ignore static, synthetic (getters/setters), and private fields
      if (field.isStatic || field.isSynthetic || field.isPrivate) continue;

      final type = field.type;
      if (type is InterfaceType) {
        if (_isFixedWidthOrRecord(type)) {
          fieldsInfo.add(field.name);
        }
      }
    }

    final mixinName = '_\$${className}Fields';
    final String fieldsBody;
    if (fieldsInfo.isEmpty) {
      fieldsBody = '@override\n  Iterable<dynamic> get fields => [];';
    } else {
      final fieldsList =
          fieldsInfo.map((name) => 'self.$name,').join('\n      ');
      fieldsBody =
          '''@override\n  Iterable<dynamic> get fields {\n    final self = this as $className;\n    return [\n      $fieldsList\n    ];\n  }''';
    }
    return '''
mixin $mixinName on Record {
  $fieldsBody
}
''';
  }

  bool _isFixedWidthOrRecord(InterfaceType type) {
    for (final superType in [type, ...type.allSupertypes]) {
      final name = superType.element.name;
      if (name == 'FixedWidthField' || name == 'Record') {
        return true;
      }
    }
    return false;
  }
}
