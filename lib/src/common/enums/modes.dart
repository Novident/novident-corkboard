enum CorkboardViewMode {
  corkboard(name: 'corkboard'),
  single(name: 'single'),
  outliner(name: 'outliner');

  final String name;

  const CorkboardViewMode({required this.name});
}
