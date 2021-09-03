class CodeData {
  final int? id;
  final String code;
  final String groupid;
 

  CodeData(
      {this.id,
      required this.code,
      required this.groupid,
     
      });

  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'groupid': this.groupid,
    
    };
  }

  factory CodeData.fromMap(int id, Map<String, dynamic> map) {
    return CodeData(
        id: id,
        code: map['code'],
        groupid: map['groupid'],
       
        );
  }

  CodeData copyWith(
      {int? id,
      String? code,
      String? groupid,
    
      }) {
    return CodeData(
      id: id ?? this.id,
      code: code ?? this.code,
      groupid: groupid ?? this.groupid,
  
    );
  }
}
