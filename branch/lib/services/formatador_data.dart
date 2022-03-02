class FormatadorData {
  String formatarData(DateTime data) {
    final dataFormatada = data.day.toString() +
        '/' +
        (data.month < 10
            ? '0' + data.month.toString()
            : data.month.toString()) +
        '/' +
        data.year.toString();

    return dataFormatada;
  }
}
