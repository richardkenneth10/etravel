import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:etravel/models/exceptions/etravel_exception.dart';
import 'package:etravel/widgets/app_widgets/app_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class SafeRequest {
  static Future run(
    Future Function() function, {
    void Function(ETravelException e)? onError,
    VoidCallback? onBegin,
    VoidCallback? onFinally,
    VoidCallback? onSuccess,
  }) async {
    final localErrorHandler = onError ??
        (e) {
          if (onBegin == null) Get.back();
          AppMessage.error(message: e.message);
          debugPrint(e.message);
        };

    (onBegin ?? AppMessage.loading).call();

    try {
      await function();
      if (onBegin == null) Get.back();
      onSuccess?.call();
    } on SocketException {
      const error = ETravelException("No internet connection");
      localErrorHandler(error);
    } on HttpException {
      const error = ETravelException("Resource not found");
      localErrorHandler(error);
    } on FormatException {
      const error = ETravelException("Bad response format");
      localErrorHandler(error);
    } on DioError catch (e) {
      final error = ETravelException.fromDioException(e);
      localErrorHandler(error);
    } on StripeException catch (e) {
      final error = ETravelException.fromStripeException(e);
      localErrorHandler(error);
    } on PlatformException catch (e) {
      final error = ETravelException.fromPlatformException(e);
      localErrorHandler(error);
    } on ETravelException catch (e) {
      localErrorHandler(e);
    } catch (e) {
      localErrorHandler(const ETravelException());
    } finally {
      onFinally?.call();
    }
  }
}
