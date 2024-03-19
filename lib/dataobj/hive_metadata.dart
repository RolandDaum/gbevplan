import 'package:hive/hive.dart';

class HIVE_MetaDataAdapter  extends TypeAdapter<HIVE_Metadata> {
  @override
  final int typeId = 0;

  @override
  HIVE_Metadata read(BinaryReader reader) {
    final name = reader.readString();
    final age = reader.readInt();
    final version = reader.readString();
    final appName = reader.readString();
    final rememberMe = reader.readBool();
    final apivalidity = reader.readString();
    final apiaddress = reader.readString();
    final lastAPICall = reader.readString();
    final notifications = reader.readBool();
    final darkmode = reader.readBool();
    final username = reader.readString();
    final password = reader.readString();
    final apikey = reader.readString();
    return HIVE_Metadata(
      HIVE_UserData(name, age),
      HIVE_AppData(HIVE_AppInfo(version, appName), HIVE_UIInfo(rememberMe), HIVE_APIInfo(apivalidity, apiaddress, lastAPICall), HIVE_AppSettings(notifications, darkmode)),
      HIVE_SecureCredentials(username, password, apikey),
    );
  }

  @override
  void write(BinaryWriter writer, HIVE_Metadata obj) {
    writer.writeString(obj.userdata.name);
    writer.writeInt(obj.userdata.age);
    writer.writeString(obj.appdata.appinfo.version);
    writer.writeString(obj.appdata.appinfo.appName);
    writer.writeBool(obj.appdata.uiinfo.rememberMe);
    writer.writeString(obj.appdata.apiinfo.apivalidity);
    writer.writeString(obj.appdata.apiinfo.apiaddress);
    writer.writeString(obj.appdata.apiinfo.lastAPICall);
    writer.writeBool(obj.appdata.appsettings.notifications);
    writer.writeBool(obj.appdata.appsettings.darkmode);
    writer.writeString(obj.secruecredentials.username);
    writer.writeString(obj.secruecredentials.password);
    writer.writeString(obj.secruecredentials.apikey);
  }
}

class HIVE_Metadata {
  HIVE_UserData userdata;
  HIVE_AppData appdata;
  HIVE_SecureCredentials secruecredentials;

  HIVE_Metadata(this.userdata, this.appdata, this.secruecredentials);
}
class HIVE_UserData {
  String name;
  int age;

  HIVE_UserData(this.name, this.age);
}
class HIVE_AppData {
  HIVE_AppInfo appinfo;
  HIVE_UIInfo uiinfo;
  HIVE_APIInfo apiinfo;
  HIVE_AppSettings appsettings;

  HIVE_AppData(this.appinfo, this.uiinfo, this.apiinfo, this.appsettings);
}
class HIVE_AppInfo {
  String version;
  String appName;
  HIVE_AppInfo(this.version, this.appName);
}
class HIVE_UIInfo {
  bool rememberMe;
  HIVE_UIInfo(this.rememberMe);
}
class HIVE_APIInfo {
  String apivalidity;
  String apiaddress;
  String lastAPICall;
  HIVE_APIInfo(this.apivalidity, this.apiaddress, this.lastAPICall);
}
class HIVE_AppSettings {
  bool notifications;
  bool darkmode;
  HIVE_AppSettings(this.notifications, this.darkmode);
}
class HIVE_SecureCredentials {
  String username;
  String password;
  String apikey;
  
  HIVE_SecureCredentials(this.username, this.password, this.apikey);
}