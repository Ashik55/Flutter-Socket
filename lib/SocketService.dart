import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketService {
  IO.Socket socket;
  // String URI = "http://192.168.88.252:3000/";
  createSocketConnection() {
    socket = IO.io("http://192.168.88.252:3000/", <String, dynamic>{
      'transports': ['websocket'],
    });
    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));


  }
}