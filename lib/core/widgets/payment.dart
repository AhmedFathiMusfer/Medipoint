import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> makePayment({
  required int appointmentId,
  required Function onSuccess,
  required Function onError,
}) async {
  try {
    bool isConnected = await NetworkHelper.isConnected();
    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return;
    }
    await RemoteProvider().send(
      request: Request(
        url: ApiConstants.createPaymentIntentEndpoint(appointmentId),
      ),
      method: RemoteMethod.post,
      onSuccess: (response, statusCode) async {
        try {
          final clientSecret = response.data['client_secret'];

          if (clientSecret == null) {
            AppSnackBar.error('payment_secret_not_received'.tr());
            return;
          }
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: "MediPoint",
              style: ThemeMode.light,
            ),
          );
          await Stripe.instance.presentPaymentSheet();
          onSuccess();
          AppSnackBar.success('payment_success'.tr());
        } catch (e) {
          onError();
        }
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        onError();
      },
    );
  } catch (e) {
    AppSnackBar.error(
      ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
    );
    onError();
  }
}
