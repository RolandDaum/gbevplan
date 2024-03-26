import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: camel_case_types
class OB_userdata {
  @Id()
  int id = 0;
  
  List<String> kurse = [];
  String jahrgang = '';

  SecureCredentials securecredentials = SecureCredentials();
}
@Entity()
class SecureCredentials {
  int id = 0;
  String username = '';
  String password = '';
  
  SomeData someData = SomeData();

  SecureCredentials();
}
@Entity()
class SomeData {
  int id = 0;
  String data = '';

  SomeData();
}
