import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/resetPassword/cubit/resetPassword.cubit.dart';
import 'package:diagno_bot/features/auth/resetPassword/cubit/resetPassword.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordView extends StatefulWidget {
  final String token;

  const ResetPasswordView({super.key, required this.token});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    var resetPasswordCubit = context.read<ResetPasswordCubit>();
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
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              // Navigate back to login page
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  Navigator.of(context).popUntil(
                    (route) =>
                        route.isFirst ||
                        route.settings.name == Routers.loginView,
                  );
                }
              });
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
                    "reset_password".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    "please_enter_new_password".tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ColorManager.secondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  40.verticalSpace,
                  Form(
                    key: resetPasswordCubit.form.key,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller:
                              resetPasswordCubit.form.newPasswordController,
                          hint: "new_password".tr(),
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        30.verticalSpace,
                        CustomTextField(
                          controller:
                              resetPasswordCubit.form.confirmPasswordController,
                          hint: "confirm_new_password".tr(),
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isConfirmPassword: true,
                          password:
                              resetPasswordCubit.form.newPasswordController,
                        ),
                        30.verticalSpace,
                        SimpleButton(
                          text: "reset_password".tr(),
                          isLoading: state.maybeWhen(
                            initial: (loading) => loading,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await resetPasswordCubit.resetPassword();
                          },
                        ),
                      ],
                    ),
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
