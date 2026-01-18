import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:buddy/core/constants/constants.dart';
import 'package:buddy/core/constants/imports.dart';

/// Socket service for real-time communication
class SocketService extends GetxService {
  late IO.Socket socket;
  final String serverUrl = Constants.socketBaseUrl;

  @override
  Future<void> onInit() async {
    super.onInit();
    print("iam hete");
    _initializeSocket();
  }

  void _initializeSocket() {
    // Set up socket options and connect
    socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection() // Enable auto-reconnect
            .setReconnectionAttempts(5) // Attempt to reconnect 5 times
            .setReconnectionDelay(
                2000) // Wait 2 seconds between reconnect attempts
            .build());

    // Socket event listeners
    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.onReconnect((_) {
      print('Reconnecting...');
    });

    socket.onReconnectError((error) {
      print('Reconnect error: $error');
    });

    socket.onReconnectFailed((_) {
      print('Reconnect failed after maximum attempts');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }

  void listenToEvent(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void closeConnection() {
    socket.disconnect();
  }
}
