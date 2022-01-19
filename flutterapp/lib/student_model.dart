class Student {
  Student(this._name, this._department, this._isActive);
  Student.withId(this._id, this._name, this._department, this._isActive);

  int? _id;
  String? _name;
  int? _isActive;
  String? _department;

  int get id => _id!;
  set id(value) {
    _id = value;
  }

  String get name => _name!;
  set name(value) {
    _name = value;
  }

  int get isActive => _isActive!;
  set isActive(value) {
    _isActive = value;
  }

  String get department => _department!;
  set department(value) {
    _department = value;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "name": name,
      "isActive": _isActive,
      "department": _department
    };
  }

  Student.fromMap(Map<String, dynamic> map) {
    _id = map["id"];
    _name = map["name"];
    _isActive = map["isActive"];
    _department = map["department"];
  }
}
