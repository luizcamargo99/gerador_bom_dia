import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CompartilharService {
  Future<void> compartilharImagem(File imagem) async {
    await Share.shareFiles([
      imagem.path,
    ]);
  }

  Future<File> criarDiretorioImagem(Uint8List bytes, src) async {
    final diretorio = await getApplicationDocumentsDirectory();
    final image = File('${diretorio.path}/$src');
    image.writeAsBytesSync(bytes);
    return image;
  }
}
