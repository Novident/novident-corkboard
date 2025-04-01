class CorkboardOptions {
  final double size;
  // 5.3 == 5:3, 5.2 == 5:2
  final double ratio;
  final double spacing;

  /// if not, then will be row mode
  final bool isColumnModeActive;
  final bool isLabelModeActive;

  CorkboardOptions({
    required this.size,
    required this.ratio,
    required this.spacing,
    required this.isColumnModeActive,
    required this.isLabelModeActive,
  });

  CorkboardOptions.starter()
      : size = 120,
        spacing = 100,
        ratio = 5.3,
        isColumnModeActive = false,
        isLabelModeActive = false;
}
