class CorkboardOptions {
  final double size;
  // 5.3 == 5:3, 5.2 == 5:2
  final double ratio;
  final double spacing;

  CorkboardOptions({
    required this.size,
    required this.ratio,
    required this.spacing,
  });

  CorkboardOptions.starter()
      : size = 120,
        spacing = 100,
        ratio = 5.3;
}
