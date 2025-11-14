import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/features/doctor/doctorDetails/cubit/doctorDetails.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  var db = AppDatabase();
  DoctorDetailsCubit(super.initialState);
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
}
