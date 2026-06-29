/// Annotation to mark a class for code generation of its fixed width fields.
class FixedWidthRecord {
  const FixedWidthRecord();
}

/// Constant instance of [FixedWidthRecord] to use as `@fixedWidth`.
const fixedWidth = FixedWidthRecord();
