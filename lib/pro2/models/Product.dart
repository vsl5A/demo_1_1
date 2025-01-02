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

  // Factory constructor to parse JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price']?.toDouble(),
      stock: json['stock'],
      discountPercentage: json['discountPercentage'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      Qty: json['Qty'] ?? 1, // Default quantity to 1 if not provided
      rating: json['rating']?.toDouble(),
      sku: json['sku'],
      weight: json['weight'],
      dimensions: json['dimensions'] != null
          ? {
        'width': json['dimensions']['width']?.toDouble() ?? 0.0,
        'height': json['dimensions']['height']?.toDouble() ?? 0.0,
        'depth': json['dimensions']['depth']?.toDouble() ?? 0.0,
      }
          : null,
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      reviews: json['reviews'] != null
          ? List<Map<String, dynamic>>.from(json['reviews'])
          : null,
      images: json['images'][0],
    );
  }}