import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/model/user.model.dart';
import 'package:diagno_bot/features/profile/index/cubit/profile.state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());

  get user => AuthManager().currentUser;
  void initial() {
    emit(ProfileState.initial());
  }
}
