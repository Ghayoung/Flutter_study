/*
그래프 애니메이션
people class
 */

class People {
  String name;
  double height;
  double weight;
  double? bmi;

  People(this.name, this.height, this.weight) {
    bmi = weight / ((height / 100) * (height / 100));
  }
}