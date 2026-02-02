import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/TextField.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:diagno_bot/features/profile/changePassword/cubit/changePassword.cubit.dart';
import 'package:diagno_bot/features/profile/changePassword/cubit/changePassword.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    var changePasswordCubit = context.read<ChangePasswordCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManager.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "change_password".tr(),
          style: TextStyle(
            color: ColorManager.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              Navigator.of(context).pop();
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: changePasswordCubit.form.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                30.verticalSpace,
                Text(
                  'enter_current_new_password'.tr(),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                30.verticalSpace,
                CustomTextField(
                  hint: 'current_password'.tr(),
                  controller: changePasswordCubit.form.oldPasswordController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                15.verticalSpace,
                CustomTextField(
                  hint: 'new_password'.tr(),
                  controller: changePasswordCubit.form.newPasswordController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                15.verticalSpace,
                CustomTextField(
                  hint: 'confirm_new_password'.tr(),
                  controller:
                      changePasswordCubit.form.confirmPasswordController,
                  isPassword: true,
                  isConfirmPassword: true,
                  password: changePasswordCubit.form.newPasswordController,
                  icon: Icons.lock_outline,
                ),
                30.verticalSpace,
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      initial: (loading) => loading,
                      orElse: () => false,
                    );
                    return SimpleButton(
                      onPressed: () {
                        changePasswordCubit.changePassword();
                      },
                      text: 'change_password'.tr(),
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
