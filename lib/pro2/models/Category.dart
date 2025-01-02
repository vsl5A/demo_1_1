class Categorytt {
  final String slug;
  final String name;
  final String url;

  Categorytt({
    required this.slug,
    required this.name,
    required this.url,
  });

  // Factory để tạo đối tượng từ JSON
  factory Categorytt.fromJson(Map<String, dynamic> json) {
    return Categorytt(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
    );
  }
}
