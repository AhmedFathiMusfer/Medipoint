import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/outlineButton.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          state.maybeWhen(
            loginSuccess:
                () => {
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
                    "HealthPal ",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    "We are here to help you!",
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
                          hint: "Your Email",
                          icon: Icons.email_outlined,
                          isEmail: true,
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          controller: loginCubit.form.passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        20.verticalSpace,
                        SimpleButton(
                          text: "login",
                          isLoading: state.maybeWhen(
                            initial: (loding) => loding,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await loginCubit.supmit();
                          },
                        ),
                      ],
                    ),
                  ),

                  20.verticalSpace,
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //     Text(
                  //       " or ",
                  //       style: GoogleFonts.poppins(color: Colors.grey.shade600),
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         thickness: 1,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // 20.verticalSpace,
                  // OutlineButton(
                  //   icon: "assets/icons/google.png",
                  //   text: "Continue with Google",
                  // ),
                  // const SizedBox(height: 15),
                  // OutlineButton(
                  //   icon: "assets/icons/facebook.png",
                  //   text: "Continue with Facebook",
                  // ),
                  // 10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create new  account?",
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushNamedAndRemoveUntil(
                            Routers.homeView,
                            predicate: (root) => false,
                          );
                        },
                        child: Text(
                          "Sign On",
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

  Widget _socialButton({required IconData icon, required String text}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        context.pushReplacementNamed(Routers.homeView);
      },
    );
  }
}
