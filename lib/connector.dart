import 'dart:io';

class SocketBat {
  static const bool DEBUG = true;

  SecureSocket _secureSocket;
  String _host;
  static const int PORT = 3000;

  SocketBat(this._host);

  Future<bool> connect() async {
    try {
      SecurityContext securityContext = SecurityContext();
      _secureSocket = await SecureSocket.connect(
        _host,
        PORT,
        context: securityContext,
        onBadCertificate: _onBadCertificate,
        timeout: Duration(seconds: 10),
      );
    } on SocketException catch (e){
      print(e.toString());
      return false;
    } on HandshakeException catch (e){
      print(e.toString());
      return false;
    }

  _secureSocket.setOption(SocketOption.tcpNoDelay, true);

  _secureSocket.listen(_receiveDataFromServer, onError: (error){
    print(error.toString());
  }, onDone: _socketDisconnected);
  
  return true;
  }

  bool _onBadCertificate(X509Certificate certificate){
    return true;
  }

  void _receiveDataFromServer(data){
    if(DEBUG) print("_receiveDataFromServer");
  }

  void _socketDisconnected() {
    if(DEBUG) print("_socketDisconnected");
    _secureSocket = null;
  }

  void disconnect(){
    if(_secureSocket != null){
      _secureSocket.destroy();
    }
  }

  void sendMessage(final List<int> bytes) {
    if(bytes != null && bytes.length > 0 ){
      if(_secureSocket != null){
        print("send bytes len: ${bytes.length}");
        _secureSocket.add(bytes);
      }
    }
  }
}