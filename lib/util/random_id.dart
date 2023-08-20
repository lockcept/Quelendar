import 'package:nanoid/nanoid.dart';

String randomId() {
  return customAlphabet('abcdefghikjlmnopqrstuvwxyzABCDEFGHIJKMLNOPQRSTUVWXYZ0123456789', 10);
}
