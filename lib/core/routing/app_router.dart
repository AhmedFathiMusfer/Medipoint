import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/enum/pages.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/stror/appStore.dart';
import 'package:diagno_bot/features/ai/chat/cubit/chat.cubit.dart';
import 'package:diagno_bot/features/ai/chat/view/chat.view.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/view/bookAppointment.view.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.cubit.dart';
import 'package:diagno_bot/features/appointment/index/view/appointment.view.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.cubit.dart';
import 'package:diagno_bot/features/auth/login/view/login.view.dart';
import 'package:diagno_bot/features/auth/forgetPassword/cubit/forgetPassword.cubit.dart';
import 'package:diagno_bot/features/auth/forgetPassword/view/forgetPassword.view.dart';
import 'package:diagno_bot/features/auth/verifyCode/cubit/verifyCode.cubit.dart';
import 'package:diagno_bot/features/auth/verifyCode/view/verifyCode.view.dart';
import 'package:diagno_bot/features/auth/resetPassword/cubit/resetPassword.cubit.dart';
import 'package:diagno_bot/features/auth/resetPassword/view/resetPassword.view.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.cubit.dart';

import 'package:diagno_bot/features/auth/registration/view/registration.view%20.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/view/doctorDetails.view.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/reviews.view.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.cubit.dart';
import 'package:diagno_bot/features/doctor/index/view/index.view.dart';
import 'package:diagno_bot/features/home/cubit/home.cubit.dart';
import 'package:diagno_bot/features/home/view/home.view.dart';
import 'package:diagno_bot/features/onBoarding/onBoarding.view.dart';
import 'package:diagno_bot/features/profile/EditProfile/view/editProfile.view.dart';
import 'package:diagno_bot/features/profile/changePassword/cubit/changePassword.cubit.dart';
import 'package:diagno_bot/features/profile/changePassword/view/changePassword.view.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.cubit.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.cubit.dart';
import 'package:diagno_bot/features/profile/index/view/profile.view.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.cubit.dart';
import 'package:diagno_bot/features/recordFiles/Folders/view/folder.view.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.cubit.dart';
import 'package:diagno_bot/features/recordFiles/files/view/file.view.dart';
import 'package:diagno_bot/features/specialty/cubit/specialties.cubit.dart';
import 'package:diagno_bot/features/specialty/view/Specialties.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routers.doctorReviewsView:
        var doctorId = settings.arguments as String? ?? "0";
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => DoctorReviewsCubit(doctorId)..loadAll(),
                child: DoctorReviewsView(doctorId: doctorId),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.specialtiesView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => SpecialtiesCubit()..loadAll(),
                child: SpecialtiesView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.fileView:
        var folderId = settings.arguments as int;
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => FileCubit(folderId: folderId)..loadAll(),
                child: PatientFilesView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.folderView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => FolderCubit()..loadAll(),
                child: PatientFoldersView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.editProfileView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => EditProfileCubit(),
                child: EditProfilePage(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.changePasswordView:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => ChangePasswordCubit(),
                child: const ChangePasswordView(),
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
                      workingHours:
                          doctor?.workingHours ??
                          List<WorkingHour>.empty(growable: true),
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
        var specialty = settings.arguments as String?;
        Appstore.instanse.currentPage = PagesEnum.doctor;
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => BlocProvider(
                create: (_) => DoctorsCubit(specialty: specialty)..loadAll(),
                child: const DoctorsView(),
              ),
          transitionDuration: Duration.zero,
        );
      case Routers.chatView:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            final chatCubit = BlocProvider.of<ChatCubit>(context);
            chatCubit.checkIfSessionIsExitOrNo();
            return BlocProvider.value(
              value: chatCubit,
              child: const ChatView(),
            );
          },

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
      case Routers.forgetPasswordView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => ForgetPasswordCubit(),
                child: const ForgetPasswordView(),
              ),
        );
      case Routers.verifyCodeView:
        var data = settings.arguments as Map<String, dynamic>? ?? {};
        var isResetPassword = data['isResetPassword'] as bool? ?? false;
        var email = data['email'] as String? ?? '';
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (_) => VerifyCodeCubit(
                      email: email,
                      isResetPassword: isResetPassword,
                    ),
                child: VerifyCodeView(
                  email: email,
                  isResetPassword: isResetPassword,
                ),
              ),
        );
      case Routers.resetPasswordView:
        var data = settings.arguments as Map<String, dynamic>? ?? {};
        var token = data['token'] as String? ?? '';
        var email = data['email'] as String? ?? '';

        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (_) => ResetPasswordCubit(token: token, email: email),
                child: ResetPasswordView(token: token),
              ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
    }
  }
}
