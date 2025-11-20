import 'dart:developer';

import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  var db = AppDatabase();
  final String doctorId;
  DoctorDetailsCubit(super.initialState, {required this.doctorId});

  add() {
    // var user = User(id: 1, name: 'ahemed', email: 'kkdkd');
    // var doctor = Doctor(id: 1, name: 'ahemed');
    // db.into(db.users).insert(user);
    // db.into(db.doctors).insert(doctor);
    // db.select(db.doctors).join([
    //   leftOuterJoin(db.doctors, db.doctors.id.equalsExp(db.users.id)),
    // ]).get();
    //  db.select(db.users)
  }

  Future<void> loadAll() async {
    if (!isClosed) {
      emit(DoctorDetailsState.loading());
    }
    await loadLocalData();
    await loadOnlineData();
  }

  Future<void> loadLocalData() async {
    try {
      final doctor = await getDoctorById(doctorId);
      if (!isClosed) {
        emit(DoctorDetailsState.success(doctor: doctor));
      }
    } catch (e) {
      AppSnackBar.error(
        ' please check your internt connection ${e.toString()}',
      );

      emit(DoctorDetailsState.error(e.toString()));
    }
  }

  Future<void> loadOnlineData() async {
    try {
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchDoctorById(doctorId)]);
      } else {
        AppSnackBar.error(' please check your internt connection');
      }
      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ' please check your internt connection ${e.toString()}',
      );
      if (!isClosed) {
        emit(DoctorDetailsState.error(e.toString()));
      }
    }
  }

  // ******************************************Api************************************************************
  Future<void> fetchDoctorById(String id) async {
    await RemoteProvider().send(
      request: Request(url: '${ApiConstants.doctorEndpoint}$id/'),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data != null) {
            await insertDoctorWithUser(res.data);
          }
        } catch (ex) {
          log(ex.toString());
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
  }

  // ******************************************db************************************************************

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

  Future<DoctorModel> getDoctorById(String id) async {
    var temp = (db.select(db.doctors).join([
      innerJoin(db.users, db.users.id.equalsExp(db.doctors.userId)),
    ]))..where(db.doctors.userId.equals(id));
    final result = await temp.get();
    final workingHours =
        await (db.select(db.workingHours)
          ..where((tbl) => tbl.doctorId.equals(id))).get();
    final reviews = await getDoctorReviewsCount(id);
    final rating = await getDoctorAverageRating(id);
    final data =
        result
            .map((row) {
              var doctor = row.readTable(db.doctors).toJson();
              final user = row.readTable(db.users).toJson();
              doctor['status'] = DoctorModelStatusConverter().toJson(
                doctor['status'],
              );
              return {...user, ...doctor, 'reviews': reviews, 'rating': rating};
            })
            .toList()
            .first;
    var doctor = DoctorModel.fromJson(data);
    doctor.workingHours = workingHours;

    log(doctor.toString());
    return doctor;
  }

  insertDoctorWithUser(doctorJson) async {
    await db.batch((batch) async {
      final userJson = doctorJson['user'];
      final workingHours = doctorJson['working_hours'];

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
      log(doctorJson.toString());
      // for (var workingHour in workingHours) {
      //   batch.insert(
      //     db.workingHours,
      //     WorkingHour.fromJson(workingHour),
      //     mode: InsertMode.insertOrReplace,
      //   );
      // }
      await insertWorkerHouers(workingHours);
    });
  }

  insertWorkerHouers(data) async {
    await db.batch((batch) {
      for (var workingHour in data) {
        batch.insert(
          db.workingHours,
          WorkingHoursCompanion(
            id: Value(workingHour['id']),
            startTime: Value(workingHour['start_time']),
            endTime: Value(workingHour['end_time']),
            doctorId: Value(workingHour['doctor']),
            patientLeft: Value(workingHour['patient_left']),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
