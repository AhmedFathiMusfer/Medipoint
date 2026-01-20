import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.maybeMap(
            loginSuccess:
                (_) => {
                  context.pushNamedAndRemoveUntil(
                    Routers.homeView,
                    predicate: (root) => false,
                  ),
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
                  20.verticalSpace,
                  Text(
                    "login".tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    "we_are_here_to_help".tr(),
                    style: GoogleFonts.poppins(
                      color: ColorManager.secondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  30.verticalSpace,
                  Form(
                    key: loginCubit.form.key,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: loginCubit.form.emailController,
                          hint: "your_email".tr(),
                          icon: Icons.email_outlined,
                          isEmail: true,
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          controller: loginCubit.form.passwordController,
                          hint: "password".tr(),
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        20.verticalSpace,
                        SimpleButton(
                          text: "login".tr(),
                          isLoading: state.maybeWhen(
                            loding: (loding) => loding,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await loginCubit.supmit();
                          },
                        ),
                      ],
                    ),
                  ),

                  5.verticalSpace,
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(Routers.forgetPasswordView);
                      },
                      child: Text(
                        "forgot_password".tr(),
                        style: TextStyle(
                          color: ColorManager.blueColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "create_new_account".tr(),
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushNamedAndRemoveUntil(
                            Routers.registrationView,
                            predicate: (root) => false,
                          );
                        },
                        child: Text(
                          "sign_on".tr(),
                          style: TextStyle(
                            color: ColorManager.blueColor,
                            fontSize: 12.sp,
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
