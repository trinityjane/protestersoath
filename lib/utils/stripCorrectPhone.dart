String stripCorrectPhone(String phone) {
  // Defensive: handle empty or short input
  if (phone.isEmpty) return '';
  // remove all characters that are not digits or a plus sign
  final String prefix = (phone.startsWith('+1'))
      ? ''
      : (phone.startsWith('+'))
          ? ''
          : '+1';
  final RegExp regExp = RegExp(r'\W+');
  final String strippedPhone = phone.replaceAll(regExp, '');
  return prefix + strippedPhone;
}

String stripPlusOnePhone(String phone) {
  // Defensive: handle empty or short input
  if (phone.length < 2) return '';
  return (phone.startsWith('+1'))
      ? phone.substring(2)
      : phone;
}
