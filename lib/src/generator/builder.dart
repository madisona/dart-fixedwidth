import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'generator.dart';

/// Builder factory for generating fixedwidth part files.
Builder fixedWidthBuilder(BuilderOptions options) =>
    SharedPartBuilder([FixedWidthGenerator()], 'fixedwidth');
