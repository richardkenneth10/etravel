class PaymentIntentResponseData {
  PaymentIntentResponseData({
    required this.clientSecret,
    required this.status,
    required this.requiresAction,
    required this.declined,
    required this.requiresAuthentication,
  });

  final String clientSecret;
  final String status;
  final bool requiresAction;
  final bool declined;
  final bool requiresAuthentication;

  factory PaymentIntentResponseData.fromJson(Map<String, dynamic> m) {
    return PaymentIntentResponseData(
      clientSecret: m['clientSecret'] as String? ?? '',
      status: m['status'] as String? ?? '',
      requiresAction: m['requiresAction'] as bool? ?? false,
      declined: m['declined'] as bool? ?? false,
      requiresAuthentication: m['requires_authentication'] as bool? ?? false,
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'clientSecret': clientSecret,
      'status': status,
      'requiresAction': requiresAction,
      'declined': declined,
      'requires_authentication': requiresAuthentication,
    };
  }

  PaymentIntentResponseData copyWithJson(Map<String, dynamic> m) {
    return PaymentIntentResponseData(
      clientSecret: m['clientSecret'] as String? ?? clientSecret,
      status: m['status'] as String? ?? status,
      requiresAction: m['requiresAction'] as bool? ?? requiresAction,
      declined: m['declined'] as bool? ?? requiresAction,
      requiresAuthentication:
          m['requires_authentication'] as bool? ?? requiresAction,
    );
  }
}
