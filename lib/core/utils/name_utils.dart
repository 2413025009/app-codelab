/// Name helpers for greetings.
const _honorifics = {'muhammad', 'muhamad', 'mohammad', 'mohamad', 'moh.', 'muh.', 'ahmad', 'm.'};

/// "Muhammad Farhan" -> "Farhan"; "Rizky Aditya" -> "Rizky".
String displayFirstName(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length > 1 && _honorifics.contains(parts.first.toLowerCase())) return parts[1];
  return parts.first;
}
