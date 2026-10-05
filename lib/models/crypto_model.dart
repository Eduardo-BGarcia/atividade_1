class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double change24h;
  final String image;
  final String lastUpdated;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.image,
    required this.lastUpdated,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      symbol: (json['symbol']?.toString() ?? '').toUpperCase(),
      price: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      change24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      image: json['image']?.toString() ?? '',
      lastUpdated: json['last_updated']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  factory CryptoModel.fromMap(Map<String, dynamic> map) {
    return CryptoModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      symbol: map['symbol']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      change24h: (map['change_24h'] as num?)?.toDouble() ?? 0.0,
      image: map['image']?.toString() ?? '',
      lastUpdated: map['last_updated']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'price': price,
      'change_24h': change24h,
      'image': image,
      'last_updated': lastUpdated,
    };
  }
}

