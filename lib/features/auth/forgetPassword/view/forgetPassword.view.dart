import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/forgetPassword/cubit/forgetPassword.cubit.dart';
import 'package:diagno_bot/features/auth/forgetPassword/cubit/forgetPassword.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  @override
  Widget build(BuildContext context) {
    var forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorManager.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (email) {
              // Navigate to verify code page
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.pushNamed(
                    Routers.verifyCodeView,
                    arguments: email,
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
                    "HealthPal",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  30.verticalSpace,
                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    "Don't worry! Enter your email address and we'll send you a link to reset your password.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ColorManager.secondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  40.verticalSpace,
                  Form(
                    key: forgetPasswordCubit.form.key,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: forgetPasswordCubit.form.emailController,
                          hint: "Your Email",
                          icon: Icons.email_outlined,
                          isEmail: true,
                        ),
                        30.verticalSpace,
                        SimpleButton(
                          text: "Send Reset Link",
                          isLoading: state.maybeWhen(
                            initial: (loading) => loading,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await forgetPasswordCubit.submit();
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
                        "Remember your password?",
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sign In",
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
