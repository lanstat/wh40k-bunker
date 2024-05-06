class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.empty() {
    return Category(id: '', name: '');
  }
}