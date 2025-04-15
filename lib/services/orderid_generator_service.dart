import 'dart:math';

String generateOrderId(){
  DateTime now=DateTime.now();

  int intRandomIds=Random().nextInt(99999);
  String id= '${now.microsecond} $intRandomIds';

  return id;
}