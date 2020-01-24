class Food{

  int calorieID;
  DateTime datetime;
  String mealType;  
  String foodName;
  int calorieIntake;
  String user;

  Food({this.calorieID, this.datetime, this.mealType, this.foodName, this.calorieIntake, this.user});

  Map<String,dynamic> toMap() {
    return {
      'calorieID': this.calorieID,
      'datetime': this.datetime.toString(),
      'mealType': this.mealType,
      'foodName': this.foodName,
      'calorieIntake': this.calorieIntake,
      'user': this.user,
    };
  }
  
  Food.fromMap(Map<String, dynamic> map) {
    this.calorieID = map['calorieID'];
    this.datetime = DateTime.parse(map['datetime']);
    this.mealType = map['mealType'];
    this.foodName = map['foodName'];
    this.calorieIntake = map['calorieIntake'];
    this.user = map['user'];
  }

}