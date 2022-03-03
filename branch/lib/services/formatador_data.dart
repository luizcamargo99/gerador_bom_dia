class FormatadorData {
  String formatarData(DateTime data) {
    final dataFormatada = _colocarZeroAntes(data.day) +
        '/' +
        (_colocarZeroAntes(data.month)) +
        '/' +
        data.year.toString();

    return dataFormatada;
  }

  String _colocarZeroAntes(int data) {
    return data < 10 ? '0' + data.toString() : data.toString();
  }
}
