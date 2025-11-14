import 'dart:developer';

import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/methods.enums..dart';
import 'package:diagno_bot/core/networking/remote/remote.dart';
import 'package:diagno_bot/core/networking/remote/request.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/doctor/index/cubit/doctors.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit() : super(const DoctorsState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    await loadLocalData();
    await loadOnlineData();
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([
        db.select(db.specialties).get(),
        getDoctors(),
      ]);
      final specialties = results[0] as List<Specialty>;
      final doctors = results[1] as List<DoctorModel>;
      emit(DoctorsState.success(doctors: doctors));
    } catch (e) {
      AppSnackBar.error(
        ' please check your internt connection ${e.toString()}',
      );

      emit(DoctorsState.error(e.toString()));
    }
  }

  Future<void> loadOnlineData() async {
    try {
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchSpecialties(), fetchDoctors()]);
      } else {
        AppSnackBar.error(' please check your internt connection');
      }
      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ' please check your internt connection ${e.toString()}',
      );
      emit(DoctorsState.error(e.toString()));
    }
  }

  // ******************************************Api************************************************************

  Future<void> fetchSpecialties() async {
    await RemoteProvider().send(
      request: Request(
        url: ApiConstants.specialtyEndpoint,
        header: {'Authorization': 'Bearer ${AuthManager().accessToken}'},
      ),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertSpecialties(res.data['results']);
          }
        } catch (ex) {
          AppSnackBar.error('an error ocurred ${ex.toString()}');
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(
          'an error ocurred. please check your internt connection ',
        );
      },
    );
  }

  Future<void> fetchDoctors() async {
    bool isConnected = await NetworkHelper.isConnected();

    if (isConnected) {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.doctorEndpoint,
          header: {'Authorization': 'Bearer ${AuthManager().accessToken}'},
        ),
        method: RemoteMethod.get,
        onSuccess: (res, statsCode) async {
          try {
            if (res.data['results'].isNotEmpty) {
              await insertDoctorWithUser(res.data['results']);
            }
          } catch (ex) {
            AppSnackBar.error('an error ocurred ${ex.toString()}');
          }
        },
        onError: (_, statsCode) {
          AppSnackBar.error(
            'an error ocurred. please check your internt connection ',
          );
        },
      );
    } else {
      // AppSnackBar.error(' please check your internt connection');
    }
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

  Future<List<DoctorModel>> getDoctors() async {
    final result =
        await (db.select(db.doctors).join([
          innerJoin(db.users, db.users.id.equalsExp(db.doctors.userId)),
        ])).get();

    final jsonList =
        result.map((row) {
          var doctor = row.readTable(db.doctors).toJson();
          final user = row.readTable(db.users).toJson();
          doctor['status'] = DoctorModelStatusConverter().toJson(
            doctor['status'],
          );
          return {...user, ...doctor};
        }).toList();
    var doctors =
        jsonList
            .map<DoctorModel>((doctor) => DoctorModel.fromJson(doctor))
            .toList();
    log(doctors.toString());
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
}
