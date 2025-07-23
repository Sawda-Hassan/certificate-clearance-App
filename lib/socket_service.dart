// ✅ socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal() {
    socket = IO.io(
'http://192.168.100.8:5000', // ✅ For real Android/iOS device

      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
        'reconnection': true,
        'reconnectionAttempts': 10,
        'reconnectionDelay': 3000,
      },
    );

    socket.onConnect((_) => print('[SOCKET] ✅ Connected!'));
    socket.onConnectError((e) => print('[SOCKET] ❌ Connect error: $e'));
    socket.onError((e) => print('[SOCKET] ❌ Error: $e'));
    socket.onDisconnect((_) => print('[SOCKET] 🔌 Disconnected!'));

    // Catch-all debug logger
    socket.onAny((event, data) {
      print('[SOCKET DEBUG] $event → $data');
    });
  }

  void waitUntilConnectedAndListen(String event, void Function(dynamic) handler) {
    if (socket.connected) {
      print('[SOCKET] 🔔 Listening to $event immediately');
      on(event, handler);
    } else {
      print('[SOCKET] ⏳ Waiting to connect before listening to $event');
      socket.onConnect((_) {
        print('[SOCKET] 🔔 Connected. Now listening to $event');
        on(event, handler);
      });
    }
  }

  void on(String event, void Function(dynamic) handler) {
    socket.off(event);
    socket.on(event, handler);
    print('[SOCKET] 🟢 Registered listener for $event');
  }

  void off(String event, [void Function(dynamic)? handler]) {
    if (handler != null) {
      print('[SOCKET] 🔕 Removing specific handler for $event');
      socket.off(event, handler);
    } else {
      print('[SOCKET] 🔕 Removing all handlers for $event');
      socket.off(event);
    }
  }

  void emit(String event, dynamic data) {
    print('[SOCKET] 🚀 Emitting $event with data: $data');
    socket.emit(event, data);
  }

  void disconnect() {
    print('[SOCKET] 🔌 Manually disconnecting socket');
    socket.disconnect();
  }
}
