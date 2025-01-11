class Product {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final int? stock;
  final double? discountPercentage;
  final String? category;
  final String? thumbnail;
  int? Qty; // Mutable field for quantity
  final double? rating;
  final String? sku;
  final int? weight;
  final Map<String, double>? dimensions; // Dimensions (width, height, depth)
  final String? warrantyInformation;
  final String? shippingInformation;
  final List<Map<String, dynamic>>? reviews; // List of reviews as maps
  final String? images; // Images as a single string (optional)

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.stock,
    this.discountPercentage,
    this.category,
    this.thumbnail,
    this.Qty,
    this.rating,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.reviews,
    this.images,
  });

  // Factory constructor to parse map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price']?.toDouble(),
      stock: map['stock'],
      discountPercentage: double.tryParse(map['discountPercentage'].toString()) ?? 0,
      category: map['category'],
      thumbnail: map['thumbnail'],
      Qty: map['Qty'] ?? 1, // Default quantity to 1 if not provided
      rating: map['rating']?.toDouble(),
      sku: map['sku'],
      weight: map['weight'],
      dimensions: map['dimensions'] != null
          ? {
        'width': map['dimensions']['width']?.toDouble() ?? 0.0,
        'height': map['dimensions']['height']?.toDouble() ?? 0.0,
        'depth': map['dimensions']['depth']?.toDouble() ?? 0.0,
      }
          : null,
      warrantyInformation: map['warrantyInformation'],
      shippingInformation: map['shippingInformation'],
      reviews: map['reviews'] != null
          ? List<Map<String, dynamic>>.from(map['reviews'])
          : null,
      images: map['images'][0],
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Product) return false;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}