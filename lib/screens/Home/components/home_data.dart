class HomeData {
  final int? id;
  final String? year;
  final String? subject;
  final String? teacher;
  final String? groupname;
  final String? classname;
  final String? groupid;
  final String? classid;

  HomeData(
      {this.id,
      this.year,
      this.subject,
      this.teacher,
      this.groupname,
      this.classname,
      this.classid,
      this.groupid});

  Map<String, dynamic> toMap() {
    return {
      'year': this.year,
      'subject': this.subject,
      'teacher': this.teacher,
      'groupname': this.groupname,
      'classname': this.classname,
      'classid': this.classid,
      'groupid': this.groupid
    };
  }

  factory HomeData.fromMap(int id, Map<String, dynamic> map) {
    return HomeData(
        id: id,
        year: map['year'],
        subject: map['subject'],
        teacher: map['teacher'],
        groupname: map['groupname'],
        classname: map['classname'],
        groupid: map['groupid'],
        classid: map['classid']);
  }

  HomeData copyWith(
      {int? id,
      String? year,
      String? subject,
      String? teacher,
      String? groupname,
      String? classname}) {
    return HomeData(
      id: id ?? this.id,
      year: year ?? this.year,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      groupname: groupname ?? this.groupname,
      classname: classname ?? this.classname,
      groupid: groupid ?? this.groupid,
      classid: classid ?? this.classid,
    );
  }
}
