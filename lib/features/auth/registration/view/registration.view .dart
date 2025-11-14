import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/outlineButton.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.state.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.cubit.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  @override
  Widget build(BuildContext context) {
    var registerCubit = context.read<RegisterCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          state.maybeMap(
            registerSuccess: (_) {
              context.pushNamedAndRemoveUntil(
                Routers.loginView,
                predicate: (root) => false,
              );
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
                    key: registerCubit.form.key,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: registerCubit.form.nameController,
                          hint: "Your Name",
                          icon: Icons.person_outline,
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          controller: registerCubit.form.emailController,
                          hint: "Your Email",
                          icon: Icons.email_outlined,
                          isEmail: true,
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          controller: registerCubit.form.passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        15.verticalSpace,
                        CustomTextField(
                          controller:
                              registerCubit.form.confirmPasswordController,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isConfirmPassword: true,
                          password: registerCubit.form.passwordController,
                        ),
                        20.verticalSpace,
                        SimpleButton(
                          text: "Create Account",
                          isLoading: state.maybeWhen(
                            initial: (loding) => loding,
                            orElse: () => false,
                          ),
                          onPressed: () async {
                            await registerCubit.supmit();
                          },
                        ),

                        20.verticalSpace,
                      ],
                    ),
                  ),

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
                  20.verticalSpace,
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
                        "Do you have an account?",
                        style: GoogleFonts.poppins(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushNamedAndRemoveUntil(
                            Routers.loginView,
                            predicate: (root) => false,
                          );
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

  Widget _socialButton({required IconData icon, required String text}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {},
    );
  }
}
