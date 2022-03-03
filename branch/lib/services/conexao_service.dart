import 'package:connectivity_plus/connectivity_plus.dart';

class ConexaoService {
  bool semInternet = false;

  Future<ConnectivityResult> verificarConexaoAtual() async {
    return await (Connectivity().checkConnectivity());
  }

  void verificarSeEstaSemInternet(ConnectivityResult conexaoAtual) {
    if (conexaoAtual == ConnectivityResult.none) {
      semInternet = true;
    } else {
      semInternet = false;
    }
  }
}
