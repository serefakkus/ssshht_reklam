bool validateCardNumWithLuhnAlgorithm(String input) {
  if (input.isEmpty) {
    return false;
  }

  if (input.length < 8) {
    return false;
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    int digit = int.parse(input[length - i - 1]);
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return true;
  }

  return false;
}
