import 'package:flutter/material.dart';

class Animal {
  String? imagePath; // 동물 이미지 경로
  String? animalName; // 동물 이름
  String? kind; // 동물 종류
  bool? flyExist = false; // 날 수 있는지 여부

  // 생성자
  Animal(
      {required this.animalName,
      required this.kind,
      required this.imagePath,
      this.flyExist});
}
