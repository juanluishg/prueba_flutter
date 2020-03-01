import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketBat {
  IO.Socket socket;
  SocketBat();
  Future<bool> connect() async {
    // Dart client
    socket = IO.io('https://35.187.101.24:3000', <String, dynamic> {
      'transports' : ['websocket'],
      'autoConnect' : false
    });
    socket.connect();
    socket.on('connect', (_) {
     print('connect');
     socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    socket.on('error', (error) => print(error));
  return true;
}
}