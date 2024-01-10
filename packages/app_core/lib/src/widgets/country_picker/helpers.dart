/// Return true if [s] is a valid double number.
bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;
