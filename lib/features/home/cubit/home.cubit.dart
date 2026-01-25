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
import 'package:diagno_bot/features/home/cubit/home.state.dart';
import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial());
  AppDatabase db = AppDatabase();
  List<New> news = [
    New(
      id: 0,
      date: DateTime.now(),
      title: 'meet_doctors_online'.tr(),
      image: 'assets/image/first_on_obourding_image.png',
      description: 'onboarding_description_1'.tr(),
    ),
    New(
      id: 0,
      date: DateTime.now(),
      title: 'connect_with_specialists'.tr(),
      image: 'assets/image/sconde_on_obourding_image.png',
      description: 'onboarding_description_2'.tr(),
    ),
    New(
      id: 0,
      date: DateTime.now(),
      title: 'thousands_of_online_specialists'.tr(),
      image: 'assets/image/final_on_obourding_image.png',
      description: 'onboarding_description_3'.tr(),
    ),
  ];

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
      if (!isClosed) {
        emit(
          HomeState.success(
            specialties: specialties.take(6).toList(),
            doctors: doctors,
            filteredDoctors: doctors,
          ),
        );
      }
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> loadOnlineData() async {
    try {
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchSpecialties(), fetchDoctors()]);
      } else {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
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

  Future<void> fetchDoctors() async {
    bool isConnected = await NetworkHelper.isConnected();

    if (isConnected) {
      await RemoteProvider().send(
        request: Request(url: ApiConstants.initEndpoint),
        method: RemoteMethod.get,
        onSuccess: (res, statsCode) async {
          log(res.data.toString());
          try {
            // if (res.data['specialties'].isNotEmpty) {
            //   await insertSpecialties(res.data['specialties']);
            // }
            if (res.data['doctors'].isNotEmpty) {
              await insertDoctorWithUser(res.data['doctors']);
            }
          } catch (ex) {
            AppSnackBar.error(
              '${ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected)}+${ex.toString()}',
            );
          }
        },
        onError: (_, statsCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
        },
      );
    } else {}
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
    //log(doctors.toString());
    return doctors;
  }

  insertDoctorWithUser(data) async {
    await db.batch((batch) {
      for (final doctorJson in data) {
        final userJson = doctorJson['user'];
        final workingHours = doctorJson['working_hours'];
        final reviews = doctorJson['reviews'];
        if (doctorJson['specialty'] == null) {
          continue;
        }
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
            specialtyAr: Value(doctorJson['specialty_ar']),
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
        for (var workingHour in workingHours) {
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
        if (reviews.isNotEmpty) {}
        batch.insertAllOnConflictUpdate(
          db.reviews,
          reviews.map<Review>((review) {
            return Review.fromJson({
              ...review,
              'doctorId': review['doctor'],
              'patientId': review['patient']['user']['id'],
              'patientName': review['patient']['user']['full_name'],
              'patientImage': review['patient']['user']['image'],
              'createdAt': review['created_at'],
              'updatedAt': review['updated_at'],
            });
          }),
        );
      }
    });
  }
}
