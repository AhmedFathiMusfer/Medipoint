import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/features/ai/chat/view/chat.view.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/view/login.view.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.cubit.dart';
import 'package:diagno_bot/features/auth/registration/view/registration.view%20.dart';
import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/bookAppointment/view/bookAppointment.view.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/doctorDetails.view.dart';
import 'package:diagno_bot/features/doctor/index/view/index.view.dart';
import 'package:diagno_bot/features/home/cubit/home.cubit.dart';
import 'package:diagno_bot/features/home/view/home.view.dart';
import 'package:diagno_bot/features/onBoarding/onBoarding.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routers.onBoardingView:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case Routers.homeView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => HomeCubit()..loadAll(),
                child: HomeView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.doctorDetailsView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => DoctorDetailsCubit(DoctorDetailsState.initial()),
                child: DoctorDetailsView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.bookAppointmentView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => BookAppointmentCubit(),
                child: BookAppointmentView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.doctorsView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const DoctorsView(),
          transitionDuration: Duration.zero,
        );
      case Routers.chatView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const ChatView(),
          transitionDuration: Duration.zero,
        );
      case Routers.registrationView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => RegisterCubit(),
                child: const RegistrationView(),
              ),
        );
      case Routers.loginView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => LoginCubit()..inital(),
                child: const LoginView(),
              ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
    }
  }
}
