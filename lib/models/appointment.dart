import 'package:attendance/models/student.dart';

import 'StudentModelSimple.dart';

class AppointmentModel {
  int? id;
  String? time;
  String? name;
  String? date;
  List<StudentModelSimple>? students;
  List<StudentModelSimple>? compensateStudents;

  AppointmentModel(
      {this.id, this.time, this.students, this.name, this.compensateStudents});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    name = json['name'];
    date = json['date'];
    students = List<StudentModelSimple>.from(
      json['students'].map(
        (model) => StudentModelSimple.fromJson(model),
      ),
    );
    compensateStudents = List<StudentModelSimple>.from(
      json['compensation_students'].map(
        (model) => StudentModelSimple.fromJson(model),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['date'] = this.date;
    data['name'] = this.name;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    if (this.compensateStudents != null) {
      data['compensation_students'] =
          this.compensateStudents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
