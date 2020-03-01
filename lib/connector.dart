import 'dart:io';

import 'package:flutter/services.dart';

class SocketBat {
  static const bool DEBUG = true;

  SecureSocket _secureSocket;
  String _host;
  static const int PORT = 3000;
  static const String HOST = "35.187.101.24";

  SocketBat(this._host);

  Future<bool> connect() async {
    try {
      //ByteData data = await rootBundle.load('assets/server-crt.pem');
      SecurityContext securityContext = SecurityContext();
      //securityContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
      _secureSocket = await SecureSocket.connect(
        HOST,
        PORT,
        onBadCertificate : _onBadCertificate,
        context: securityContext,
      );
    } on SocketException catch (e) {
      print(e.toString());
      return false;
    } on HandshakeException catch (e) {
      print(e.toString());
      return false;
    } on Exception catch(e){
      print(e.toString());
    }

    //_secureSocket.setOption(SocketOption.tcpNoDelay, true);

    _secureSocket.listen(_receiveDataFromServer, onError: (error) {
      print(error.toString());
    }, onDone: _socketDisconnected);

    return true;
  }

  bool _onBadCertificate(X509Certificate certificate) {
    return true;
  }

  void _receiveDataFromServer(data) {
    if (DEBUG) print("_receiveDataFromServer");
  }

  void _socketDisconnected() {
    if (DEBUG) print("_socketDisconnected");
    _secureSocket = null;
  }

  void disconnect() {
    if (_secureSocket != null) {
      _secureSocket.destroy();
    }
  }

  void sendMessage(final List<int> bytes) {
    if (bytes != null && bytes.length > 0) {
      if (_secureSocket != null) {
        print("send bytes len: ${bytes.length}");
        _secureSocket.add(bytes);
      }
    }
  }
}
