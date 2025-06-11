import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal() {
    socket = IO.io(
      'http://10.0.2.2:5000', // <-- ONLY this, no quotes, no slash, no placeholder!
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );
    // Debug prints for connection status
    socket.onConnect((_) => print('[SOCKET] Connected!'));
    socket.onConnectError((e) => print('[SOCKET] Connect error: $e'));
    socket.onError((e) => print('[SOCKET] General error: $e'));
    socket.onDisconnect((_) => print('[SOCKET] Disconnected!'));
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }

  void off(String event, Function(dynamic) handler) {
    socket.off(event, handler);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void disconnect() {
    socket.disconnect();
  }
}
