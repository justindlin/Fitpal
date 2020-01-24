class Weight {
  int weightID;
  DateTime datetime;
  double weight;
  String user;

  Weight({this.weightID, this.datetime, this.weight, this.user});

  Map<String,dynamic> toMap() {
    return {
      'weightID': this.weightID,
      'datetime': this.datetime.toString(),
      'weight': this.weight,
      'user': this.user,
    };
  }

  Weight.fromMap(Map<String, dynamic> map) {
    this.weightID = map['weightID'];
    this.datetime = DateTime.parse(map['datetime']);
    this.weight = map['weight'];
    this.user = map['user'];
  }
}
