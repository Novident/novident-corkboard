enum CorkboardViewMode {
  corkboard(name: 'corkboard'),
  single(name: 'single'),
  outliner(name: 'outliner');

  final String name;

  const CorkboardViewMode({required this.name});
}

extension EasyCorkboardViewItemAccess on CorkboardViewMode {
  bool get isSingleMode => this == CorkboardViewMode.single;
  bool get isCorkboard => this == CorkboardViewMode.corkboard;
  bool get isOutliner => this == CorkboardViewMode.outliner;
}
