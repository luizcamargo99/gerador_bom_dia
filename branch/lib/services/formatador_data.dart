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

  String tratarDiaDaSemana(int diaDaSemana) {
    switch (diaDaSemana) {
      case DateTime.monday:
        return 'Segunda';
      case DateTime.tuesday:
        return 'Terça';
      case DateTime.wednesday:
        return 'Quarta';
      case DateTime.thursday:
        return 'Quinta';
      case DateTime.friday:
        return 'Sexta';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }
}
