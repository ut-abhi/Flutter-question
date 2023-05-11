

import 'dart:convert';
import 'package:flutter/foundation.dart';

class Student {
  String rollNo;
  String name;
  String college;

  Student({
    required this.rollNo,
    required this.name,
    required this.college,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      rollNo: map['roll no.'] as String,
      name: map['name'] as String,
      college: map['college'] as String,
    );
  }

}

