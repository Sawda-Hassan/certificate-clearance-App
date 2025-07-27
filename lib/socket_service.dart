import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal() {
    socket = IO.io(
      'http://10.0.2.2:5000', // ✅ Use this for Android emulator
      IO.OptionBuilder()
          .setTransports(['websocket']) // ✅ Only use WebSocket
          .enableAutoConnect() // ✅ Automatically reconnect
          .build(),
    );

    // ✅ Register all event listeners BEFORE connecting
    socket.onConnect((_) {
      print('[SOCKET] ✅ Connected!');
    });

    socket.onConnectError((err) {
      print('[SOCKET] ❌ Connect Error: $err');
    });

    socket.onError((err) {
      print('[SOCKET] ❌ General Error: $err');
    });

    socket.onDisconnect((_) {
      print('[SOCKET] 🔌 Disconnected!');
    });

    socket.onAny((event, data) {
      print('[SOCKET DEBUG] $event → $data');
    });

    // ✅ Finally, connect
    socket.connect();
  }

  /// Wait until connected before registering listener
  void waitUntilConnectedAndListen(String event, void Function(dynamic) handler) {
    if (socket.connected) {
      print('[SOCKET] 🔔 Already connected. Listening to $event now');
      on(event, handler);
    } else {
      print('[SOCKET] ⏳ Waiting to connect before listening to $event');
      socket.onConnect((_) {
        print('[SOCKET] 🔔 Connected. Now listening to $event');
        on(event, handler);
      });
    }
  }

  /// Register a listener for a socket event
  void on(String event, void Function(dynamic) handler) {
    socket.off(event); // remove previous
    socket.on(event, handler);
    print('[SOCKET] 🟢 Registered listener for $event');
  }

  /// Stop listening to a socket event
  void off(String event, [void Function(dynamic)? handler]) {
    if (handler != null) {
      socket.off(event, handler);
    } else {
      socket.off(event);
    }
  }

  /// Emit a socket event with data
  void emit(String event, dynamic data) {
    print('[SOCKET] 🚀 Emitting $event with data: $data');
    socket.emit(event, data);
  }

  /// Disconnect the socket
  void disconnect() {
    print('[SOCKET] 🔌 Manually disconnecting socket');
    socket.disconnect();
  }
}
