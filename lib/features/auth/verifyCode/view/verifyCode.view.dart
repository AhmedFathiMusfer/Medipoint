import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/verifyCode/cubit/verifyCode.cubit.dart';
import 'package:diagno_bot/features/auth/verifyCode/cubit/verifyCode.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyCodeView extends StatefulWidget {
  final String email;
  final bool isResetPassword;
  const VerifyCodeView({
    super.key,
    required this.email,
    required this.isResetPassword,
  });

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  @override
  Widget build(BuildContext context) {
    var verifyCodeCubit = context.read<VerifyCodeCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorManager.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (token, email) {
              if (widget.isResetPassword) {
                if (mounted) {
                  context.pushNamed(
                    Routers.resetPasswordView,
                    arguments: {'token': token, 'email': email},
                  );
                }
              } else {
                if (mounted) {
                  context.pushNamedAndRemoveUntil(
                    Routers.loginView,
                    predicate: (root) => false,
                  );
                }
              }
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  Image.asset(
                    "assets/icons/logo.png",
                    height: 60.h,
                    width: 60.w,
                    color: ColorManager.primaryColor,
                  ),
                  10.verticalSpace,
                  Text(
                    "healthpal".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  30.verticalSpace,
                  Text(
                    "verify_code".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    "${"please_enter_code_sent".tr()}\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ColorManager.secondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  40.verticalSpace,
                  Form(
                    key: verifyCodeCubit.form.key,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: verifyCodeCubit.form.codeController,
                          hint: "enter_verification_code".tr(),
                          icon: Icons.vpn_key_outlined,
                          validator: true,
                        ),
                        30.verticalSpace,
                        SimpleButton(
                          text: "verify_code".tr(),
                          isLoading: state.maybeWhen(
                            initial: (loading) => loading,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await verifyCodeCubit.submit();
                          },
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "didnt_receive_code".tr(),
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          // Resend code functionality can be added here
                          AppSnackBar.warning(
                            'Code resend feature will be implemented',
                          );
                        },
                        child: Text(
                          "resend".tr(),
                          style: TextStyle(
                            color: ColorManager.blueColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
