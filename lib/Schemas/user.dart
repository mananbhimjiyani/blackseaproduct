// ignore_for_file: prefer_collection_literals, unnecessary_this

class User {
  int? userID;
  int? employeeID;
  String? userFirstName;
  String? userLastName;
  String? email;
  String? userPic;
  String? jobTitle;
  int? locationID;
  String? reportingTo;
  String? userName;
  String? password;

  User({
    this.userID,
    this.employeeID,
    this.userFirstName,
    this.userLastName,
    this.email,
    this.userPic,
    this.jobTitle,
    this.locationID,
    this.reportingTo,
    this.userName,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['UserID'],
      employeeID: json['EmployeeID'],
      userFirstName: json['UserFirstName'],
      userLastName: json['UserLastName'],
      email: json['Email'],
      userPic: json['UserPic'],
      jobTitle: json['JobTitle'],
      locationID: json['LocationID'],
      reportingTo: json['ReportingTo'],
      userName: json['UserName'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UserID'] = this.userID;
    data['EmployeeID'] = this.employeeID;
    data['UserFirstName'] = this.userFirstName;
    data['UserLastName'] = this.userLastName;
    data['Email'] = this.email;
    data['UserPic'] = this.userPic;
    data['JobTitle'] = this.jobTitle;
    data['LocationID'] = this.locationID;
    data['ReportingTo'] = this.reportingTo;
    data['UserName'] = this.userName;
    data['Password'] = this.password;
    return data;
  }
}