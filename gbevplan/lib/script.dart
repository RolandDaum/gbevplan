class Scripts {
  static String jhginttostring(int jahrgang) {
    if (jahrgang <= 10) {
      return "unterstufe";
    } else if (jahrgang == 11) {
      return "mittelstufe";
    } else if (jahrgang >= 12) {
      return "oberstufe";
    }
    return "";
  }
}
