import 'dart:developer';

import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  String? specialty;
  DoctorsCubit({this.specialty}) : super(const DoctorsState.initial());

  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(DoctorsState.loading());
    }

    await loadLocalData();
    if (isClosed) return;
    await loadOnlineData();
    specialty = null;
  }

  Future<void> loadLocalData() async {
    try {
      if (isClosed) return;
      final results = await Future.wait([
        db.select(db.specialties).get(),
        getDoctors(specialty: specialty),
      ]);
      final specialties = results[0] as List<Specialty>;
      final doctors = results[1] as List<DoctorModel>;
      if (!isClosed) {
        emit(
          DoctorsState.success(
            doctors: doctors.reversed.toList(),
            specialities: specialties,
            specialtySelected: specialty ?? "All",
          ),
        );
      }
    } catch (e) {
      // AppSnackBar.error(
      //   ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      // );
    }
  }

  Future<void> loadOnlineData() async {
    try {
      if (isClosed) return;
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchDoctors()]);
      } else {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
      if (isClosed) return;
      await loadLocalData();
    } catch (e) {
      // AppSnackBar.error(
      //   ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      // );
    }
  }

  fillterDoctorBySpecialtyOrName(String? specialty, String? name) async {
    if (isClosed) return;
    final filteredDoctors = await getDoctors(specialty: specialty, name: name);
    if (!isClosed) {
      state.mapOrNull(
        success: (state) {
          if (!isClosed) {
            emit(
              state.copyWith(
                doctors: filteredDoctors,
                specialtySelected: specialty ?? 'All',
              ),
            );
          }
        },
      );
    }
  }
  // ******************************************Api************************************************************

  Future<void> fetchSpecialties() async {
    await RemoteProvider().send(
      request: Request(url: ApiConstants.specialtyEndpoint),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertSpecialties(res.data['results']);
          }
        } catch (ex) {
          // AppSnackBar.error(
          //   ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          // );
        }
      },
      onError: (_, statsCode) {
        log(statsCode.toString());
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
  }

  Future<void> fetchDoctors() async {
    await RemoteProvider().send(
      request: Request(url: ApiConstants.doctorEndpoint),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertDoctorWithUser(res.data['results']);
          }
        } catch (ex) {
          // AppSnackBar.error(
          //   ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          // );
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
  }

  // ******************************************db************************************************************
  insertSpecialties(data) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.specialties,
        data
            .map<Specialty>((specialty) => Specialty.fromJson(specialty))
            .toList(),
      );
    });
  }

  Future<double> getDoctorAverageRating(String doctorId) async {
    final avgExpr = db.reviews.rating.avg();

    final row =
        await (db.selectOnly(db.reviews)
              ..addColumns([avgExpr])
              ..where(db.reviews.doctorId.equals(doctorId)))
            .getSingleOrNull();

    double avg = row?.read(avgExpr) ?? 0;
    return avg.clamp(0, 5);
  }

  Future<int> getDoctorReviewsCount(String doctorId) async {
    final countExpr = db.reviews.id.count();

    final row =
        await (db.selectOnly(db.reviews)
              ..addColumns([countExpr])
              ..where(db.reviews.doctorId.equals(doctorId)))
            .getSingleOrNull();

    return row?.read(countExpr) ?? 0;
  }

  Future<List<DoctorModel>> getDoctors({
    String? specialty,
    String? name,
  }) async {
    var temp = (db.select(db.doctors).join([
      innerJoin(db.users, db.users.id.equalsExp(db.doctors.userId)),
    ]));
    if (specialty != null) {
      temp = temp..where(db.doctors.specialty.equals(specialty));
    }
    if (name != null && name.isNotEmpty) {
      temp = temp..where(db.users.fullName.contains(name));
    }
    final result = await temp.get();

    final jsonList =
        result.map((row) async {
          var doctor = row.readTable(db.doctors).toJson();
          final user = row.readTable(db.users).toJson();
          final reviews = await getDoctorReviewsCount(user['id']);
          final rating = await getDoctorAverageRating(user['id']);
          doctor['status'] = DoctorModelStatusConverter().toJson(
            doctor['status'],
          );
          return {...user, ...doctor, 'reviews': reviews, 'rating': rating};
        }).toList();
    var doctors = await Future.wait(jsonList).then(
      (jsonList) =>
          jsonList
              .map<DoctorModel>((doctor) => DoctorModel.fromJson(doctor))
              .toList(),
    );
    //   log(doctors.toString());
    return doctors;
  }

  insertDoctorWithUser(data) async {
    await db.batch((batch) {
      for (final doctorJson in data) {
        final userJson = doctorJson['user'];

        batch.insert(
          db.users,
          UsersCompanion(
            id: Value(userJson['id']),
            fullName: Value(userJson['full_name']),
            email: Value(userJson['email']),
            role: Value(userJson['role']),
            gender: Value(userJson['gender']),
          ),
          mode: InsertMode.insertOrReplace,
        );

        batch.insert(
          db.doctors,
          DoctorsCompanion(
            userId: Value(userJson['id']),
            fees: Value(doctorJson['fees']),
            experience: Value(doctorJson['experience']),
            education: Value(doctorJson['education']),
            specialty: Value(doctorJson['specialty']),
            about: Value(doctorJson['about']),
            addressLine1: Value(doctorJson['address_line1']),
            addressLine2: Value(doctorJson['address_line2']),
            status: Value(
              DoctorModelStatusConverter().fromJson(doctorJson['status']),
            ),
            isVerified: Value(doctorJson['is_verified'] ?? false),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  insertWorkerHouers(data) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.workingHours,
        data
            .map<WorkingHour>(
              (workingHour) => WorkingHour.fromJson(workingHour),
            )
            .toList(),
      );
    });
  }
}
