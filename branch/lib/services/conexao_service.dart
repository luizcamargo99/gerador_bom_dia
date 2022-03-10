import 'package:connectivity_plus/connectivity_plus.dart';

class ConexaoService {
  bool semInternet = false;

  Future<void> verificarSeEstaSemInternet() async {
    final conexaoAtual = await (Connectivity().checkConnectivity());
    semInternet = (conexaoAtual == ConnectivityResult.none);
  }
}
