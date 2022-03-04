import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:branch/services/compartilhar_service.dart';
import 'package:branch/services/formatador_data.dart';
import 'package:branch/services/gerador_service.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  final _geradorService = GeradorService();
  final _compartilharService = CompartilharService();
  final _formatadorData = FormatadorData();

  Color _corTexto = Colors.white;
  Color _pickerColor = const Color(0xff443a49);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _gerar();
  }

  _gerar() async {
    setState(() {
      _isLoading = true;
    });

    await _geradorService.validarInternetParaGerarImagem();

    setState(() {
      _geradorService.conexaoService.semInternet;
      _geradorService.imagemFundo;
      _corTexto = Colors.white;
      _geradorService.controllerFraseBomDia.text;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 222, 89, 1),
        title: Text(
          'Gerador de Bom Dia'.toUpperCase(),
          style: const TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
        ),
      ),
      body: _isLoading ? _loading() : _body(),
      bottomNavigationBar:
          _isLoading || _geradorService.conexaoService.semInternet
              ? const Text('')
              : _rodapeFilter(),
    );
  }

  Widget _body() {
    if (_geradorService.conexaoService.semInternet) {
      return _semInternetWidget();
    }
    return _bodyImagem();
  }

  Widget _bodyImagem() {
    return Center(
      child: ListView(
        children: [
          _inputFraseBomDia(),
          _imagemBomDia(),
          _compartilharImagem(),
        ],
      ),
    );
  }

  Widget _semInternetWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
            child: Text(
          'Parece que você está sem Internet. Conecte-se em uma rede para gerar sua imagem única...',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )),
        ElevatedButton(
          child: Text(
            'Tentar novamente'.toUpperCase(),
            style: const TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
          ),
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(255, 222, 89, 1)),
          onPressed: () {
            _gerar();
          },
        ),
      ],
    );
  }

  _inputFraseBomDia() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, top: 50),
          child: TextFormField(
            cursorColor: Colors.yellow,
            autofocus: false,
            maxLines: 1,
            maxLength: _geradorService.limiteCaracteres,
            controller: _geradorService.controllerFraseBomDia,
            onChanged: (String query) async {
              setState(() {});
            },
            decoration: const InputDecoration(
                focusColor: Colors.yellow,
                hoverColor: Colors.yellow,
                labelText: 'Editar Frase de Bom Dia',
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(54, 54, 51, 1))),
                labelStyle: TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
                hintStyle: TextStyle(color: Colors.yellow)),
          ),
        ),
        Stack(
          alignment: const FractionalOffset(.5, 1.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: 30,
                width: 270,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _mudarCorTextoModal();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(255, 222, 89, 1)),
                  icon: const Icon(
                    Icons.color_lens,
                    size: 18,
                    color: Color.fromRGBO(54, 54, 51, 1),
                  ),
                  label: Text(
                    'MUDAR A COR DO TEXTO'.toUpperCase(),
                    style:
                        const TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _mudarCorTextoModal() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Escolha uma cor!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _pickerColor,
            onColorChanged: _changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'Mudar a cor da frase'.toUpperCase(),
              style: const TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
            ),
            style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(255, 222, 89, 1)),
            onPressed: () {
              setState(() => _corTexto = _pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  Widget _botaoGerar() {
    return SizedBox(
      height: 50,
      width: 350,
      child: ElevatedButton.icon(
        onPressed: () async {
          await _gerar();
        },
        style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(255, 222, 89, 1)),
        icon: const Icon(
          Icons.wb_sunny,
          size: 18,
          color: Color.fromRGBO(54, 54, 51, 1),
        ),
        label: Text(
          'Gerar Nova Imagem de Bom Dia!'.toUpperCase(),
          style: const TextStyle(color: Color.fromRGBO(54, 54, 51, 1)),
        ),
      ),
    );
  }

  Widget _compartilharImagem() {
    return Stack(
      alignment: const FractionalOffset(.5, 1.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 50,
            width: 300,
            child: ElevatedButton.icon(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                if (bytes == null) return;

                File imagem = await _compartilharService.criarDiretorioImagem(
                    bytes, 'bom_dia.png');
                await _compartilharService.compartilharImagem(imagem);
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(54, 54, 51, 1)),
              icon: const Icon(
                Icons.share,
                size: 18,
                color: Color.fromRGBO(255, 222, 89, 1),
              ),
              label: Text(
                'compartilhar'.toUpperCase(),
                style: const TextStyle(color: Color.fromRGBO(255, 222, 89, 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loading() {
    return Center(
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Text(
            'Gerando uma Imagem única para você...'.toUpperCase(),
            style: const TextStyle(
              backgroundColor: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const CircularProgressIndicator(color: Color.fromRGBO(54, 54, 51, 1)),
      ]),
    );
  }

  Widget _imagemBomDia() {
    return Screenshot(
      controller: screenshotController,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.2),
                  child: Image.file(
                    _geradorService.imagemFundo!,
                    filterQuality: FilterQuality.low,
                    height: 350,
                    width: 400,
                    fit: BoxFit.cover,
                  ),
                  width: double.infinity,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(bottom: 280),
                child: Text(
                  'Bom Dia!!!'.toUpperCase(),
                  style: const TextStyle(
                      backgroundColor: Colors.yellow,
                      color: Color.fromRGBO(54, 54, 51, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0),
                )),
            _felizDia(),
            Center(
                child: Text(
              '"' + _geradorService.controllerFraseBomDia.text + '"',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _corTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            )),
            Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 260),
                child: Text(
                  _formatadorData.formatarData(DateTime.now()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0),
                )),
            Opacity(
                opacity: 0.1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(top: 300),
                  child: Text(
                    'Gerador de Bom Dia'.toUpperCase(),
                    style: const TextStyle(
                        backgroundColor: Colors.yellow,
                        color: Color.fromRGBO(54, 54, 51, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _felizDia() {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(bottom: 180),
          child: Text(
            'FELIZ ${_formatadorData.tratarDiaDaSemana(DateTime.now().weekday)}!'
                .toUpperCase(),
            style: const TextStyle(
                backgroundColor: Color.fromRGBO(54, 54, 51, 1),
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )),
    ]);
  }

  Widget _rodapeFilter() {
    return Stack(
      alignment: const FractionalOffset(.5, 1.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: _botaoGerar(),
        ),
      ],
    );
  }
}
