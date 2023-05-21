class CardData {
  CardData({
    required this.id,
    required this.cardBrand,
    required this.last4,
  });

  final String id;
  final String cardBrand;
  final String last4;

  factory CardData.fromJson(Map<String, dynamic> m) {
    return CardData(
      id: m['payment_method_id'] as String,
      cardBrand: m['card_brand'] as String,
      last4: m['last4'] as String,
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'payment_method_id': id,
      'card_brand': cardBrand,
      'last4': last4,
    };
  }

  CardData copyWithJson(Map<String, dynamic> m) {
    return CardData(
      id: m['payment_method_id'] as String? ?? id,
      cardBrand: m['card_brand'] as String? ?? cardBrand,
      last4: m['last4'] as String? ?? last4,
    );
  }
}
