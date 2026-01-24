import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/payment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showPaymentDialog(BuildContext context, int bookingId) {
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("complete_payment".tr()),
        content: Text("appointment_booked_success".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamedAndRemoveUntil(
                Routers.appointmentView,
                predicate: (route) => false,
              );
            },
            child: Text(
              "pay_later".tr(),
              style: TextStyle(color: ColorManager.primaryColor),
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    ColorManager.primaryColor,
                  ),
                ),
                onPressed: () async {
                  if (isLoading) return;
                  setState(() {
                    isLoading = true;
                  });
                  // Navigator.pop(context);
                  // Navigator.pop(context);

                  await makePayment(
                    appointmentId: bookingId,

                    onSuccess: () {
                      context.pushNamedAndRemoveUntil(
                        Routers.appointmentView,
                        predicate: (root) => false,
                      );
                    },
                    onError: () {
                      context.pushNamedAndRemoveUntil(
                        Routers.appointmentView,
                        predicate: (root) => false,
                      );
                    },
                  );
                },
                child:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          "pay_now".tr(),
                          style: TextStyle(color: Colors.white),
                        ),
              );
            },
          ),
        ],
      );
    },
  );
}
