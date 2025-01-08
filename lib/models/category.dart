class Category {
  final String slug;
  final String name;
  final String url;

  Category({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      slug: map['slug'],
      name: map['name'],
      url: map['url'],
    );
  }
}
