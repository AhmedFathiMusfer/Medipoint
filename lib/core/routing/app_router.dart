import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/view/chat.view.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/view/bookAppointment.view.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:diagno_bot/features/appointment/index/view/appointment.view.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/view/login.view.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.cubit.dart';
import 'package:diagno_bot/features/auth/registration/view/registration.view%20.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/doctorDetails.view.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.cubit.dart';
import 'package:diagno_bot/features/doctor/index/view/index.view.dart';
import 'package:diagno_bot/features/home/cubit/home.cubit.dart';
import 'package:diagno_bot/features/home/view/home.view.dart';
import 'package:diagno_bot/features/onBoarding/onBoarding.view.dart';
import 'package:diagno_bot/features/profile/EditProfile/view/editProfile.view.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.cubit.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.cubit.dart';
import 'package:diagno_bot/features/profile/index/view/profile.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routers.editProfileView:
        var newImagePath = settings.arguments as String?;
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => EditProfileCubit(newImagePath),
                child: EditProfilePage(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.profileView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => ProfileCubit(),
                child: ProfileView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.appointmentView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => AppointmentCubit()..loadAll(),
                child: AppointmentView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.bookingView:
        var doctor = settings.arguments as DoctorModel?;
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create:
                    (_) => BookAppointmentCubit(
                      workingHours: doctor?.workingHours ?? [],
                      doctorId: doctor?.userId ?? '',
                    )..loading(),
                child: BookAppointmentView(),
              ),
          transitionDuration: Duration.zero,
        );

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
        var doctorId = settings.arguments as String? ?? '';
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create:
                    (_) => DoctorDetailsCubit(
                      doctorId: doctorId,
                      DoctorDetailsState.initial(),
                    )..loadAll(),
                child: DoctorDetailsView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.doctorsView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => DoctorsCubit()..loadAll(),
                child: const DoctorsView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.chatView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => ChatCubit()..createSession(),
                child: const ChatView(),
              ),
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
