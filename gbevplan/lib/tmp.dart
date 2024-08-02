import 'package:cloud_firestore/cloud_firestore.dart';

// Loading the Map data into Firestore
void transfareData() {
//   Map<String, List<String>> OLDjahrgangsbaende = {
//     'Bd1': ["DE2", "EN2", "EN3", "FR1", "GE1", "GE2", "LA1", "MA1"],
//     'Bd2': ["BI1", "CH1", "DE3", "EK1", "EN1", "PW1"],
//     'Bd3': ["BI2", "DE1", "KU1", "MA2", "PH1", "PW2"],
//     'Bd4': ["bi2", "ch1", "if2", "ph1", "re1"],
//     'Bd5': ["en1", "fr1", "ka1", "ma2", "pw2"],
//     'Bd6': ["bi1", "en2", "ge2", "ku1"],
//     'Bd7': ["de1", "if1", "ma3", "mu1", "snn1"],
//     'Bd8': ["ds1", "ma4", "re2", "wn1", "rk1"],
//     'Bd9': ["de2", "ge1", "ma1", "pw1"],
//     'Bd10': ["sf1", "sf2", "sf3", "sf4", "sf5", "sf6"],
//     'sp1': ["sp1"],
//     'sp2': ["sp2"],
//     'sp3': ["sp3"],
//     'sp4': ["sp4"],
//     'spp1': ["spp1"],
//     'snn1': ["snn1"],
//   };
//   Map<String, List<Map<String, String>>> OLDjahrgangsbaendeWithRoom = {
//     'Bd1': [
//       {'coursname': 'DE2', 'raum': '001'},
//       {'coursname': 'EN2', 'raum': '002'},
//       {'coursname': 'EN3', 'raum': '005'},
//       {'coursname': 'FR1', 'raum': '003'},
//       {'coursname': 'GE1', 'raum': '004'},
//       {'coursname': 'GE2', 'raum': '106'},
//       {'coursname': 'LA1', 'raum': '049'},
//       {'coursname': 'MA1', 'raum': '006'}
//     ],
//     'Bd2': [
//       {'coursname': 'BI1', 'raum': 'Bi3'},
//       {'coursname': 'CH1', 'raum': 'Ch2'},
//       {'coursname': 'DE3', 'raum': '105'},
//       {'coursname': 'EK1', 'raum': '119'},
//       {'coursname': 'EN1', 'raum': '002'},
//       {'coursname': 'PW1', 'raum': '003'}
//     ],
//     'Bd3': [
//       {'coursname': 'BI2', 'raum': 'Bi3'},
//       {'coursname': 'DE1', 'raum': '049'},
//       {'coursname': 'KU1', 'raum': 'Ku3'},
//       {'coursname': 'MA2', 'raum': '002'},
//       {'coursname': 'PH1', 'raum': 'Ph1'},
//       {'coursname': 'PW2', 'raum': '003'}
//     ],
//     'Bd4': [
//       {'coursname': 'bi2', 'raum': 'Bi3'},
//       {'coursname': 'ch1', 'raum': 'Ch1'},
//       {'coursname': 'if2', 'raum': '114'},
//       {'coursname': 'ph1', 'raum': 'Ph1'},
//       {'coursname': 're1', 'raum': '001'}
//     ],
//     'Bd5': [
//       {'coursname': 'en1', 'raum': '003'},
//       {'coursname': 'fr1', 'raum': '001'},
//       {'coursname': 'ka1', 'raum': '005'},
//       {'coursname': 'ma2', 'raum': '004'},
//       {'coursname': 'pw2', 'raum': '006'}
//     ],
//     'Bd6': [
//       {'coursname': 'bi1', 'raum': 'Ph2'},
//       {'coursname': 'en2', 'raum': '101'},
//       {'coursname': 'ge2', 'raum': '105'},
//       {'coursname': 'ku1', 'raum': 'Ku2'}
//     ],
//     'Bd7': [
//       {'coursname': 'de1', 'raum': '004'},
//       {'coursname': 'if1', 'raum': '114'},
//       {'coursname': 'ma3', 'raum': '002'},
//       {'coursname': 'mu1', 'raum': 'Mu3'},
//       {'coursname': 'snn1', 'raum': '003'}
//     ],
//     'Bd8': [
//       {'coursname': 'ds1', 'raum': '050'},
//       {'coursname': 'ma4', 'raum': '001'},
//       {'coursname': 're2', 'raum': '101'},
//       {'coursname': 'wn1', 'raum': '006'},
//       {'coursname': 'rk1', 'raum': '004'}
//     ],
//     'Bd9': [
//       {'coursname': 'de2', 'raum': '006'},
//       {'coursname': 'ge1', 'raum': '002'},
//       {'coursname': 'ma1', 'raum': '001'},
//       {'coursname': 'pw1', 'raum': '117'}
//     ],
//     'Bd10': [
//       {'coursname': 'sf1', 'raum': 'Ku3'},
//       {'coursname': 'sf2', 'raum': '050'},
//       {'coursname': 'sf3', 'raum': '001'},
//       {'coursname': 'sf4', 'raum': '003'},
//       {'coursname': 'sf5', 'raum': '114'},
//       {'coursname': 'sf6', 'raum': 'Ch1'}
//     ],
//     'sp1': [
//       {'coursname': 'sp1', 'raum': 'TH3'}
//     ],
//     'sp2': [
//       {'coursname': 'sp2', 'raum': 'TH1'}
//     ],
//     'sp3': [
//       {'coursname': 'sp3', 'raum': 'TH1'}
//     ],
//     'sp4': [
//       {'coursname': 'sp4', 'raum': 'TH1'}
//     ],
//     'spp1': [
//       {'coursname': 'spp1', 'raum': 'TH1'}
//     ],
//     'snn1': [
//       {'coursname': 'snn1', 'raum': '003'}
//     ]
//   };
// // Lesson - Bände
//   Map<int, Map<int, String?>> OLDjahrgangsbandplan = {
//     0: {
//       1: "Bd8",
//       2: "Bd8",
//       3: "Bd3",
//       4: "Bd2",
//       5: "Bd7",
//       6: "Bd7",
//       7: null,
//       8: "Bd10",
//       9: "Bd10",
//       10: "sp1",
//       11: "sp1"
//     },
//     1: {
//       1: "Bd2",
//       2: "Bd2",
//       3: "Bd1",
//       4: "Bd1",
//       5: "Bd6",
//       6: "Bd6",
//       7: null,
//       8: "sp4",
//       9: "sp4",
//       10: null,
//       11: null
//     },
//     2: {
//       1: "Bd4",
//       2: "Bd4",
//       3: "Bd5",
//       4: "Bd5",
//       5: "Bd1",
//       6: "Bd9",
//       7: null,
//       8: "Bd3",
//       9: "Bd3",
//       10: "sp2",
//       11: "sp2"
//     },
//     3: {
//       1: "snn1",
//       2: "Bd7",
//       3: "Bd9",
//       4: "Bd9",
//       5: "Bd6",
//       6: "Bd8",
//       7: null,
//       8: "Bd2",
//       9: "Bd2",
//       10: "sp3",
//       11: "sp3"
//     },
//     4: {
//       1: "Bd4",
//       2: "Bd5",
//       3: "Bd1",
//       4: "Bd1",
//       5: "Bd3",
//       6: "Bd3",
//       7: null,
//       8: "spp1",
//       9: "spp1",
//       10: null,
//       11: null
//     }
//   };

  Map<String, List<Map<String, String>>> jahrgangsbaendeWithRoom = {
    'Bd1': [
      {'coursname': 'DE2', 'raum': '001'},
      {'coursname': 'EN2', 'raum': '002'},
      {'coursname': 'EN3', 'raum': '005'},
      {'coursname': 'FR1', 'raum': '003'},
      {'coursname': 'GE1', 'raum': '117'},
      {'coursname': 'LA1', 'raum': '05'},
      {'coursname': 'MA1', 'raum': '006'}
    ],
    'Bd2': [
      {'coursname': 'BI1', 'raum': 'Bi2'},
      {'coursname': 'CH1', 'raum': 'Ch2'},
      {'coursname': 'DE3', 'raum': '110'},
      {'coursname': 'EK1', 'raum': '103'},
      {'coursname': 'EN1', 'raum': '002'},
      {'coursname': 'PW1', 'raum': '003'}
    ],
    'Bd3': [
      {'coursname': 'BI2', 'raum': 'Bi3'},
      {'coursname': 'DE1', 'raum': '108'},
      {'coursname': 'KU1', 'raum': 'Ku3'},
      {'coursname': 'MA2', 'raum': '002'},
      {'coursname': 'PH1', 'raum': 'Ph1'},
      {'coursname': 'PW2', 'raum': '003'}
    ],
    'Bd4': [
      {'coursname': 'bi2', 'raum': 'Bi3'},
      {'coursname': 'ch1', 'raum': 'Ch1'},
      {'coursname': 'if2', 'raum': '114'},
      {'coursname': 'ph1', 'raum': 'Ph2'},
      {'coursname': 're1', 'raum': '001'}
    ],
    'Bd5': [
      {'coursname': 'en1', 'raum': '003'},
      {'coursname': 'fr1', 'raum': '001'},
      {'coursname': 'la1', 'raum': '004'},
      {'coursname': 'pw2', 'raum': '006'}
    ],
    'Bd6': [
      {'coursname': 'bi1', 'raum': 'Bi2'},
      {'coursname': 'en2', 'raum': '112'},
      {'coursname': 'ge2', 'raum': '119'},
      {'coursname': 'ku1', 'raum': 'Ku3'},
      {'coursname': 'ds2', 'raum': 'Mu1'},
      {'coursname': 'mu1', 'raum': 'Mu3'}
    ],
    'Bd7': [
      {'coursname': 'de1', 'raum': '003'},
      {'coursname': 'ma3', 'raum': '002'},
      {'coursname': 'snn1', 'raum': '004'}
    ],
    'Bd8': [
      {'coursname': 'ma4', 'raum': '004'},
      {'coursname': 're2', 'raum': '107'},
      {'coursname': 'wn1', 'raum': '006'},
    ],
    'Bd9': [
      {'coursname': 'de2', 'raum': '006'},
      {'coursname': 'ge1', 'raum': '004'},
      {'coursname': 'ma1', 'raum': 'N11'},
      {'coursname': 'pw1', 'raum': '116'}
    ],
    'Bd10': [
      {'coursname': 'sf1', 'raum': 'Ku3'},
      {'coursname': 'sf2', 'raum': '050'},
      {'coursname': 'sf3', 'raum': '001'},
      {'coursname': 'sf4', 'raum': '004'},
      {'coursname': 'sf5', 'raum': '114'},
      {'coursname': 'sf6', 'raum': 'Ph1'}
    ],
    'sp1': [
      {'coursname': 'sp1', 'raum': 'TH3'}
    ],
    'sp2': [
      {'coursname': 'sp2', 'raum': 'TH1'}
    ],
    'sp3': [
      {'coursname': 'sp3', 'raum': 'TH1'}
    ],
    'sp4': [
      {'coursname': 'sp4', 'raum': 'TH1'}
    ],
    'spp1': [
      {'coursname': 'spp1', 'raum': 'TH1'},
      {'coursname': 'ds1', 'raum': 'Mu1'}
    ],
    'snn1': [
      {'coursname': 'snn1', 'raum': '003'},
      {'coursname': 'ds1', 'raum': 'Mu1'}
    ]
  };
  Map<int, Map<int, String?>> jahrgangsbandplan = {
    0: {
      1: "Bd8",
      2: "Bd8",
      3: "Bd3",
      4: "Bd2",
      5: "Bd7",
      6: "Bd7",
      7: null,
      8: "Bd10",
      9: "Bd10",
      10: "sp3",
      11: "sp3"
    },
    1: {
      1: "Bd2",
      2: "Bd2",
      3: "Bd1",
      4: "Bd1",
      5: "Bd6",
      6: "Bd6",
      7: null,
      8: "spp1",
      9: "spp1",
      10: "sp1",
      11: "sp1"
    },
    2: {
      1: "Bd4",
      2: "Bd4",
      3: "Bd5",
      4: "Bd5",
      5: "Bd1",
      6: "Bd9",
      7: null,
      8: "Bd3",
      9: "Bd3",
      10: "sp4",
      11: "sp4"
    },
    3: {
      1: "snn1",
      2: "Bd7",
      3: "Bd9",
      4: "Bd9",
      5: "Bd6",
      6: "Bd8",
      7: null,
      8: "Bd2",
      9: "Bd2",
      10: "sp2",
      11: "sp2"
    },
    4: {
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
          ? {
              for (var courseMap in jahrgangsbaendeWithRoom[bandString]!)
                {
                  datatoadd[courseMap["coursname"].toString()] = {
                    "lehrer": "",
                    "raum": courseMap["raum"]
                  }
                }
            }
          : {};

      db
          .collection("2024-25-1")
          .doc("13")
          .collection((dayINT).toString())
          .doc((stundeINT - 1).toString())
          .set(datatoadd);
    });
  });

  dynamic allcourses = [];
  jahrgangsbaendeWithRoom.forEach((bandname, courseList) {
    for (var course in courseList) {
      allcourses.add(course["coursname"]);
    }
  });
  db.collection("2024-25-1").doc("13").set({"all_courses": allcourses});
}
