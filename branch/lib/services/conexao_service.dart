import 'package:connectivity_plus/connectivity_plus.dart';

class ConexaoService {
  Future<ConnectivityResult> verificarConexaoAtual() async {
    return await (Connectivity().checkConnectivity());
  }

  bool verificarSeEstaSemInternet(ConnectivityResult conexaoAtual) {
    if (conexaoAtual == ConnectivityResult.none) {
      return true;
    }
    return false;
  }
}
