bool validarCpf(String cpf) {
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
  if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

  List<int> digits = cpf.split('').map(int.parse).toList();

  int calc(int start, int count) {
    int sum = 0;
    for (int i = 0; i < count; i++) {
      sum += digits[i] * (start - i);
    }
    int mod = sum % 11;
    return mod < 2 ? 0 : 11 - mod;
  }

  return digits[9] == calc(10, 9) && digits[10] == calc(11, 10);
}
