import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gbevplan/components/popUp.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<JahrgangsData?> getJahrgangsdata(BuildContext context) async {
  print('I N I T  -  H I V E');
  Box userdata_box = Hive.box('userdata');
  Box appdata_box = Hive.box('appdata');
  Box apidata_box = Hive.box('apidata');

  Map<dynamic, dynamic> securedata = userdata_box.get('securedata');

  String jarhgang = userdata_box.get('jahrgang');

  var headers = {
  'username': securedata['username'].toString(),
  'password': securedata['password'].toString(),
  'jahrgang': jarhgang
  };
  headers.entries.forEach((element) {
    print(element);
  });
  var request = http.MultipartRequest('GET', Uri.parse('https://daum-schwagstorf.ddns.net/jahrgangsdata'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();



  if (response.statusCode == 200) {
    String jsonString = await response.stream.bytesToString();
    return JahrgangsData.fromJson(json.decode(jsonString));
  }
  else {
    PopUp.create(context, 2, response.statusCode.toString(), await response.stream.bytesToString());
    return null;
  }
}

class JahrgangsData {
  Map<String, Wochentag> kursplan;
  List<String> kurse;

  JahrgangsData({required this.kursplan, required this.kurse});

  factory JahrgangsData.fromJson(Map<String, dynamic> json) {
    Map<String, Wochentag> kursplanMap = {};
    json['kursplan'].forEach((key, value) {
      kursplanMap[key] = Wochentag.fromJson(value);
    });
    return JahrgangsData(
      kursplan: kursplanMap,
      kurse: List<String>.from(json['kurse']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> kursplanMap = {};
    kursplan.forEach((key, value) {
      kursplanMap['"$key"'] = value.toJson();
    });
    List<String> kursJSList = [];
    kurse.forEach((element) {
      kursJSList.add('"$element"');
    });
    return {
      '"kursplan"': kursplanMap,
      '"kurse"': kursJSList,
    };
  }
}

class Wochentag {
  Map<String, Stunde> stunden;

  Wochentag({required this.stunden});

  factory Wochentag.fromJson(Map<String, dynamic> json) {
    Map<String, Stunde> stundenMap = {};
    json.forEach((key, value) {
      stundenMap[key] = Stunde.fromJson(value);
    });
    return Wochentag(stunden: stundenMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> stundenMap = {};
    stunden.forEach((key, value) {
      stundenMap['"$key"'] = value.toJson();
    });
    return stundenMap;
  }
}

class Stunde {
  Map<String, Kurs> kurse;

  Stunde({required this.kurse});

  factory Stunde.fromJson(Map<String, dynamic> json) {
    Map<String, Kurs> kursMap = {};
    json.forEach((key, value) {
      kursMap[key] = Kurs.fromJson(value);
    });
    return Stunde(kurse: kursMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> kursMap = {};
    kurse.forEach((key, value) {
      kursMap['"$key"'] = value.toJson();
    });
    return kursMap;
  }
}

class Kurs {
  String raum;
  String lehrer;

  Kurs({required this.raum, required this.lehrer});

  factory Kurs.fromJson(Map<String, dynamic> json) {
    return Kurs(
      raum: json['room'],
      lehrer: json['teacher'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '"room"': '"$raum"',
      '"teacher"': '"$lehrer"',
    };
  }
}















// class Kursplan {
//   Map<String, Map<String, Map<String, Map<String, String>>>> kursplan;
//   List<String> kurse;
//   Kursplan({required this.kursplan, required this.kurse});
//   factory Kursplan.fromJson(Map<String, dynamic> json) {
//     return Kursplan(
//       kursplan: Map<String, Map<String, Map<String, Map<String, String>>>>.from(json['kursplan']).map((key, value) => MapEntry(
//         key,
//         Map<String, Map<String, Map<String, String>>>.from(value).map((key, value) => MapEntry(
//           key,
//           Map<String, Map<String, String>>.from(value).map((key, value) => MapEntry(
//             key,
//             Map<String, String>.from(value),
//           )),
//         )),
//       )),
//       kurse: List<String>.from(json['kurse']),
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'kursplan': kursplan.map((key, value) => MapEntry(
//         key,
//         value.map((key, value) => MapEntry(
//           key,
//           value.map((key, value) => MapEntry(
//             key,
//             Map<String, String>.from(value),
//           )),
//         )),
//       )),
//       'kurse': kurse,
//     };
//   }
// }