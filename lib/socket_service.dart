// socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal() {
    socket = IO.io(
      'http://localhost:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // optional: call connect() manually
          .build(),
    );
    socket.connect();
  }

  void on(String event, Function(dynamic) handler) => socket.on(event, handler);
  void emit(String event, dynamic data) => socket.emit(event, data);
  void disconnect() => socket.disconnect();
}
