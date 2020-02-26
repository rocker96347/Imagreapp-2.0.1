class Note {
  int id;
  String title;
  String note;
  Note({this.id, this.title, this.note});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['Title'] = title;
    map['Description'] = note;
    return map;
  }
}
