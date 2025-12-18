import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/specialty/cubit/specialties.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialtiesCubit extends Cubit<SpecialtiesState> {
  SpecialtiesCubit() : super(const SpecialtiesState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(SpecialtiesState.loading());
    }
    await loadLocalData();
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([db.select(db.specialties).get()]);
      final specialties = results[0];
      if (!isClosed) {
        emit(SpecialtiesState.success(specialities: specialties));
      }
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  fillterDoctorBySpecialtyOrName(String? specialty, String? name) async {
    // final filteredDoctors = await getDoctors(specialty: specialty, name: name);
    // state.mapOrNull(
    //   success: (state) {
    //     if (!isClosed) {
    //       emit(
    //         state.copyWith(
    //           doctors: filteredDoctors,
    //           specialtySelected: specialty ?? 'All',
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
