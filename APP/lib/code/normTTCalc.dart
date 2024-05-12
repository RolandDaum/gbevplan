import 'dart:core';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Bände - Subjects
Map<String, List<String>> jahrgangsbaende = {
  'Bd1': [
    "DE2",
    "ENG2",
    "ENG3",
    "FR1",
    "GE1",
    "GE2",
    "LA1",
    "MA1"
  ],
  'Bd2': [
    "BI1",
    "CH1",
    "DE3",
    "EK1",
    "ENG1",
    "PW1"
  ],
  'Bd3': [
    "BI2",
    "DE1",
    "KU1",
    "MA2",
    "PH1",
    "PW2"
  ],
  'Bd4': [
    "bi2",
    "ch1",
    "if2",
    "ph1",
    "re1"
  ],
  'Bd5': [
    "en1",
    "fr1",
    "ka1",
    "ma2",
    "pw2"
  ],
  'Bd6': [
    "bi1",
    "en2",
    "ge2",
    "ku1"
  ],
  'Bd7': [
    "de1",
    "if1",
    "ma3",
    "mu1",
    "snn1"
  ],
  'Bd8': [
    "ds1",
    "ma4",
    "re2",
    "wn1",
    "rk1",
    "re2"
  ],
  'Bd9': [
    "de2",
    "ge1",
    "ma1",
    "pw1"
  ],
  'Bd10': [
      "sf1",
      "sf2",
      "sf3",
      "sf4",
      "sf5",
      "sf6"
    ]
};

// Lesson - Bände
Map<int, Map<int, String?>> jahrgangsbandplan = {
  1: {
    1: "Bd8",
    2: "Bd8",
    3: "Bd3",
    4: "Bd2",
    5: "Bd7",
    6: "Bd7",
    7: null,
    8: "Bd10",
    9: "Bd10",
    10: "sp1",
    11: "sp1"
  },
  2: {
    1: "Bd2",
    2: "Bd2",
    3: "Bd1",
    4: "Bd1",
    5: "Bd6",
    6: "Bd6",
    7: null,
    8: "sp2",
    9: "sp2",
    10: null,
    11: null
  },
  3: {
    1: "Bd4",
    2: "Bd4",
    3: "Bd5",
    4: "Bd5",
    5: "Bd1",
    6: "Bd9",
    7: null,
    8: "Bd3",
    9: "Bd3",
    10: "sp3",
    11: "sp3"
  },
  4: {
    1: "snn1",
    2: "Bd7",
    3: "Bd9",
    4: "Bd9",
    5: "Bd6",
    6: "Bd8",
    7: null,
    8: "Bd2",
    9: "Bd2",
    10: "sp4",
    11: "sp4"
  },
  5: {
      1: "Bd4",
      2: "Bd5",
      3: "Bd1",
      4: "Bd1",
      5: "Bd3",
      6: "Bd3",
      7: null,
      8: "spp1",
      9: "spp1",
      10: null,
      11: null
    }
};

// Man braucht eingentlich eine extra Raum Map für jeden Tag, weil die nie const sind.
// // Lesson - Raum
// Map<String, String> jahrgangskursraum = {
//     "MA1": '006', 
//     "MA2": '002', 
//     "PH1": 'PH1', 
//     "CH1": 'NW', 
//     "BI1": '', 
//     "BI2",
//     "DE1", 
//     "DE2", 
//     "DE3",
//     "ENG1", 
//     "ENG2", 
//     "ENG3",
//     "LA1",
//     "FR1",
//     "EK1", 
//     "PW1", 
//     "PW2",
//     "GE1", 
//     "GE2",
//     "KU1", 
//     "KU2",
//     "ma1", 
//     "ma2", 
//     "ma3", 
//     "ma4", 
//     "ph1", 
//     "bi1", 
//     "bi2",
//     "if1",
//     "if2", 
//     "ch1",
//     "de1", 
//     "de2", 
//     "eng1", 
//     "eng2", 
//     "snn1", 
//     "la1", 
//     "fr1",
//     "pw1", 
//     "pw2", 
//     "ge1", 
//     "ge2", 
//     "re1", 
//     "re2", 
//     "rk1", 
//     "wn1",
//     "mu1", 
//     "ku1", 
//     "ds1",
//     "sp1", 
//     "sp2", 
//     "sp3", 
//     "sp4", 
//     "spp1",
//     "sf1", 
//     "sf2", 
//     "sf3", 
//     "sf4", 
//     "sf5", 
//     "sf6"
// };

void calcNormTT() {
  // Hive - Storage
  Box userdata_box = Hive.box('userdata');
  Box appdata_box = Hive.box('appdata');
  Box apidata_box = Hive.box('apidata');

  List<String>? subjectList = userdata_box.get('selected_courses');
  if (subjectList == null) {
    subjectList = [];
  }

  Map<int, Map<int, String>> normTT = {};
  
  jahrgangsbandplan.forEach((weekday, day) {
    Map<int, String> dailyLessonsMap = {}; // creates map for a day
    day.forEach((lesson, band) {
      dailyLessonsMap[lesson] = '';
      if (band == null) {
      } else if (band.contains('Bd')) {
        jahrgangsbaende[band]?.forEach((subject) {
          if (subjectList!.contains(subject)) {
            dailyLessonsMap[lesson] = subject;
          }
        });
      } else if (band.contains('sp')) {
        if (subjectList!.contains(band)) {
          dailyLessonsMap[lesson] = band;
        }
      }
    });
    normTT[weekday] = dailyLessonsMap;
  });

  appdata_box.put('normtimetable', normTT);
}

Map<int, Map<int, String>> convertNormTTfromHiveDynMapToMap(Map<dynamic, dynamic>? dynMap) {
  if (dynMap == null) {
    return {
      1: {
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: "",
        11: ""
      },
      2: {
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: "",
        11: ""
      },
      3: {
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: "",
        11: ""
      },
      4: {
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: "",
        11: ""
      },
      5: {
        1: "",
        2: "",
        3: "",
        4: "",
        5: "",
        6: "",
        7: "",
        8: "",
        9: "",
        10: "",
        11: ""
      },
    };
  }


  Map<int, Map<int, String>> resultMap = {};
  dynMap.forEach((key, value) {
    if (key is int && value is Map<dynamic, dynamic>) {
      Map<int, String> innerMap = {};
      value.forEach((innerKey, innerValue) {
        if (innerKey is int && innerValue is String) {
          innerMap[innerKey] = innerValue;
        }
      });
      resultMap[key] = innerMap;
    }
  });
  return resultMap;
}