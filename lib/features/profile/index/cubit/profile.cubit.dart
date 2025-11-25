import 'package:diagno_bot/features/profile/index/cubit/profile.state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image == null) return;
      var filePath = image.path;
      emit(ProfileState.EditTheAvatar(imagePath: filePath));
    } on PlatformException catch (e) {
      print('Failed to pick a photo $e');
    }
  }
}
