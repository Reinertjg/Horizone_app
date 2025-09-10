
// Returns the text before the first separator (comma, hyphen, or slash), if
/// present.
String beforeComma(String text) {
  final i = text.indexOf(RegExp(r'[,/-]'));
  return (i == -1) ? text : text.substring(0, i);
}