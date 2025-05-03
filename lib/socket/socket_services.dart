import 'dart:async';
import 'dart:convert';

import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';

class SocketService {
  WebSocketChannel? channel;

  void connect(String groupName, StreamController controller) async {
    try {
      final token = SharedPrefs.getAuthToken();
      if (token == null || token.isEmpty) {
        print('Error: Auth token is missing');
        return;
      }

      final url = 'ws://54.147.131.51:8081/ws/chat/$groupName/?token=$token';
      print('Connecting to WebSocket: $url');

      channel = WebSocketChannel.connect(Uri.parse(url));

      channel!.stream.listen(
        (message) {
          print('Received message: $message');
          controller.add(message);
        },
        onError: (error) {
          print('Connection Error: $error');
        },
        onDone: () {
          print('Disconnected from socket server');
        },
        cancelOnError: true,
      );

      print('Socket connection successful');
    } catch (e, stackTrace) {
      print('Socket connection failed: $e');
      print('StackTrace: $stackTrace');
      Get.snackbar('Socket Error', 'Failed to connect to chat server.');
    }
  }

  void sendMessage(String message) {
    try {
      if (channel == null) {
        print('Error: Channel is not connected.');
        return;
      }

      Map<String, dynamic> msg = {
        "message": message,
      };
      channel!.sink.add(jsonEncode(msg));
      print('Sent message: $msg');
    } catch (e) {
      print('Error while sending message: $e');
    }
  }

  void disconnect() {
    try {
      if (channel != null) {
        channel!.sink.close();
        print('Socket disconnected manually');
        channel = null;
      }
    } catch (e) {
      print('Error while disconnecting socket: $e');
    }
  }
}
