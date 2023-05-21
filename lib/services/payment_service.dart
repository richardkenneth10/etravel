import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/models/user/user_data.dart';
import 'package:etravel/models/payment/payment_intent_response_data.dart';
import 'package:etravel/services/api.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart' hide Response;
import 'package:etravel/models/payment/card_data.dart' as c;
import 'package:http/http.dart' as http;

class PaymentService extends GetxService {
  final _user = Get.find<UserDataService>().currentUser;
  final _stripe = Stripe.instance;
  UserData? get userData => null;

  final _savedCards = <c.CardData>[].obs;
  List<c.CardData> get savedCards => _savedCards();

  Future<void> saveCardDetails() async {
    final paymentMethod = await _stripe.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(
            email: _user?.email,
            phone: _user?.phone,
            name: _user?.displayName,
          ),
        ),
      ),
    );
    final res = await Get.find<APIService>().api.post(
      '/payment/save-card-for-payments',
      data: {
        "paymentMethodId": paymentMethod.id,
      },
    );

    if (res.statusCode == 102) {
      throw ETravelException(res.data['msg']);
    }

    if (res.statusCode == 201) {
      final clientSecret = res.data['clientSecret'];
      await _stripe.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret,
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: userData?.email,
              name: userData?.displayName,
              phone: userData?.phone,
            ),
          ),
        ),
      );
    }
  }

  Future<List<c.CardData>> getSavedCards() async {
    final res = await Get.find<APIService>().api.get(
          '/payment/saved-cards',
        );

    log(res.data['cards'].toString());
    final cards = res.data['cards'] as List? ?? [];
    return cards.map((e) => c.CardData.fromJson(e)).toList();
  }

  Future<void> payWithSavedCard(
      {required String paymentMethodId, required int rideId}) async {
    final res = await Get.find<APIService>().api.post(
      '/payment/pay-with-saved-card',
      data: {
        "paymentMethodId": paymentMethodId,
        "rideId": rideId,
      },
    );

    log(res.data.toString());
    await _handlePaymentResponse(res, paymentMethodId);
  }

  Future<void> payWithNewCard({required int rideId}) async {
    final paymentMethod = await _stripe.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(
            email: _user?.email,
            phone: _user?.phone,
            name: _user?.displayName,
          ),
        ),
      ),
    );
    final res = await Get.find<APIService>().api.post(
      '/payment/pay-with-card',
      data: {
        "paymentMethodId": paymentMethod.id,
        "rideId": rideId,
      },
    );

    log(res.data.toString());
    await _handlePaymentResponse(res, paymentMethod.id);
  }

  Future<http.Response> _addPaymentMethodOnBackend({
    required String email,
    required String paymentMethodId,
    required String phone,
    required String name,
  }) async {
    final url = Uri.parse(
        'https://us-central1-etravel-cab.cloudfunctions.net/StripeAddPaymentMethod');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "email": email,
          "payment_method_id": paymentMethodId,
          "name": name,
          "phone": phone,
        },
      ),
    );
    return response;
  }

  Future<http.Response> _getCardOffSessionPaymentMethods(
      {required String email}) async {
    final url = Uri.parse(
        'https://us-central1-etravel-cab.cloudfunctions.net/StripeOffSessionPaymentMethodsForCard');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {"email": email},
      ),
    );
    return response;
  }

  Future<http.Response> _chargeCardOffSession({
    required String email,
    required String paymentMethodId,
    required String rideId,
    required String? currency,
  }) async {
    final url = Uri.parse(
        'https://us-central1-etravel-cab.cloudfunctions.net/StripeChargeCardOffSession');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "email": email,
          "payment_method_id": paymentMethodId,
          "ride_id": rideId,
          "currency": currency,
        },
      ),
    );
    return response;
  }

  Future<void> _handlePaymentConfirmation(String clientSecret) async {
    final paymentIntent = await _stripe.handleNextAction(clientSecret);

    if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
      await _stripe.confirmPayment(
        paymentIntentClientSecret: clientSecret,
      );
    } else {
      log("Payment successful");
    }
  }

  Future<http.Response> _callPayEndpointMethodId(
      {required bool useStripeSdk,
      required String paymentMethodId,
      required String currency,
      required String rideId}) async {
    final url = Uri.parse(
        'https://us-central1-etravel-cab.cloudfunctions.net/StripePayEndpointMethodId');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "use_stripe_sdk": useStripeSdk,
          "payment_method_id": paymentMethodId,
          "currency": currency,
          "ride_id": rideId,
        },
      ),
    );
    return response;
  }

  Future<http.Response> _callPayEndpointIntentId(
      {required String paymentIntentId}) async {
    final url = Uri.parse(
        'https://us-central1-etravel-cab.cloudfunctions.net/StripePayEndpointIntentId');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "payment_intent_id": paymentIntentId,
        },
      ),
    );
    return response;
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    final cards = await getSavedCards();
    _savedCards(cards);
  }

  Future<void> _handlePaymentResponse(
      Response res, String paymentMethodId) async {
    final paymentIntentResponseData =
        PaymentIntentResponseData.fromJson(res.data);
    if (paymentIntentResponseData.requiresAction &&
        paymentIntentResponseData.clientSecret.isNotEmpty) {
      await _handlePaymentConfirmation(paymentIntentResponseData.clientSecret);
      return;
    }
    if (paymentIntentResponseData.requiresAuthentication &&
        paymentIntentResponseData.clientSecret.isNotEmpty) {
      final intent = await _stripe.confirmPayment(
        paymentIntentClientSecret: paymentIntentResponseData.clientSecret,
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData:
              PaymentMethodDataCardFromMethod(paymentMethodId: paymentMethodId),
        ),
      );
      if (intent.status != PaymentIntentsStatus.Succeeded) {
        throw const ETravelException('Payment unsuccessful');
      }
    }
  }
}
