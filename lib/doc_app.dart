import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocApp extends StatelessWidget {
  final AppRouter appRouter;
  const DocApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(325, 812),
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [BlocProvider<ChatCubit>(create: (_) => ChatCubit())],
        child: MaterialApp(
          scaffoldMessengerKey: AppSnackBar.messengerKey,
          navigatorKey: AppRouter.navigatorKey,
          title: 'Doc App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: ColorManager.primaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          initialRoute:
              AuthManager().isLoggedIn()
                  ? Routers.homeView
                  : Routers.onBoardingView,
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}
