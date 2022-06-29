class Usermodel {
  String? uid;
  String? email;
  String? fname;
  String? lname;
  Usermodel({this.uid, this.email, this.fname , this.lname});
  //receive data from server
  factory Usermodel.fromMap(map) {
    return Usermodel(
      uid: map['uid'],
      email: map['email'],
      fname: map['fname'],
      lname: map['lname']
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname
    };
  }
}