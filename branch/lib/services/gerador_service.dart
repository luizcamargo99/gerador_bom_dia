import 'dart:io';
import 'dart:math';
import 'package:branch/configuracoes/configuracoes.dart';
import 'package:branch/services/compartilhar_service.dart';
import 'package:branch/services/conexao_service.dart';
import 'package:branch/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class GeradorService {
  final _httpService = HttpService();
  final _translator = GoogleTranslator();
  final conexaoService = ConexaoService();

  TextEditingController controllerFraseBomDia = TextEditingController();
  int limiteCaracteres = 120;
  File? imagemFundo;

  Future<void> validarInternetParaGerarImagem() async {
    await conexaoService.verificarSeEstaSemInternet();
    if (!conexaoService.semInternet) {
      await _gerarImagemBomDia();
    }
  }

  Future<void> _gerarImagemBomDia() async {
    await _gerarFraseAleatoria();
    await _gerarFundoAleatorio();
  }

  Future<void> _gerarFraseAleatoria() async {
    final url = Uri.parse(Configuracoes.apiFrasesMotivacionais);
    final frases = await _httpService.httpGet(url, '');

    int random = Random().nextInt(frases.length);
    Translation fraseTraduzida =
        await _realizarTraducaoFrase(frases[random]['text']);

    _validarCaracteresFrase(fraseTraduzida);
  }

  void _validarCaracteresFrase(Translation fraseTraduzida) {
    if (fraseTraduzida.text.length > limiteCaracteres) {
      _gerarFraseAleatoria();
    } else {
      controllerFraseBomDia.text = fraseTraduzida.text;
    }
  }

  Future<void> _gerarFundoAleatorio() async {
    Uri url = Uri.parse(Configuracoes.apiImagensFundo(Random().nextInt(100)));

    final images =
        await _httpService.httpGet(url, Configuracoes.tokenImagemApi);

    int randomImage = Random().nextInt(images['photos'].length);
    await _salvarFundoPath(images['photos'][randomImage]['src']['original']);
  }

  Future<void> _salvarFundoPath(String src) async {
    final response = await http.get(Uri.parse(src));
    imagemFundo = await CompartilharService().criarDiretorioImagem(
        response.bodyBytes, DateTime.now().toString() + '.png');
  }

  Future<Translation> _realizarTraducaoFrase(String frase) async {
    return await _translator.translate(frase, from: 'en', to: 'pt');
  }
}
