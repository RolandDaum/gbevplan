import 'package:cloud_firestore/cloud_firestore.dart';

// Loading the Map data into Firestore
void transfareData() {
  Map<String, List<String>> jahrgangsbaende = {
    'Bd1': ["DE2", "EN2", "EN3", "FR1", "GE1", "GE2", "LA1", "MA1"],
    'Bd2': ["BI1", "CH1", "DE3", "EK1", "EN1", "PW1"],
    'Bd3': ["BI2", "DE1", "KU1", "MA2", "PH1", "PW2"],
    'Bd4': ["bi2", "ch1", "if2", "ph1", "re1"],
    'Bd5': ["en1", "fr1", "ka1", "ma2", "pw2"],
    'Bd6': ["bi1", "en2", "ge2", "ku1"],
    'Bd7': ["de1", "if1", "ma3", "mu1", "snn1"],
    'Bd8': ["ds1", "ma4", "re2", "wn1", "rk1"],
    'Bd9': ["de2", "ge1", "ma1", "pw1"],
    'Bd10': ["sf1", "sf2", "sf3", "sf4", "sf5", "sf6"],
    'sp1': ["sp1"],
    'sp2': ["sp2"],
    'sp3': ["sp3"],
    'sp4': ["sp4"],
    'spp1': ["spp1"],
    'snn1': ["snn1"],
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

  final db = FirebaseFirestore.instance;
  db.databaseId = "database";

  jahrgangsbandplan.forEach((dayINT, dayMap) {
    dayMap.forEach((stundeINT, bandString) {
      Map<String, dynamic> datatoadd = {};

      bandString != null
          ? jahrgangsbaende[bandString]!.forEach((stringkurs) {
              datatoadd[stringkurs] = {"lehrer": "", "raum": ""};
            })
          : {};

      db
          .collection("2023-24-2")
          .doc("12")
          .collection((dayINT - 1).toString())
          .doc((stundeINT - 1).toString())
          .set(datatoadd);
    });
  });

  dynamic allcourses = [];
  jahrgangsbaende.forEach((bandname, courseList) {
    courseList.forEach((course) {
      allcourses.add(course);
    });
  });
  db.collection("2023-24-2").doc("12").set({"all_courses": allcourses});
}
